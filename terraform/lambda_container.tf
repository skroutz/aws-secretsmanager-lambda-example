module "lambda_container" {
  source="terraform-aws-modules/lambda/aws"

  function_name   = local.lambda-container-name
  description     = "Example Python Lambda Container with Secrets Manager integration"
  
  create_package = false
  package_type = "Image"

  # create_lambda_function_url = true
  image_uri    = "533973265978.dkr.ecr.eu-central-1.amazonaws.com/secretsmanager-lambda-example-ecr:v0.0.10"
  # image_config_entry_point =  ["/app/lambda-secrets"]
  # image_config_working_directory = "/app"
  # image_config_command = ["-f", "/app/secrets.yaml"]
  # docker_build_root = "../lambda-container/"
  # docker_file = "../lambda_container/Dockerfile"

  lambda_role = module.lambda_role.iam_role_arn
  create_role = false

  tags = local.tags
}