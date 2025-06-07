variable "environment" {
  description = "Ambiente de deploy (ex: dev, qa, prod)"
  type        = string
}

variable "project" {
  description = "Nome do projeto para compor o nome do bucket"
  type        = string
}

variable "bucket_acl" {
  description = "ACL do bucket S3 (ex: private)"
  type        = string
  default     = "private"
}
