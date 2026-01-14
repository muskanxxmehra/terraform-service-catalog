################################################################################
# Example terraform.tfvars file
# Copy this file to terraform.tfvars and customize for your environment
# For Terraform Cloud, set these as workspace variables
################################################################################

# General Settings
aws_region   = "us-east-1"
project_name = "my-web-app"
environment  = "dev"

# Network Settings
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

# Security Settings
key_name         = "my-key-pair"           # Your EC2 key pair name
ssh_allowed_cidr = ["YOUR_IP/32"]          # Restrict SSH to your IP
app_port         = 8080                     # Optional: custom app port

# Application Server Settings
app_name          = "web-app"
app_instance_type = "t3.micro"              # Free Tier eligible
app_volume_size   = 8
create_app_eip    = false

# Database Server Settings
db_instance_type = "t3.micro"               # Free Tier eligible
db_volume_size   = 8
db_name          = "appdb"
db_user          = "appuser"
db_password      = "YourSecurePassword123!" # Use Terraform Cloud sensitive variable

# Tags
tags = {
  Owner      = "your-name"
  CostCenter = "your-cost-center"
}
