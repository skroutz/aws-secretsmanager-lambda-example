resource "aws_secretsmanager_secret" "app-secret-1" {
  name = "${local.secret-path}/secret1"
  description = "The secret to be used with Example Secrets Lambda"

  # This allowes immediate deletion
  # it is meant for testing
  recovery_window_in_days = 0

  tags = local.tags
}

resource "aws_secretsmanager_secret" "app-secret-2" {
  name = "${local.secret-path}/secret2"
  description = "The secret to be used with Example Secrets Lambda"

  # This allowes immediate deletion
  # it is meant for testing
  recovery_window_in_days = 0

  tags = local.tags
}