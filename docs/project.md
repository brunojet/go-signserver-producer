# Projeto: Porta de Entrada do Sistema de Assinatura de APKs

## Estrutura de Diretórios e Arquivos

```
/go-signserver-producer
│
├── main.go                # Ponto de entrada da aplicação, inicializa o servidor HTTP
├── go.mod / go.sum        # Gerenciamento de dependências Go
├── /docs                  # Documentação do projeto
│   └── project.md         # Documento de requisitos, arquitetura e premissas
├── /internal              # Código interno do domínio da aplicação
│   ├── /handlers          # Handlers HTTP (recebem e respondem requisições REST)
│   ├── /services          # Lógica de negócio (casos de uso, orquestração)
│   ├── /repositories      # Implementação de acesso a dados (DynamoDB, S3, SQS)
│   └── /models            # Estruturas de dados, entidades e DTOs
├── /pkg                   # Pacotes utilitários e helpers reutilizáveis
├── /scripts               # Scripts auxiliares (deploy, setup, etc)
└── README.md              # Instruções rápidas e visão geral do projeto
```

**Função dos diretórios principais:**
- **/internal/handlers:** Endpoints REST, validação de entrada e resposta HTTP.
- **/internal/services:** Lógica de negócio, regras e orquestração entre handlers e repositórios.
- **/internal/repositories:** Comunicação com DynamoDB, S3, SQS e outros recursos externos.
- **/internal/models:** Definição das entidades do domínio, DTOs e estruturas de dados.
- **/pkg:** Utilitários e funções auxiliares que podem ser reutilizados em outros projetos.
- **/docs:** Documentação técnica e de requisitos.
- **/scripts:** Scripts para automação, deploy, testes, etc.

Essa estrutura segue as premissas da Clean Architecture, facilitando manutenção, testes e evolução do projeto.

## Premissas de Arquitetura
- O projeto segue o padrão Clean Architecture para organização do código Go.
- Separação clara de responsabilidades: Handlers (HTTP), Services (lógica de negócio), Repositories (acesso a dados), Models (entidades/dto).
- O serviço é responsável apenas pela orquestração e publicação de mensagens, não realiza autenticação diretamente (autenticação é feita por camada externa, como API Gateway ou Ingress).
- Integração com AWS S3 para upload de arquivos via presigned URL.
- Integração com AWS SQS para publicação de mensagens assíncronas.
- Integração com AWS DynamoDB para persistência e rastreabilidade dos pedidos de assinatura.
- Processamento assíncrono e assinatura dos APKs são realizados por outros serviços (WorkerPool).
- Foco em rastreabilidade, escalabilidade e desacoplamento.

## Visão Geral
Este serviço/pod é o ponto de entrada do sistema de assinatura de APKs pós-upload. Ele é responsável por:
- Receber requisições HTTP de clientes externos (ex: sistemas parceiros, portais, automações).
- Gerenciar o upload dos arquivos APK e metadados associados.
- Validar, armazenar temporariamente e registrar os pedidos recebidos.
- Gerar URLs presignadas para upload direto de APKs grandes (multipart upload S3).
- Enviar uma mensagem para a fila (SQS, Azure Queue, etc) contendo as informações necessárias para o processamento e roteamento do APK, incluindo o perfil do dispositivo.

## Fluxo Básico
1. **Solicitação de upload:** O cliente informa o perfil do dispositivo e solicita o upload.
2. **Geração de presigned URL:** O backend gera uma URL temporária (multipart, se necessário) para upload direto do APK para o storage (S3, Azure Blob, etc).
3. **Upload do APK:** O cliente faz upload direto para o storage usando a URL fornecida.
4. **Notificação de conclusão:** O cliente (ou evento do storage) notifica o backend que o upload foi concluído, informando o perfil/ID do dispositivo e a localização do APK.
5. **Validação e registro:** O backend valida, registra o pedido e publica uma mensagem na fila para ser consumida pelo WorkerPool/roteador.
6. **Resposta ao cliente:** Retorna um status de aceite/erro para o cliente, podendo fornecer um ID de rastreamento.

## Responsabilidades
- Garantir segurança e integridade dos uploads (usando presigned URLs e validação de perfil).
- Isolar o cliente do processamento assíncrono, respondendo rapidamente.
- Garantir que cada pedido seja registrado de forma única e rastreável.
- Ser desacoplado do processamento/assinatura em si (apenas publica na fila).
- Roteamento futuro: incluir informações de perfil/modelo/tipo de chave para permitir roteamento dinâmico no WorkerPool.

## Observações
- Suporta múltiplos assinadores: o perfil do dispositivo enviado pelo cliente determina o roteamento posterior.
- Uploads grandes são feitos via presigned URL e multipart upload, garantindo escalabilidade e resiliência.
- O processamento assíncrono e a assinatura real são feitos por outros serviços (como o WorkerPool já documentado).
- Pode ser integrado com sistemas de autenticação, storage e monitoramento.

---

*Documento gerado com apoio do GitHub Copilot para descrever o componente de entrada do sistema de assinatura de APKs, incluindo suporte a múltiplos assinadores e uploads grandes.*
