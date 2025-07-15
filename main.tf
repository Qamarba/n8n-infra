# ---------------------------
# Variables
# ---------------------------
variable "ami_id" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "region" {
  type        = string
  description = "AWS region"
}

#variable "ssh_key_name" {
#  type        = string
#  description = "Name of existing SSH key pair"
#}

# ---------------------------
# Provider
# ---------------------------
provider "aws" {
  region = var.region
}

# ---------------------------
# Use default VPC
# ---------------------------
data "aws_vpc" "default" {
  default = true
}

# ---------------------------
# Use one default subnet in default VPC
# ---------------------------
data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  availability_zone = "${var.region}a"
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "example" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.default.id
  associate_public_ip_address = true

  tags = {
    Name = "default-ec2"
  }
}
