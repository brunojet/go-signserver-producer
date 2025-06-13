resource "aws_sqs_queue" "this" {
  name                      = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  redrive_policy             = var.redrive_policy
  tags                       = var.tags
}

resource "aws_iam_role" "sqs_access" {
  name = "${var.name}-role"
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

resource "aws_iam_policy" "sqs_access" {
  name        = "${var.name}-policy"
  description = "Policy for SQS access to ${var.name}"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl"
      ],
      Resource = aws_sqs_queue.this.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_policy_attachment" {
  role       = aws_iam_role.sqs_access.name
  policy_arn = aws_iam_policy.sqs_access.arn
}
