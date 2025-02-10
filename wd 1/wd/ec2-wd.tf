locals {
  t_shirt_type_cs = contains(var.instance_type_list, var.instance_type_wd) ? var.instance_type_wd : ""
}

locals {
  Server_list_WD = [
    for i in range(var.wd_count) :
    # Adjust naming format as needed
    "WD${i + 1}"
  ]
}
 
resource "aws_instance" "sap_web_dispatcher" {
  count                         =   var.wd_count
  ami                           =   data.aws_ami.SAP_ami.id
  subnet_id         	          =   "subnet-06b04478c693753f9"
  security_groups               =   flatten(data.aws_security_groups.security_group.*.ids)
  instance_type                 =   var.instance_type_wd
  iam_instance_profile          =   var.instance_profile
  key_name                      =   "ssh-ec2-default"
  associate_public_ip_address   =   true

# Swap EBS Volume
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = false
  }

  # /usr/sap EBS Volume
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = false
  }
  tags = {
    Name            = format("%s-%s-%s", var.application_name, var.sap_sid,local.Server_list_WD[count.index])
    username          = var.user
    Application       = var.appid
    sap-sid           = var.sap_sid
    sap-apsid         = var.sap_apsid
    sap-volume-type   = var.app_volume_type
  }
 
}
# Output Public IP of the Instance
output "sap_web_dispatcher_public_ips" {
  value             = aws_instance.sap_web_dispatcher[*].public_ip
}
