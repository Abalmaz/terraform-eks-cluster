variable "region" {
  default = "eu-west-3"
}

variable "env_pref" {
  description = "Environment prefix, for example development, stage, prod"
  type        = string
  default     = "dev"
}

variable "name" {
  description = "Name of the application"
  type        = string
  default     = "myapp"
}

variable vpc_cidr_block {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "Node instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "max_ecr_image_count" {
  description = "How many Docker Image versions AWS ECR will store"
  default     = 5
}

variable "ecr_image_tag" {
  description = "Image tag for first push to ECR"
  default     = "0.0.1" 
}

variable "my_ip" {
  default = "86.200.174.215/32"
}