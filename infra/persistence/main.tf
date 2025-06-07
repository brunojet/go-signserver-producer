provider "aws" {
  region = var.aws_region != null ? var.aws_region : "us-east-1"
}

resource "aws_s3_bucket" "persistence" {
  bucket = "${var.project}-${var.environment}"

  tags = {
    Name        = "${var.project}-${var.environment}"
    Environment = var.environment
    Project     = var.project
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "persistence_versioning" {
  bucket = aws_s3_bucket.persistence.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "persistence_access" {
  name = "${var.project}-${var.environment}-persistence-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name        = "${var.project}-${var.environment}-persistence-access"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_iam_policy" "persistence_policy" {
  name        = "${var.project}-${var.environment}-persistence-policy"
  description = "Policy for S3 persistence access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.persistence.arn,
          "${aws_s3_bucket.persistence.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "persistence_policy_attachment" {
  role       = aws_iam_role.persistence_access.name
  policy_arn = aws_iam_policy.persistence_policy.arn
}

output "debug_project" {
  value = var.project
}

output "debug_environment" {
  value = var.environment
}
