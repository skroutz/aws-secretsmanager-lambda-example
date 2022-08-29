module "lambda_container" {
  source="terraform-aws-modules/lambda/aws"

  function_name   = local.lambda-container-name
  description     = "Example Python Lambda Container with Secrets Manager integration"
  
  create_package = false
  package_type = "Image"

  # create_lambda_function_url = true
  image_uri    = "533973265978.dkr.ecr.eu-central-1.amazonaws.com/secretsmanager-lambda-example-container:latest"

  environment_variables = tomap({
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/extensions/wrapper/load-secrets"
    SECRET_REGION = data.aws_region.current.name
  })

  lambda_role = module.lambda_role.iam_role_arn
  create_role = false

  tags = local.tags
}