# ECR Repository for URL Shortener Application 
# Moved to AWS Console for better management

# resource "aws_ecr_repository" "url-repo" {
#   name                 = "url-shortener-repo"
#   image_tag_mutability = "MUTABLE"
#   force_delete         = false
#
#   image_scanning_configuration {
#     scan_on_push = true
#   }
#
#   encryption_configuration {
#     encryption_type = "AES256"
#   }
#
#   tags = {
#     Name = "url-shortener-ecr"
#   }
# }
#
# resource "aws_ecr_lifecycle_policy" "url_repo_policy" {
#   repository = aws_ecr_repository.url-repo.name
#
#   policy = <<EOF
#   {
#     "rules": [
#       {
#         "rulePriority": 1,
#         "description": "Expire untagged images older than 30 days",
#         "selection": {
#           "tagStatus": "untagged",
#           "countType": "sinceImagePushed",
#           "countUnit": "days",
#           "countNumber": 30
#         },
#         "action": {
#           "type": "expire"
#         }
#       },
#       {
#         "rulePriority": 2,
#         "description": "Keep last 10 tagged images",
#         "selection": {
#           "tagStatus": "any",
#           "countType": "imageCountMoreThan",
#           "countNumber": 10
#         },
#         "action": {
#           "type": "expire"
#         }
#       }
#     ]
#   }
#   EOF
# }
