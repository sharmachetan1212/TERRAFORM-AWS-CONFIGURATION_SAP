provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Specify the desired version
      version = "~> 5.64.0"
    }
  }
}

# Define the VPC ID if you have the n number of VPC
data "aws_vpcs" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["vpc-036268133895cbb5a"]
  }
}

data "aws_subnet" "subnet_ids" {
  count = length(data.aws_vpcs.vpc_id.ids) > 0 ? 1 : 0
  vpc_id = data.aws_vpcs.vpc_id.id

  filter {
    name   = "tag:Name"
    values = ["subnet-06b04478c693753f9"]
  }
}

# Create additional security groups for a VPC, each with their own inbound and outbound rules.
data "aws_security_groups" "security_group" {
  count = length(data.aws_vpcs.vpc_id.ids) > 0 ? 1 : 0

  filter {
    name   = "vpc-id"
    values = length(data.aws_vpcs.vpc_id.ids) > 0 ? [data.aws_vpcs.vpc_id.ids[0]] : []
  }

  filter {
    name   = "group-name"
    values = ["default", "*-SAP-APP", "*-APP-SERVER*", "*-FileShare*", "*_app"]
  }
}

resource "aws_efs_file_system" "efs_creation" {
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  creation_token   = format("EFS%s", var.efs_sid)

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name           = "EFS${var.efs_sid}"
    subnet_id      = data.aws_subnet.subnet_ids.id
    security_group = data.aws_security_groups.security_group.id
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count           = length(var.instance_ids)
  file_system_id  = aws_efs_file_system.efs_creation.id[0]
  subnet_id       = data.aws_subnet.subnet_id.id
  security_groups = data.aws_security_groups.security_group.id
}

# Ensure Terraform destroys Mount Target first
resource "aws_efs_mount_target" "mount_target_delete" {
  count          = terraform.workspace == "destroy" ? 1 : 0
  file_system_id = aws_efs_file_system.efs_creation.id[0]
  subnet_id      = "subnet-06b04478c693753f9"
}

variable "efs_id" {}

variable "instance_ids" {
  type = list(string)
}

variable "aws_region" {
    type    = string
    default = "us-east-1"
}

variable "efs_sid" {
  type = string
  default = "BPM"
}

output "efs_id" {
  value = aws_efs_file_system.efs_creation.id
}
