output "queue_id" { value = aws_sqs_queue.this.id }
output "queue_arn" { value = aws_sqs_queue.this.arn }
output "queue_url" { value = aws_sqs_queue.this.url }

output "role_arn" {
  description = "ARN da IAM Role para acesso à fila SQS."
  value       = aws_iam_role.sqs_access.arn
}

output "policy_arn" {
  description = "ARN da IAM Policy para acesso à fila SQS."
  value       = aws_iam_policy.sqs_access.arn
}
