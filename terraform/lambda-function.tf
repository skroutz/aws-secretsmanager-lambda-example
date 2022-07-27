module "lambda_py_function" {
  source="terraform-aws-modules/lambda/aws"

  function_name   = local.py-lambda-function-name
  description     = "Example Python Lambda Function with Secrets Manager integration"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.8"

  # create_lambda_function_url = true
  source_path = "../py-function/"

  layers = [
    "${local.lambda-layer-arn}:49"
  ]

  environment_variables = tomap({
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/secrets-layer/lambda-secrets"
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

  source_path = "../rb-function/"
  # create_lambda_function_url = true

  layers = [
    "${local.lambda-layer-arn}:50"
  ]

  environment_variables = tomap({
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/secrets-layer/secrets-layer.sh"
    SECRET_REGION = data.aws_region.current.name
  })
  
  lambda_role = module.lambda_role.iam_role_arn
  create_role = false

  tags = local.tags
}