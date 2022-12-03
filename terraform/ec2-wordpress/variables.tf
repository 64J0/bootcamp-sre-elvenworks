variable "canonical_id" {}
variable "public_key" {}
variable "rds_db_username" {}
variable "rds_db_password" {}
variable "rds_db_host" {}
variable "rds_db_port" {}
variable "wordpress_db_name" {}
variable "wordpress_db_username" {}
variable "wordpress_db_password" {}
variable "tags" {}

variable "ami" {
  type        = string
  description = "The AWS EC2 AMI for the VM instance"
}

variable "key_name" {
  type        = string
  description = "The .pem key name"
  default     = "curso_terraform"
}

variable "vpc_wordpress" {
  description = "Virtual Private Cloud for the Wordpress project"
}

variable "subnet_wordpress" {
  description = "The wordpress subnet that we're going to put this VM"
}
