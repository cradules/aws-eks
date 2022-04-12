
#Create VPC
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.vpc-name
  cidr                 = var.vpc-cidr
  azs                  = var.vpc-azs
  public_subnets       = var.vpc-public-subnets
  enable_dns_hostnames = var.vpc-enable-dns-hostnames
  tags = {
    "Name"        = "eks-${var.eks-cluster-name}"
    "Environment" = var.environment
    "Terraform"   = "true"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
    "karpenter.sh/discovery"                        = var.eks-cluster-name
  }
}

#Create EKS Cluster with IRSA integration
module "eks" {
  source                      = "terraform-aws-modules/eks/aws"
  cluster_name                = var.eks-cluster-name
  cluster_version             = var.eks-cluster-version
  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = module.vpc.public_subnets
  create_cloudwatch_log_group = false
  cluster_security_group_additional_rules = {
    ingress_nodes_karpenter_ports_tcp = {
      description                = "Karpenter readiness"
      protocol                   = "tcp"
      from_port                  = 8443
      to_port                    = 8443
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    aws_lb_controller_webhook = {
      description                   = "Cluster API to AWS LB Controller webhook"
      protocol                      = "all"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_group_defaults = {
    # We are using the IRSA created below for permissions
    # This is a better practice as well so that the nodes do not have the permission,
    # only the VPC CNI addon will have the permission
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      capacity_type = "SPOT"
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {}

    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
  }

  tags = {
    "Name"                   = var.eks-cluster-name
    "Environment"            = var.environment
    "Terraform"              = "true"
    "karpenter.sh/discovery" = var.eks-cluster-name
  }
}

# Create CNI IRSA integration

module "vpc_cni_irsa" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "vpc-cni-role-${var.eks-cluster-name}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
  tags = {
    "Name"        = "vpc-cni-irsa-${var.eks-cluster-name}"
    "Environment" = var.environment
    "Terraform"   = "true"
  }
}


# Add Karpenter IRSA

module "karpenter_irsa" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "karpenter-controller-${var.eks-cluster-name}"

  attach_karpenter_controller_policy     = true
  attach_cluster_autoscaler_policy       = true
  attach_ebs_csi_policy                  = true
  attach_node_termination_handler_policy = true
  attach_load_balancer_controller_policy = true
  attach_vpc_cni_policy                  = true
  attach_external_dns_policy             = true

  karpenter_controller_cluster_ids = [module.eks.cluster_id]

  karpenter_controller_node_iam_role_arns = [
    module.eks.eks_managed_node_groups["default"].iam_role_arn

  ]
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }
  tags = {
    "Name"        = "karpenter-irsa-${var.eks-cluster-name}"
    "Environment" = var.environment
    "Terraform"   = "true"
  }
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${var.eks-cluster-name}"
  role = module.karpenter_irsa.iam_role_name
}

#Install karpenter
module "karpenter" {
  source                          = "./modules/karpenter"
  eks-cluster-name                = var.eks-cluster-name
  eks-cluster_endpoint            = module.eks.cluster_endpoint
  karpenter_irsa_role_arn         = module.karpenter_irsa.iam_role_arn
  karpenter_chart_version         = "0.6.5"
  karpenter_node_instance_profile = aws_iam_instance_profile.karpenter.name
}

# Install haproxy
module "haproxy-external" {
  source                = "./modules/haproxy-external"
  haproxy_chart_version = "1.21.0"
}

# Install prometheus
module "prometheus" {
  source                   = "./modules/prometheus"
  prometheus_chart_version = "15.5.3"
}

module "grafana" {
  source                = "./modules/grafana"
  grafana_chart_version = "6.24.1"
}