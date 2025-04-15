# Reference the existing IAM role (unchanged)
data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

# ECS Service for Auth Service
resource "aws_ecs_service" "backend_auth_service" {
  name            = "backend-auth-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.auth_task.arn
  desired_count   = 1
  launch_type     = "EC2"
  depends_on      = [aws_lb_listener_rule.auth_rule]

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.auth_tg.arn
    container_name   = "backend-auth-container"
    container_port   = 8080
  }

  iam_role = data.aws_iam_role.ecs_service_role.arn  # Reference existing role

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}

# ECS Service for Booking Service
resource "aws_ecs_service" "backend_booking_service" {
  name            = "backend-booking-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.booking_task.arn
  desired_count   = 1
  launch_type     = "EC2"
  depends_on      = [aws_lb_listener_rule.booking_rule]

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.booking_tg.arn
    container_name   = "backend-booking-container"
    container_port   = 8082
  }

  iam_role = data.aws_iam_role.ecs_service_role.arn  # Reference existing role

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}
