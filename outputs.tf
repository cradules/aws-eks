output "eks-name" {
  value = var.eks-cluster-name
}

output "eks-endpoint" {
  value = module.eks.cluster_endpoint
}
output "karpenter-arn" {
  value = module.karpenter_irsa.iam_role_arn
}