data "aws_iam_policy_document" "session-manager-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "tf-session-manager-role" {
  name               = "tf-session-manager-role"
  assume_role_policy = data.aws_iam_policy_document.session-manager-assume-role.json
}

data "aws_iam_policy_document" "session-manager-permissions" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "session-manager-permissions" {
  name        = "session-manager-permissions"
  description = "limited permissions for session manager use, created by terraform"
  policy      = data.aws_iam_policy_document.session-manager-permissions.json
}

resource "aws_iam_role_policy_attachment" "tf-session-manager-policies" {
  role       = aws_iam_role.tf-session-manager-role.name
  policy_arn = aws_iam_policy.session-manager-permissions.arn
}

resource "aws_iam_instance_profile" "session-manager-instance-profile" {
  # Because this expression refers to the role, Terraform can infer
  # automatically that the role must be created first.
  name = "session-manager-instance-profile"
  role = aws_iam_role.tf-session-manager-role.name
}
