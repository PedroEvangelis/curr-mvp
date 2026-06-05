# curr-mvp — System Guide

> Leia este arquivo primeiro. Ele orienta qualquer agente a navegar o projeto e entender o que fazer.

## O Projeto em 30s

Sistema para manter um perfil profissional (`profile.md`) e gerar currículos em PDF otimizados para ATS a partir dele.

**Toda interação tem um de dois objetivos:**
1. **Atualizar o perfil** — criar ou editar `profile.md`
2. **Gerar currículo** — analisar uma vaga × perfil e gerar PDF

Não há outros objetivos. Não há saudação genérica, não há conversa casual. Toda mensagem do usuário deve ser classificada em um desses dois.

## Estrutura de Navegação

```
.specs/
├── guide.md                          ← VOCÊ ESTÁ AQUI
├── project/
│   ├── VISION.md                     propósito, atores, métricas
│   ├── GLOSSARY.md                   termos do domínio
│   ├── BIG_PICTURE.md                índice de entidades e features
│   ├── CONVENTIONS.md                padrões de implementação
│   ├── ARCHITECTURE.md               decisões arquiteturais (ADRs)
│   └── STATE.md                      memória entre sessões
└── features/
    ├── profile-management/spec.md    ← COMO criar/atualizar o perfil
    ├── job-briefing/spec.md          ← COMO analisar vaga e gerar currículo
    └── template-system/spec.md       ← formato canônico do JSON + template
```

## Como Usar Este Guia

1. **Recebeu uma mensagem do usuário?** Classifique em:
   - **É currículo?** → o usuário trouxe uma vaga, quer gerar PDF → vá para [features/job-briefing/spec.md](features/job-briefing/spec.md)
   - **É perfil?** → o usuário quer criar/atualizar o perfil, ou a mensagem não é vaga → vá para [features/profile-management/spec.md](features/profile-management/spec.md)
   - **Dúvida sobre o sistema?** → responda e pergunte: "Quer atualizar seu perfil ou gerar um currículo?"

2. **Sempre carregue `profile.md`** se ele existir. É a fonte da verdade.

3. **Sempre atualize os documentos globais** ao final: STATE.md, BIG_PICTURE.md.

## Pipeline Completo

```
profile.md ──┐
              ├──→ IA analisa (briefing) → JSON canônico → output/*.json
desc. vaga ──┘
                                                         ↓
                                        bin/typst compile → output/*.pdf
```

## Comandos Essenciais

```powershell
.\setup.ps1                           # instala Typst em bin/
bin\typst compile --root="." src\templates\resume.typ "output\FILE.pdf" --input data="..\..\output\FILE.json"
```

## Perfil Filosofia

- `profile.md` é **incremental**: nunca precisa estar completo. Cada interação adiciona.
- **Se não existe, crie.** Pergunte ao usuário os dados principais.
- **Sempre sugira melhorias.** O usuário pode não saber o que adicionar.
- O perfil é seu, não da IA. Pergunte antes de modificar.

## Template

- Único e imutável: `src/templates/resume.typ`
- Lê dados via `--input data=<json>` + `sys.inputs`
- Formato canônico em [features/template-system/spec.md](features/template-system/spec.md)
