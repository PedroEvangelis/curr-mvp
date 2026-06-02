# Conventions

**Default:**
- Diagramas: Mermaid (compatível com GitHub, GitLab, Obsidian, VS Code)
- Formato de perfil: Markdown (`.md`)
- Formato de template: Typst (`.typ`) — template fixo e imutável
- Formato de saída: PDF (ATS-tagged)
- Versionamento: Git

## Pipeline de Geração

```
profile.md → IA (briefing) → JSON → typst compile (--input data=) → PDF
```

O template nunca muda. O JSON em `output/` é o único input variável.

## Template System

- Template único em `templates/resume.typ`.
- Dados injetados via `sys.inputs.at("data")` → `json()`.
- Seções iteradas com laços `for`. Nenhum dado fixo no template.
- Formato canônico documentado em `.specs/features/template-system/spec.md`.

## Estrutura de Diretórios

```
curr-mvp/
├── .specs/              documentação viva
├── bin/                 gitignored — tooling (typst)
├── templates/           templates .typ (imutáveis)
├── output/              gitignored — PDFs + JSONs gerados
├── profile.md           perfil central
├── setup.ps1            bootstrap do ambiente
└── .gitignore
```
