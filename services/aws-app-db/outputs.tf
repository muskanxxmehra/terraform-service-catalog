################################################################################
# AWS App + DB Service - Outputs
# These outputs are returned after successful deployment
################################################################################

#------------------------------------------------------------------------------
# VPC Outputs
#------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

#------------------------------------------------------------------------------
# Security Group Outputs
#------------------------------------------------------------------------------

output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = module.security.app_sg_id
}

output "db_security_group_id" {
  description = "The ID of the database security group"
  value       = module.security.db_sg_id
}

#------------------------------------------------------------------------------
# Application Server Outputs
#------------------------------------------------------------------------------

output "app_instance_id" {
  description = "The ID of the application EC2 instance"
  value       = module.app.instance_id
}

output "app_public_ip" {
  description = "The public IP address of the application server"
  value       = module.app.public_ip
}

output "app_public_dns" {
  description = "The public DNS name of the application server"
  value       = module.app.public_dns
}

output "app_private_ip" {
  description = "The private IP address of the application server"
  value       = module.app.private_ip
}

output "app_elastic_ip" {
  description = "The Elastic IP address of the application server (if created)"
  value       = module.app.elastic_ip
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://${module.app.public_ip}"
}

#------------------------------------------------------------------------------
# Database Server Outputs
#------------------------------------------------------------------------------

output "db_instance_id" {
  description = "The ID of the database EC2 instance"
  value       = module.db.instance_id
}

output "db_private_ip" {
  description = "The private IP address of the database server"
  value       = module.db.private_ip
}

output "db_endpoint" {
  description = "Database connection endpoint (IP:Port)"
  value       = module.db.db_endpoint
}

output "db_connection_string" {
  description = "MySQL connection string for the application"
  value       = "mysql://${var.db_user}:****@${module.db.private_ip}:3306/${var.db_name}"
  sensitive   = true
}

#------------------------------------------------------------------------------
# Summary
#------------------------------------------------------------------------------

output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    region          = var.aws_region
    environment     = var.environment
    vpc_cidr        = var.vpc_cidr
    app_instance    = module.app.instance_id
    app_access      = "http://${module.app.public_ip}"
    db_instance     = module.db.instance_id
    db_endpoint     = module.db.db_endpoint
  }
}
