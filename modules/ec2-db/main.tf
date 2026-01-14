################################################################################
# EC2 DB Module - Database Server
# Uses t2.micro (Free Tier eligible)
# Placed in private subnet for security
################################################################################

resource "aws_instance" "db" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = false  # DB should not have public IP

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  user_data = var.user_data != "" ? var.user_data : <<-EOF
    #!/bin/bash
    yum update -y
    
    # Install MySQL/MariaDB
    amazon-linux-extras install mariadb10.5 -y
    systemctl start mariadb
    systemctl enable mariadb
    
    # Basic MySQL secure installation
    mysql -e "UPDATE mysql.user SET Password=PASSWORD('${var.db_password}') WHERE User='root';"
    mysql -e "DELETE FROM mysql.user WHERE User='';"
    mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -e "DROP DATABASE IF EXISTS test;"
    mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -e "CREATE DATABASE IF NOT EXISTS ${var.db_name};"
    mysql -e "CREATE USER IF NOT EXISTS '${var.db_user}'@'%' IDENTIFIED BY '${var.db_password}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"
  EOF

  tags = merge(var.tags, {
    Name = "${var.environment}-db-server"
    Role = "Database"
  })

  lifecycle {
    create_before_destroy = true
  }
}
