output "bucket_name" {
  description = "Name of the S3 bucket created for persistence."
  value       = aws_s3_bucket.persistence.bucket
}

output "persistence_role_arn" {
  description = "ARN da IAM Role para acesso ao bucket de persistência."
  value       = aws_iam_role.persistence_access.arn
}
