# Terraform & Ansible AWS Deployment for NextCloud

This repository contains the infrastructure as code (IaC) setup using Terraform and Ansible to deploy a Dockerized NextCloud application on AWS. The project is created for the Telerik DevOps Upskill program, showcasing a complete CI/CD pipeline.


## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Infrastructure Details](#infrastructure-details)
- [Ansible Playbook](#ansible-playbook)
- [Terraform Configuration](#terraform-configuration)
- [Variables](#variables)
- [How to Use](#how-to-use)
- [Contributors](#contributors)
- [License](#license)

## Overview

The primary goal of this project is to demonstrate a comprehensive CI/CD pipeline by deploying a Dockerized NextCloud application on AWS. The technologies utilized include Ansible, Terraform, and AWS. The project is specifically designed for the Telerik DevOps Upskill program.

## Repo Structure
```
.
├── ansible
│   └── instance-config.yml <-- EC2 Configuration FIle
├── app <--application folder
│   ├── compose.yaml <-- NextCloud YAML File for Docker
│   ├── output.jpg
│   └── README.md <-- Basic Information about the NextCloud
├── LICENSE <-- Repo LICENSE file
├── packer
│   └── packer.pkr.hcl <--packer file
├── README.md <-- Thi README.md file
└── terraform <-- Terraform Code folder
    ├── main.tf
    ├── outputs.tf
    ├── terraform.tf
    └── variables.tf
```
## Project goal and Overview


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
