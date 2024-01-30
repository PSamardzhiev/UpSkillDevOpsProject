# NextCloud on AWS EC2 Instance using DevOps Practices
##### Telerik Academy DevOps UpSkill Final Project - 2023-2024 #####
## Table of Contents

- [Overview](#overview)
- [Repo Structure](#Repo-Structure)
- [Branching Strategy](#Branching-Strategy)
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

## Branching Strategy
Currently available branches: `main` and `new-features`  
The `main` branch is protected and any changes needs to come via PR  
New changes and features should be introduced via `new-features` branch  

## CICD Workflow Details:
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
Source file `./packer/packer.pkr.hcl`
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
`source file: ./terraform/main.tf`
### Terraform AWS Infrastructure Deployment

This Terraform configuration automates the deployment of AWS infrastructure, designed specifically for the Telerik DevOps Upskill program. The primary goal is to showcase a complete CI/CD pipeline by deploying a Dockerized NextCloud application.

### Key Components:

1. **AWS Provider Configuration**: The AWS provider is set to the us-east-1 region.

2. **VPC Definition**: Defines a Virtual Private Cloud (VPC) with specified CIDR block and tags for identification.

3. **Subnet Deployment**: Private and public subnets are deployed within the VPC, each associated with respective availability zones.

4. **Route Tables**: Creates route tables for public and private subnets, with configurations for internet and NAT gateways.

5. **Internet Gateway and NAT Gateway**: Establishes an internet gateway for public subnets and a NAT gateway for private subnets.

6. **EC2 Instance**: Launches an EC2 instance in a public subnet, running a Dockerized NextCloud application. Ansible is used to configure the instance.

7. **S3 Bucket**: S3 bucket deployment for tfstate, MyAWSKey.pem and tfplan storage

8. **Security Groups**: Defines security groups for SSH, web traffic, and ICMP ping.

### Usage:

1. Ensure AWS credentials are properly configured.

2. Update variables in `variables.tf` to match your desired configurations.

3. Run `terraform init`, `terraform plan`, and `terraform apply` to deploy the infrastructure.

4. Explore and adapt the Terraform modules based on your specific requirements.

This Terraform setup serves as a practical example for creating a robust AWS infrastructure and integrating it into a larger DevOps workflow.  

---
`source file: ./terraform/outputs.tf`

### Terraform Outputs

This Terraform configuration provides useful outputs to retrieve information about the deployed infrastructure. These outputs can be leveraged for better visibility and integration into other parts of your DevOps workflow.

### Outputs:

1. **Project Name:**
   - Description: Print a custom message.
   - Value: "Telerik Academy UpSkill DevOps Project"

2. **VPC ID:**
   - Description: Output the ID of the Virtual Private Cloud (VPC).
   - Value: The ID of the VPC created during deployment.

3. **Public URL for Web Server:**
   - Description: Public URL for accessing the web server.
   - Value: `http://${aws_instance.web_server.public_ip}:80`

4. **EC2 Private IP Address:**
   - Description: Private IP address of the EC2 instance.
   - Value: The private IP address of the web server instance.

5. **EC2 Public IP Address:**
   - Description: Public IP address of the EC2 instance.
   - Value: The public IP address of the web server instance.

6. **VPC Information:**
   - Description: Information about the VPC environment.
   - Value: "Your ${aws_vpc.vpc.tags.Environment} VPC has an ID of ${aws_vpc.vpc.id}"

7. **EC2 Instance Name:**
   - Description: Outputs the name of the EC2 instance.
   - Value: The value of the 'Name' tag assigned to the web server instance.

   > Note: The 'sensitive' attribute is set to false for the EC2 instance name output, making it visible in the output without hiding sensitive information.

### Usage:

Retrieve these outputs using the `terraform output` command after successfully applying the Terraform configuration. These outputs can be valuable for scripting, automation, or integrating with other tools in your DevOps pipeline.

---
`source file: ./terraform/terraform.tf`

### Terraform Configuration

This Terraform configuration file specifies the required version of Terraform and the necessary providers for the successful execution of the deployment script.

### Configuration Details:

- **Terraform Version:**
  - Minimum Required Version: 1.0.6
  - Details: This configuration requires Terraform version 1.0.6 or newer to ensure compatibility.

- **Required Providers:**
  - **AWS Provider:**
    - Source: hashicorp/aws
    - Version: ~> 5.0
  - **Random Provider:**
    - Source: hashicorp/random
    - Version: ~> 3.1.0
  - **HTTP Provider:**
    - Source: hashicorp/http
    - Version: ~> 2.1.0
  - **Local Provider:**
    - Source: hashicorp/local
    - Version: ~> 2.1.0
  - **TLS Provider:**
    - Source: hashicorp/tls
    - Version: ~> 4.0.0

### Usage:

Ensure that you have Terraform version 1.0.6 or a newer version installed. Use the specified providers to integrate with the respective services during the deployment process. Update the versions as needed, following the specified version constraints.

---
`source file: ./terraform/variables.tf`

### Terraform Variables

This section defines the variables used in the Terraform configuration, allowing for customization and flexibility during deployment.

### Variable Details:

- **aws_region:**
  - Type: string
  - Description: Specifies the AWS region to test AWS resources created using Terraform.
  - Default: "us-east-1"

- **vpc_name:**
  - Type: string
  - Description: Specifies the name for the Virtual Private Cloud (VPC).
  - Default: "demo_vpc"

- **vpc_cidr:**
  - Type: string
  - Description: Specifies the CIDR block for the VPC.
  - Default: "10.0.0.0/16"

- **private_subnets:**
  - Type: map
  - Description: Defines the private subnets with corresponding availability zone numbers.
  - Default: { "private_subnet_1" = 1, "private_subnet_2" = 2, "private_subnet_3" = 3 }

- **public_subnets:**
  - Type: map
  - Description: Defines the public subnets with corresponding availability zone numbers.
  - Default: { "public_subnet_1" = 1, "public_subnet_2" = 2, "public_subnet_3" = 3 }

- **variables_sub_cidr:**
  - Type: string
  - Description: CIDR block for the Variables Subnet.
  - Default: "10.0.202.0/24"

- **variables_sub_az:**
  - Type: string
  - Description: Availability Zone used for the Variables Subnet.
  - Default: "us-east-1a"

- **variables_sub_auto_ip:**
  - Type: bool
  - Description: Set automatic IP assignment for the Variables Subnet.
  - Default: true

- **environment:**
  - Type: string
  - Description: Specifies the environment for deployment.
  - Default: "dev"

- **vpc_owner:**
  - Type: string
  - Description: Specifies the deployment owner.
  - Default: "Petko"

- **instance_type:**
  - Type: string
  - Description: Specifies the AWS Instance Type (EC2 Type).
  - Default: "t2.medium"

### Usage:

Adjust these variables according to your deployment requirements. Update the values to match your desired configuration before running Terraform.

---


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
Improve tfstate using dynamoDB

## License:
The 'LICENSE' file in this repository outlines the rules of engagement governing the use of the project's source code and assets. It establishes the terms under which you can embrace and share this work. Kindly respect and honor these terms as you engage with and contribute to this project.

### Terms of Use

[MIT License]

Please refer to the 'LICENSE' file in this repo for the specific terms and conditions governing the use of this project.

## Contributors and Collaborators
### Contributors
- Petko Samardzhiev - github: https://github.com/PSamardzhiev

### Collaborators
- Iliyan Vutoff - github: https://github.com/vutoff
- Daniel Rankov - github: https://github.com/severel

