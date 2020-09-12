#/bin/bash

# If aws_credentials file is not present, ask and save the
# user's AWS credentials to be used by Terraform
if ! [ -e ./aws_credentials ]; then
    echo "Please inform your AWS credentials"
    read -p "aws_access_key_id: " aws_access_key_id
    read -p "aws_secret_access_key: " aws_secret_access_key

    echo "[default]" > aws_credentials
    echo "aws_access_key_id = $aws_access_key_id" >> aws_credentials
    echo "aws_secret_access_key = $aws_secret_access_key" >> aws_credentials
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

export PATH=$PATH:./terraform
./terraform --help
