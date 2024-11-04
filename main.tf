terraform {
  backend "s3" {
    bucket = "s3-terraform-bucket-remote-state"
    key    = "tfstate/terraform.tfstate"
    region = "eu-west-3"
    dynamodb_table = "terraform-state-lock-dynamodb-table"
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "azs"{}

module "myapp-vpc" {
  source = "./modules/network"
  name = var.name
  env_pref = var.env_pref
  vpc_cidr = var.vpc_cidr_block
  azs = data.aws_availability_zones.azs.names
}

module "myapp-ecr" {
  source = "./modules/ecr"
  name = var.name
  env_pref = var.env_pref
  max_image_count = var.max_ecr_image_count
  image_tag = var.ecr_image_tag
}

module "myapp-ecs" {
  source = "./modules/ecs"
  name = "myapp"
  vpc_id = module.myapp-vpc.vpi_id
  private_ips = module.myapp-vpc.private_subnets
  public_ips = module.myapp-vpc.public_subnets
  min_size = 1
  max_size = 2
  desired_capacity = 1
  key_name = "ECS-key"
  instance_type = "t2.micro"
  repository_url = module.myapp-ecr.repository_url
  image_tag = var.ecr_image_tag
  my_ip = var.my_ip 
}