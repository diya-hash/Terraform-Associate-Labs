terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_server" {
  ami           = "ami-0fff1b9a61dec8a5f"
  instance_type = "t2.micro"
  tags = {
    Name = "My-Server"
  }
  lifecycle {
    prevent_destroy = false
  }
}

output "public_ip" {
  value     = aws_instance.my_server.public_ip
  sensitive = false
}

