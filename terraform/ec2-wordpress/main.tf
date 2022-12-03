resource "aws_security_group" "wordpress_ec2" {
  name        = "wordpress_ec2"
  description = "Security group for the Wordpress EC2 instance"
  vpc_id      = var.vpc_wordpress.id

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

resource "aws_instance" "wordpress" {
  ami                         = var.ami
  key_name                    = var.key_name
  subnet_id                   = var.subnet_wordpress.id
  vpc_security_group_ids      = [aws_security_group.wordpress_ec2.id]
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  disable_api_stop            = false
  disable_api_termination     = false
  monitoring                  = true
  user_data                   = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt install ansible curl git nano unzip -y
    cd /tmp

    git clone https://github.com/64J0/bootcamp-sre-elvenworks

    # delete the default values
    rm ./bootcamp-sre-elvenworks/ansible/wordpress-aws/roles/mysql-server/defaults/main.yml

    tee -a ./bootcamp-sre-elvenworks/ansible/wordpress-aws/roles/mysql-server/defaults/main.yml << END
    ---
    rds_db_host: "${var.db_host}"
    rds_db_port: "${var.db_port}"
    rds_db_username: "${var.db_username}"
    rds_db_password: "${var.db_password}"
    wordpress_db_name: "wordpress"
    wordpress_db_username: "wpadmin"
    wordpress_db_password: "Wp@12345"
    END

    cp ./bootcamp-sre-elvenworks/ansible/wordpress-aws/roles/mysql-server/defaults/main.yml ./bootcamp-sre-elvenworks/ansible/wordpress-aws/roles/wordpress/defaults/main.yml
    
    # sudo ansible-playbook ./bootcamp-sre-elvenworks/ansible/wordpress-aws/wordpress.yml
    EOF

  tags = var.tags
}
