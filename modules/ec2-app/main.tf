################################################################################
# EC2 App Module - Application Server
# Uses t2.micro (Free Tier eligible)
################################################################################

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  user_data = var.user_data != "" ? var.user_data : <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ${var.app_name}</h1>" > /var/www/html/index.html
  EOF

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}"
    Role = "Application"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for App Server (optional)
resource "aws_eip" "app" {
  count    = var.create_eip ? 1 : 0
  instance = aws_instance.app.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-eip"
  })
}
