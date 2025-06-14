locals {
  # Concatena o nome do projeto e ambiente para facilitar padronização de nomes
  project_env = "${var.project}-${var.environment}"
}
