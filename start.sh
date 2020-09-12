#/bin/bash

# If user.tfvars file is not present, ask and save the
# user's AWS credentials and region to be used by Terraform
if ! [ -e ./user.tfvars ]; then
    echo "Please inform your AWS credentials and region"
    read -p "region: " region
    read -p "access_key: " access_key
    read -p "secret_key: " secret_key

    echo "access_key = $access_key" >> user.tfvars
    echo "secret_key = $secret_key" >> user.tfvars
    echo "public_key_path = $PWD/id_rsa.pub" >> user.tfvars
    echo >> user.tfvars
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
terraform plan -var-file="user.tfvars"
