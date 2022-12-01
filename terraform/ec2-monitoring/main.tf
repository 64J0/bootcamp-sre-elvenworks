resource "aws_security_group" "monitoring_ec2" {
  name        = "monitoring_ec2"
  description = "Allow external connection to the monitoring EC2 instance"
  vpc_id      = var.vpc_wordpress_id

  # TODO: add SSL certificate
  # ingress {
  #   description = "TLS from everywhere"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [aws_vpc.wordpress.cidr_block]
  }

  # All the egress traffic is enabled.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# TODO: make the configuration using Ansible
resource "aws_instance" "monitoring" {
  ami                         = var.ami
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.monitoring_ec2.id]
  subnet_id                   = aws_subnet.monitoring.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  disable_api_stop            = false
  disable_api_termination     = false
  monitoring                  = true
  user_data                   = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt install ansible curl git unzip -y
    cd /tmp
    git clone https://github.com/64J0/bootcamp-sre-elvenworks
    sudo ansible-playbook ansible/monitoring/monitoring.yml
    EOF

  tags = var.tags
}
