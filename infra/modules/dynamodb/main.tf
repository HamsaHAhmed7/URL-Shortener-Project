terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
  }
}




resource "aws_dynamodb_table" "url_dynamo" {
  name         = "url-dynamo-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "short_code"

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "short_code"
    type = "S"
  }

  tags = {
    Name = "url-dynamo-table"
  }
}