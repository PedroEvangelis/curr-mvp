# Glossary

Termos do domínio do sistema curr-mvp. Mantido vivo — cresce organicamente com novas features.

## Perfil
Documento central `profile.md` que contém a base completa do profissional: meta (frontmatter), narrativa de carreira, contexto por experiência, formação, projetos, mapa de conhecimentos, capacidades e idiomas. É a fonte única da verdade para geração de currículos.

## Vaga (ou Oportunidade)
Descrição de uma posição/oportunidade profissional. Inclui título, empresa, requisitos, responsabilidades, tecnologias mencionadas. É o input para o briefing e para a geração do currículo.

## Briefing
Sessão interativa entre o agente (IA) e o usuário onde a vaga é analisada contra o perfil completo. O agente sugere adaptações, verifica compatibilidade de tecnologias (inferências inclusivas), e propõe otimizações. O usuário aprova ou ajusta antes da geração.

## Currículo
Artefato final gerado: um documento PDF otimizado para a vaga e para ATS, compilado via typst a partir de um template selecionado.

## Template
Arquivo `.typ` (Typst) que define o layout visual do currículo — cores, fontes, disposição dos blocos. O usuário pode criar e escolher templates diferentes para cada currículo.

## ATS (Applicant Tracking System)
Sistema automatizado usado por recrutadores para triar currículos. Currículos otimizados para ATS usam palavras-chave relevantes, estrutura semântica limpa e formatação legível por máquina.

## Inferência Tecnológica
Regra de compatibilidade entre tecnologias. Exemplo: C# infere .NET (porque C# requer runtime .NET), mas .NET não infere C# (pode ser VB, F#, etc.). Usado durante o briefing para preencher lacunas entre o perfil e os requisitos da vaga.

## Profile.md
Arquivo Markdown que armazena o perfil completo. É a fonte da verdade. Pode ser editado manualmente ou atualizado durante briefings.

## PDF Taggeado
PDF gerado com marcações semânticas (tags) que melhoram a legibilidade por ATS. O typst permite gerar PDFs com estrutura acessível e tags apropriadas.

## Formato Canônico
Schema JSON que define a estrutura de dados de um currículo. É o contrato entre a IA (que gera os dados durante o briefing) e o template Typst (que renderiza). Documentado em `.specs/features/template-system/spec.md`. Contém meta, dados pessoais e seções com items tipados.
