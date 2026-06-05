# Session State — 2026-06-03

## Resumo da Sessão (Acumulado)

### Sessão Anterior: Estratégia TOTVS + Enriquecimento de Perfil (2026-06-02)
- Estratégia de posicionamento definida: primário .NET/ERP, secundário Node/React
- Resumo otimizado para site da TOTVS elaborado
- Experiências Irrah Tech e ITEM Sistemas reescritas
- Data ITEM corrigida: "Setembro 2022 - Maio 2025"

### Sessão Atual: Reestruturação do Projeto (2026-06-03)
- Criado diretório `src/` com `src/templates/` e `src/scripts/`
- `templates/` movido para `src/templates/`
- `bin/lint-json.ts` e `bin/validate-json.ts` movidos para `src/scripts/`
- Scripts `compile.ps1` e `setup.ps1` na raiz viraram wrappers que delegam para `src/scripts/`
- Corrigido `sys.inputs.at("data")` para usar `default: "_empty_resume.json"` (lint da ZED)
- Criado `templates/_empty_resume.json` como fallback para lint standalone
- Removido `location` do template (não utilizado)
- Removido `opt-len()` (código morto)
- Removidos os diretórios antigos (`templates/`, `bin/*.ts`)
- Todos os paths em `AGENTS.md`, `.specs/` e scripts atualizados
- Lint (indentação 2 espaços) + validação Zod integrados ao pipeline de compilação

## Outputs Gerados
- Nenhum novo. Estrutura reorganizada, compilação testada e funcionando.

## Decisões Pendentes
- Nenhuma.

## Blockers
- Nenhum.

## Lições Aprendidas
- `opt()` no template protege campos ausentes — `none` vira `""` sem quebrar a compilação.
- `--input data` paths são relativos ao `.typ`, não ao `--root`.
- `sys.inputs.at("key", default: "...")` requer um default válido — se for uma string, `json()` tenta abrir como arquivo.
- `Join-Path` no PowerShell 5.1 aceita apenas 2 argumentos posicionais.
- Múltiplos currículos para mesma empresa com stacks diferentes exigem JSONs separados.
- `compile.ps1` executa lint (indentação 2 espaços) + validação Zod antes de compilar.
- Templates .typ referenciam `_empty_resume.json` com caminho relativo ao próprio diretório.

## Deferred Ideas
- Script de orquestração para automatizar pipeline profile → JSON → PDF.
