locals {
  project-name = "secretsmanager-lambda-example"

  iam-resource-prefix = "SkroutzSecretExampleLambda"

  tags = {
    "PartOf" : "https://phabricator.skroutz.gr/T110466",
    "DeployedFrom" : "https://github.com/skroutz/aws-secretsmanager-lambda-example",
    "Team" : "Security"
    "Environment" : "Testing"
    "ManagedBy" : "Terraform"
  }

  py-lambda-function-name  = "${local.project-name}-py-lambda-function"
  rb-lambda-function-name  = "${local.project-name}-rb-lambda-function"
  lambda-layer-name     = "${local.project-name}-secrets-layer"
  lambda-layer-arn     = "arn:aws:lambda:eu-central-1:533973265978:layer:secretsmanager-lambda-example-secrets-layer"
  secret-path = local.project-name
  secret-name  = "${local.project-name}/secret1"

  iam-deployer-user    = "${local.iam-resource-prefix}DeployerUser"
  iam-deployer-role    = "${local.iam-resource-prefix}DeployerRole"
  iam-deployer-policy  = "${local.iam-resource-prefix}DeployerPolicy"
  iam-execution-role   = "${local.iam-resource-prefix}ExecutionRole"
  iam-execution-policy = "${local.iam-resource-prefix}ExecutionPolicy"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}