# language-generation-v0.1 — Post-mortem

Frozen benchmark: E01 v1, E02 v1, E03 v1 × Gemini 3.1 Pro (Low), Nemotron 3
Ultra Free, Muse Spark 1.3 Free → 9/9 executions recorded. Corpus fingerprint
at run time: `llms-full.txt` SHA-256
`3E520ACEC41548A10B2B20D37E399763AB66B9BCCADB348A843AE7ECBF675ED5`
(252,495 bytes). This document analyzes; it changes no result.

## 1. Benchmark outcomes

| Model | E01 | E02 | E03 | Total |
|---|---|---|---|---|
| Gemini 3.1 Pro (Low) | PASS 3/3 | FAIL (Compile) 0/3 | PASS 3/3 | 2/3 |
| Nemotron 3 Ultra Free | PASS 3/3 | FAIL (Compile) 0/3 | FAIL (Compile) 0/3 | 1/3 |
| Muse Spark 1.3 Free | PASS 3/3 | PASS 3/3 | PASS 3/3 | 3/3 |

All models passed E01. E02 split on implementation strategy (arrays vs.
scalars), not on effort: both array users failed identically, the scalar
user passed. E03 split on message-assembly shape (one long line vs. shorter
statements).

## 2. Confirmed documentation findings

### Finding #1 — bracket indexing is 1-based for the tested constructs

- Gemini E02 (`vnNotas[0..4]`) and Nemotron E02 (`vnNotas[0..4]`) both failed
  with `Erro indexando fora dos limites: 0`.
- Minimal corrections shifting only `0..4` → `1..5` passed 3/3 for both
  models (Regra 561 and Regra 565 outputs on record).
- Official Senior support article 23581 (`Indexando fora dos limites`)
  independently establishes 1-based vector positions for `Alfa[N]`, explains
  it is not a list of variables, and recommends dynamic lists for
  collection-like needs.

Conclusion: the corpus presentation that let 0-based indexing look valid for
this construct was misleading. Corrected in `docs/language/arrays.md` and
`docs/guides/limitations.md` (new L13 is unrelated; the indexing correction
is in arrays.md). Scope is bounded: 1-based is established for the tested
bracket forms (`Numero[5]` element assignment, `Alfa[N]` char positions),
not as a universal rule for every Senior collection type.

### Finding #2 — compiler source-line length limit

- Nemotron E03's single message-construction line failed at column 255 with
  `linha para o compilador é muito grande`.
- Splitting only that statement (byte-identical final string) compiled and
  executed. The evaluator further observed the error persists even with the
  rule commented out, suggesting the limit acts during line reading/parsing
  (recorded as observation, not mechanism).
- Documented as observed limitation/guidance; no universal maximum is
  claimed (column 255 is the failure point of this execution, not a
  specification).

## 3. Unresolved findings

### Finding #3 — Nemotron E03 reversal logic

After the line split compiled, outputs were the originals, not reversals.
Trace against documented `CopiarAlfa` semantics: the countdown loop prepends
positions 3, 2, 1 — a double reversal yielding the identity. The API usage
matches the documentation; the loop logic is wrong (`wrong-algorithm`,
`NOT_DOC_RELATED`). No documentation change follows; no further v0.1
diagnostic is attempted.

### Standing conflicts (unchanged by v0.1)

Function calls in conditions, expressions in parameters, `DataHoje` typing,
date literals, JSON paths, encoding defaults, file modes, placeholder-vs-DML
SQL, and spaced/unspaced numeric names all remain preserved as documented.
v0.1 neither confirmed nor denied them beyond the indexed-access and
line-length results above.

## 4. Diagnostic evidence inventory

- `results/gemini-3-1-pro-low/E02.corrected-indexing.lsp` + record:
  hypothesis CONFIRMED (3/3).
- `results/nemotron-3-ultra-free/E02.corrected-indexing.lsp` + record:
  hypothesis CONFIRMED (3/3).
- `results/nemotron-3-ultra-free/E03.corrected-line-length.lsp` + record:
  line-length hypothesis CONFIRMED; reversal-correctness REFUTED (0/3).
- Official Senior article 23581 (support site): authoritative backing for
  Finding #1, paraphrased into the corpus provenance; not bulk-copied.

## 5. Documentation changes resulting from v0.1

- `docs/language/arrays.md`: 0-based presentation corrected — 1-based forms
  now primary with diagnostic + official-article evidence; community 0-based
  examples preserved as contradicted evidence, not valid patterns; guidance
  forbids generating 0-based bracket access for these constructs.
- `docs/guides/limitations.md`: new observed line-length limitation with the
  column-255 evidence and the split-statements safe pattern.
- Frozen v0.1 results, cases, prompts, and original `.lsp` files unchanged.
- Regenerated `llms.txt` / `llms-full.txt` carry the post-v0.1 corpus; the
  v0.1 fingerprint above stays attached to this benchmark. This is not v0.2 —
  any future evaluation round is a separate deliberate run.
