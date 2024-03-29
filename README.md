# Deploy EKS Cluster and "default" components

This repository contains the necessary elements to deploy an AWS EKS cluster via [Terraform Cloud](https://cloud.hashicorp.com/products/terraform).

***NOTE***

The provided work-frame is not production ready and is designed for a development environment. It can be a good start for reaching a production environment

## Components

- [EKS Cluster](https://aws.amazon.com/eks/) (Kubernetes)
- [Karpenter](https://karpenter.sh/) (compute provisioning for Kubernetes clusters)
- [Haproxy Kubernetes Ingress](https://github.com/haproxytech/helm-charts)
- Additional secondary required elements:
  - [IAM policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_access-management.html)
  - [IRSA](https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-enable-IAM.html)
  - [OIDC](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
  - [Grafana](https://grafana.com/)
  - [Prometheus](https://prometheus.io/)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 1.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | n/a |
| <a name="module_grafana"></a> [grafana](#module\_grafana) | ./modules/grafana | n/a |
| <a name="module_haproxy-external"></a> [haproxy-external](#module\_haproxy-external) | ./modules/haproxy-external | n/a |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ./modules/karpenter | n/a |
| <a name="module_karpenter_irsa"></a> [karpenter\_irsa](#module\_karpenter\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ./modules/prometheus | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |
| <a name="module_vpc_cni_irsa"></a> [vpc\_cni\_irsa](#module\_vpc\_cni\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_eks_cluster.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks-auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks-cluster-name"></a> [eks-cluster-name](#input\_eks-cluster-name) | EKS Cluster Name | `string` | `"eks-dev"` | no |
| <a name="input_eks-cluster-version"></a> [eks-cluster-version](#input\_eks-cluster-version) | EKS Cluster Version | `string` | `"1.21"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | VPC Environment Tag | `string` | `"dev"` | no |
| <a name="input_vpc-azs"></a> [vpc-azs](#input\_vpc-azs) | VPC Availability Zones | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b",<br>  "us-east-2c"<br>]</pre> | no |
| <a name="input_vpc-cidr"></a> [vpc-cidr](#input\_vpc-cidr) | AWS VPC CIRDs | `string` | `"192.168.0.0/16"` | no |
| <a name="input_vpc-enable-dns-hostnames"></a> [vpc-enable-dns-hostnames](#input\_vpc-enable-dns-hostnames) | Enable DNS for resolving VM's hostnames | `bool` | `true` | no |
| <a name="input_vpc-name"></a> [vpc-name](#input\_vpc-name) | AWS VPC Name | `string` | `"vpc-dev"` | no |
| <a name="input_vpc-public-subnets"></a> [vpc-public-subnets](#input\_vpc-public-subnets) | VPC public subnets | `list(string)` | <pre>[<br>  "192.168.0.0/18",<br>  "192.168.64.0/18",<br>  "192.168.128.0/18"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks-endpoint"></a> [eks-endpoint](#output\_eks-endpoint) | n/a |
| <a name="output_eks-name"></a> [eks-name](#output\_eks-name) | n/a |
| <a name="output_karpenter-arn"></a> [karpenter-arn](#output\_karpenter-arn) | n/a |
<!-- END_TF_DOCS -->