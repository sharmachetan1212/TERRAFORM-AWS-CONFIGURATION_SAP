# TERRAFORM-AWS-CONFIGURATION_SAP
# ☁️ Terraform AWS Configuration for SAP

Infrastructure-as-Code (IaC) project to provision AWS infrastructure for SAP system deployment using Terraform. Designed to automate the creation of networking, compute, storage, and security resources tailored to SAP environments.

---

## 🚀 Project Overview

- 📦 Automates AWS infrastructure setup for SAP workloads
- 📄 Written entirely in Terraform
- 🌍 Supports VPC, Subnets, EC2, EBS volumes, and Security Groups
- 🧩 Modular and reusable Terraform code structure

---

## 🛠️ Tech Stack

- Terraform (v1.x)
- AWS Services:
  - EC2
  - VPC
  - Subnets
  - Security Groups
  - IAM
  - EBS

---

## 📁 Project Structure

```bash
TERRAFORM-AWS-CONFIGURATION_SAP/
├── main.tf                  # Primary infrastructure config
├── variables.tf             # Variable definitions
├── outputs.tf               # Output values
├── providers.tf             # Provider config (AWS)
├── terraform.tfvars         # Variable values (optional)
└── README.md
