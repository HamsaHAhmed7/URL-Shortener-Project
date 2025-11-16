
variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}
variable "iam_task_execution_role_arn" {
  type = string
}

variable "iam_task_role_arn" {
  type = string
}
