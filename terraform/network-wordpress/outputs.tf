output "vpc_wordpress" {
  value = aws_vpc.wordpress
}

output "subnet_wordpress_public" {
  value = aws_subnet.wordpress_public
}

output "subnets_wordpress_private" {
  value = [aws_subnet.wordpress_private_1, aws_subnet.wordpress_private_2]
}