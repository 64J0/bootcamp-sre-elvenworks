# Required to connect to the Wordpress VM
# WARNING:
# This key is stored in the terraform state.
# For production does not use this method.
resource "tls_private_key" "rsa_curso_terraform" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "rsa_curso_terraform" {
  content         = tls_private_key.rsa_curso_terraform.private_key_pem
  filename        = "curso_terraform.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "curso_terraform" {
  key_name   = "curso_terraform"
  public_key = tls_private_key.rsa_curso_terraform.public_key_openssh
}

module "network_wordpress" {
  source = "./network-wordpress"

  tags = merge(var.tags, { role = "network" })
}

module "ec2_wordpress" {
  source = "./ec2-wordpress"

  ami              = data.aws_ami.ubuntu_20_04.id
  key_name         = aws_key_pair.curso_terraform.key_name
  public_key       = var.public_key
  canonical_id     = var.canonical_id
  vpc_wordpress    = module.network_wordpress.vpc_wordpress
  subnet_wordpress = module.network_wordpress.subnet_wordpress_public
  tags             = merge(var.tags, { role = "wordpress" })
}

# module "ec2_monitoring" {
#   source = "./ec2-monitoring"

#   ami              = data.aws_ami.ubuntu_20_04.id
#   key_name         = aws_key_pair.curso_terraform.key_name
#   public_key       = var.public_key
#   canonical_id     = var.canonical_id
#   vpc_wordpress    = module.network.vpc_wordpress
#   subnet_wordpress = module.network.subnet_wordpress_public
#   tags             = merge(var.tags, { role = "monitoring" })
# }
