# resource "aws_lambda_layer_version" "secrets-layer" {
#   layer_name          = local.lambda-layer-name
#   description         = "Example Lambda Layer for exporting secrets from Secrets Manager as environment variables"

#   filename = "../secrets-layer.zip"
#   compatible_runtimes = ["python3.8", "python3.9", "ruby2.7"]

#   # tags = local.tags
# }

# module "lambda_layer" {
#   source = "terraform-aws-modules/lambda/aws"

#   create = false
#   create_layer = false

#   layer_name          = "${local.lambda-layer-name}"
#   description         = "Example Lambda Layer for exporting secrets from Secrets Manager as environment variables"
#   compatible_runtimes = ["python3.8", "ruby2.7"]

#   source_path = "../secrets-layer/"

#   tags = local.tags
# }
