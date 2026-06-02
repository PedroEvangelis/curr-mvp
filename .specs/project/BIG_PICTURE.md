# Big Picture — curr-mvp

Índice navegável do sistema. Mantido automaticamente pelo agente.

## Entities

Entidades core do domínio e as features que as definem:

- **Perfil**: base completa do profissional → [features/profile-management/spec.md]
- **Vaga**: descrição de oportunidade profissional → [features/job-briefing/spec.md]
- **Currículo**: artefato PDF gerado → [features/job-briefing/spec.md], [features/template-system/spec.md]
- **Template**: layout `.typ` → [features/template-system/spec.md]
- **Briefing**: sessão interativa de análise → [features/job-briefing/spec.md]

## Feature Map

| Feature | Status | Modo | Entidades |
|---------|--------|------|-----------|
| profile-management | ✅ Spec | DISCOVER | Perfil |
| job-briefing | ✅ Spec | DISCOVER | Vaga, Currículo, Briefing |
| template-system | ✅ Spec | BUILD | Template, Currículo |

## Decision Log

| ADR | Decisão | Feature de Origem |
|-----|---------|-------------------|
| ADR-001 | Template único e imutável. Dados fluem via JSON + `sys.inputs`. Template itera seções com loops. | [features/template-system/spec.md] |

## Global Behaviors

| Comportamento | Aplica-se a | Origem |
|---------------|-------------|--------|
| *Nenhum comportamento global ainda.* | — | — |

## Open Questions

_Nenhuma._
