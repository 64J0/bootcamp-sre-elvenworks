variable "location" {}
variable "availability_zone" {}
variable "tags" {}
variable "canonical_id" {}
variable "profile" {}
variable "public_key" {}

variable "ami" {
  type        = string
  description = "The AWS EC2 AMI for the VM instance."
}

variable "key_name" {
  type        = string
  description = "The .pem key name"
  default     = "curso_terraform"
}
