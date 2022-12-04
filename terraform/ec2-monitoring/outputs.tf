output "public_ip" {
  value = aws_instance.monitoring.public_ip
}

output "monitoring_ec2_sg" {
  value = aws_security_group.monitoring_ec2
}