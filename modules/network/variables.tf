variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = ""
}

variable "env_pref" {
  description = "Environment prefix, for example development, stage, prod"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones."
  type        = list(string)
  default     = []
}
