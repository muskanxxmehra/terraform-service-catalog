variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}

variable "app_instance_type" {}
variable "db_instance_type" {}

variable "app_name" {}
variable "app_user_data" {}

variable "tags" {
  type = map(string)
}

