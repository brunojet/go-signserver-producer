resource "aws_sfn_state_machine" "this" {
  name     = "${var.project_env}-${var.name}"
  tags = var.tags
  role_arn = aws_iam_role.stepfunction_exec.arn
  definition = var.definition
}

resource "aws_iam_role" "stepfunction_exec" {
  name = "${var.project_env}-${var.name}-exec-role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "states.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.stepfunction_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsLoggingServiceRolePolicy"
}

