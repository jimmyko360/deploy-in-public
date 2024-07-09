data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
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
  name   = "${var.app_name}-session-manager-permissions"
  policy = data.aws_iam_policy_document.session-manager-permissions.json
}

data "aws_iam_policy_document" "ecr-policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:*",
      "cloudtrail:LookupEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr-policy" {
  name   = "${var.app_name}-ecr-policy"
  policy = data.aws_iam_policy_document.ecr-policy.json
}


data "aws_iam_policy_document" "CreateServiceLinkedRole-policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["replication.ecr.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "CreateServiceLinkedRole-policy" {
  name   = "${var.app_name}-CreateServiceLinkedRole-policy"
  policy = data.aws_iam_policy_document.CreateServiceLinkedRole-policy.json
}

# testing out managed_policy_arns instead of aws_iam_policy_document, aws_iam_policy, and aws_iam_role_policy_attachment
# looks like it worked
resource "aws_iam_role" "my-ecr-iam-role" {
  name               = "${var.app_name}-ecr-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  #   managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]
}

# I used multiple policy documents here
# I could have just added AmazonSSMManagedInstanceCore to managed_policy_arns above
resource "aws_iam_role_policy_attachment" "session-manager-permissions" {
  role       = aws_iam_role.my-ecr-iam-role.name
  policy_arn = aws_iam_policy.session-manager-permissions.arn
}

resource "aws_iam_role_policy_attachment" "ecr-policy" {
  role       = aws_iam_role.my-ecr-iam-role.name
  policy_arn = aws_iam_policy.ecr-policy.arn
}

resource "aws_iam_role_policy_attachment" "CreateServiceLinkedRole-policy" {
  role       = aws_iam_role.my-ecr-iam-role.name
  policy_arn = aws_iam_policy.CreateServiceLinkedRole-policy.arn
}

resource "aws_iam_instance_profile" "my-tf-ecr-ec2-profile" {
  name = "${var.app_name}-ecr-ec2-profile"
  role = aws_iam_role.my-ecr-iam-role.name
}
