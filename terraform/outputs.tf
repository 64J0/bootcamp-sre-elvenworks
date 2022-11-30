output "ec2_wordpress_public_ip" {
  value = module.ec2_wordpress.public_ip
}

output "rds_host" {
  value = module.rds_wordpress.database_endpoint
}

output "rds_port" {
  value = module.rds_wordpress.database_port
}

# output "ec2_monitoring_public_ip" {
#   value = module.ec2_monitoring.public_ip
# }