output "table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.url_dynamo.name
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.url_dynamo.arn
}

output "dynamodb_table_name" {
  description = "The ID of the DynamoDB table"
  value       = aws_dynamodb_table.url_dynamo.id
}
