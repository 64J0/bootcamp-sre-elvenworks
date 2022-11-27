output "ec2_wordpress_public_ip" {
  value = module.ec2_wordpress.public_ip
}

output "ec2_monitoring_public_ip" {
  value = module.ec2_monitoring.public_ip
}