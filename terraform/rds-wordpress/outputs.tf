output "database_endpoint" {
  description = "The endpoint to reach the database"
  value       = aws_db_instance.wordpress_mysql.address
}

output "database_port" {
  description = "The port to reach the database"
  value       = aws_db_instance.wordpress_mysql.port
}