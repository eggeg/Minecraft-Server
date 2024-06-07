terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
  shared_credentials_files = ["credentials"]
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "minecraft_sg" {
  name   = "minecraft_sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
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

resource "aws_eip" "minecraft_eip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.minecraft_server.id
  allocation_id = aws_eip.minecraft_eip.id
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft_key"
  public_key = file("./minecraft_key.pub")
}

resource "aws_instance" "minecraft_server" {
  ami                         = "ami-05a6dba9ac2da60cb"
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.minecraft_sg.id]
  key_name                    = aws_key_pair.minecraft_key.key_name
  associate_public_ip_address = true
  depends_on                  = [aws_security_group.minecraft_sg]

  tags = {
    Name = "Minecraft Server"
  }
}

output "instance_public_ip" {
  value = aws_eip.minecraft_eip.public_ip
}