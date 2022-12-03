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

  ami                   = data.aws_ami.ubuntu_20_04.id
  key_name              = aws_key_pair.curso_terraform.key_name
  public_key            = var.public_key
  canonical_id          = var.canonical_id
  vpc_wordpress         = module.network_wordpress.vpc_wordpress
  subnet_wordpress      = module.network_wordpress.subnet_wordpress_public
  rds_db_username       = var.rds_db_username
  rds_db_password       = var.rds_db_password
  rds_db_host           = module.rds_wordpress.database_endpoint
  rds_db_port           = module.rds_wordpress.database_port
  wordpress_db_name     = var.wordpress_db_name
  wordpress_db_username = var.wordpress_db_username
  wordpress_db_password = var.wordpress_db_password
  tags                  = merge(var.tags, { role = "wordpress" })
}

module "rds_wordpress" {
  source = "./rds-wordpress"

  db_username               = var.db_username
  db_password               = var.db_password
  vpc_wordpress             = module.network_wordpress.vpc_wordpress
  subnets_wordpress_private = module.network_wordpress.subnets_wordpress_private
  wordpress_ec2_sg          = module.ec2_wordpress.wordpress_ec2_sg
  tags                      = merge(var.tags, { role = "database" })
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
