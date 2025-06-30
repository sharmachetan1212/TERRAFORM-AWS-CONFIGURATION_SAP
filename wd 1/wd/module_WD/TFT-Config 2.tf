module "IAC_TFT" {
  source                        = "../../wd"
  application_name              = "Web Dispatcher"
  instance_profile              = "ec2-readonly"
  sap_sid                       = "BPM"
  wd_count                      = 1
  user                          = "chetan"
  IAC_org                       = "SystemAdministrator"
  instance_type_wd              = "t2.micro"
  wd_ami                        = "ami-012967cc5a8c9f891"
  appid                         = "APPID01234567890"
  sap_apsid                     = "APSID_WD_9876543210"
  region                        = "us-east-1"
  aws_vpc                       = "vpc-036268133895cbb5a"
  aws_subnet_id                 = ["subnet-06b04478c693753f9"]
}
