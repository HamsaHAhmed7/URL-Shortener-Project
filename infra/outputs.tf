
output "domain_name" {
  description = "Application domain name"
  value       = var.domain_name
}

output "https_domain_name" {
  description = "Deployment environment name"
  value       = "https://${var.domain_name}"
}