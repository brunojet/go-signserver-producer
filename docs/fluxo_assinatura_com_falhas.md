# Fluxo de Assinatura de APKs com Tratamento de Falhas

Este documento detalha o fluxo de trabalho do processo de assinatura de APKs, incluindo os principais pontos de falha e estratégias de tratamento de exceções.

```mermaid
flowchart TD
    A[Início: UploadRequest recebido] --> B[Registrar pedido no DynamoDB]
    B --> C{Registro criado?}
    C -- Não --> Z1[Retornar erro ao cliente]
    C -- Sim --> D[Gerar presigned URL]
    D --> E[Retornar presigned URL ao cliente]
    E --> F[Upload do APK no S3]
    F --> G[S3 envia evento para EventBridge]
    G --> H[Step Functions inicia processamento]
    H --> I[Buscar registro do APK no DynamoDB]
    I --> J{Registro encontrado e hash/size válido?}
    J -- Não --> Z2[Atualizar status para erro e notificar cliente]
    J -- Sim --> K[Atualizar status para 'uploaded']
    K --> L[Atualizar status para 'processing']
    L --> M[Chamar serviço assinador externo HTTP]
    M --> N{Resposta do assinador?}
    N -- Erro/Timeout --> Z3[Retry ou atualizar status para erro e notificar cliente]
    N -- Sucesso --> O[Salvar APK assinado no S3]
    O --> P{Salvo com sucesso?}
    P -- Não --> Z4[Retry ou atualizar status para erro e notificar cliente]
    P -- Sim --> Q[Atualizar status para 'signed']
    Q --> R[Notificar cliente callback ou polling]
    R --> S[Fim]

    %% Falhas
    Z1[Retornar erro ao cliente]
    Z2[Atualizar status para erro e notificar cliente]
    Z3[Retry ou atualizar status para erro e notificar cliente]
    Z4[Retry ou atualizar status para erro e notificar cliente]
```

---

## Estratégias de Tratamento de Falhas

- **Validação de integridade:**
  - O Step Functions valida se o registro do APK existe no DynamoDB e se hash/size conferem.
  - Se não existir ou não bater, status de erro e notificação ao cliente.
- **Falhas de comunicação externa:**
  - Retries automáticos configurados no Step Functions para falhas temporárias.
  - Após esgotar tentativas, status de erro e notificação ao cliente.
- **Falhas de escrita/leitura:**
  - Retries automáticos para operações em DynamoDB e S3.
  - Dead-letter queue (DLQ) para casos não recuperáveis.
- **Notificação de erro:**
  - Sempre que possível, o cliente é notificado via callback HTTP (webhook) ou pode consultar o status via polling.
- **Auditoria e logging:**
  - Todas as falhas e exceções são registradas para auditoria e troubleshooting.

---

*Este fluxo detalha os principais pontos de decisão e falha do processo de assinatura, promovendo resiliência, rastreabilidade e comunicação clara com o cliente.*
