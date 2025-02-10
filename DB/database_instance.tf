# Check if Terraform is in "destroy" mode
locals {
  is_destroy_db = length(terraform.workspace) == 0 || terraform.workspace == "default"
}

# EC2 naming
locals {
  Server_list_DB = [
    for i in range(var.db_count) :
    #count
    "DB${i + 1}"
  ]
}

# instance type value
locals {
  instance_types_db = contains(var.instance_type_list, var.instance_type_db) ? var.instance_type_db : ""
}

# Dynamic variable that assigns device names for Oracle SAP data and logs
# Device names assigned to SAP data will be /dev/sd (from h to q)
locals {
  oradata_volume_names = formatlist("%s", null_resource.oradata_volume_names_list.*.triggers.oradata_volume_name)
  origlog_volume_names = formatlist("%s", null_resource.origlog_volume_names_list.*.triggers.origlog_volume_name)
  mirrlog_volume_names = formatlist("%s", null_resource.mirrlog_volume_names_list.*.triggers.mirrlog_volume_name)
}

# sapdata resource block for mounts number
resource "null_resource" "oradata_volume_names_list" {
  count = var.oracle_disk_num

  triggers = {
    # Generate device names from /dev/sdh to /dev/sdq by count.index
    oradata_volume_name = format("%s%s", "/dev/sd", jsondecode(format("\"\\u%04x\"", 104 + count.index)))
  }
}

# oracle origlog disks calculation
resource "null_resource" "origlog_volume_names_list" {
  count = var.oracle_log_disk_num

  triggers = {
    origlog_volume_name = count.index == 0 ? "/dev/sdr" : count.index == 1 ? "/dev/sds" : ""
  }
}

# oracle mirrlog disks calculation
resource "null_resource" "mirrlog_volume_names_list" {
  count = var.oracle_log_disk_num

  triggers = {
    mirrlog_volume_name = count.index == 0 ? "/dev/sdt" : count.index == 1 ? "/dev/sdu" : ""
  }
}

# EC2 Instance Resource
resource "aws_instance" "app_server_db" {
  ami                         = data.aws_ami.random_ami.id
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type_db
  count                       = var.db_count
  subnet_id                   = "subnet-06b04478c693753f9"
  security_groups             = flatten(data.aws_security_groups.security_group.*.ids)
  iam_instance_profile        = var.instance_profile
  key_name                    = "ssh-ec2-default"
  associate_public_ip_address = true

  # Used for the oracle data mounts
  dynamic "ebs_block_device" {
    for_each = toset(local.oradata_volume_names)
    iterator = device
    content {
      device_name           = device.value
      volume_size           = var.oracle_disk_size
      volume_type           = var.oracle_sapdata_volume_type
      iops                  = var.oracle_data_iops
      throughput            = var.oracle_data_throughput
      delete_on_termination = true
    }
  }

  # /oracle/var.sap_sid/origlog(A|B)
  # Delete EBS volumes when the instances are terminated
  dynamic "ebs_block_device" {
    for_each = toset(local.origlog_volume_names)
    iterator = device
    content {
      device_name           = device.value
      volume_size           = var.oracle_log_disk_size
      volume_type           = var.oracle_orig_mirr_log_volume_type
      iops                  = var.oracle_data_iops
      throughput            = var.oracle_data_throughput
      delete_on_termination = true
    }
  }

  # /oracle/var.sap_sid/mirrlog(A|B)
  # Delete EBS volumes when the instances are terminated
  dynamic "ebs_block_device" {
    for_each = toset(local.mirrlog_volume_names)
    iterator = device
    content {
      device_name           = device.value
      volume_size           = var.oracle_log_disk_size
      volume_type           = var.oracle_orig_mirr_log_volume_type
      iops                  = var.oracle_data_iops
      throughput            = var.oracle_data_throughput
      delete_on_termination = true
    }
  }

  # swap
  # Dynamically passing volume type. Default is gp3.
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = var.custom_db_swap
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

  # /oracle
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdd"
    volume_size           = 10
    volume_type           = var.app_volume_type
    delete_on_termination = true
  }

  # /oem
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sde"
    volume_size           = 10
    volume_type           = var.app_volume_type
    delete_on_termination = true
  }

  # /oracle/<SID>
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = 50
    volume_type           = var.app_volume_type
    delete_on_termination = true
  }

  # /oracle/<SID>/oraarch
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 100
    volume_type           = var.oracle_oraarch_volume_type
    iops                  = var.oracle_data_iops
    throughput            = var.oracle_data_throughput
    delete_on_termination = true
  }

  # /oracle/var.sap_sid/flashback
  # Delete EBS volumes when the instances are terminated
  ebs_block_device {
    device_name           = "/dev/sdv"
    volume_size           = var.oracle_flashback_disk
    volume_type           = var.oracle_flashback_volume_type
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
  }

  # Update the Instance and tag name
  tags = {
    Name            = format("%s-DATABASE-%s-%s", var.instance_name, var.sap_sid, local.Server_list_DB[count.index])
    username        = var.user
    Application     = var.appid
    sap-sid         = var.sap_sid
    sap-apsid       = var.sap_apsid
    sap-volume-type = var.app_volume_type
  }
}
