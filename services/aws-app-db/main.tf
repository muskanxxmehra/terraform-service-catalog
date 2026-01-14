################################################################################
# AWS App + DB Service
# This service provisions a complete web application stack:
# - VPC with public and private subnets
# - Application server in public subnet
# - Database server in private subnet
# - Security groups with proper access controls
#
# Compatible with AWS Free Tier (t2.micro instances)
################################################################################

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }

  # Uncomment for Terraform Cloud backend
  # cloud {
  #   organization = "your-org-name"
  #   workspaces {
  #     name = "aws-app-db"
  #   }
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Service     = "aws-app-db"
    }
  }
}

################################################################################
# Data Sources
################################################################################

# Get latest Amazon Linux 2 AMI (Free Tier eligible)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# Modules
################################################################################

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = data.aws_availability_zones.available.names[0]
  environment         = var.environment
  tags                = var.tags
}

module "security" {
  source = "../../modules/security"

  vpc_id           = module.vpc.vpc_id
  environment      = var.environment
  ssh_allowed_cidr = var.ssh_allowed_cidr
  app_port         = var.app_port
  tags             = var.tags
}

module "app" {
  source = "../../modules/ec2-app"

  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.app_instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security.app_sg_id
  key_name          = var.key_name
  app_name          = var.app_name
  environment       = var.environment
  root_volume_size  = var.app_volume_size
  user_data         = var.app_user_data
  create_eip        = var.create_app_eip
  tags              = var.tags
}

module "db" {
  source = "../../modules/ec2-db"

  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.db_instance_type
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security.db_sg_id
  key_name          = var.key_name
  environment       = var.environment
  root_volume_size  = var.db_volume_size
  db_name           = var.db_name
  db_user           = var.db_user
  db_password       = var.db_password
  user_data         = var.db_user_data
  tags              = var.tags
}
