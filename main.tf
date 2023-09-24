terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# The access and secret can be passed along with region
# but it get the keys stored by AWS CLI
# C:\Users\<username>\.aws
provider "aws" {
  region = "ap-south-1"
}

###### Syntax ######
# resource "provider_resource_name" "unique_name_for_the_resource_provided_by_you" {
#     key1   = value1
#     key2   = value2
#     key3   = value3
#     key4   = value4
#     value can be list, string, dictionary
# }
###### Syntax ######

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my_first_instance" {
  ami                    = "ami-06f621d90fa29f6d0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_first_instance_security_group.id]
  key_name               = aws_key_pair.my_first_instance_key_pair.id
  tags = {
    instance_number = "1"
    name            = "Demo"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "my_first_instance_ebs" {
  availability_zone = aws_instance.my_first_instance.availability_zone
  size              = 10

  tags = {
    ec2_name = "Demo"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
resource "aws_volume_attachment" "my_first_instance_ebs_attachment" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.my_first_instance_ebs.id
  instance_id = aws_instance.my_first_instance.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "my_first_instance_security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "webserver"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "my_first_instance_key_pair" {
  key_name   = "aws_ec2"
  public_key = file("C:/Users/Naveen.Singh/.ssh/id_rsa.pub")
}

output "public_ip" {
  value = aws_instance.my_first_instance.public_ip
}