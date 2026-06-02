# Session State — 2026-06-02

## Resumo da Sessão (Acumulado)

### Sessão Atual: Estratégia TOTVS + Enriquecimento de Perfil
- Estratégia de posicionamento definida: primário .NET/ERP, secundário Node/React
- Resumo otimizado para site da TOTVS elaborado
- Experiência Irrah Tech reescrita com correções: OTEL ("participei ativamente"), Kafka, Ports and Adapters, descrição do Plugchat (multi-canal, bots, IA), Firebase Storage + Realtime
- Experiência ITEM Sistemas reescrita com destaques: NF-e/NFS-e integrando prefeituras, liderança em testes unitários + refatoração com testes de regressão, documentação interna Vitepress, observabilidade OTEL
- Data ITEM corrigida: "Setembro 2022 - Maio 2025" (2 anos e 8 meses)

### Job 1: Lyncas — FullStack (Python + React)
- Análise de match, adaptações (Python, IA/LLMs), JSON + PDF gerados
- Profile.md atualizado

### Job 2: Lyncas — Banco de Talentos .NET C#
- Match fortíssimo: 3 anos de ecossistema .NET na ITEM Sistemas
- Currículo posicionado para backend .NET com ênfase em C#, .NET Core, SQL Server, Dapper, microsserviços
- JSON + PDF gerados separadamente (mantendo o FullStack anterior)
- Skills reordenadas: .NET em primeiro plano, mensageria/event-driven adicionados como conceitos

## Outputs Gerados
| Currículo | JSON | PDF |
|-----------|------|-----|
| FullStack (Python + React) | `output/Jun 2026 x Lyncas x Engenheiro de Software Sênior FullStack.json` | `output/...pdf` (66 KB) |
| .NET C# (Banco de Talentos) | `output/Jun 2026 x Lyncas x Banco de Talentos .NET.json` | `output/...pdf` (64 KB) |
| Node.js Pleno | `output/Jun 2026 x Lyncas x Desenvolvedor Node.js Pleno.json` | `output/...pdf` (63 KB) |

## Adaptações no Perfil (sessão anterior)
- Título: "Desenvolvedor Backend | Node.js, NestJS & Arquitetura de Dados" → "Desenvolvedor Full Stack | Node.js, React, Python & Integração com IA"
- Apresentação: adicionado Python, IA/LLMs, microsserviços
- Habilidades: Python (intermediário), IA Generativa e LLMs, WebSockets
- curr-mvp: descrição enriquecida com LLMs, MCPs e agentes de IA

## Decisões Pendentes
- Nenhuma.

## Blockers
- Nenhum.

## Lições Aprendidas
- Template `resume.typ` exige todos os campos no JSON (`technologies`, `methodologies`, `keywords`, `url`, `bullets`, `pronouns`, `personal-site`) — omitir causa erro.
- `--input data` paths são relativos ao `.typ`, não ao `--root`.
- Múltiplos currículos para mesma empresa com stacks diferentes exigem JSONs separados.

## Deferred Ideas
- Script de orquestração para automatizar pipeline profile → JSON → PDF.
