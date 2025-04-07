vpc_id         = "vpc-0040321d1cdc2e010"  # Replace with your actual VPC ID

subnet_ids     = ["subnet-058a9db7f15b08540","subnet-00655a6224c447235",] # ("subnet-0e3daa9422adb8ec2" instance type (t2.small) is not supported in your requested Availability Zone (ap-south-1c))

alb_security_group = "sg-0e3a6cfdb67d677f8"

ecs_instance_security_group = "sg-0e3a6cfdb67d677f8"

key_name = "dev-server"

ami_image_id = "ami-0b14bc68238a38fbd"  # Replace with the ECS-optimized AMI ID(ami is not accessible due to Subscription issue)

instance_type = "t2.medium"