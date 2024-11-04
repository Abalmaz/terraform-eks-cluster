resource "aws_alb" "alb" {
  name            = "${var.env_pref}-${var.name}-lb"
  load_balancer_type = "application"
  internal           = false
  subnets         = var.public_ips
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.env_pref}-${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 5
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 2
    
  }
  tags = {
    Name        = "${var.name}-lb-tg"
    Environment = var.env_pref
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
}
