data "aws_availability_zones" "available" {
  state = "available"
}

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
  db_subnet_group_name   =  # Two Subnets

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


resource "aws_subnet" "mysql_rds_subnets" {
  count             = 2
  cidr_block        = ["172.3X.3X.0/24","172.3X.3X.0/24"]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "mysql_rds_subnet_${count.index}"
  }
}

resource "aws_route_table" "mysql_rds_private_route" {

  tags = {
    Name = "Route table for RDS"
  }
}

resource "aws_route_table_association" "mysql_rds_private_route_attach_subnet" {
  count          = 2
  subnet_id      = aws_subnet.mysql_rds_subnets[count.index].id
  route_table_id = aws_route_table.mysql_rds_private_route.id
}

resource "aws_db_subnet_group" "mysql_rds_subnet_group" {
  name       = "mysql_rds_subnet_group"
  subnet_ids = [for subnet in aws_subnet.mysql_rds_subnets : subnet.id]

  tags = {
    Name = "mysql_rds_subnet_group"
  }
}

output "rds_subnet_group_id" {
  value = aws_db_subnet_group.mysql_rds_subnet_group.id
}


output "database_endpoint" {
  description = "the endpoint of database"
  value       = aws_db_instance.mysql_rds.address
}
output "database_port" {
  description = "the port of database"
  value       = aws_db_instance.mysql_rds.port
}