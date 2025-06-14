output "state_machine_arn" {
  value = aws_sfn_state_machine.this.arn
}

output "stepfunction_exec_role_arn" {
  description = "ARN da role de execução da Step Function (deve ser usada na Step Function)"
  value       = aws_iam_role.stepfunction_exec.arn
}

output "stepfunction_exec_role_name" {
  value = aws_iam_role.stepfunction_exec.name
}

output "stepfunction_basic_policy_arn" {
  description = "ARN da policy mínima da Step Function"
  value       = aws_iam_policy.stepfunction_basic.arn
}
