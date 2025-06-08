output "bucket_name" { value = aws_s3_bucket.this.bucket }
output "bucket_arn" { value = aws_s3_bucket.this.arn }
output "role_arn" { value = aws_iam_role.s3_access.arn }
output "policy_arn" { value = aws_iam_policy.s3_policy.arn }
