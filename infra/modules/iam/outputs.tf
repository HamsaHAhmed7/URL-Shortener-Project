
output "task_execution_role_arn" {
  value = aws_iam_role.Url_Execution_Role.arn
}

output "task_role_arn" {
  value = aws_iam_role.Url_Task_Role.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.Url_CodeDeploy_Role.arn
}