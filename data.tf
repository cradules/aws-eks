data "aws_eks_cluster_auth" "eks-auth" {
  depends_on = [module.eks]
  name       = module.eks.cluster_id
}

data "aws_eks_cluster" "eks-cluster" {
  depends_on = [module.eks]
  name       = module.eks.cluster_id
}