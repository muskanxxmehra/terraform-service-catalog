################################################################################
# EC2 App Module - Outputs
################################################################################

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.app.arn
}

output "private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.app.private_ip
}

output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.app.public_ip
}

output "public_dns" {
  description = "The public DNS name of the instance"
  value       = aws_instance.app.public_dns
}

output "elastic_ip" {
  description = "The Elastic IP address (if created)"
  value       = var.create_eip ? aws_eip.app[0].public_ip : null
}
