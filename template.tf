provider "aws" {
    # profile =                 "${var.profile}"
    shared_credentials_file = "./aws_credentials"
    region =                  "us-east-1"
}

# Resource configuration
# This AMI is equivalent to Ubuntu 16.04 64 bits
resource "aws_instance" "hello-instance" {
    ami = "ami-06b263d6ceff0b3dd"
    instance_type = "t2.micro"
    tags {
        Name = "hello-instance"
    }
}
