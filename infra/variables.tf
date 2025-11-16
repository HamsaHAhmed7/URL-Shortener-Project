variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "base_domain" {
  description = "Base domain for Route53 zone lookup"
  type        = string
  default     = "hamsa-ahmed.co.uk"
}

variable "domain_name" {
  description = "Full domain name for the application"
  type        = string
  default     = "url-shortener.hamsa-ahmed.co.uk"
}