terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "ria-terraform-org"
    workspaces {
      name = "aws-app-db-dev"
    }
  }
}

