output "github-python-workflow-env" {

  description = "The values to be set with Github Workflow"
  value = {
    "AWS_REGION" : data.aws_region.current.name,
    "LAMBDA_FUNCTION_NAME" : module.lambda_py_function.lambda_function_name,
    "ASSUME_ROLE" : module.deployer_role.iam_role_name,
  }
}

output "github-ruby-workflow-env" {

  description = "The values to be set with Github Workflow"
  value = {
    "AWS_REGION" : data.aws_region.current.name,
    "LAMBDA_FUNCTION_NAME" : module.lambda_rb_function.lambda_function_name,
    "ASSUME_ROLE" : module.deployer_role.iam_role_name,
  }
}

output "github-image-workflow-env" {

  description = "The values to be set with Github Workflow"
  value = {
    "AWS_REGION" : data.aws_region.current.name,
    "ECR_REPOSITORY" : local.ecr-name
    "ASSUME_ROLE" : module.deployer_role.iam_role_name,
  }
}

output "github-custom-image-workflow-env" {

  description = "The values to be set with Github Workflow"
  value = {
    "AWS_REGION" : data.aws_region.current.name,
    "ECR_REPOSITORY" : local.custom-ecr-name
    "ASSUME_ROLE" : module.deployer_role.iam_role_name,
  }
}

output "aws-deployer" {

  description = "The IAM API Keys to set in Github Secrets"
  sensitive   = true
  value = {
    "AWS_ACCESS_KEY_ID" : module.user.iam_access_key_id,
    "AWS_SECRET_ACCESS_KEY" : module.user.iam_access_key_secret,
  }
}