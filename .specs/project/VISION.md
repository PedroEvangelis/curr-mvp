# Product Vision — curr-mvp

## Problem Statement
Manter e versionar múltiplos currículos otimizados para vagas específicas é trabalhoso e lento. O usuário edita manualmente um currículo base, não reaproveita conteúdo entre versões, e gerar currículos customizados para diferentes vagas é repetitivo e propenso a erro. Cada currículo precisa ser estruturado e ter palavras-chave otimizadas para sistemas de rastreamento de candidatos (ATS).

## Atores
- **Usuário (profissional)**: pessoa que mantém seu perfil profissional completo e gera currículos sob demanda, otimizados para cada vaga.

## Success Metrics
- **Tempo de geração**: gerar um currículo pronto (PDF) para uma vaga em <5 minutos de interação.
- **Adoção**: usuário usa o sistema para 100% das candidaturas em vez de edição manual.
- **Satisfação**: usuário considera o currículo gerado "melhor ou igual" ao que faria manualmente.
- **Versionamento**: todo currículo gerado está rastreável (vaga + empresa + data) no repositório.

## Out of Scope (Initial)
- Portal web ou interface gráfica — tudo via terminal/CLI.
- Integração com APIs de vagas (LinkedIn, Indeed, etc.) — o usuário traz a descrição da vaga.
- Parse automático de PDF de vagas — o usuário cola/descreve a vaga.
- Sistema multi-usuário — single-user.
