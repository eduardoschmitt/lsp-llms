# Contribuindo

Este projeto transforma documentação existente em referência fiel para LLMs. Contribua em fatias pequenas e verificáveis.

## Antes de alterar qualquer coisa

1. Leia o `AGENTS.md` (raiz do workspace) — ele define missão, fidelidade às fontes e o protocolo de execução.
2. Localize a seção relevante na documentação-fonte e leia o contexto ao redor antes de transformar trechos isolados.
3. Defina o menor escopo útil (idealmente um tópico de `docs/` por vez) e não amplie para domínios vizinhos sem concluir e validar o atual.

## Regras que não têm exceção

- Não invente funções, parâmetros, retornos, sintaxe, tipos ou contextos de execução.
- Não corrija silenciosamente material suspeito da fonte: preserve o sentido original e registre a incerteza (`Conflict / uncertainty`).
- Não infira comportamento de LSP a partir de outras linguagens.
- Documentação técnica em `docs/` permanece em inglês; exemplos de código LSP permanecem intactos (traduzem-se só os comentários explicativos, sem mudar o sentido técnico).

## Fluxo de trabalho

```bash
# 1. edite apenas as fontes em docs/
# 2. regenere os artefatos
python scripts/build_llms.py
# 3. valide
python scripts/build_llms.py --check
```

- Nunca edite `llms.txt` ou `llms-full.txt` à mão.
- Nada de `evals/` entra no corpus (o gerador consome só `docs/`).
- Casos de avaliação congelados não são reescritos: versões novas documentam o motivo e o histórico é preservado.

## O que incluir no relato da mudança

- Seções da fonte inspecionadas.
- Arquivos criados ou modificados.
- Ambiguidade ou conflito encontrado (e onde cada interpretação veio).
- Validação executada (`--check`, diff revisado).
- Próxima fatia recomendada — sem iniciá-la automaticamente.
