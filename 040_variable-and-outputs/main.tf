terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "instance_type" {
  type        = string
  description = "The size of the instance."
  #   sensitive   = true
  validation {
    condition     = can(regex("^t2.", var.instance_type))
    error_message = "the instance must be a t2 type EC2 instance"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = var.instance_type
}

output "public_ip" {
  value       = aws_instance.my_server.public_ip
  sensitive   = true
  description = "The public ip of the instance"
}
