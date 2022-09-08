# aws-secretsmanager-lambda-example
An example repo to showcase different Lambda Deployments leveraging Skroutz's [aws-lambda-secrets](https://github.com/skroutz/aws-lambda-secrets) Extension Layer to integrate with AWS SecretsManager. Deployed via Terraform and Github Workflows.

# Contents
## `py-function/`

This directory contains code for:

* A basic Python Lambda Function (`arm64`) that serves the value of an Environment Variable (`SECRET_VALUE`) to showcase the use of Lambda Secrets Extension

## `rb-function/`

This directory contains code for:

* A basic Ruby Lambda Function (`x86_64`) that serves the value of an Environment Variable (`SECRET_VALUE`) to showcase the use of Lambda Secrets Extension

## `lambda-container/`

This directory contains code for:

* An example Lambda Container Application that serves the value of an Environment Variable (`SECRET_VALUE`) and the Dockerfile to showcase the use of Lambda Secrets Extension

---
**Multiple lambda functions are deployed to demonstrate  Secrets Layer's compatibility with multiple Lambda Runtimes and Architectures**

## `terraform/`

This directory contains code for deploying:

* An IAM User that can assume an IAM Role able to deploy the Lambda Layer and Applications (used by Github Workflows Pipeline)
* Secret Manager secret entries to be used by Lambdas
* An ECR repository to publish the docker image used by Lambda Container app
* An IAM Role to be used by Lambdas to pull the secret values from AWS SecretsManager API
* Two Lambda Functions and a Lambda Container
* (Deprecated) A Lambda Layer to abstract the process of exporting secrets from Amazon Secrets Manager to Environment Variables for consumption by the Lambda handler running the application code.

# Usage

First of all one needs to deploy the whole terraform directory. This works as below:

```
cd terraform/

# First create the user
terraform apply -target module.user

# Then the rest of the resources
terraform apply
```

The Terraform outputs contain IAM User (Keys that need to be set in Github Secrets and AWS resource names to be set as EnvVars under Github Workflows `env:` paramete2.

Workflows Pipeline assumes terraform has run succesfully.)
, s run ruby

# Workflows

Commiting to main under `/py-function` or `/rb-function` path will trigger the relevant `Deploy to Lambda Function` workflow ([python](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/deploy-python-lambda-function.yml), [ruby](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/deploy-ruby-lambda-function.yml)) which creates a zip archive containing the application code and updates the deployed function using AWS cli.

Commiting to main under `/lambda-container` path will trigger [Publish Lambda Image to Amazon ECR](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/publish-lambda-image.yml) workflow which builds and publishes the Lambda Container image to ECR.

# Other Resources:

* [\[Github Action\] aws-lambda-deploy. (does not work for publishing Layers)](https://github.com/marketplace/actions/aws-lambda-deploy)

* [\[AWS\] Creating AWS Lambda environment variables from AWS Secrets Manager](https://aws.amazon.com/blogs/compute/creating-aws-lambda-environmental-variables-from-aws-secrets-manager/)

* [\[AWS\] Lambda Runtime Wrapper](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-modify.html#runtime-wrapper)

* [\[AWS\] Creating and sharing Lambda layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html)