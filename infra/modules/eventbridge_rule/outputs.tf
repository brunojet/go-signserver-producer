output "rule_arn" {
  value = aws_cloudwatch_event_rule.this.arn
}
output "target_arn" {
  value = aws_cloudwatch_event_target.this.arn
}
