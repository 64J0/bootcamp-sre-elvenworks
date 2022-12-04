variable "canonical_id" {}
variable "public_key" {}
variable "tags" {}

variable "ami" {
  type        = string
  description = "The AWS EC2 AMI for the VM instance."
}

variable "key_name" {
  type        = string
  description = "The .pem key name"
  default     = "curso_terraform"
}

variable "vpc_wordpress" {
  description = "Virtual Private Cloud for the Wordpress project"
}

variable "subnet_monitoring" {
  description = "The monitoring subnet that we're going to put this VM"
}

variable "ec2_wordpress_private_ip" {
  description = "The private IP of the Wordpress VM"
}