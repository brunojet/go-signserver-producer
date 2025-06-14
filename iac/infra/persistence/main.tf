provider "aws" {
  region = var.aws_region != null ? var.aws_region : "us-east-1"
}

module "persistence_bucket" {
  source        = "../modules/s3_bucket"
  bucket_name   = "${var.project}-${var.environment}"
  versioning    = true
  force_destroy = false
  tags = {
    Name        = "${var.project}-${var.environment}"
    Environment = var.environment
    Project     = var.project
  }
}

module "device_profile_table" {
  source     = "../modules/dynamodb_table"
  table_name = "${var.project}-${var.environment}-device-profile"
  hash_key   = "pk"
  range_key  = "sk"
  attributes = [
    { name = "pk", type = "S" },
    { name = "sk", type = "S" }
  ]
  tags = {
    Name        = "${var.project}-${var.environment}-device-profile"
    Environment = var.environment
    Project     = var.project
  }
}

module "signature_request_table" {
  source     = "../modules/dynamodb_table"
  table_name = "${var.project}-${var.environment}-signature-request"
  hash_key   = "pk"
  range_key  = "sk"
  attributes = [
    { name = "pk", type = "S" },
    { name = "sk", type = "S" }
  ]
  tags = {
    Name        = "${var.project}-${var.environment}-signature-request"
    Environment = var.environment
    Project     = var.project
  }
}
