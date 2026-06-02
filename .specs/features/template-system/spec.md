---
type: spec
feature: template-system
concerns: []
---

# Spec — Template System

## Description

Define o template único e imutável para renderização de currículos via Typst. O template consome dados via `--input data=<json>` — sem ele, não há saída. O formato canônico do JSON é o contrato entre o briefing (IA) e o template.

## Como Usar

```powershell
# 1. Setup (uma vez)
.\setup.ps1

# 2. Gerar currículo
bin\typst compile --root="." templates\resume.typ "output\2026-05-31 x Empresa x Vaga.pdf" --input data="..\output\2026-05-31 x Empresa x Vaga.json"
```

## Formato Canônico (Schema JSON)

```jsonc
{
  "meta": {
    "template": "basic-resume",
    "accent-color": "#26428b (cor de headings e links)",
    "body-color": "#000000 (cor do texto corporal, opcional, padrão #000000)",
    "font": "Noto Sans",
    "paper": "a4",
    "author-position": "left",
    "personal-info-position": "left",
    "lang": "pt",
    "keywords": "string — metadados PDF separados por vírgula",
    "tech-block-font-size": 9.5 "(opcional, padrão 9.5)"
  },
  "personal": {
    "name": "string (obrigatório)",
    "location": "string",
    "email": "string",
    "phone": "string",
    "github": "string",
    "linkedin": "string",
    "personal-site": "string",
    "pronouns": "string"
  },
  "summary": "string (opcional) — resumo profissional otimizado para ATS, renderizado como parágrafo antes das seções",
  "sections": [
    {
      "type": "education | work | projects | certificates | extracurriculars | skills | languages",
      "title": "string — heading da seção (ex: 'Formação')",
      "items": [
        // type-specific shape, veja abaixo
      ]
    }
  ]
}
```

### Items por tipo de seção

**education**
```
{ institution, location, degree, level?, dates: { start, end }, gpa?, technologies?: string[], methodologies?: string[], keywords?: string[], bullets[] }
```

**work**
```
{ company, location, title, dates: { start, end }, technologies?: string[], methodologies?: string[], keywords?: string[], bullets[] }
```

**projects**
```
{ name, role?, url?, dates: { start, end }, technologies?: string[], methodologies?: string[], keywords?: string[], bullets[] }
```

**certificates**
```
{ name, issuer, url?, date, technologies?: string[], methodologies?: string[], keywords?: string[], bullets[] }
```

**extracurriculars**
```
{ activity, dates: { start, end }, bullets[] }
```

**skills**
```
{ category, skills: string[] }
```

**languages**
```
{ language, proficiency }
```

### Regras

- `dates.start` e `dates.end` são strings livres (`"Mar 2020"`, `"2024-06"`, `"Present"`).
- `bullets` pode ser vazio (`[]`).
- Campos opcionais podem ser omitidos ou string vazia. O template ignora valores vazios.
- `sections` vazias são ignoradas pelo template.

## Funcionamento

O template `templates/resume.typ` é imutável (salvo decisão explícita do usuário, os helpers ficam em `templates/basic-resume/resume.typ`). Ele:

1. Lê JSON de `sys.inputs.at("data")`
2. Renderiza `data.summary` como parágrafo antes das seções (se existir)
3. Renderiza dados pessoais via `resume.with(...)`
4. Itera `sections` e, para cada `type`, chama a função correspondente:
   - `education` → `edu(...)`
   - `work` → `work(...)`
   - `projects` → `project(...)`
   - `certificates` → `certificates(...)`
   - `extracurriculars` → `extracurriculars(...)`
   - `skills` → lista formatada com categoria
   - `languages` → `languages(items:)`

Os helpers `work`, `edu`, `projects` e `certificates` aceitam:
- `technologies` (`string[]`) — renderizado como "_Tecnologias:_ ..." ao final do item (itens separados por ", ")
- `methodologies` (`string[]`) — renderizado como "_Metodologias:_ ..." ao final do item
- `keywords` (`string[]`) — renderizado como "_Palavras-chave:_ ..." ao final do item
- `education` aceita também `level` (string, ex: "Superior (Tecnólogo)", "Técnico") — prefixa o degree

## Out of Scope

- Múltiplos templates simultâneos
- Edição manual do template
