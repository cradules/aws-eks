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