packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "simple-server"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "server" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    # these values can be pulled from the AMI in the AWS console (search by the AMI ID)
    filters = {
      name                = "al2023-ami-2023.*.0-kernel-6.1-x86_64" # Amazon Linux 2023 AMI
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"] # owner of the Amazon Linux AMI
  }
  ssh_username = "ec2-user"

  tags = {
    Name = "simple-server"
  }
}

build {
  sources = ["source.amazon-ebs.server"]

  provisioner "file" {
    source      = "simple-server.service"
    destination = "/tmp/simple-server.service"
  }

  provisioner "shell" {
    script = "./setup.sh"
  }
}