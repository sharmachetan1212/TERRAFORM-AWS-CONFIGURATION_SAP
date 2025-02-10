# variables.tf
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
}

variable "db_count" {
  description = "How many EC2 servers you want"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "This describes the ami image"
  type        = string
  default     = "ami-08d70e59c07c61a3a"
}

variable "db_server" {
  description = "CS server EC2 name"
  type        = string
  default     = "DB"
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

variable "instance_profile" {
  description = "Desired instance profile"
}

variable "user" {
  description = "Description of the user input"
  type        = string
}

variable "IAC_org" {
  description = "Organization tag creation for all instances based on jx2"
  type        = string
}

variable "instance_type_list" {
  description = "List of allowed EC2 instance types (already defined and static)"
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

variable "instance_type_db" {
  description = "Instance type to be used for CS instances"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(var.instance_type_list, var.instance_type_db)
    error_message = "Invalid instance type. Please select one of the following: ${join(", ", var.instance_type_list)}."
  }
}

variable "oracle_disk_size" {
  description = "Total size of the database (DB) in GiB"
  type        = number
  default     = 200
}

variable "oracle_disk_num" {
  description = "Number of sapdata mounts (n)"
  type        = number
  default     = 4
}

variable "availability_zone" {
  description = "Availability Zone to create resources"
  type        = string
  default     = "us-east-1a"
}

variable "custom_db_swap" {
  type        = number
  description = "Custom swap size for SAP Oracle DB server instances"
  default     = 128
}

variable "oracle_sapdata_volume_type" {
  type        = string
  description = "(Optional) Can be set to GP2 or GP3"
  default     = "gp3"
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

variable "oracle_oraarch_volume_type" {
  type        = string
  description = "(Optional) Can be set to GP2 or GP3"
  default     = "gp3"
}

variable "oracle_log_disk_num" {
  description = "EBS Disk number for `ORACLE ORIG and MIRR Log`"
  type        = number
  default     = 1
}

variable "oracle_log_disk_size" {
  description = "EBS Disk size for `ORACLE ORIG and MIRR Log`"
  type        = number
  default     = 10
}

variable "oracle_orig_mirr_log_volume_type" {
  type        = string
  description = "(Optional) Can be set to GP2 or GP3"
  default     = "gp3"
}

variable "oracle_data_iops" {
  type        = number
  description = "If disk_size is specified as custom, it's mandatory to provide a value for oracle_data_iops"
  default     = 3000
}

variable "oracle_data_throughput" {
  type        = number
  description = "If disk_size is specified as custom, it's mandatory to provide a value for oracle_data_iops"
  default     = 125
}

variable "oracle_flashback_disk" {
  description = "EBS Disk Map for `ORACLE Flashback`"
  type        = number
  default     = 50
}

variable "oracle_flashback_volume_type" {
  type        = string
  description = "(Optional) Can be set to GP2 or GP3"
  default     = "gp3"
}

variable "region" {
  type        = string
  description = "Provide the AWS region"
  default     = "us-east-1"
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
