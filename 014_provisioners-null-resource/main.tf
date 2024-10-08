terraform {
  #   backend "remote" { 
  #     organization = "org_diya" 

  #     workspaces { 
  #       name = "provisioners" 
  #     } 
  #   } 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
data "aws_vpc" "main" {
  id = "vpc-06771758657a140ad"
}
resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "My Server Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["99.240.67.76/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkNvI+H3XQUQAxor2xxx0QY2jwJwhPhP1mD+ETduDy/u58jkO9PZdr6uD9/7akNi8Hi48hwl9w9EACO5vgfD4H4OQ2KMOl8/0JCyhMQSiGISSc+j3Af9xfzgIP4qbRNSLpcIRLLEBFAJuE2vXpkhM4MCSF+jeksNXRLdfm3HyMVQiGnxIR1o/gEutLqdiQWxTMaxA0BICmU4IoyrmLN+jfpPdDq1GPvBWCoDVbDxYFjxabMq31g6SEBlZXsj2orpffJVgBA4zSqlzaUlttsE/oXHb7QZQ54omQAW+xMyecThN7LpyG/f/gLV95gHg2J02CGl10QdUDHQYnDMb522kwUiiu1iMvdnngssMmLMF+vbkDNmkRnquSh7f0qWyE87or9lqwx9KIbjCyYWJYoD4TjzpTCp+PAAlCCa0MiorBX2N5LOS7nB9iLtyZPo8+Fu6E/XBhtalb9t+4dV3BhcVaYuL9aGMWECQBHQMEmDQG9y9gpMJFqJxsj5ANyrTW+UE= shaikhdiyasalam@Shaikhs-MacBook-Air.local"
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}
resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered
  provisioner "file" {
    content     = "mars"
    destination = "/home/ec2-user/barsoon.txt"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file("/Users/shaikhdiyasalam/.ssh/terraform")
    }
  }

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  tags = {
    Name = "MyServer"
  }
}
resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.my_server.id}"
  }
  depends_on = [
    aws_instance.my_server
  ]
}
output "public_ip" {
  value = aws_instance.my_server.public_ip
}

