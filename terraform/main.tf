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
  region = "us-east-1"
}

# data blocks allow us to query AWS for information about a resource that is
# not managed by Terraform (e.g. an AMI we created with Packer 😉)
data "aws_ami" "simple_server_ami" {
  most_recent = true
  # gets the most recent AMI we built using Packer
  name_regex = "simple-server-*"
  owners     = ["self"]
}

resource "aws_instance" "simple_server_app" {
  ami           = data.aws_ami.simple_server_ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "SimpleServerApp"
  }

  vpc_security_group_ids = [aws_security_group.allow_dev_app.id]
}
