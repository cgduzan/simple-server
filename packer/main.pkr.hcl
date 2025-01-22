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

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "server" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
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

  # provisioner "shell" {
  #   environment_vars = [
  #     # "FOO=hello world",
  #   ]
  #   inline = [
  #     # "echo \"FOO is $FOO\" > example.txt",
  #     "echo Installing Node",
  #     "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash",
  #     "source ~/.bashrc",
  #     "nvm install --lts",
  #     "node -e \"console.log('Running Node.js ' + process.version)\"",

  #     "echo Installing Git",
  #     "sudo yum update -y",
  #     "sudo yum install git -y",
  #     "git --version",

  #     "echo Installing Simple Server",
  #     "git clone https://github.com/cgduzan/simple-server.git",
  #     "cd simple-server/server/",
  #     "npm i",
  #     # it's a JS file, nothing to "build" here
  #   ]
  # }
  provisioner "shell" {
    script = "./setup.sh"
  }
}