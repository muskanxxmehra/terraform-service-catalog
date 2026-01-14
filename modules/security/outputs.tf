################################################################################
# Security Module - Outputs
################################################################################

output "app_sg_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app.id
}

output "app_sg_name" {
  description = "The name of the application security group"
  value       = aws_security_group.app.name
}

output "db_sg_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.db.id
}

output "db_sg_name" {
  description = "The name of the database security group"
  value       = aws_security_group.db.name
}
