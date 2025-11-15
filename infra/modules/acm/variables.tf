variable "domain_name" {
  description = "The domain name to request the ACM certificate for"
  type        = string

}

variable "zone_id" {
  description = "The Route 53 Hosted Zone ID where the validation record will be created"
  type        = string

}

