#!/bin/bash

# Specify the S3 bucket name and tfstate file name
S3_BUCKET_NAME="devops-tfm-s3-bucket-us-east-1a"
TFSTATE_FILE_NAME="terraform.tfstate"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and configure your credentials."
    exit 1
fi

# Check if the specified S3 bucket exists
if ! aws s3 ls "s3://$S3_BUCKET_NAME" &> /dev/null; then
    echo "S3 bucket '$S3_BUCKET_NAME' does not exist or you don't have permission to access it."
    exit 1
fi

# Copy tfstate file from S3 bucket to local terraform directory
aws s3 cp "s3://$S3_BUCKET_NAME/$TFSTATE_FILE_NAME" ./
cp -f ./$TFSTATE_FILE_NAME ../terraform/terraform.tfstate
echo "tfstate file copied successfully from S3 bucket to local directory: $LOCAL_DIRECTORY"
sleep 2
cd ../terraform
terraform init
terraform refresh
terraform destroy

