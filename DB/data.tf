# AWS AMI for SAP
data "aws_ami" "random_ami" {
  most_recent = true

  filter {
    name   = "image-id"
    # Example: Fetch RHEL AMI; customize as needed
    values = [var.ami_id]
  }
}

# Define the VPC ID if you have the n number of VPC
data "aws_vpcs" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = [var.aws_vpc]
  }
}

data "aws_subnet" "subnet_ids" {
  count = length(data.aws_vpcs.vpc_id.ids) > 0 ? 1 : 0
  vpc_id = data.aws_vpcs.vpc_id.id

  filter {
    name   = "tag:Name"
    values = var.aws_subnet_id
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
