variable "location" {
  type        = string
  default     = "us-east-1"
  description = "The region that this resource is going to be created. North Virginia by default."
}

variable "tags" {
  type        = map(string)
  description = "Key-value pairs used to identify resources."
  default = {
    project-name = "wordpress-turbinado"
    author       = "vinicius.gajo"
    environment  = "production"
    owner        = "elvenworks"
  }
}

variable "canonical_id" {
  # https://ubuntu.com/server/docs/cloud-images/amazon-ec2
  description = "The ID of the Canonical owner (AMI)."
  type        = string
  default     = "099720109477"
}

variable "profile" {
  type        = string
  default     = "gajo"
  description = "The profile that is going to be used to connect to the AWS. You can find it in '~/.aws/credentials'."
}

variable "public_key" {
  type        = string
  default     = "ssh-rsa CHANGEME"
  description = "The SSH public key that is going to be stored in the EC2 VM to allow us to connect. It was generated with the command 'ssh-keygen -t rsa -b 2048 -f curso_terraform', and entering a passphrase."
  sensitive   = true
}
