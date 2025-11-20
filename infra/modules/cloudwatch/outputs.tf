output "sns_topic_arn" {
  value       = aws_sns_topic.alerts.arn
  description = "SNS topic ARN for CloudWatch alerts"
}

output "dashboard_name" {
  value       = aws_cloudwatch_dashboard.service_dashboard.dashboard_name
  description = "Name of CloudWatch dashboard"
}
