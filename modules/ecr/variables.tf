variable "name" {
  description = "Name of the application"
  type        = string
  default     = ""
}

variable "env_pref" {
  description = "Environment prefix, for example development, stage, prod"
  type        = string
  default     = "dev"
}

variable "max_image_count" {
  description = "How many Docker Image versions AWS ECR will store"
  type        = number
  default     = 5
}

variable "image_tag" {
  description = "Image tag for first push to ECR"
  type        = string
  default     = "0.0.1" 
}