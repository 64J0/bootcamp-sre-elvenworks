output "vpc_wordpress" {
  value = aws_vpc.wordpress
}

output "subnet_wordpress_public" {
  value = aws_subnet.wordpress_public
}