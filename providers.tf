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

provider "kubernetes" {
  host               = data.aws_eks_cluster.eks-cluster.endpoint
  client_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  token              = data.aws_eks_cluster_auth.eks-auth.token
}
provider "helm" {
  kubernetes {
    host               = data.aws_eks_cluster.eks-cluster.endpoint
    client_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority[0].data)
    token              = data.aws_eks_cluster_auth.eks-auth.token
  }
}