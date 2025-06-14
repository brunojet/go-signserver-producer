variable "region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Nome do projeto para compor o nome do bucket"
  type        = string
  default     = "go-signserver"
}

variable "environment" { type = string }

locals {
  project_env = "${var.project}-${var.environment}"
}
