locals {
  allowed_environments = ["dev", "qa", "prod"]
  environment         = terraform.workspace
  project_env         = "${var.project}-${local.environment}"
}

resource "null_resource" "validate_workspace" {
  count = contains(local.allowed_environments, local.environment) ? 0 : 1
  provisioner "local-exec" {
    command = "echo Workspace inválido: ${local.environment}. Use dev, qa ou prod. && exit 1"
  }
}
