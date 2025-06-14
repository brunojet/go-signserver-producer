resource "aws_iam_role" "stepfunction_exec" {
  name = "${var.name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "states.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "stepfunction_basic" {
  name        = "${var.name}-basic-policy"
  description = "Permissões mínimas para Step Function (ajuste conforme necessário)"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["logs:CreateLogGroup"],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "stepfunction_basic_attach" {
  role       = aws_iam_role.stepfunction_exec.name
  policy_arn = aws_iam_policy.stepfunction_basic.arn
}

resource "aws_sfn_state_machine" "this" {
  name     = var.name
  role_arn = aws_iam_role.stepfunction_exec.arn
  definition = var.definition
}
