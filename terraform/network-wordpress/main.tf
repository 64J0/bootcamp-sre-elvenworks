# Create a VPC
resource "aws_vpc" "wordpress" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags                 = var.tags
}

# 1. Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.wordpress.id
  tags   = var.tags
}

resource "aws_subnet" "wordpress_public" {
  vpc_id            = aws_vpc.wordpress.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags              = var.tags
}

resource "aws_subnet" "wordpress_private_1" {
  vpc_id            = aws_vpc.wordpress.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1c"
  tags              = var.tags
}

resource "aws_subnet" "wordpress_private_2" {
  vpc_id            = aws_vpc.wordpress.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "us-east-1d"
  tags              = var.tags
}

# 2. Route table + rota 0.0.0.0/0 "apontando" para o Internet Gateway
resource "aws_route_table" "wordpress_rt_public" {
  vpc_id = aws_vpc.wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}

# 3. Association da subnet com a route table
resource "aws_route_table_association" "wordpress_rt_public_assoc" {
  subnet_id      = aws_subnet.wordpress_public.id
  route_table_id = aws_route_table.wordpress_rt_public.id
}

resource "aws_route_table" "wordpress_rt_private" {
  vpc_id = aws_vpc.wordpress.id
  tags   = var.tags
}

resource "aws_route_table_association" "wordpress_rt_private_1_assoc" {
  subnet_id      = aws_subnet.wordpress_private_1.id
  route_table_id = aws_route_table.wordpress_rt_private.id
}

resource "aws_route_table_association" "wordpress_rt_private_2_assoc" {
  subnet_id      = aws_subnet.wordpress_private_2.id
  route_table_id = aws_route_table.wordpress_rt_private.id
}