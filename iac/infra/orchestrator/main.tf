data "terraform_remote_state" "persistence" {
  backend = "s3"
  config = {
    bucket  = "brunojet-tfstate"
    key     = "persistence/terraform.tfstate"
    region  = "${var.region}"
    encrypt = true
  }
}

# Lambda (placeholder)
module "signer_lambda" {
  source                = "../modules/lambda"
  name                  = "${local.project_env}-signer-lambda"
  handler               = "hello.handler"
  runtime               = "nodejs18.x"
  filename              = null
  environment_variables = {}
  timeout               = 10
  memory_size           = 128
  tags = {
    Name        = "${local.project_env}-signer-lambda"
    Environment = var.environment
    Project     = var.project
  }
}

# Step Function
module "signer_flow" {
  source     = "../modules/stepfunction"
  name       = "${local.project_env}-signer-flow"
  definition = <<EOF
{
  "Comment": "Signer flow skeleton",
  "StartAt": "InvokeLambda",
  "States": {
    "InvokeLambda": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "${module.signer_lambda.function_arn}",
        "Payload.$": "$"
      },
      "End": true
    }
  }
}
EOF
}

module "s3_object_created_eventbridge" {
  source        = "../modules/eventbridge"
  name          = local.project_env
  target_arn    = module.signer_flow.state_machine_arn
  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "resources": ["arn:aws:s3:::${data.terraform_remote_state.persistence.outputs.persistence_bucket_name}"]
}
EOF
}

# Policy para Step Function invocar Lambda (criada após Lambda e Step Function existirem)
resource "aws_iam_policy" "stepfunction_lambda_invoke" {
  name        = "${var.project}-${var.environment}-stepfunction-lambda-invoke"
  description = "Permite à Step Function invocar Lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["lambda:InvokeFunction"],
      Resource = module.signer_lambda.function_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "stepfunction_invoke_lambda" {
  role       = module.signer_flow.stepfunction_exec_role_name
  policy_arn = aws_iam_policy.stepfunction_lambda_invoke.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.project_env}-lambda-persistence"
  description = "Permite ao Lambda acessar S3 e DynamoDB da persistência"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "${data.terraform_remote_state.persistence.outputs["persistence_bucket_arn"]}",
          "${data.terraform_remote_state.persistence.outputs["persistence_bucket_arn"]}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ],
        Resource = [
          "${data.terraform_remote_state.persistence.outputs["device_profile_table_arn"]}",
          "${data.terraform_remote_state.persistence.outputs["signature_request_table_arn"]}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_access_persistence" {
  role       = module.signer_lambda.role_name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

