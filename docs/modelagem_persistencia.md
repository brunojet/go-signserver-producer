# Modelagem de Dados para Persistência (DynamoDB)

## Visão Geral
Este documento descreve a modelagem de dados sugerida para persistência dos perfis de dispositivo (DeviceProfile) e controle dos pedidos de assinatura (SignatureRequest) utilizando o Amazon DynamoDB.

---

## 1. Tabela: DeviceProfile
Armazena informações sobre os perfis de dispositivos suportados para upload e assinatura.

- **Partition Key:** `pk` (string, profile_id)
- **Sort Key:** `sk` (string, valor fixo "PROFILE")
- **Atributos:**
  - `pk` (string, PK, valor igual ao profile_id)
  - `sk` (string, SK, valor fixo "PROFILE")
  - `name` (string)
  - `description` (string)
  - `created_at` (ISO8601 string)
  - `updated_at` (ISO8601 string)
  - `status` (string: active/inactive)
  - `config` (map, obrigatório)

**Padrão de nomenclatura:**
Para facilitar abstrações e reuso de código, recomenda-se que todas as tabelas usem os nomes padronizados `pk` (partition key) e `sk` (sort key), documentando o significado de cada um conforme o contexto da tabela.

**Exemplo de item:**
```json
{
  "pk": "android_pos_v1",
  "sk": "PROFILE",
  "name": "Android POS v1",
  "description": "Perfil para maquininhas Android POS versão 1",
  "created_at": "2025-06-07T12:00:00Z",
  "updated_at": "2025-06-07T12:00:00Z",
  "status": "active",
  "config": {
    "signer_queue": "arn:aws:sqs:us-east-1:123456789012:gertec-sign-queue",
    "device_type": "TEF"
  }
}
```

---

## 2. Tabela: SignatureRequest
Controla o ciclo de vida dos pedidos de upload e assinatura de APKs.

- **Partition Key:** `pk` (string, UUID v4)
- **Sort Key:** `sk` (string, referência a DeviceProfile)
- **Atributos:**
  - `pk` (string, PK, gerado como UUID v4)
  - `sk` (string, SK, referência a DeviceProfile)
  - `created_at` (ISO8601 string)
  - `updated_at` (ISO8601 string)
  - `status` (string: received, uploading, uploaded, processing, signed, error, etc)
  - `history` (list de objetos: status, timestamp, observação)
  - `error_message` (string, opcional)
  - `file_name` (string)
  - `file_size` (number)
  - `file_hash` (string)
  - `upload_method` (string)
  - `signer_queue` (string, snapshot do DeviceProfile)
  - `device_type` (string, snapshot do DeviceProfile)

**Padrão de nomenclatura:**
Para facilitar abstrações e reuso de código, recomenda-se que todas as tabelas usem os nomes padronizados `pk` (partition key) e `sk` (sort key), documentando o significado de cada um conforme o contexto da tabela.

**Observação:**
No momento da criação da SignatureRequest, os campos críticos do DeviceProfile (como signer_queue e device_type) devem ser copiados para a SignatureRequest. Isso garante rastreabilidade e preserva o contexto original do pedido, mesmo que o DeviceProfile seja alterado no futuro.

**Exemplo de item:**
```json
{
  "pk": "01HXZ9YQK7Y8Y8QK7Y8Y8QK7Y8",
  "sk": "android_pos_v1",
  "created_at": "2025-06-07T12:10:00Z",
  "updated_at": "2025-06-07T12:15:00Z",
  "status": "uploaded",
  "history": [
    { "status": "received", "timestamp": "2025-06-07T12:10:00Z" },
    { "status": "uploading", "timestamp": "2025-06-07T12:11:00Z" },
    { "status": "uploaded", "timestamp": "2025-06-07T12:15:00Z" }
  ],
  "file_name": "app-release.apk",
  "file_size": 12345678,
  "file_hash": "aabbccddeeff...",
  "upload_method": "presigned_url",
  "signer_queue": "arn:aws:sqs:us-east-1:123456789012:gertec-sign-queue",
  "device_type": "TEF"
}
```

---

## 3. Índices Secundários Sugeridos
- **GSI por status:** permite consultar pedidos por status (ex: todos os pendentes de assinatura).
  - Partition Key: `status`
  - Sort Key: `created_at`
- **GSI por device_profile:** permite consultar todos os pedidos de um perfil específico.
  - Partition Key: `device_profile`
  - Sort Key: `created_at`

---

## 4. Considerações
- O DynamoDB é ideal para workloads event-driven, com consultas rápidas por chave e escalabilidade automática.
- O histórico de status pode ser expandido para rastreabilidade completa.
- Campos extras podem ser adicionados conforme necessidade (ex: usuário, logs, integrações externas).

---

*Documento gerado automaticamente para apoiar a modelagem de persistência do sistema de assinatura de APKs usando DynamoDB.*
