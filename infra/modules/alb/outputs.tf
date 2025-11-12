output "alb_arn" {
  value = aws_lb.url_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.url_alb.dns_name
}

output "target_group_arn_blue" {
  value = aws_lb_target_group.url_alb_tg_blue.arn
}

output "target_group_arn_green" {
  value = aws_lb_target_group.url_alb_tg_green.arn
}

output "listener_arn" {
  value = aws_lb_listener.url_alb_listener.arn
}
