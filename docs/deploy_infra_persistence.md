# GitHub Actions Workflow: Terraform Deploy - Persistence

Este documento descreve o processo de deploy automatizado da infraestrutura de persistência (S3) usando Terraform e GitHub Actions, incluindo práticas de aprovação manual e restrições de branch.

## Visão Geral
- O deploy da infraestrutura é realizado via workflow do GitHub Actions.
- O workflow executa `terraform init` e `terraform plan` automaticamente a cada push ou pull request na pasta `infra/persistence`.
- O passo de `terraform apply` (criação/alteração de recursos na AWS) só ocorre após aprovação manual de um usuário autorizado.
- O workflow pode ser disparado manualmente via interface do GitHub (workflow_dispatch).

## Fluxo do Workflow
1. **Disparo**: O workflow é disparado em push/pull request para arquivos de infraestrutura ou manualmente.
2. **Checkout do código**: O repositório é clonado no runner do GitHub Actions.
3. **Setup do Terraform**: O ambiente é preparado para rodar comandos Terraform.
4. **Configuração das credenciais AWS**: As credenciais são lidas dos GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
5. **Terraform Init**: Inicializa o diretório de trabalho do Terraform.
6. **Terraform Plan**: Gera o plano de execução, mostrando o que será criado/alterado.
7. **Aprovação manual**: O workflow pausa e aguarda aprovação de um usuário autorizado.
8. **Terraform Apply**: Após aprovação, o plano é aplicado e os recursos são criados/alterados na AWS.

## Proteções e Boas Práticas
- O passo de `apply` só executa após aprovação manual, reduzindo riscos de alterações acidentais.
- O recurso S3 está protegido com `prevent_destroy` no Terraform.
- Recomenda-se restringir o workflow para rodar apenas em branches principais (ex: `develop`, `main`).
- As credenciais AWS nunca ficam expostas no código, apenas nos GitHub Secrets.

## Exemplo de Workflow YAML
```yaml
name: Terraform Deploy - Persistence

on:
  push:
    branches:
      - develop
    paths:
      - 'infra/persistence/**'
      - '.github/workflows/terraform-persistence.yml'
  pull_request:
    branches:
      - develop
    paths:
      - 'infra/persistence/**'
  workflow_dispatch:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      - name: Terraform Init
        working-directory: infra/persistence
        run: terraform init
      - name: Terraform Plan
        working-directory: infra/persistence
        run: terraform plan -var="environment=dev" -var="project=go-signserver-producer"
      - name: Wait for manual approval
        uses: trstringer/manual-approval@v1
        with:
          secret: ${{ github.TOKEN }}
          approvers: seu-usuario-github
          minimum-approvals: 1
      - name: Terraform Apply
        if: ${{ success() }}
        working-directory: infra/persistence
        run: terraform apply -auto-approve -var="environment=dev" -var="project=go-signserver-producer"
```

## Observações
- Substitua `seu-usuario-github` pelo(s) usuário(s) autorizado(s) a aprovar o deploy.
- Ajuste a região AWS conforme necessário.
- Para ambientes diferentes, altere o valor da variável `environment`.

---

> Dúvidas ou sugestões? Edite este arquivo para manter o processo sempre atualizado!
