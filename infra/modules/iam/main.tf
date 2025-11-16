resource "aws_iam_role" "Url_Execution_Role" {
  name = "url-shortener-dev-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Url_Execution_Role_ECR" {
  role       = aws_iam_role.Url_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "Url_Execution_Role_Logs" {
  role       = aws_iam_role.Url_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "Url_Execution_Role_Secrets" {
  role       = aws_iam_role.Url_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ddb_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
    ]
  }
}

resource "aws_iam_role" "Url_Task_Role" {
  name = "url-shortener-dev-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "Url_Task_Role_Policy" {
  name   = "url-shortener-ddb-policy"
  policy = data.aws_iam_policy_document.ddb_policy.json
}

resource "aws_iam_role_policy_attachment" "Url_Task_Role_Policy_Attach" {
  role       = aws_iam_role.Url_Task_Role.name
  policy_arn = aws_iam_policy.Url_Task_Role_Policy.arn
}

resource "aws_iam_role" "Url_CodeDeploy_Role" {
  name = "url-shortener-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Url_CodeDeploy_Role_Policy_Attach" {
  role       = aws_iam_role.Url_CodeDeploy_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
