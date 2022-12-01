resource "aws_security_group" "mysql_rds" {
  name        = "mysql_rds"
  description = "Security group for the MySQL instance in RDS"
  vpc_id      = var.vpc_wordpress.id

  ingress {
    description     = "MySQL traffic from Wordpress SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.wordpress_ec2_sg.id]
  }

  # All the egress traffic is enabled.
  # Not required for a database, which will simply receive data.
  #   egress {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  tags = var.tags
}

resource "aws_db_subnet_group" "mysql" {
  name        = "mysql_subnet_group"
  description = "MySQL subnet group for the Wordpress project"
  # Since the db subnet requires 2 or more subnets, we are going to
  # loop through our private subnets and add them to this db subnet group
  subnet_ids = [for subnet in var.subnets_wordpress_private : subnet.id]
}

resource "aws_db_instance" "wordpress_mysql" {
  allocated_storage      = 4 # GB
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  db_name                = "wordpress"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.mysql.id
  vpc_security_group_ids = [aws_security_group.mysql_rds.id]
  skip_final_snapshot    = true
}