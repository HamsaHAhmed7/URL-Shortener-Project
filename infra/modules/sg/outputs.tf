output "ecs_sg_id" {
  description = "The ID of the ECS security group"
  value       = aws_security_group.ecs_sg.id
}

output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "vpc_endpoint_sg_id" {
  description = "The ID of the VPC Endpoint security group"
  value       = aws_security_group.vpc_endpoint_sg.id

}