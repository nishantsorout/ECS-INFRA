# Create Application Load Balancer (ALB)
resource "aws_lb" "ktt_ecs_alb" {
  name               = "ktt-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group]
  subnets            = var.subnet_ids
  enable_deletion_protection = false
}

# Create Target Group for Authentication Service
resource "aws_lb_target_group" "auth_tg" {
  name        = "ktt-auth-tg"
  port        = 8080
  protocol    = "HTTP" 
  vpc_id      = var.vpc_id
  target_type = "instance"  

  health_check {
    path                = "/"  
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher  = "200-499"
  }

}

# Create Target Group for Booking Service
resource "aws_lb_target_group" "booking_tg" {
  name        = "ktt-booking-tg"
  port        = 8082
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"  

  health_check {
    path                = "/" 
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher  = "200-499"
  }


}

# ALB HTTP Listener (Port 80)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ktt_ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Service not found"
      status_code  = "404"
    }
  }
}

# Highest priority: Health checks (if needed)
resource "aws_lb_listener_rule" "health_check" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 50  # Lower number = higher priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_tg.arn  # Or a dedicated health-check TG
  }

  condition {
    path_pattern {
      values = ["/health"]  # Ensure health checks pass
    }
  }
}

# Auth service (priority 100)
resource "aws_lb_listener_rule" "auth_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_tg.arn
  }

  condition {
    path_pattern {
      values = ["/auth*", "/auth/*"]  # Handles both /auth and /auth/*
    }
  }
}

# Booking service (priority 200)
resource "aws_lb_listener_rule" "booking_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.booking_tg.arn
  }

  condition {
    path_pattern {
      values = ["/booking*", "/booking/*"]
    }
  }
}

# Default rule (lowest priority)
resource "aws_lb_listener_rule" "default_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 500  # Lowest priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_tg.arn  # Or a static site TG
  }

  # Catch-all for unmatched paths
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
