terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
  }
}

data "aws_route53_zone" "url_zone" {
  name         = "hamsa-ahmed.co.uk"
  private_zone = false
}


resource "aws_route53_record" "url_new_domain" {
  zone_id = data.aws_route53_zone.url_zone.id
  name    = "url-shortener"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
