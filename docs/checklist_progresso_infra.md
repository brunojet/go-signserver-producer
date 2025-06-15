# Checklist de Progresso e Próximos Passos – Infraestrutura Cloud

## 1. Estrutura e Planejamento
- [x] Definição da arquitetura principal (persistência, filas, orquestração, API)
- [x] Discussão sobre steps de deploy e responsabilidades
- [x] Estrutura modular do Terraform definida

## 2. Módulos de Infraestrutura
- [x] Módulo DynamoDB criado e parametrizado
- [x] Módulo S3 Bucket criado e parametrizado
- [x] Módulo SQS (fila principal e DLQ) criado e parametrizado
- [x] Outputs dos recursos expostos
- [x] Roles e Policies IAM criadas e expostas nos módulos
- [ ] Validar se o GitHub Actions (ou pipeline CI/CD) possui permissões para criar todos os recursos (DynamoDB, S3, SQS, IAM, etc)
- [x] DynamoDB e S3 já validados com sucesso

## 3. Integração e Permissões
- [ ] Garantir permissões do usuário/role de deploy (Terraform)
- [ ] Testar criação dos recursos em ambiente AWS
- [ ] Validar outputs e integrações entre recursos (ex: redrive policy SQS)

## 4. Próximos Passos
- [ ] Criar módulo para Step Functions
- [ ] Criar módulo para Lambdas
- [ ] Criar módulo para API Gateway
- [ ] Integrar recursos (Lambdas com SQS, Step Functions, etc)
- [ ] Documentar fluxos de deploy e dependências
- [ ] Automatizar pipeline CI/CD (opcional)

## 5. Documentação
- [ ] Atualizar diagramas e fluxos em docs/
- [ ] Registrar decisões arquiteturais e aprendizados

---

> **Dica:** Marque cada item conforme for avançando. Isso ajuda a visualizar o progresso e priorizar as próximas entregas.
