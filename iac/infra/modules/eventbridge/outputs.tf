output "resource_name" {
  description = "Nome da regra EventBridge criada."
  value       = aws_cloudwatch_event_rule.this.name
}

output "resource_arn" {
  description = "ARN da regra EventBridge criada."
  value       = aws_cloudwatch_event_rule.this.arn
}
