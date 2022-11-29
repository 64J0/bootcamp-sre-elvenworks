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
resource "aws_route_table_association" "wordpress_subnet" {
  subnet_id      = aws_subnet.wordpress.id
  route_table_id = aws_route_table.wordpress_gw.id
}

resource "aws_subnet" "wordpress" {
  vpc_id            = aws_vpc.wordpress.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags              = var.tags
}