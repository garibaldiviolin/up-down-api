# up-down-api
A entire API ecossystem buit using Python, Django, Django REST Framework, Postgres, Terraform and AWS
Based on the article: https://hiveit.co.uk/techshop/terraform-aws-vpc-example/05-prepare-a-web-application-for-ec2/

## Objective
The main idea here is to:
1) create the entire AWS infrastructure to run a REST API built using Python (more details below);
2) download, configure, and run this web application in the EC2 instances;
3) perform a stress test by calling multiple async client requests to the REST API and then shows the time results.

## REST API
More details about the REST API used can be found here: https://github.com/garibaldiviolin/pythonapi

## Requirements
- Ubuntu distribution
- Python 3+
