terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
  required_version = ">= 1.1.0"

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