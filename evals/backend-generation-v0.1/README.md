# backend-generation-v0.1

**Purpose:** evaluate whether a single LLM can use the current post-v0.1
`llms-full.txt` documentation to generate valid LSP for three
backend-oriented tasks (JSON, file I/O, HTTP/web-services).

This suite is intentionally simpler than `language-generation-v0.1`: one
model, three exercises, no model comparison.

## Model under evaluation

`Gemini 3.1 Pro (Low)`

This suite intentionally uses only one model. It is not a model-comparison
benchmark; later suites may compare models or conditions.

## Corpus under test

Post-`language-generation-v0.1` corpus (includes the v0.1 post-mortem
documentation corrections):

- `llms-full.txt` SHA-256 `5396C2A7212606E1BD147DD12CDDF3610A8A0FDD87DA605C9E3D30D4291F7C06`
- `llms-full.txt` size: 255,437 bytes

All runs in this suite must use these exact bytes. Any corpus change requires
a new suite version or an explicit re-baselining note.

## Scope

Exercises test **documented LSP backend capabilities** only. No customer
database schemas, Senior ERP table names, rule identifiers, undocumented
runtime variables, module-specific context, or production environment
knowledge. All non-LSP information needed is inside each exercise.

## Methodology

```text
solver prompt + llms-full.txt (identical bytes)
→ model response (one execution per exercise)
→ preserve the response verbatim under results/gemini-3-1-pro-low/
→ copy the generated LSP rule without modification
→ compile in a real Senior environment, record COMPILE
→ execute if compilation succeeds, record RUNTIME
→ compare observable behavior with the expected behavior, record OUTPUT
→ diagnose failures (fragment / symptom / root cause / correct approach)
→ only then create/document human corrections, if useful, as separate records
```

Stages, `Cases correct`/`NOT RUN` handling, `Human fixes required` records,
failure taxonomy, documentation-coverage classes (`DOC_CLEAR` / `DOC_WEAK` /
`DOC_MISSING` / `DOC_CONFLICT` / `NOT_DOC_RELATED`), and the documentation
feedback loop all follow `../language-generation-v0.1/README.md` without
duplication here — that file is the methodology reference for both suites.

## Leakage prevention

The solving model receives ONLY `llms-full.txt` + the solver prompt from the
case file. It must NOT receive: this README, complete case files,
evaluator-only expected behavior, evaluator notes, likely failure modes,
previous responses, previous results, diagnoses, corrected solutions, or
aggregate results. Evaluation artifacts are not LSP documentation and must
never become input to `llms.txt` or `llms-full.txt` (the generator consumes
only `docs/**/*.md`).

## Reproducibility

Every execution records: suite version; exercise ID/version; model provider;
exact model name; execution date; repository commit when available;
`llms-full.txt` SHA-256 and byte size as above; documentation-context
confirmation; exact solver prompt; original model response; compilation
result; compiler error text when applicable; runtime result; actual
observable behavior; expected behavior; diagnosis; human fixes.

## Freeze policy

Cases are frozen as B01 v1, B02 v1, B03 v1 once the first real execution
begins. A defective exercise gets a new version with a documented reason;
v1 history is preserved.

## Evaluation environment

All runs in this suite so far were executed in:

```text
Product: Senior Gestão Empresarial
Version: 5.10.4.9
```

LSP APIs, signatures, and behaviors can vary between Senior ecosystem
versions. Empirical eval results are therefore valid for the recorded
environment and must not be automatically treated as universal. Where the
corpus, official documentation of another version, and executed behavior
diverge, the divergence is preserved with its version identified.

## Results

| Model | B01 JSON | B02 File I/O | B03 HTTP |
|---|---|---|---|
| Gemini 3.1 Pro (Low) | PASS 3/3 | FAIL (see trail; mode fix: partial — count open) | v1 endpoint-dependent (404); **v2 PASS** (`HTTP OK: https://httpbin.org/get`) |

Details: `results/gemini-3-1-pro-low/` (verbatim `.lsp` evidence,
per-exercise records, one diagnostic correction pending execution).
No other models are in scope for this suite.

Findings so far (evidence, not corpus changes):

- B02 surfaced three issues in sequence: path escaping (`DOC_CLEAR`), a
  version-dependent `ArqExiste` arity divergence on 5.10.4.9
  (`DOC_CONFLICT`), and an open-mode mismatch. The mode-matched diagnostic
  (`B02.corrected-modes.lsp`) compiled and executed: the mode error is gone
  and `Existe: 1` / `Primeira: Alpha` check out, but `LinhasArquivo`
  returned 0 instead of 3 — an open line-count finding, not a rule.
- B03 v1 confirmed the HTTP mechanism end to end (compiled request, live 404
  response). B03 v2 (httpbin + response-body assertion) passed fully:
  `HTTP OK: https://httpbin.org/get`, validating request, status, and
  parsed response in one run.
- v0.1 results and frozen artifacts are unaffected by this suite.
