output "table_name" { value = aws_dynamodb_table.this.name }
output "table_arn" { value = aws_dynamodb_table.this.arn }
output "role_arn" { value = aws_iam_role.dynamodb_access.arn }
output "policy_arn" { value = aws_iam_policy.dynamodb_policy.arn }
