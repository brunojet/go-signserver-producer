# Orchestrator infra: EventBridge rule + Step Function skeleton

module "signer_flow" {
  source     = "./modules/stepfunction"
  name       = "${var.project}-${var.environment}-signer-flow"
  role_arn   = var.sfn_role_arn
  definition = <<EOF
{
  "Comment": "Signer flow skeleton",
  "StartAt": "ExampleState",
  "States": {
    "ExampleState": {
      "Type": "Pass",
      "End": true
    }
  }
}
EOF
}

module "s3_object_created_rule" {
  source        = "./modules/eventbridge_rule"
  name          = "${var.project}-${var.environment}-s3-object-created"
  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "resources": ["arn:aws:s3:::${var.s3_bucket_name}"]
}
EOF
  target_arn    = module.signer_flow.state_machine_arn
  role_arn      = var.eventbridge_invoke_role_arn
}
