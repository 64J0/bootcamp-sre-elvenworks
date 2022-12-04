resource "aws_security_group" "monitoring_ec2" {
  name        = "monitoring_ec2"
  description = "Allow external connection to the monitoring EC2 instance"
  vpc_id      = var.vpc_wordpress.id

  ingress {
    description = "Prometheus port"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana port"
    from_port   = 3000
    to_port     = 3000
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

resource "aws_instance" "monitoring" {
  ami                         = var.ami
  key_name                    = var.key_name
  subnet_id                   = var.subnet_monitoring.id
  vpc_security_group_ids      = [aws_security_group.monitoring_ec2.id]
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

    # delete the default values
    rm ./bootcamp-sre-elvenworks/ansible/monitoring-aws/roles/prometheus/defaults/main.yml

    tee -a ./bootcamp-sre-elvenworks/ansible/monitoring-aws/roles/prometheus/defaults/main.yml << END
    ---
    ec2_wordpress_private_ip: "${var.ec2_wordpress_private_ip}"
    END

    sudo ansible-playbook ansible/monitoring-aws/monitoring.yml
    EOF

  tags = var.tags
}
