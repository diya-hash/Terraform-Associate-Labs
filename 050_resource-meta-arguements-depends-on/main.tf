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

resource "aws_s3_bucket" "bucket" {
  bucket = "459204382345-depends-on"
  depends_on = [
    aws_s3_bucket.bucket
  ]

}

resource "aws_instance" "my_server" {
  ami           = "ami-0fff1b9a61dec8a5f"
  instance_type = "t2.micro"

}

output "public_ip" {
  value     = aws_instance.my_server.public_ip
  sensitive = false
}

