variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "simple-webapp-cluster"
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
  default     = "simple-webapp-service"
}

variable "task_definition" {
  description = "The task definition for the ECS service"
  type        = string
}

variable "desired_count" {
  description = "The desired number of tasks for the ECS service"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "The VPC ID where the ECS service will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs for the ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The security group IDs for the ECS service"
  type        = list(string)
}

variable "container_image" {
  description = "The container image (including tag) to deploy to ECS"
  type        = string
  default     = ""
}