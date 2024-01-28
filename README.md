# NextCloud on AWS using DevOps Practices
##### Telerik Academy DevOps UpSkill Final Project - 2023-2024 #####
## Table of Contents

- [Overview](#overview)
- [Repo Structure](#Repo-Structure)
- [CICD Workflow Details](#CICD-Workflow)
- [Packer Details](#Immutable-Infrastructure-with-Hashicorp-Packer)
- [Terraform IaC Details](#Terraform-IaC-Details)
- [Ansible Config Management Details](#Ansible-Configuration-Managmenet)
- [Usage and Requirements](#Usage-Requirements)
- [Possible Future Improvements](#Future-Improvements)
- [License](#License)
- [Contributors and Collaborators](#Contributors-and-Collaborators)

## Quick Overview

The primary goal of this project is to demonstrate a comprehensive CI/CD pipeline by deploying a Dockerized NextCloud application on AWS using set of DevOps practices such as:

- Branching Strategies, CICD, AWS Cloud, Packer - immutable infrastructure, Terraform Code, Security Checks with Chekov, Code Format, Code Validation, Configuration Management (Ansible) Installation, Instance Configuration management from central management system, Docker, Cutom Docker Application (image) deployment.

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
## CICD Workflow Details
`source file: .git/workflows/terraform.yaml`

Defines single job with multiple steps as a complete CICD Pipeline
- Setup AWS Cli by exporting access key and secret access key to the build environment
- Setup Terraform using hashicorp/setup-terraform@v1
- Installs Checkov using Python PIP
- Terraform init - initiates the terraform code
- Checkov Scan - performs an security scan with Chekov, the pipeline will not continue if Checkov scan fails
- Formats terraform code using terraform fmt
- Performs Terraform Code validation using terraform validate, if the validation fails the pipeline will not continue
- Creates terraform plan with output to tfplan file
- Finally if the above mentioned checks are passed, then terraform apply with auto-approve is executed to build the AWS environment
- As a final step, once the EC2 environment is built using the terraform code, the pipeline copies the tfstate (terraform state file), MyAWSKey.pem (private key for EC2 management*) and tfplan file to a private S3 Bucket.
- * The Infrastructure administrator can download the MyAWSKey.pem file and use ssh -i MyAWSKey.pem ubuntu@Public-IP-Address in order to connect and manually manage the EC2 VM.
- The below image shows the completed CICD Pipeline in GitHub:

![CICD](img/cicd.jpg)

## Immutable Infrastructure with Hashicorp Packer:
### Packer Template for Ubuntu AMI

This part of the project contains a Packer template for building an Amazon Machine Image (AMI) with Ubuntu 22.04 using the `amazon-ebs` builder. The resulting AMI is named "telerik-demo-ami" and is configured for use in the `us-east-1` region with an instance type of `t2.micro`.

Packer Configuration

The Packer template utilizes the `amazon-ebs` builder with the following configuration:

- **AMI Name**: "telerik-demo-ami"
- **Instance Type**: "t2.micro"
- **Region**: "us-east-1"
- **Source AMI Filter**:
  - Filters for the latest Ubuntu 22.04 AMD64 server image.
  - Filters for EBS root device type and HVM virtualization type.
  - Owner set to Canonical (owner ID: "099720109477").
- **SSH Username**: "ubuntu"

How to Use

1. Install Packer on your local machine.
2. Clone this repository and navigate to the `./packer` folder
3. Review and customize the Packer template (`packer.pkr.hcl`) if needed.
4. Run the Packer build command: `packer build ubuntu-ami.pkr.hcl`.

The resulting AMI will be available in your AWS account with the specified name ("telerik-demo-ami") and configuration.

## Terraform IaC Details:


## Ansible Configuration Managmenet:
`source file: ./ansible/instance-config.yaml`  
Ansible Playbook Desired State Configuration: Install Docker on EC2 Instance  

The following Ansible playbook, `install_docker.yml`, automates the installation of Docker on an EC2 target instance. This playbook is designed to be executed on the localhost, assuming you have SSH access to the target EC2 instance.

### Playbook Tasks:

1. **Get Current User**: Retrieves the current user information on the localhost.

2. **Update Apt Packages**: Ensures that the apt package manager on the localhost is up-to-date.

3. **Install Docker Dependencies**: Installs essential dependencies required for Docker on the localhost.

4. **Add Docker GPG Key**: Adds the GPG key for the Docker repository.

5. **Add Docker APT Repository**: Adds the Docker APT repository to the package manager.

6. **Install Docker**: Installs the Docker Community Edition on the localhost.

7. **Add User to Docker Group**: Adds the current user to the Docker group, enabling Docker commands without sudo.

8. **Start Docker Service**: Ensures that the Docker service is started on the localhost.

### How to Use:

1. Ensure you have SSH access to the target EC2 instance.

2. Update the target EC2 instance details in the `hosts` section of the playbook if necessary.

3. Run the playbook using the command: `cd ansible && ansible-playbook instance-config.yaml `.

This playbook streamlines the process of setting up Docker on an EC2 instance, providing a seamless environment for containerized applications.

## Usage requirements:
- In order to use this project and manually create the infrastructure you need to have AWS account and Terraform installed locally, Terraform modules version is outlined in terraform/terraform.tf file
``````hcl
          terraform.tf

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
- Once you have terraform installed locally nagivate to terraform folder and execute the following commands in your terminal:

```bash
terraform init
terraform plan #review the provided plan
terraform apply #confirmation will be requred
```
## Future Improvements:
Migrate the application to Kubernetes (AWS EKS)  
Implement Observavility Tools  
Scale out the application

## License:
The 'LICENSE' file in this repository outlines the rules of engagement governing the use of the project's source code and assets. It establishes the terms under which you can embrace and share this work. Kindly respect and honor these terms as you engage with and contribute to this project.

### Terms of Use

[MIT License]

Please refer to the 'LICENSE' file in this repo for the specific terms and conditions governing the use of this project.

## Contributors and Collaborators
### Contributors
- Petko Samardzhiev

### Collaborators
- Iliyan Vutoff - github: https://github.com/vutoff
- Daniel Rankov - github: https://github.com/severel

