output "persistence_bucket_name" {
  description = "Name of the S3 bucket created for persistence."
  value       = module.persistence_bucket.bucket_name
}

output "persistence_bucket_arn" {
  description = "ARN do bucket S3 de persistência."
  value       = module.persistence_bucket.bucket_arn
}

output "persistence_bucket_role_arn" {
  description = "ARN da IAM Role para acesso ao bucket de persistência."
  value       = module.persistence_bucket.role_arn
}

output "persistence_buckett_policy_arn" {
  description = "ARN da IAM Policy para acesso ao bucket de persistência."
  value       = module.persistence_bucket.policy_arn
}

output "device_profile_table_name" {
  description = "Nome da tabela DynamoDB device-profile."
  value       = module.device_profile_table.table_name
}

output "device_profile_table_arn" {
  description = "ARN da tabela DynamoDB device-profile."
  value       = module.device_profile_table.table_arn
}

output "device_profile_role_arn" {
  description = "ARN da IAM Role para acesso à tabela device-profile."
  value       = module.device_profile_table.role_arn
}

output "device_profile_policy_arn" {
  description = "ARN da IAM Policy para acesso à tabela device-profile."
  value       = module.device_profile_table.policy_arn
}

output "signature_request_table_name" {
  description = "Nome da tabela DynamoDB signature-request."
  value       = module.signature_request_table.table_name
}

output "signature_request_table_arn" {
  description = "ARN da tabela DynamoDB signature-request."
  value       = module.signature_request_table.table_arn
}

output "signature_request_role_arn" {
  description = "ARN da IAM Role para acesso à tabela signature-request."
  value       = module.signature_request_table.role_arn
}

output "signature_request_policy_arn" {
  description = "ARN da IAM Policy para acesso à tabela signature-request."
  value       = module.signature_request_table.policy_arn
}

output "main_queue_url" {
  description = "URL da fila SQS principal."
  value       = module.main_queue.queue_url
}

output "main_queue_arn" {
  description = "ARN da fila SQS principal."
  value       = module.main_queue.queue_arn
}

output "main_dlq_url" {
  description = "URL da DLQ da fila SQS."
  value       = module.main_dlq.queue_url
}

output "main_dlq_arn" {
  description = "ARN da DLQ da fila SQS."
  value       = module.main_dlq.queue_arn
}

output "main_queue_role_arn" {
  description = "ARN da IAM Role para acesso à fila SQS principal."
  value       = module.main_queue.role_arn
}

output "main_queue_policy_arn" {
  description = "ARN da IAM Policy para acesso à fila SQS principal."
  value       = module.main_queue.policy_arn
}

output "main_dlq_role_arn" {
  description = "ARN da IAM Role para acesso à DLQ da fila SQS."
  value       = module.main_dlq.role_arn
}

output "main_dlq_policy_arn" {
  description = "ARN da IAM Policy para acesso à DLQ da fila SQS."
  value       = module.main_dlq.policy_arn
}
