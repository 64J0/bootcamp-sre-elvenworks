output "public_ip" {
  value = aws_instance.wordpress.public_ip
}

output "private_ip" {
  value = aws_instance.wordpress.private_ip
}

output "wordpress_ec2_sg" {
  value = aws_security_group.wordpress_ec2
}
