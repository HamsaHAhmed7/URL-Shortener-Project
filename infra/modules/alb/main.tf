resource "aws_lb" "url_alb" {
  name               = "url-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "url-alb"
  }
}

resource "aws_lb_listener" "url_alb_listener" {
  load_balancer_arn = aws_lb.url_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.url_alb_tg_blue.arn
  }
}

resource "aws_lb_target_group" "url_alb_tg_green" {
  name        = "url-alb-tg-green"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "url-alb-tg-green"
  }
}

resource "aws_lb_target_group" "url_alb_tg_blue" {
  name        = "url-alb-tg-blue"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "url-alb-tg-blue"
  }
}
