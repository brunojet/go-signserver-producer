# Estrutura de Monorepo para Projetos Cloud com Rastreabilidade e Compliance

## Visão Geral
Este documento apresenta um padrão de estrutura de monorepo para projetos cloud-native, com foco em rastreabilidade, integração com ferramentas de segurança (Defect Dojo, Veracode), automação CI/CD e governança corporativa.

---

## 1. Organização de Diretórios

```
/<sigla-app>                # Raiz do monorepo (ex: go-signserver-producer)
│
├── infra/                  # Infraestrutura como código (Terraform, CloudFormation, etc)
│   ├── persistence/        # Módulo de persistência (S3, DynamoDB, etc)
│   ├── networking/         # Módulo de rede (VPC, subnets, etc)
│   ├── app/                # Infra da aplicação serverless (Lambdas, Step Functions, API Gateway, roles, etc)
│   │   ├── main.tf         # Infraestrutura dos componentes serverless
│   │   ├── state_machine.asl.json # Definição do Step Functions (ASL/JSON)
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── ...
│   └── ...                 # Outros domínios de infraestrutura
│
├── app/                    # Código-fonte da aplicação serverless
│   ├── lambda_entry/       # Lambda principal (porta de entrada)
│   │   ├── main.go         # Ou index.js, handler.py, etc.
│   │   └── ...
│   ├── step_functions/     # Handlers usados em Step Functions
│   │   ├── handler1/
│   │   │   └── main.go
│   │   ├── handler2/
│   │   │   └── main.go
│   │   └── ...
│   └── shared/             # Código compartilhado entre lambdas
│       └── utils.go
│
├── internal/               # (Opcional) Lógica de domínio compartilhada
├── scripts/                # Scripts utilitários (deploy, build, etc)
├── docs/                   # Documentação técnica e operacional
├── .github/workflows/      # Pipelines CI/CD (GitHub Actions)
└── README.md               # Visão geral do monorepo
```

---

## 2. Convenção de Nomes e Tags
- **Prefixo único:** Use a sigla-app como prefixo em todos os recursos cloud, artefatos, tags e nomes de pipeline (ex: `sigla-app-s3-dev`).
- **Tag de rastreabilidade:** Adicione a tag `sigla-app` em todos os recursos para integração com Defect Dojo, Veracode e outras ferramentas de compliance.
- **Branching:** Use branches padronizados (`develop`, `master`, `release*`, `feature/<dev>`, etc).
- **Arquivos .env:** Mantenha arquivos de variáveis por ambiente (ex: `develop.env`, `release.env`, `master.env`).

---

## 3. Integração com Ferramentas de Segurança
- **Defect Dojo:** Configure o pipeline para enviar resultados de scan (SAST/DAST) usando a tag `sigla-app` para rastreabilidade.
- **Veracode:** Use a sigla-app como identificador de aplicação/serviço nos scans e relatórios.
- **CI/CD:** Garanta que todos os jobs de build, test, scan e deploy recebam a variável/tag `sigla-app`.

---

## 4. Boas Práticas de CI/CD
- **Workflows separados por domínio:** Um workflow para cada módulo (ex: `terraform-persistence.yml`, `terraform-app.yml`).
- **Plan e Apply separados:** Plan em PR, Apply só em merge para branches finais.
- **Limpeza de recursos temporários:** Se criar ambientes por branch/dev, automatize a destruição ao fechar o PR.
- **Outputs e rastreabilidade:** Exiba outputs relevantes e registre artefatos/scans com a tag do projeto.

---

## 5. Exemplo de Tagging em Terraform
```hcl
resource "aws_s3_bucket" "persistence" {
  bucket = "${var.project}-${var.environment}"
  tags = {
    Name        = "${var.project}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    SiglaApp    = var.project # Tag para rastreabilidade
  }
}

resource "aws_lambda_function" "entry" {
  function_name = "${var.project}-entry"
  filename      = "${path.module}/../../app/lambda_entry/dist/lambda.zip"
  tags = {
    Project     = var.project
    Environment = var.environment
    SiglaApp    = var.project
  }
}
```

---

### Observação sobre Step Functions
- O arquivo de definição do Step Functions (ex: `state_machine.asl.json`) deve ficar no diretório de infraestrutura (`infra/app/`), junto com o código Terraform que o provisiona.
- O recurso `aws_sfn_state_machine` no Terraform referencia esse arquivo para criar/atualizar a máquina de estados.
- O código dos Lambdas referenciados pelo Step Functions fica em `app/`.

Exemplo de uso no Terraform:
```hcl
resource "aws_sfn_state_machine" "main" {
  name       = "${var.project}-state-machine"
  role_arn   = aws_iam_role.step_functions_role.arn
  definition = file("${path.module}/state_machine.asl.json")
  tags = {
    Project  = var.project
    SiglaApp = var.project
  }
}
```

---

## 6. Recomendações Finais
- Centralize o máximo possível sob a sigla-app para facilitar compliance e auditoria.
- Documente a convenção de nomes e tags no README do monorepo.
- Alinhe com o time de segurança/DevSecOps para garantir integração com as ferramentas corporativas.
- Use automação para manter ambientes limpos e evitar custos desnecessários.
- Estruture o código dos Lambdas e Step Functions em subpastas dentro de `app/` para facilitar build, testes e deploy.

---

**Exemplo de sigla-app:**
- `sigla-app = go-signserver-producer`

**Este padrão facilita rastreabilidade, governança e integração com ferramentas de segurança em ambientes corporativos, inclusive para arquiteturas serverless e Step Functions.**
