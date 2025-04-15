variable "aws_region" {
  default = "ap-south-1"
}

variable "image_tag" {
  description = "The image tag for the Docker image"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "ktt-cluster"
}

variable "vpc_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_security_group" {}

variable "ecs_instance_security_group" {}

variable "key_name" {}


variable "ami_image_id" {
  description = "The AMI ID to use for EC2 instances in the ECS cluster"
  type        = string
}

variable "instance_type" {
  type = string
}

