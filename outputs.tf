# output "public_ips" {
#   value = module.myapp-vpc.public_subnets
# }
# output "private_ips" {
#   value = module.myapp-vpc.private_subnets
# }
# output "vpc_id" {
#   value = module.myapp-vpc.vpc_id
# }
output "repository_url" {
  value = module.myapp-ecr.repository_url
}