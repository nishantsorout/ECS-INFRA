resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = 1
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "ktt-AutoScaling-Instance"
    propagate_at_launch = true
  }
}

