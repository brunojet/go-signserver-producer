resource "aws_iam_role" "lambda_exec" {
  name = "${var.name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "lambda_basic" {
  name        = "${var.name}-basic-policy"
  description = "Basic Lambda execution policy"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_basic.arn
}

# Gera um arquivo hello.js inline para o Lambda, se filename não for informado
resource "local_file" "lambda_hello" {
  count    = var.filename == null || var.filename == "" ? 1 : 0
  content  = <<-EOF
    exports.handler = async (event) => {
      return { statusCode: 200, body: JSON.stringify({ message: "Hello, world!" }) };
    };
  EOF
  filename = "${path.module}/hello.js"
}

data "archive_file" "lambda_zip" {
  count       = var.filename == null || var.filename == "" ? 1 : 0
  type        = "zip"
  source_file = local_file.lambda_hello[0].filename
  output_path = "${path.module}/hello.zip"
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.filename != null && var.filename != "" ? var.filename : data.archive_file.lambda_zip[0].output_path
  source_code_hash = var.filename != null && var.filename != "" ? filebase64sha256(var.filename) : data.archive_file.lambda_zip[0].output_base64sha256
  environment {
    variables = var.environment_variables
  }
  timeout = var.timeout
  memory_size = var.memory_size
  tags = var.tags
}
