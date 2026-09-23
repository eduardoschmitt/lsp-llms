# Evaluations (`evals/`)

This directory exists to answer one practical question:

> Can an LLM, using the generated `llms-full.txt`, produce valid and correct LSP code?

`lsp-llms` uses executable and manual validation to measure whether the
documentation actually helps LLMs generate valid LSP — not to showcase models.

## Suites, not a single benchmark

Different evaluation suites may test different hypotheses (language generation,
generation without documentation context, Senior runtime knowledge, regression
behavior, utility-library usage, and others). Each suite owns its methodology,
cases, and results:

```text
evals/
└── <suite-name>-<version>/
    ├── README.md     # suite methodology (frozen per version)
    ├── cases/        # frozen exercise definitions + evaluator references
    └── results/      # per-model executions (responses are immutable history)
```

## Rules that apply to every suite

- Evaluation artifacts are **not** LSP documentation sources.
- Nothing under `evals/` may enter `llms.txt` or `llms-full.txt`. The generator
  consumes only `docs/**/*.md`, which structurally enforces this separation.
- Generated model responses are preserved verbatim as historical evidence and
  are never silently corrected; corrections live in separate diagnostic records.
- Cases become immutable once real evaluation begins. A defective case is
  versioned (v1, v2, …), never silently rewritten — history is preserved.
- A model failure never automatically triggers a documentation change. Failures
  are diagnosed, classified against the current docs, and only then may motivate
  a docs improvement through the normal project workflow.
