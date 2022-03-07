
#ESK VARS
variable "eks-cluster-name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "eks-cluster-version" {
  description = "EKS Cluster Version"
  type        = string
}

#VPC VARS
variable "vpc-name" {
  description = "AWS VPC Name"
  type        = string
}

variable "vpc-cidr" {
  description = "AWS VPC CIRDs"
  type        = list(string)
}

variable "vpc-azs" {
  description = "VPC Availability Zones"
  type        = list(string)
}

variable "vpc-public-subnets" {
  description = "VPC public subnets"
  type        = list(string)
}

variable "vpc-enable-dns-hostnames" {
  description = "Enable DNS for resolving VM's hostnames"
  type        = bool
  default     = true
}

# Misc VARS
variable "environment" {
  description = "VPC Environment Tag"
  type        = string
}