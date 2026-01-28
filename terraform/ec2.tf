terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.28.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "dev-key" {
  key_name   = "dev-key"
  public_key = file("dev_key.pub")
}

resource "aws_default_vpc" "dev-vpc" {
  
}

resource "aws_security_group" "dev-sg" {
    name        = "dev-sg"
    description = "Security group for dev EC2 instance"
    vpc_id      = aws_default_vpc.dev-vpc.id
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port   = 8080
      to_port     = 8080 
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    }

resource "aws_instance" "dev-instance" {
    ami = var.ami
    instance_type = var.inst-type
    key_name = aws_key_pair.dev-key.key_name
    vpc_security_group_ids = [aws_security_group.dev-sg.id]
    user_data = file("installation.sh")
    root_block_device {
      volume_size = 50
      volume_type = "gp3"
    }
    tags = {
      Name = "Dev-Instance"
    }
}
