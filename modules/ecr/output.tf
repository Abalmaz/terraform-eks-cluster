# output "registry_id" {
#   value       = aws_ecr_repository.ecr.name.registry_id
#   description = "Registry ID"
# }

output "repository_name" {
  value       = aws_ecr_repository.ecr.name
  description = "Name of repository created"
}

output "repository_url" {
  value       = aws_ecr_repository.ecr.repository_url
  description = "URL of repository created"
}