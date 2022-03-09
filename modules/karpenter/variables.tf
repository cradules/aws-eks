variable "karpenter_irsa_role_arn" {
  description = "Karpenter IRSA Role ARN"
}

variable "eks-cluster-name" {
  description = "EKS Cluster Name"
}
variable "eks-cluster_endpoint" {
  description = "EKS Cluster Endpoint"
}
variable "karpenter_chart_version" {
  description = "Karpenter Chart Version"
}

variable "karpenter_node_instance_profile" {
  description = "Instance profile name used by karpenter"
}