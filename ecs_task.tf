# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/ktt-service-logs"
}

# Permission of TaskExecutionRole
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "auth_task" {
  family                   = "backend-auth-service"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "bridge" 
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "backend-auth-container"
      image     = "${aws_ecr_repository.backend_auth.repository_url}:${var.image_tag}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostport = 0
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ktt-service-logs"
          "awslogs-region"        = "ap-south-1"
          "awslogs-stream-prefix" = "auth"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "booking_task" {
  family                   = "backend-booking-service"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "bridge" 
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "backend-booking-container"
      image     = "${aws_ecr_repository.backend_booking.repository_url}:${var.image_tag}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8082
          hostport = 0
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ktt-service-logs"
          "awslogs-region"        = "ap-south-1"
          "awslogs-stream-prefix" = "booking"
        }
      }
    }
  ])
}
