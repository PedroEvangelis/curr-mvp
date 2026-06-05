# Architecture

## ADRs

### ADR-001: Template único e imutável com dados via JSON

**Contexto:** Gerar currículos para diferentes vagas exige dados diferentes, mas criar um `.typ` novo a cada currículo quebra a rastreabilidade e duplica lógica de renderização.

**Decisão:** Manter um único template `.typ` imutável. Dados fluem via JSON externo, lido em tempo de compilação com `sys.inputs` e `json()`. O template itera as seções com `for` loops.

**Alternativas consideradas:**
- **Gerar .typ por currículo:** Rejeitado — duplica template, dificulta manutenção.
- **Múltiplos templates fixos (um por layout):** Adiado — o template único resolve o caso atual.

**Consequências:**
- Toda mudança de layout é centralizada em `src/templates/resume.typ`.
- O JSON é o artefato de intercâmbio: pode ser re-renderizado com outros templates no futuro.
- O template precisa tratar seções vazias, campos opcionais e tipos variantes.

**Referência:** `.specs/features/template-system/spec.md`
