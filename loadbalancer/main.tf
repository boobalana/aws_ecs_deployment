resource "aws_alb" "ecs_cluster_alb" {
  name            = "${var.ecs_cluster_name}-ALB"
  internal        = false
  security_groups = [var.alb_security_group_id]
  subnets         = var.public_subnets_id
  tags = {
    Name = "${var.ecs_cluster_name}-ALB"
  }
}

resource "aws_alb_listener" "ecs_alb_http_listener" {
  load_balancer_arn = aws_alb.ecs_cluster_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
  }
    depends_on = [aws_alb_target_group.ecs_default_target_group]
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.ecs_cluster_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [aws_alb_target_group.ecs_default_target_group]
}

resource "aws_alb_target_group" "ecs_default_target_group" {
  name        = "ecstg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "10"
    timeout             = "5"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }
  tags = {
    Name = "${var.ecs_cluster_name}-TG"
  }
  lifecycle {
    create_before_destroy = true
  }
}
