terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.3"
    }
  }

  required_version = ">= 1.2.0"
}

# Conigure the AWS Provider
provider "aws" {
  region  = var.location
  profile = var.profile
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

data "aws_ami" "ubuntu_20_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = [var.canonical_id]
}

# Create a VPC
resource "aws_vpc" "wordpress" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags             = var.tags
}

# 1. Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.wordpress.id
  tags   = var.tags
}

# 2. Route table + rota 0.0.0.0/0 "apontando" para o Internet Gateway
resource "aws_route_table" "wordpress_gw" {
  vpc_id = aws_vpc.wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}

# 3. Association da subnet com a route table
resource "aws_route_table_association" "wordpress_gw" {
  gateway_id     = aws_internet_gateway.gw.id
  subnet_id      = aws_subnet.wordpress.id
  route_table_id = aws_route_table.wordpress_gw.id
}

resource "aws_subnet" "wordpress" {
  vpc_id            = aws_vpc.wordpress.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags              = var.tags
}

resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow HTTP through TLS inbound traffic"
  vpc_id      = aws_vpc.wordpress.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.wordpress.cidr_block]
  }

  tags = var.tags
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.wordpress.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.wordpress.cidr_block]
  }

  tags = var.tags
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.wordpress.id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [aws_vpc.wordpress.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Required to connect to the Wordpress VM
# WARNING:
# This key is stored in the terraform state.
# For production does not use this method.
resource "tls_private_key" "rsa_curso_terraform" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "rsa_curso_terraform" {
  content  = tls_private_key.rsa_curso_terraform.private_key_pem
  filename = "curso_terraform.pem"
}

resource "aws_key_pair" "curso_terraform" {
  key_name   = "curso_terraform"
  public_key = tls_private_key.rsa_curso_terraform.public_key_openssh
}

resource "aws_instance" "wordpress" {
  ami                         = data.aws_ami.ubuntu_20_04.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_https.id, aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.wordpress.id
  associate_public_ip_address = true
  disable_api_stop            = false
  disable_api_termination     = false
  key_name                    = aws_key_pair.curso_terraform.key_name

  tags = var.tags

  depends_on = [aws_key_pair.curso_terraform]
}
