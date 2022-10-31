# AWS Secrets Manager Lambda Example
This repo consist of a collection of example Lambda applications deployed as native functions and containers to showcase the integration and compatibility of Skroutz's [aws-lambda-secrets](github.com/skroutz/aws-lambda-secrets) extension with various Lambda runtimes and architectures.

## Contents

### `terraform`
This directory contains code for deploying:

* An IAM deployer user that can assume an IAM deployer role able to deploy the example applications (used by Github Workflows)
* Least privilege access to resources like ECR, Lambdas, etc
* 2 Container Registries (ECR)
* 2 Lambda native functions and 2 Lambda containers
* 2 SecretsManager secrets to be used by the applications
* An IAM Role to be used by the Lambda applications to access the AWS SecretsManager secrets

### Example applications

* `/py-function`: simple python app
* `/rb-function`: simple ruby app
* `/lambda-container`: simple app packed with aws-lambda-extension in a container image
* `lambda-custom-container`: simple app packed with aws-lambda-extension configured to run with aws-ric within a custom container

### Github Workflows

Github Workflows assume terraform has run properly.

* pushing changes under `/py-function` or `/rb-function` triggers the corresponding workflow deploying a new function version
* pushing changes under `/lambda-container` or `/lambda-custom-container` triggers the corresponding workflow publishing a new container image to ECR