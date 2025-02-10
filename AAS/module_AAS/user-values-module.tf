module "user_module" {
  source              = "../../AAS" # Path to the module
  instance_name       = "TERRAFORM-AWS"
  instance_type_as    = "t2.micro"
  instance_profile    = "ec2-readonly"
  as_count            = 1
  user                = "chetan.sharma"
  ami_id              = "ami-012967cc5a8c9f891"
  sap_sid             = "BPM"
  IAC_org             = "SystemAdministrator"
  appid               = "APPID01234567890"
  sap_apsid           = "APSID_AAS_9876543210"
  region              = "us-east-1"
  aws_vpc             = "vpc-036268133895cbb5a"
  aws_subnet_id       = ["subnet-06b04478c693753f9"]
}
