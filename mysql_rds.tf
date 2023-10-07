resource "aws_db_instance" "mysql_rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.33"
  instance_class         = "db.md5.large"
  db_name                = "first_instance"
  username               = "mysql_user"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.mysql_rds_security_group.id]
  db_subnet_group_name   = ["172.3X.3X.0/24","172.3X.3X.0/24"] # Two Subnets

}

resource "aws_security_group" "mysql_rds_security_group" {
  name        = "mysql-sg"
  description = "Allow EC2 instances to connect"

  ingress {
    description = "Allow mysql traffic from ec2 instance"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.3X.3X.0/24"] #EC2 instance CIDR Range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "database_endpoint" {
  description = "the endpoint of database"
  value       = aws_db_instance.mysql_rds.address
}
output "database_port" {
  description = "the port of database"
  value       = aws_db_instance.mysql_rds.port
}