################################################################################
# EC2 DB Module - Outputs
################################################################################

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.db.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.db.arn
}

output "private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.db.private_ip
}

output "private_dns" {
  description = "The private DNS name of the instance"
  value       = aws_instance.db.private_dns
}

output "db_endpoint" {
  description = "Database connection endpoint"
  value       = "${aws_instance.db.private_ip}:3306"
}
