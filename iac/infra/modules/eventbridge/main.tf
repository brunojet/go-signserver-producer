resource "aws_iam_role" "eventbridge_invoke" {
  name = "${var.name}-eventbridge-invoke-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "events.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_cloudwatch_event_rule" "this" {
  name          = "${var.name}-eventbridge-rule"
  event_pattern = var.event_pattern
  event_bus_name = var.event_bus_name
}

resource "aws_cloudwatch_event_target" "this" {
  rule         = aws_cloudwatch_event_rule.this.name
  arn          = var.target_arn
  role_arn     = aws_iam_role.eventbridge_invoke.arn
  event_bus_name = var.event_bus_name
}
