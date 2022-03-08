# Install karpenter


module "karpenter" {
  source     = "terraform-module/release/helm"
  namespace  = "karpenter"
  repository = "https://charts.karpenter.sh/"


  app = {
    name             = "karpenter"
    version          = "0.6.4"
    create_namespace = true
    chart            = "karpenter"
    force_update     = true
    wait             = false
    recreate_pods    = true
    deploy           = 1
  }

  values = [file("helm-values/karpenter.yaml")]

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.karpenter_irsa_role_arn
    },
    {
      name  = "clusterName"
      value = var.eks-cluster-name
    },
    {
      name  = "clusterEndpoint"
      value = var.eks-cluster_endpoint
    }
  ]
}

