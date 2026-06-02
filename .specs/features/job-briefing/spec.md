---
type: spec
feature: job-briefing
concerns: []
---

# Spec — Job Briefing

## Description

Fluxo principal: usuário traz uma vaga, IA analisa contra o perfil, sugere adaptações, gera o JSON canônico e compila o PDF.

## Pré-condição

`profile.md` **deve existir**. Se não existe, execute o fluxo [profile-management](features/profile-management/spec.md) primeiro.

## Etapas

### 1. Carregar Contexto
- Leia `profile.md` completo
- Receba a descrição da vaga do usuário (pode ser colada, texto livre, URL)
- Se for URL, tente extrair o conteúdo da página

### 2. Analisar Match (Briefing)
- Compare perfil × vaga:
  - **Tecnologias:** quais o perfil tem e a vaga pede? Identifique gaps.
  - **Inferência:** C# → .NET (runtime necessário), React → Next.js (ecossistema comum), etc. Se a vaga pede .NET e o perfil tem C#, considere compatível.
  - **Experiência:** as experiências do perfil são relevantes para a vaga?
  - **Apresentação:** o título e texto de apresentação estão alinhados com a vaga?
- Apresente a análise ao usuário

### 3. Propor Adaptações
- Sugira adaptações específicas:
  - "Sua experiência como Full Stack pode destacar mais o backend se a vaga é de backend"
  - "Seu título está como 'Engenheiro de Software'. Para essa vaga, 'Desenvolvedor Full Stack' seria melhor?"
  - "A vaga pede .NET. Você tem C# listado — posso incluir .NET como tecnologia compatível?"
- O usuário aprova, rejeita ou ajusta cada sugestão
- Adapte o conteúdo para o currículo (NÃO altere `profile.md` ainda — apenas o currículo)

### 4. Gerar JSON Canônico
- Monte o JSON seguindo o formato em [features/template-system/spec.md](features/template-system/spec.md)
- Salve em `output/{data} x {Empresa} x {Vaga}.json`
- Regras:
  - Seções vazias → omitir do JSON
  - bullets vazios → `[]`
  - Datas no formato livre (`"Mar 2020"`, `"2024-06"`, `"Present"`)

### 5. Compilar PDF
```powershell
bin\typst compile templates\resume.typ "output\{data} x {Empresa} x {Vaga}.pdf" --input data="output\{data} x {Empresa} x {Vaga}.json"
```

### 6. Pós-geração
- Pergunte se o usuário quer salvar as adaptações no `profile.md` (atualizar perfil com a nova perspectiva)
- Pergunte se quer gerar outro currículo
- Atualize `profile.md` se o usuário autorizar

## Regras de Inferência Tecnológica

| Tecnologia no Perfil | Pode Inferir |
|---------------------|--------------|
| C# | .NET, .NET Core, ASP.NET |
| Python | Django, Flask, FastAPI |
| JavaScript | Node.js, TypeScript, React, Vue |
| TypeScript | JavaScript, Node.js |
| React | Next.js, React Native |
| SQL | PostgreSQL, MySQL, SQL Server |

Regra geral: a inferência é **unidirecional** (da específica para a geral). A menos que o contexto da vaga claramente indique o contrário.
