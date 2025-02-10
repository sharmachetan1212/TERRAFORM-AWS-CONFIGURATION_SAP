# Check if Terraform is in "destroy" mode
locals {
  is_destroy_as = length(terraform.workspace) == 0 || terraform.workspace == "default"
}

locals {
  Server_list_AS = [
    for i in range(var.as_count) :
    "AAS${i + 1}" # Adjust naming format as needed
  ]
}

locals {
  instance_types_as = contains(var.instance_type_list, var.instance_type_as) ? var.instance_type_as : ""
}

# EC2 Instance Resource
resource "aws_instance" "app_server_as" {
  ami = data.aws_ami.random_ami.id
  # availability_zone             = var.availability_zone
  instance_type               = var.instance_type_as
  count                       = var.as_count
  subnet_id                   = "subnet-06b04478c693753f9"
  security_groups             = flatten(data.aws_security_groups.security_group.*.ids)
  iam_instance_profile        = var.instance_profile
  key_name                    = "ssh-ec2-default"
  associate_public_ip_address = true

  # swap
  # Dynamically passing volume type. Default is gp3.
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = var.custom_aas_swap
    volume_type           = var.swap_volume_type
    delete_on_termination = true
  }

  # /usr/sap
  # Dynamically passing volume type. Default is gp3.
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = 110
    volume_type           = var.app_volume_type
    delete_on_termination = true
  }

  # /oracle/client
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdd"
    volume_size           = 5
    volume_type           = var.app_volume_type
    delete_on_termination = true
  }

  tags = {
    Name            = format("%s-APP-%s-%s", var.instance_name, var.sap_sid, local.Server_list_AS[count.index])
    username        = var.user
    Application     = var.appid
    sap-sid         = var.sap_sid
    sap-apsid       = var.sap_apsid
    sap-volume-type = var.app_volume_type
  }
}

