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
  count         = local.web_count_map[terraform.workspace]

  ami                   = data.aws_ami.ubuntu.id
  instance_type         = local.web_instance_type_map[terraform.workspace]
  cpu_core_count        = local.cpu_core_count_map[terraform.workspace] # For t3.micro only 1 core is available
  cpu_threads_per_core  = local.cpu_threads_per_core_map[terraform.workspace]
#  ipv6_address_count    = 1
# Using ipv6 addresses appeared to be impossible: Error: Error launching source instance: InvalidParameterValue: Subnet does not contain any IPv6 CIDR block ranges
  monitoring            = true

  tags = {
    Name = "07-terraform-03-basic"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "web_with_for_each" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]

  for_each = local.web_vm_map[terraform.workspace]

  monitoring = true

  tags = {
    name = "ubuntu_instance"
  }
}

# Additional Data
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}