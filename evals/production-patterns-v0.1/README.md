# production-patterns-v0.1

**Purpose:** regression-check whether an LLM given the current
`llms-full.txt` follows the verified production patterns for variable
naming and SQL cursor parameterization instead of repeating known past
mistakes (e.g. declaring `CODPRO` as `Numero`, wrapping simple cursor
values in `__Inserir`, renaming context-provided variables).

This suite uses **static checks only**. Its cases require Senior ERP
database tables and execution-context variables that cannot be exercised
outside Senior, so responses are inspected against a fixed checklist —
they are NOT compiled or executed here. Static outcomes must never be
presented as Senior runtime success. A separate future suite with Senior
ERP runtime access may execute equivalent prompts; its results would be
recorded independently.

## Scope

Variable naming conventions (`docs/language/variables.md`, production
`a` / `n` / `d` guidance) and simple-cursor SQL parameterization
(`docs/database/cursors-sql.md`, production patterns A and B). Three
cases: TA (naming), TB (product cursor), TC (context variables).

Out of scope: full LSP language coverage (see
`../language-generation-v0.1/`), backend composition (see
`../backend-generation-v0.1/`), Senior ERP schema knowledge beyond what
the corpus records, and any runtime behavior.

## Methodology

```text
solver prompt + llms-full.txt (identical bytes for every model)
→ model response (one execution per case per model)
→ preserve the response verbatim under results/<model>/
→ apply the case's static checklist to the response text (no modification)
→ record PASS/FAIL per checklist item, plus the verbatim fragments examined
→ diagnose failures (fragment / symptom / root cause / correct approach)
```

There are no COMPILE / RUNTIME / OUTPUT stages in this suite. If a
response is later executed in Senior ERP, that execution belongs to a
different suite version with its own environment record — never an
amendment to a static result.

Stages, failure taxonomy, documentation-coverage classes (`DOC_CLEAR` /
`DOC_WEAK` / `DOC_MISSING` / `DOC_CONFLICT` / `NOT_DOC_RELATED`), and
the documentation feedback loop follow
`../language-generation-v0.1/README.md` without duplication here — that
file is the methodology reference. The static checklist replaces only
the stage definitions.

## Leakage prevention

The solving model receives ONLY `llms-full.txt` + the solver prompt from
the case file. It must NOT receive: this README, complete case files,
evaluator-only expectations, evaluator notes, checklist answers,
previous model responses, previous results, diagnoses, corrected
solutions, or aggregate results. Evaluation artifacts are not LSP
documentation and must never become input to `llms.txt` or
`llms-full.txt` (the generator consumes only `docs/**/*.md`).

## Reproducibility

Every execution records: suite version; case ID/version; model provider;
exact model name; execution date; repository commit when available;
`llms-full.txt` SHA-256 and byte size; documentation-context
confirmation; exact solver prompt; original model response; static
checklist outcome per item with supporting fragments; diagnosis.

The exact same solver prompt and exact same `llms-full.txt` bytes are
used across models for each case. Only the model changes.

## Freeze policy

Cases are frozen as TA v1, TB v1, TC v1 once the first real execution
begins. A defective case gets a new version with a documented reason;
v1 history is preserved. Documentation may evolve independently,
enabling comparisons such as "TB v1: corpus v0.3 → FAIL, corpus
v0.4 → PASS" without changing the test.

## Results

No executions yet. This table fills in as runs complete (static checks
only — see the purpose note above):

| Model | TA Naming | TB Product cursor | TC Context vars |
|---|---|---|---|
| — | — | — | — |
