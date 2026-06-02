---
type: spec
feature: profile-management
concerns: []
---

# Spec — Profile Management

## Description

Gerenciar o perfil profissional central (`profile.md`). É a fonte única da verdade. Tudo que a IA sabe sobre o usuário vem daqui. O perfil é incremental: cresce a cada interação.

## Estado

- Se `profile.md` **não existe**: IA deve criá-lo perguntando ao usuário.
- Se `profile.md` **existe**: IA carrega e pergunta o que o usuário quer adicionar/editar.
- O perfil **nunca** é considerado completo. Sempre há algo a adicionar.

## Estrutura do `profile.md`

Markdown livre com seções. Exemplo de seções esperadas:

```markdown
# Dados Pessoais
Nome: ...
LinkedIn: ...
GitHub: ...
Email: ...
Telefone: ...
Localização: ...

# Título Profissional
...

# Apresentação
...

# Experiências

## Empresa X | Cargo | Data início - Data fim
- Descrição da experiência
- Tecnologias usadas

# Formação
...

# Cursos e Certificações
...

# Habilidades Técnicas
- Categoria: skill1, skill2, ...

# Habilidades Complementares
...
```

O formato é livre — a IA interpreta o conteúdo durante o briefing.

## Comportamento da IA

1. **Se profile.md não existe:**
   - Informe o usuário que o perfil ainda não foi criado
   - Pergunte os dados essenciais (nome, linkedin, github, email, telefone, localização, título)
   - Pergunte sobre experiências: "Quais empresas você trabalhou?"
   - Pergunte sobre formação, certificações, habilidades
   - Crie `profile.md` e salve
   - Confirme com o usuário

2. **Se profile.md existe:**
   - Carregue e leia o conteúdo
   - Apresente um resumo: "Seu perfil tem X experiências, Y certificações..."
   - Pergunte: "O que você quer adicionar ou atualizar?"
   - Aceite texto livre: "adiciona uma experiência na empresa Z" ou "atualiza meu email"
   - Após cada alteração, salve e confirme
   - Sugira melhorias: "Percebi que você não mencionou projetos pessoais. Quer adicionar?"

3. **Regras:**
   - Pergunte antes de modificar. O perfil é do usuário.
   - Preserve formatação existente. Só edite a seção afetada.
   - Se o usuário não sabe o que adicionar, sugira seções comuns.
