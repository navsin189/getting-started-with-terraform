resource "aws_ecs_cluster" "first_cluster" {
  name = "terraform-cluster"
}

resource "aws_ecs_task_definition" "first_task" {
  family                   = "web_server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "tf-container"
      image     = "public.ecr.aws/docker/library/httpd:2.4.57"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
  ])
}

# Terraform is not a right tool to handle ECS task execution
data "aws_ecs_task_execution" "first_task_execution" {
  cluster         = aws_ecs_cluster.first_cluster.id
  task_definition = aws_ecs_task_definition.first_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-024f4c6d8b50add8a"]
    security_groups  = [aws_security_group.first_task_sg.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "first_task_sg" {
  name        = "websever container"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "webserver"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "websever container"
  }
}