# up-down-api
An entire API ecosystem built using Python, Django, Django REST Framework, Postgres, Terraform and AWS.
Based on the article: https://hiveit.co.uk/techshop/terraform-aws-vpc-example/05-prepare-a-web-application-for-ec2/

## Objective
The main idea here is to:
1) create the entire AWS infrastructure to run a REST API built using Python (more details below);
2) download, configure, and run this web application in the EC2 instances;
3) perform a stress test by calling multiple async client requests to the REST API and then shows the time results.

## REST API
More details about the REST API used can be found here: https://github.com/garibaldiviolin/pythonapi .

## Requirements
- Ubuntu distribution with `ssh-keygen` installed;
- Python 3+;
- A `access_key` and a `secret_key` with programming access to AWS.

## How to run
1) Just run `start.sh` script. **Make sure you have sudo permission.**;
2) The first time you run the script, you'll be prompt to insert your AWS credentials and region. Just type this information;
3) Also, this script will try to download and install terraform and unzip. You need to accept the download of these applications in order to complete the process;
4) After that the script will try to generate a new SSH public and private keys for the test in the same directory of the `start.sh`. **So make sure you have installed and configured the `ssh-keygen` as mentioned above.**;
5) If all of the steps above completed successfully, the script will now call terraform to create the infrastructure at AWS;
6) After all that, the script will call `terraform destroy` to remove all the infrastructure from AWS.
