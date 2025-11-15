output "domain_name" {
  value       = aws_route53_record.url_new_domain.fqdn
  description = "Fully qualified domain name for the deployed URL shortener service"
}

output "zone_id" {
    value       = data.aws_route53_zone.url_zone.id
    description = "Route53 Hosted Zone ID for the domain"
  
}