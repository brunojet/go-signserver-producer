# Estimativa de Custos AWS - Persistência (S3 e DynamoDB)

## Premissas
- Região: us-east-1
- Cada assinatura gera 1 escrita e 1 leitura no DynamoDB
- Tamanho médio de arquivo S3: 10 MB
- Cada assinatura gera 1 upload (10 MB) no S3
- Cálculo para três cenários: 500, 2.000 e 5.000 assinaturas/mês
- Valores de junho/2025

---

## 1. DynamoDB (On-Demand)
| Cenário                | Leituras/mês | Escritas/mês | Custo Leituras | Custo Escritas | Total |
|------------------------|--------------|--------------|---------------|---------------|-------|
| 500 assinaturas/mês    | 500          | 500          | $0.000125     | $0.000625     | $0.00075 |
| 2.000 assinaturas/mês  | 2.000        | 2.000        | $0.0005       | $0.0025       | $0.003   |
| 5.000 assinaturas/mês  | 5.000        | 5.000        | $0.00125      | $0.00625      | $0.0075  |

- Preço leitura: $0.25 por 1 milhão
- Preço escrita: $1.25 por 1 milhão

---

## 2. S3 (Armazenamento e Requests)
| Cenário                | Armazenamento/mês | PUTs/mês | GETs/mês | Custo Storage | Custo Requests | Total |
|------------------------|-------------------|----------|----------|---------------|----------------|-------|
| 500 assinaturas/mês    | 5 GB              | 500      | 500      | $0.12         | $0.002         | $0.122 |
| 2.000 assinaturas/mês  | 20 GB             | 2.000    | 2.000    | $0.48         | $0.008         | $0.488 |
| 5.000 assinaturas/mês  | 50 GB             | 5.000    | 5.000    | $1.20         | $0.02          | $1.22  |

- Preço storage: $0.023/GB/mês
- Preço PUT/GET: $0.005 por 1.000 requests

---

## 3. Resumo dos Custos Mensais
| Cenário                | DynamoDB | S3    | Total |
|------------------------|----------|-------|-------|
| 500 assinaturas/mês    | $0.00075 | $0.122| $0.123|
| 2.000 assinaturas/mês  | $0.003   | $0.488| $0.491|
| 5.000 assinaturas/mês  | $0.0075  | $1.22 | $1.23 |

---

## 4. Custos Indiretos e Pegadinhas

Além dos custos diretos de armazenamento e requisições, outros fatores podem impactar a fatura:

### S3
- **Transferência de dados (Data Transfer Out):** Downloads para fora da AWS são cobrados e podem ser relevantes se houver muitos acessos externos.
- **Versionamento:** Se ativado, cada versão ocupa espaço e pode aumentar o custo de storage.
- **Requests adicionais:** LIST, DELETE, HEAD, COPY, etc., também são cobrados (embora geralmente baratos).
- **Replication:** Replicação entre regiões (CRR) gera custos extras de storage e transferência.
- **Storage Class:** Classes como Glacier, Intelligent-Tiering ou transições automáticas podem gerar custos inesperados.
- **Logs e CloudWatch:** Ativar logs de acesso pode gerar custos de armazenamento em S3 e CloudWatch.

### DynamoDB
- **Backup e Restore:** Backups automáticos ou manuais são cobrados por GB.
- **Streams:** Ativar DynamoDB Streams gera custo adicional por leitura de stream.
- **Global Tables:** Replicação multi-região aumenta bastante o custo.
- **Data Transfer:** Transferência entre regiões ou para fora da AWS é cobrada.
- **CloudWatch:** Métricas customizadas e alarmes podem gerar custos adicionais.

### Outros
- **KMS:** Uso de chaves KMS para criptografia pode gerar custo por request.
- **IAM:** Políticas e roles não geram custo direto, mas uso excessivo de permissões pode aumentar riscos.
- **Lambda, Step Functions, SQS:** Se integrados, cada serviço tem seu próprio modelo de cobrança.

> **Recomendação:** Sempre monitore o Cost Explorer da AWS e revise a fatura detalhada para identificar custos indiretos.

---

*Gerado automaticamente por GitHub Copilot em jun/2025.*
