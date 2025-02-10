# This file has been created to provide the region and cloud provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}
