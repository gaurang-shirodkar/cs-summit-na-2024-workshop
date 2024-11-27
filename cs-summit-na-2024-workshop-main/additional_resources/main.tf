data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.aws_ssm_parameter.eks_iam_role_name.value}"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_ssm_parameter" "eks_iam_role_name" {
  name = "/sysdig-eks/worker-nodes-iam-role"
}

resource "aws_iam_role" "read_dynamodb" {
  name               = "sysdig-demo-read-dynamodb"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "read_dynamodb_policy_attachment" {
  role       = aws_iam_role.read_dynamodb.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}
