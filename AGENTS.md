# curr-mvp — OpenCode instructions

## FIRST ACTION

Read `.specs/guide.md`. It explains the complete project — what it does, how to navigate, and the two possible flows.

## Entrypoint Gate (HARD GATE)

**Trigger:** Every first user message — greetings, single words, questions, empty messages. No exceptions.

**Detection & Routing:**
- **Job posting** (URL, structured description, intent to apply) → execute **job-briefing** flow per [features/job-briefing/spec.md](.specs/features/job-briefing/spec.md)
- **Non-job** (everything else including "oi") → execute **profile-management** flow per [features/profile-management/spec.md](.specs/features/profile-management/spec.md)

**FORBIDDEN:** Generic greetings, open-ended questions, any message that doesn't route to one of the two flows.

## Skills (optional)

| Skill | When |
|-------|------|
| `spec-driven-analyst` | For spec work (DISCOVER/BUILD/FIX checkpoints) |
| `typst` | When compiling `.typ` files to PDF |

## Setup

```powershell
.\setup.ps1                          # downloads typst binary to bin/
```

## Compile

```powershell
.\compile.ps1 "output/DATA x EMPRESA x VAGA.json"
```

O script:
- Copia o JSON para `_temp_resume.json` (nome simples, sem caracteres especiais) na raiz do projeto
- Compila para `_temp_resume.pdf`
- Renomeia para o nome final do PDF
- Limpa os temporários

Funciona em Windows, Linux e macOS (PowerShell Core).

## Template JSON — Atenção: todas as chaves opcionais são obrigatórias

O template em `src/templates/resume.typ` acessa campos do JSON com notação de ponto (`item.technologies`). Isso **quebra** se a chave não existir no dicionário. Mesmo campos opcionais na spec precisam estar presentes.

**Todo JSON deve conter:**

| Contexto | Campos obrigatórios |
|----------|-------------------|
| `personal` | `name`, `email`, `phone`, `github`, `linkedin`, `personal-site`, `pronouns` |
| work / education / projects | `technologies: []`, `methodologies: []`, `keywords: []`, `bullets: []` |
| projects | `url: ""`, `dates: { "start": "", "end": "" }` (mesmo sem datas) |
| education | `technologies: []`, `methodologies: []`, `keywords: []`, `bullets: []` |

**Antes de gerar JSON**, leia `src/templates/basic-resume/resume.typ` para verificar os parâmetros exatos que cada helper aceita (`work()`, `edu()`, `project()`, `certificates()`). Isso evita erros de chave faltante na compilação.

## Typst Path Resolution

- `read()` e `json()` resolvem caminhos relativos ao **diretório do arquivo `.typ`** que os chama, não ao `--root`
- `src/templates/resume.typ` → `json("data/foo.json")` busca em `src/templates/data/foo.json`
- Para acessar `output/file.json` de dentro de `src/templates/`: usar `../../output/file.json`
- Usar **forward slashes** (`/`) no caminho (funciona em Windows, Linux e Mac)

## Profile — Notas sobre Pedro (acumulativo)

Além do que está em `profile.md`, o agente deve saber:

- **Marketing digital:** experiência real com GA, Meta Pixel, Tag Manager — implementou tracking no Plugchat. Não é apenas conhecimento teórico.
- **Digital One:** é uma agência de marketing digital, não uma empresa de tecnologia genérica.
- **Ferramentas de preferência pessoal:** Tailwind CSS (desde ITEM Sistemas), ShadCN/UI, Zustand (desde Irrah Tech). NestJS e Express.
- **Notas fiscais:** domínio de NF-e/NFS-e, integrou com o sistema da Elotech (gestão pública).
- **Empreendedorismo:** marca de camisetas foi produto digital com campanhas, perfil, tráfego — não é só "negócio físico".
- **Comportamento em entrevista/briefing:** quando um gap é identificado, Pedro frequentemente tem a experiência mas não a listou — perguntar de forma dirigida ("você tem experiência com X?") revela mais do que esperar que ele ofereça.
- **Comunicação:** traduz linguagem técnica para times de negócio/marketing naturalmente.
- **Mentoria:** ensina colegas e alunos ativamente, criou documentação técnica por iniciativa própria.

## Conventions

- Profile: `profile.md` (Markdown, incremental, never complete). É a fonte da verdade — deve conter detalhes ricos o suficiente para que um agente entenda profundamente a trajetória do usuário. **Nunca deve ser compactado ou resumido.**
- Template: `src/templates/resume.typ` (immutable)
- Output: `output/{data} x {Empresa} x {Vaga}.pdf` + companion `.json`
- Pipeline: profile.md → AI briefing → JSON → typst compile → PDF
- Versioning: Git
- **Title per job**: definir o título profissional no briefing conforme a vaga específica (ex: "Desenvolvedor Full Stack" → "Desenvolvedor Back-End .NET"). O título não fica fixo no perfil — é adaptado a cada currículo.
- **Work order**: ordenar experiências por relevância para a vaga, não cronologicamente. A experiência mais alinhada com os requisitos deve aparecer primeiro.

## Features

| Feature | Status | What |
|---------|--------|------|
| **template-system** | ✅ Spec | [features/template-system/spec.md](.specs/features/template-system/spec.md) |
| **profile-management** | ✅ Spec | [features/profile-management/spec.md](.specs/features/profile-management/spec.md) |
| **job-briefing** | ✅ Spec | [features/job-briefing/spec.md](.specs/features/job-briefing/spec.md) |
