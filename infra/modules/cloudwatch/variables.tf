variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for all metrics"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group (usually blue or green)"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table used by the app"
  type        = string
}

variable "alert_email" {
  description = "Email for CloudWatch alarm notifications"
  type        = string
  default     = ""
}
