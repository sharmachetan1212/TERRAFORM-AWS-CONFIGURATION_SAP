provider "aws" {
  region = var.region
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

variable "IAC_org" {
  type = string
}
