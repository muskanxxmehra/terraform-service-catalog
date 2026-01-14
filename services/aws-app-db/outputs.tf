output "app_public_ip" {
  value = module.app.public_ip
}

output "db_private_ip" {
  value = module.db.private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

