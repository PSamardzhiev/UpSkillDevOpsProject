# NextCloud on AWS using DevOps Practices
##### Telerik Academy DevOps UpSkill Final Project - 2023-2024 #####
## Table of Contents

- [Overview](#overview)
- [Repo Structure](#Repo-Structure)
- [CICD Workflow](#CICD-Workflow)
- [Usage and Requirements](#Usage-Requirements)

## Quick Overview

The primary goal of this project is to demonstrate a comprehensive CI/CD pipeline by deploying a Dockerized NextCloud application on AWS.

## Repo Structure
```
.
├── ansible
│   └── instance-config.yml  <-- EC2 Ansible Config
├── app  <--application folder
│   ├── compose.yaml  <-- NextCloud YAML File for Docker
│   ├── output.jpg
│   └── README.md  <-- Basic Information about the NextCloud
├── LICENSE  <-- Repo LICENSE file
├── packer
│   └── packer.pkr.hcl <--packer file
├── README.md  <-- Thi README.md file
└── terraform  <-- Terraform Code folder
    ├── main.tf  <-- Main Terraform File
    ├── outputs.tf  <-- Outputs the infrastructure Details
    ├── terraform.tf  <-- TF Modules Version
    └── variables.tf  <-- Variables File
```
## CICD Workflow


## Usage requirements:
- In order to use this project you need to have AWS account and Terraform installed locally, Terraform modules version is outlined in terraform/terraform.tf file
``````hcl
terraform {
  required_version = ">=1.0.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 2.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
  }
}
``````
- Once you have terraform installed locally nagivate to terraform folder and execute the following commands
```bash
terraform init
terraform plan #review the provided plan
terraform apply #confirmation will be requred
``````
