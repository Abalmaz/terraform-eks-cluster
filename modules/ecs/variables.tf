variable "name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = ""
}

variable "env_pref" {
  description = "Environment prefix, for example development, stage, prod"
  type        = string
  default     = "dev"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "instance_type" {
  
}

variable "my_ip" {
  
}

variable "key_name" {
  
}

variable "private_ips" {
  
}
variable "min_size" {
   
}

variable "max_size" {
   
}

variable "desired_capacity" {
  
}

variable "vpc_id" {
  
}

variable "public_ips" {
  
}

variable "repository_url" {
  
}
variable "image_tag" {
  
}
variable "log_retention_in_days" {
   default = 14
}
