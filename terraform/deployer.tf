# Lambda Deployer Role trust policy
data "aws_iam_policy_document" "deployer-trust-policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      # Github Action Tag the Sessions with specific metadata
      "sts:TagSession"
    ]

    principals {
      type = "AWS"
      identifiers = [
        # Only the created user (deployer) can assume the Role
        module.user.iam_user_arn
      ]
    }
  }
}

# Lambda Deployer Role policy document
data "aws_iam_policy_document" "deployer-policy" {
    statement {
        sid = "DeployLambdaCode"
        effect = "Allow"

        actions = [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
        ]

        resources = [
            "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${local.py-lambda-function-name}",
            "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${local.rb-lambda-function-name}",
        ]
    }

    statement {
      sid = "PublishLambdaLayerVersion"
      effect = "Allow"

      actions = [
        "lambda:PublishLayerVersion"
      ]

      resources = [
        "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:layer:${local.lambda-layer-name}"
      ]
    }
}

module "deployer_policy" {
    source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-policy?ref=v5.1.0"

    name = local.iam-deployer-policy
    description = "Part of https://phabricator.skroutz.gr/T110466"
    policy = data.aws_iam_policy_document.deployer-policy.json

    tags = local.tags
}

# Role to be assumed by Lambda Deployer User used in Github Workflow
module "deployer_role" {
    source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-assumable-role?ref=v5.1.0"

    create_role = true

    role_name = local.iam-deployer-role
    role_requires_mfa = false

    custom_role_trust_policy = data.aws_iam_policy_document.deployer-trust-policy.json
    custom_role_policy_arns = [
        module.deployer_policy.arn,
    ]

    tags = local.tags

}

# Deployer User bound to Github Action
module "user" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-user?ref=v5.1.0"

  create_iam_access_key = true
  create_user           = true
  name                  = local.iam-deployer-user

  tags = local.tags
}