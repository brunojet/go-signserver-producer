output "bucket_name" {
  description = "Name of the S3 bucket created for persistence."
  value       = module.persistence_bucket.bucket_name
}

output "persistence_role_arn" {
  description = "ARN da IAM Role para acesso ao bucket de persistência."
  value       = module.persistence_bucket.role_arn
}

output "persistence_policy_arn" {
  description = "ARN da IAM Policy para acesso ao bucket de persistência."
  value       = module.persistence_bucket.policy_arn
}
