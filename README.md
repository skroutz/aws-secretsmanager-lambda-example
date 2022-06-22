# aws-secretsmanager-lambda-example
An example application that showcases a Lambda Deployment with AWS SecretsManager integration based on Lambda Layers, through Github Workflows.

# Contents
## `py-function/`

This directory contains code for:

* A basic Python Lambda Function that serves the value of an Environment Variable (`SECRET_VALUE`)

## `rb-function/`

This directory contains code for:

* A basic Ruby Lambda Function that serves the value of an Environment Variable (`SECRET_VALUE`)

---
**Multiple lambda functions are deployed to showcase  Secrets Layer's compatibility with multiple Lambda Runtimes**

## `secrets-layer/`

This directory contains code for:

* A Go script for retrieving a secret value from Amazon Secrets Manager API
* A Bash wrapper script, as an entrypoint executing the Go script, exporting the secret value in an Environment Variable and forwarding execution to the Lambda handler.

## `terraform/`

This directory contains code for deploying:

* An IAM User that can assume an IAM Role able to deploy the Lambda Layer and Function (used by Github Workflows)
  * Least privilege access to resources like Lambda Functions and Layers
* A SecretsManager secret to be used by the Lambda app
* An IAM Role to be used by the Lambda Layer to pull the secret from AWS SecretsManager API
* A Lambda Function running the app code
* A Lambda Layer to abstract the process of exporting secrets from Amazon Secrets Manager to Environment Variables for consumption by the Lambda handler running the application code.

# Usage

First of all one needs to deploy the whole terraform directory. This works as below:

```
cd terraform/

# First create the user
terraform apply -target module.user

# Then the rest of the resources
terraform apply
```

The Terraform outputs contain IAM User Keys that need to be set in Github Secrets and AWS resource names to be set in Github Workflows `env:` for [Deploying the Lambda Function](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/deploy-lambda-function.yml#L11) and [Publishing the Secrets Layer](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/publish-secrets-layer.yml#L11). Both Workflows assume terraform has run succesfully.

# Workflows

Commiting to main under `py-function/` path will trigger the [`Deploy to Lambda Function`](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/deploy-lambda-function.yml) Github Workflow, which creates a zip archive with the contents of `./py-function` and updates the deployed function's code using `lambda:UpdateFunctionCode` via AWS cli.

Commiting to main under `secrets-layer/` path will trigger the [`Publish Lambda Secrets Layer`](https://github.com/skroutz/aws-secretsmanager-lambda-example/blob/main/.github/workflows/publish-secrets-layer.yml) Github Workflow, which builds the Go binary for retrieving secrets via Secrets Manager's API and creates a zip archive with the contents of `./secrets-layer` along with the complied binary. The zip archive is published as a Lambda Layer Version using `lambda:PublishLayerVersion` via AWS cli.

# Other Resources:

* [\[Github Action\] aws-lambda-deploy. (does not work for publishing Layers)](https://github.com/marketplace/actions/aws-lambda-deploy)

* [\[AWS\] Creating AWS Lambda environment variables from AWS Secrets Manager](https://aws.amazon.com/blogs/compute/creating-aws-lambda-environmental-variables-from-aws-secrets-manager/)

* [\[AWS\] Lambda Runtime Wrapper](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-modify.html#runtime-wrapper)

* [\[AWS\] Creating and sharing Lambda layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html)