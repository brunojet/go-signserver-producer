provider "aws" {
  region = var.region
}

module "persistence_bucket" {
  source      = "../modules/s3_bucket"
  bucket_name = "apk-files"
  versioning  = true
  tags        = local.tags
  project_env = local.project_env
}

module "device_profile_table" {
  source     = "../modules/dynamodb_table"
  table_name = "device-profile"
  hash_key   = "pk"
  range_key  = "sk"
  attributes = [
    { name = "pk", type = "S" },
    { name = "sk", type = "S" }
  ]
  tags        = local.tags
  project_env = local.project_env
}

module "signature_request_table" {
  source     = "../modules/dynamodb_table"
  table_name = "signature-request"
  hash_key   = "pk"
  range_key  = "sk"
  attributes = [
    { name = "pk", type = "S" },
    { name = "sk", type = "S" }
  ]
  tags        = local.tags
  project_env = local.project_env
}
