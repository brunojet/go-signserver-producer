#!/bin/bash
# load_env.sh - Carrega variáveis de ambiente do arquivo correto baseado no evento do GitHub Actions

# Detecta evento e branch
if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
  BRANCH_NAME="$GITHUB_BASE_REF"
else
  BRANCH_NAME="${GITHUB_REF##*/}"
fi

ENV_FILE="${BRANCH_NAME}.env"
echo "Arquivo de configuração de ambiente: $ENV_FILE"
if [[ "$BRANCH_NAME" == release* ]]; then
  ENV_FILE="release.env"
fi

if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
  echo "Environment=$ENVIRONMENT, Project=$PROJECT"
  # Exporta variáveis para o ambiente global do GitHub Actions
  echo "ENVIRONMENT=$ENVIRONMENT" >> $GITHUB_ENV
  echo "PROJECT=$PROJECT" >> $GITHUB_ENV
else
  echo "Arquivo $ENV_FILE não encontrado. Falhando o workflow."
  exit 2
fi
