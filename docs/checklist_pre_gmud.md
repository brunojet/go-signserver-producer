# Checklist Pré-GMUD para Deploy Seguro de Infraestrutura e Aplicação

Este documento visa padronizar e aumentar a segurança dos deploys, minimizando falhas em GMUDs e garantindo que infraestrutura e aplicação estejam sempre sincronizadas.

---

## 1. Planejamento
- [ ] Definir janela de deploy em horário de menor impacto.
- [ ] Comunicar todos os times envolvidos sobre a janela e escopo da mudança.
- [ ] Garantir que todos os times estejam cientes de bloqueio para mudanças paralelas.

## 2. Sincronização de Ambientes
- [ ] Validar que o ambiente de homologação/QA está idêntico ao de produção (mesmo código, mesmas versões de dependências, mesma infraestrutura).
- [ ] Usar infraestrutura como código (ex: Terraform) com state remoto compartilhado.

## 3. Validação Pré-GMUD
- [ ] Executar `terraform plan` em produção e revisar o plano de mudanças.
- [ ] Comparar o plano de produção com o último plano de homologação/QA.
- [ ] Investigar e resolver qualquer diferença inesperada (drift, mudanças manuais, alterações de outros times).
- [ ] Validar que não há recursos "fora do código" (criados manualmente).

## 4. Aprovação
- [ ] Checklist de aprovação manual (workflow pause) antes do deploy em produção.
- [ ] Aprovação formal/documentada de todos os times impactados.

## 5. Execução do Deploy
- [ ] Executar deploy de infraestrutura e aplicação juntos, sempre que possível.
- [ ] Executar testes automáticos e manuais pós-deploy.
- [ ] Monitorar métricas, logs e alertas em tempo real.

## 6. Rollback
- [ ] Ter plano de rollback documentado e testado.
- [ ] Garantir que rollback pode ser feito rapidamente (scripts, comandos prontos, snapshots/backups).
- [ ] Documentar qualquer incidente ou ação de rollback.

## 7. Pós-Deploy
- [ ] Validar sucesso do deploy com usuários-chave e stakeholders.
- [ ] Atualizar documentação e changelog compartilhado.
- [ ] Liberar ambiente para novas mudanças após confirmação de estabilidade.

---

## Observações
- Deploys de infraestrutura e aplicação devem ser feitos juntos sempre que possível para evitar inconsistências.
- Nunca faça mudanças manuais em produção sem registrar e comunicar.
- Use ferramentas de detecção de drift (ex: `terraform plan`, Driftctl) regularmente.
- Mantenha comunicação aberta entre todos os times envolvidos.

---

*Este checklist pode ser adaptado conforme a maturidade do time e ferramentas disponíveis. O objetivo é garantir GMUDs bem-sucedidas, ambientes sincronizados e máxima rastreabilidade.*
