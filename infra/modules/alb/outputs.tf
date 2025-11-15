output "alb_dns_name" {
  value = aws_lb.url_alb.dns_name
}

output "listener_arn_blue" {
  value = aws_lb_listener.listener_blue.arn
}

output "listener_arn_green" {
  value = aws_lb_listener.listener_green.arn
}

output "target_group_arn_blue" {
  value = aws_lb_target_group.blue.arn
}

output "target_group_arn_green" {
  value = aws_lb_target_group.green.arn
}

output "target_group_name_blue" {
  value = aws_lb_target_group.blue.name
}

output "target_group_name_green" {
  value = aws_lb_target_group.green.name
}
output "listener_arn" {
  value = aws_lb_listener.listener_blue.arn
}

output "alb_zone_id" {
  value = aws_lb.url_alb.zone_id
}

output "alb_arn" {
  value = aws_lb.url_alb.arn
  
}