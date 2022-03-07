
#ESK VARS
variable "eks-cluster-name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "eks-dev"
}

variable "eks-cluster-version" {
  description = "EKS Cluster Version"
  type        = string
  default     = "1.21"
}

#VPC VARS
variable "vpc-name" {
  description = "AWS VPC Name"
  type        = string
  default     = "vpc-dev"
}

variable "vpc-cidr" {
  description = "AWS VPC CIRDs"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc-azs" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["us-est-2a", "us-east-2b", "us-east-2c"]
}

variable "vpc-public-subnets" {
  description = "VPC public subnets"
  type        = list(string)
  default     = ["192.168.0.0/18", "192.168.64.0/18", "192.168.128.0/18"]
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
  default     = "dev"
}