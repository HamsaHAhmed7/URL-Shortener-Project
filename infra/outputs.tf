
output "domain_name" {
  description = "Application domain name"
  value       = var.domain_name
}

output "https_domain_name" {
  description = "Deployment environment name"
  value       = "https://${var.domain_name}"
}

output "github_actions_role_arn" {
  value       = module.github_oidc.role_arn
  description = "Add this to GitHub Secrets as AWS_ROLE_ARN"
}