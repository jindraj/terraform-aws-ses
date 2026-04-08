data "aws_iam_policy_document" "ses_inline_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = ["*"]
  }
}

variable "enable_iam_role" {
  description = "Enable IAM Role for SES access."
  type        = bool
  default     = false
}

variable "enable_iam_user" {
  description = "Enable IAM User for SES access."
  type        = bool
  default     = false
}

data "aws_iam_policy_document" "ses_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ses" {
  count = var.enable_iam_role ? 1 : 0
  name = "ses-role"
  assume_role_policy = data.aws_iam_policy_document.ses_trust_policy.json

  inline_policy {
    name   = "ses-inline-policy"
    policy = data.aws_iam_policy_document.ses_inline_policy.json
  }
}

resource "aws_iam_user" "ses" {
  count = var.enable_iam_user ? 1 : 0
  name  = "ses-user"
  force_destroy = true
}

resource "aws_iam_user_policy" "ses" {
  count = var.enable_iam_user ? 1 : 0
  name   = "ses-inline-policy"
  user   = aws_iam_user.ses[0].name
  policy = data.aws_iam_policy_document.ses_inline_policy.json
}

resource "aws_iam_access_key" "ses" {
  count = var.enable_iam_user ? 1 : 0
  user  = aws_iam_user.ses[0].name
}

locals {
  ses_smtp_password_v4 = var.enable_iam_user && length(aws_iam_access_key.ses) > 0 ? aws_iam_access_key.ses[0].ses_smtp_password_v4 : null
}

output "ses_iam_policy_document" {
  value = data.aws_iam_policy_document.ses_inline_policy.json
}

output "ses_iam_role_arn" {
  value = var.enable_iam_role && length(aws_iam_role.ses) > 0 ? aws_iam_role.ses[0].arn : null
}

output "ses_iam_user_access_key_id" {
  value = var.enable_iam_user && length(aws_iam_access_key.ses) > 0 ? aws_iam_access_key.ses[0].id : null
  sensitive = true
}

output "ses_smtp_password_v4" {
  value     = local.ses_smtp_password_v4
  sensitive = true
}