variable "canonical_id" {}
variable "public_key" {}
variable "db_username" {}
variable "db_password" {}
variable "db_host" {}
variable "db_port" {}
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
