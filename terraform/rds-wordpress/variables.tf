variable "tags" {}
variable "rds_db_username" {}
variable "rds_db_password" {}

variable "vpc_wordpress" {
  description = "Virtual Private Cloud for the Wordpress project"
}

variable "wordpress_ec2_sg" {
  description = "Security group from the Wordpress EC2"
}

variable "subnets_wordpress_private" {
  description = "The private subnets created for this RDS instance"
}