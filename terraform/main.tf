# AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# AMI Data
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Instance Resources
resource "aws_instance" "web" {
  ami                   = data.aws_ami.ubuntu.id
  instance_type         = "t3.micro"
  cpu_core_count        = 1 # For t3.micro only 1 core is available
  cpu_threads_per_core  = 1 # Disabling multithreading
#  ipv6_address_count    = 1
# Using ipv6 adresses appeared to be impossible: Error: Error launching source instance: InvalidParameterValue: Subnet does not contain any IPv6 CIDR block ranges
  monitoring            = true

  tags = {
    Name = "07-terraform-02-syntax"
  }
}

# Additional Data
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}