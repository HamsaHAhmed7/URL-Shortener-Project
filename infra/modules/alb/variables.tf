variable "alb_sg_id" {
  description = "The ID of the ALB security group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
}
