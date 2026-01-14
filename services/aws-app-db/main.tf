provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                = "../../modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  tags                  = var.tags
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.vpc.vpc_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "app" {
  source            = "../../modules/ec2-app"
  ami_id            = data.aws_ami.amazon_linux.id
  instance_type     = var.app_instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security.app_sg_id
  app_name          = var.app_name
  user_data         = var.app_user_data
}

module "db" {
  source            = "../../modules/ec2-db"
  ami_id            = data.aws_ami.amazon_linux.id
  instance_type     = var.db_instance_type
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security.db_sg_id
}

