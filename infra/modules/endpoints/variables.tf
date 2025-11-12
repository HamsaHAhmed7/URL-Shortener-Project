variable "vpc_id" {
  description = "The ID of the VPC where the ECS cluster will be created"
  type        = string
}

variable "ecs_sg_id" {
  description = "The ID of the ECS security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS cluster"
  type        = list(string)
}

variable "vpc_endpoint_sg_id" {
  description = "The ID of the VPC Endpoint security group"
  type        = string
}

variable "private_route_table_id" {
  description = "The ID of the private route table"
  type        = string

}