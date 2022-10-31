module "lambda_py_function" {
  source="terraform-aws-modules/lambda/aws"

  function_name   = local.py-lambda-function-name
  description     = "Example Python Lambda Function with Secrets Manager integration"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.8"
  architectures   = ["arm64"]
  
  # create_lambda_function_url = true
  source_path = "../py-function/"

  layers = [
    "arn:aws:lambda:eu-central-1:123456789012:layer:aws-lambda-secrets-layer-arm64:15"
  ]

  environment_variables = tomap({
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/extensions/wrapper/load-secrets"
    SECRET_REGION = data.aws_region.current.name
  })
  
  lambda_role = module.lambda_role.iam_role_arn
  create_role = false

  tags = local.tags
}

module "lambda_rb_function" {
  source="terraform-aws-modules/lambda/aws"

  function_name   = local.rb-lambda-function-name
  description     = "Example Ruby Lambda Function with Secrets Manager integration"
  handler         = "lambda_function.lambda_handler"
  runtime         = "ruby2.7"
  architectures   = ["x86_64"]

  source_path = "../rb-function/"
  # create_lambda_function_url = true

  layers = [
    "arn:aws:lambda:eu-central-1:123456789012:layer:aws-lambda-secrets-layer-x86_64:15"
  ]

  environment_variables = tomap({
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/extensions/wrapper/load-secrets"
    SECRET_REGION = data.aws_region.current.name
  })
  
  lambda_role = module.lambda_role.iam_role_arn
  create_role = false

  tags = local.tags
}