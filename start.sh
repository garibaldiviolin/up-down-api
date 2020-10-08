#/bin/bash

# If terraform.tfvars file is not present, ask and save the
# user's AWS credentials and region to be used by Terraform
# It also creates the terraform.tfvars based on a variables.template
# file, so DO NOT modify or remove this file!
if ! [ -e ./terraform.tfvars ]; then
    echo "Please inform your AWS credentials and region"
    read -p "region: " region
    read -p "access_key: " access_key
    read -p "secret_key: " secret_key

    cp variables.template terraform.tfvars
    echo "access_key = $access_key" >> terraform.tfvars
    echo "secret_key = $secret_key" >> terraform.tfvars
    echo "public_key_path = $PWD/id_rsa.pub" >> terraform.tfvars
    echo >> terraform.tfvars
fi

# if unzip is not present, install it
if ! [ -x "$(command -v unzip)" ]; then
    sudo apt-get update
    sudo apt-get install -y unzip
fi

# if terraform is not present, install it
if ! [ -e ./terraform ]; then
    rm -Rf ./terraform*
    wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
    unzip terraform_0.11.13_linux_amd64.zip
fi

# Add current folder to PATH to allow execution of terraform
export PATH=$PATH:$PWD

# Ask for user's AWS email and create SSH keys to be used to
# access all EC2 instances
if ! [ -e ./id_rsa ]; then
    read -p "aws_email: " aws_email
    ssh-keygen -t rsa -b 4096 -C "$aws_email" -f ./id_rsa -q -N ""
fi

terraform init
terraform plan
terraform destroy
