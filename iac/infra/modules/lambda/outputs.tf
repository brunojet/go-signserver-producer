output "function_arn" { value = aws_lambda_function.this.arn }
output "function_name" { value = aws_lambda_function.this.function_name }
output "role_arn" {
  value = aws_iam_role.lambda_exec.arn
}
output "policy_arn" {
  value = aws_iam_policy.lambda_basic.arn
}
output "role_name" {
  value = aws_iam_role.lambda_exec.name
}
