terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  cloud {
    organization = "guts"

    workspaces {
      name = "guts-eks-dev"
    }
  }
}
provider "aws" {
  region = "us-east-2"
}

provider "helm" {
  kubernetes {
    host               = data.aws_eks_cluster.eks-cluster.endpoint
    client_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token              = data.aws_eks_cluster_auth.eks-auth.token
  }
}