output "eventbridge_rule_name" {
  description = "Nome da regra EventBridge criada."
  value       = aws_cloudwatch_event_rule.this.name
}

output "eventbridge_rule_arn" {
  description = "ARN da regra EventBridge criada."
  value       = aws_cloudwatch_event_rule.this.arn
}
