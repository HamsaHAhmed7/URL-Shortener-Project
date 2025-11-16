variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "target_group_blue_name" {
  type = string
}

variable "target_group_green_name" {
  type = string
}

variable "listener_arn" {
  type = string
}

variable "iam_code_deploy_role_arn" {
  type = string
}