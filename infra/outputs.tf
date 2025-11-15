output "domain_name" {
  value       = module.route53.domain_name
  description = "Public domain for the URL Shortener"
}
