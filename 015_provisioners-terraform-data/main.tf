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
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
data "aws_vpc" "main" {
  id = "vpc-06d5575973a832582"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBTXHBLI0IA4Q8BZ7BEiQdieXDMteqErhIUwybvqfYh5UbeughFiW58rfKgSHp4yEQ8FbgX1io2j9ExAK7myWsLgohZYWPAMSODHNDpR+jpGAGn7C7umAdFgZWDy23QYF8Xt7GzSUSzPMQLDNrljuPdKBr9Q5KUSJBiu8QHiONw1aGenyVkzeTy+JZhum6bPFeh05fjHbNGrG91CzLb0tLszHFfJtliPI8bQgpE/3vCclhoPcNBhPkuzsDNkUmAud3Gn3K9Lu2KaJKsvhmpOgdqZJnQ8vUsCh0rqh+Qi8A1EBjBChGygS98i0ihl41mwV41LHmUV94Geu4+kKOqO5LwWRWqivALs6w9GiCZnyV6p1Y+FcnxG6jy0FcHGHMGqZfHv1/EoHOKmHuz9VDGDJU2wLPk9R1dZRdHmcqloGf//I2y5W7zTa3vIOtNwCHprR6MOS4O+wNxFVc5l8aqT2BmOfNn+lVg4mQv7vU4lEggH6stzp5vhFDmmy8o6pVeOM= shaikhdiyasalam@Shaikhs-MacBook-Air.local"
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}
resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t3.micro"
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
resource "terraform_data" "status" {
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

