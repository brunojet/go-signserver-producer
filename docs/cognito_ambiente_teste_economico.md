# Cognito AWS - Plano para Ambiente de Testes Econômico

## Objetivo
Reduzir ao máximo os custos do Cognito em ambientes de desenvolvimento e testes, evitando cobranças inesperadas e mantendo a funcionalidade básica para validação de fluxos.

---

## Estratégias para Cognito Econômico

1. **Use apenas User Pool (evite Identity Pool se não for necessário)**
   - Identity Pool (federated identities) pode gerar cobranças extras por usuários autenticados/guest.

2. **Aproveite a cota gratuita de 50.000 MAUs/mês**
   - Limite os testes a poucos usuários e evite criar múltiplos pools.

3. **Evite autenticação federada (Google, Facebook, SAML, OIDC)**
   - Cada autenticação federada é cobrada separadamente, mesmo em dev.
   - Use apenas usuários nativos do User Pool para testes.

4. **Não ative MFA via SMS**
   - SMS é cobrado por mensagem e pode ser caro. Prefira MFA por TOTP (Google Authenticator) se precisar testar MFA.

5. **Não configure domínio customizado**
   - O Hosted UI padrão do Cognito é gratuito. Domínio customizado gera cobrança extra.

6. **Remova recursos de teste imediatamente após uso**
   - Exclua User Pools, Identity Pools e domínios customizados assim que terminar os testes.

7. **Evite criar múltiplos pools para o mesmo propósito**
   - Reutilize pools existentes sempre que possível.

8. **Monitore o Cost Explorer e configure budgets/alerts**
   - Ative alertas de custo para evitar surpresas.

9. **Limite o número de usuários e operações**
   - Use poucos usuários e evite testes massivos de login/logout/refresh.

10. **Desative recursos avançados não utilizados**
    - Ex: triggers Lambda, advanced security, analytics, etc.

---

## Exemplo de configuração mínima para testes
- 1 User Pool
- 1-5 usuários de teste
- Sem MFA via SMS
- Sem autenticação federada
- Sem domínio customizado
- Excluir pool após testes

---

## Observações
- Mesmo com 1 usuário, recursos como MFA via SMS, autenticação federada e domínios customizados podem gerar custos rapidamente.
- O billing do Cognito é pró-rata: se criar e excluir no mesmo mês, pode ser cobrado proporcionalmente.
- Sempre revise o Cost Explorer após testes.

---

*Gerado automaticamente por GitHub Copilot em jun/2025.*
