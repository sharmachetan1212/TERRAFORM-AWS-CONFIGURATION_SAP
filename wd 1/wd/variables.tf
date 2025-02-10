variable "application_name" {
  description = "Application name"
}

variable "wd_count" {
  description = "SAP Application Server Count"
  type = number

  validation {
    condition     = var.wd_count > 0
    error_message = "wd_count must be greater than 0."
  }
}

variable "wd_server" {
  type = string
  description = "Count of the instance type name"
  default = "WD"
}

variable "efs_encryption" {
  description = "Enable EFS encryption"
  default     = true
}

variable "env" {
  description = "Allows you to specify the environment"
  default     = "prod"

  validation {
    condition     = contains(["prod", "qa", "dev"], var.env)
    error_message = "Environment must be one of: prod, qa, dev."
  }
}

variable "instance_profile" {
  description = "Desired instance profile"
}

variable "os_filter" {
  description = "OS type"
  default     = "*ami*"
}

variable "sap_sid" {
  description = "The 3 character alpha numeric SAP SID and/or HANA tenant SID in upper case"

  validation {
    condition     = length(var.sap_sid) == 3 && can(regex("^[A-Z0-9]{3}$", var.sap_sid))
    error_message = "SAP SID must be exactly 3 alphanumeric uppercase characters."
  }
}

variable "subnet_filter" {
  description = "Allows you to query the desired subnet"
  default     = "default-subnet-public1-us-east-1a" # Change to string if a single value
}

variable "subnet_id" {
  description = "Allows you to query the desired subnet id"
  default     = "subnet-063ce7808fdabeed2" 
}

variable "tags_as" {
  description = "Additional tags for the SAP AS instance type"
  default     = {}
}

variable "tags_cs" {
  description = "Additional tags for the SAP CS instance type"
  default     = {}
}

variable "tags_db" {
  description = "Additional tags for the SAP HDB instance type"
  default     = {}
}

variable "tags_efs" {
  description = "Variable to store EFS tags for SAP workloads"
  default     = {}
}

variable "user" {
  description = "Account ID of the user"
}

variable "vpc_id" {
  description = "Allows you to specify the VPC ID"
  default     = "vpc-036268133895cbb5a"
}

variable "vpc_filter" {
  description = "Allows you to query the desired VPC"
  default     = "default-vpc*"
}

variable "vpcxEnvironment" {
  description = "Allows you to specify the VPCx environment"
  default     = "PROD"

  validation {
    condition     = contains(["PROD", "QA", "DEV"], var.vpcxEnvironment)
    error_message = "vpcxEnvironment must be one of: PROD, QA, DEV."
  }
}

# List of allowed instance types (already defined and static)
variable "instance_type_list" {
  description = "List of allowed EC2 instance types"
  type        = list(string)
  default = [
    "t2.micro", "m6i.large", "c6i.large", "r6i.large", "d3en.large", "r5b.large", "m5n.large", "x1e.large",
    "m6i.xlarge", "c6i.xlarge", "r6i.xlarge", "d3en.xlarge", "r5b.xlarge", "m5n.xlarge", "x1e.xlarge",
    "m6i.2xlarge", "c6i.2xlarge", "r6i.2xlarge", "d3en.2xlarge", "r5b.2xlarge", "m5n.2xlarge", "x1e.2xlarge",
    "m6i.4xlarge", "c6i.4xlarge", "r6i.4xlarge", "d3en.4xlarge", "r5b.4xlarge", "m5n.4xlarge", "x1e.4xlarge",
    "m6i.8xlarge", "c6i.8xlarge", "r6i.8xlarge", "d3en.8xlarge", "r5b.8xlarge", "m5n.8xlarge", "x1e.8xlarge",
    "m6i.16xlarge", "c6i.16xlarge", "r6i.16xlarge", "d3en.16xlarge", "r5b.16xlarge", "m5n.16xlarge", "x1e.16xlarge"
  ]
}

variable "instance_type_wd" {
  description = "Instance type to be used for CS instances"
  type        = string
  default     = "c6i.xlarge"

  validation {
    condition     = contains(var.instance_type_list, var.instance_type_wd)
    error_message = "Invalid instance type. Please select one of the following: ${join(", ", var.instance_type_list)}."
  }
}

variable "wd_ami" {
  description = "AMI for web dispature"
  type        = string
  default     = ""
}

variable "region" {
  type = string
  description = "Provide the AWS region"
  default = "us-east-1"
}

variable "appid" {
  type        = string
  description = "APP ID for the SAP system"
}

variable "sap_apsid" {
  type        = string
  description = "APS ID for SAP systems"
  default     = null
}

variable "swap_volume_type" {
  description = "EBS volume to be created for the SWAP mount"
  type        = string
  default     = "gp3"
}

variable "app_volume_type" {
  type        = string
  description = "(Optional) Can be set to GP2 or GP3"
  default     = "gp3"
}

variable "aws_vpc" {
  type        = string
  description = "For the desired VPC or private VPC"
  default     = "vpc-036268133895cbb5a"
}

variable "aws_subnet_id" {
  type        = list(string)
  description = "For the subnets thats comes under the desired VPC"
  default     = ["subnet-06b04478c693753f9"]
}
