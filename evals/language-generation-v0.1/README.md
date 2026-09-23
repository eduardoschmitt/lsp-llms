# language-generation-v0.1

**Purpose:** evaluate whether an LLM given the current `llms-full.txt` can
generate self-contained, compiling, correctly-executing LSP for small
algorithmic problems.

This is an experiment, not a comprehensive LSP benchmark: 3 exercises ×
3 models = 9 executions total. All models receive documentation context;
there is no no-documentation baseline yet.

## Scope

This suite evaluates knowledge of the **LSP language currently documented by
`lsp-llms`**. It does NOT evaluate Senior ERP development knowledge.

Out of scope: Senior database schemas, ERP tables, customer databases, rule
identifiers, event identifiers, runtime-provided variables, customer-specific
variables, module-specific behavior, production business rules, external
services, undocumented Senior runtime context.

All exercise inputs are hardcoded inside the generated rule. No interactive
input. No database access. A model should be able to solve each exercise
using only `llms-full.txt` + the solver prompt.

## Methodology

```text
solver prompt + llms-full.txt (identical bytes for every model)
→ model response (one execution per exercise per model)
→ preserve the response verbatim under results/<model>/
→ copy the generated LSP rule without modification
→ compile in a real Senior environment, record COMPILE
→ execute if compilation succeeds, record RUNTIME
→ compare the single final output with the expected output, record OUTPUT
→ diagnose failures (fragment / symptom / root cause / correct approach)
→ only then create/document human corrections, if useful, as separate records
```

The first model response is the benchmark result. Never silently correct code
before its result is recorded.

## Evaluation stages

### GENERATION

Did the model provide a complete LSP solution?

### COMPILE

Did the original generated rule compile without human modification?

### RUNTIME

Did the original compiled rule execute without runtime errors?

### OUTPUT

Did the execution produce the expected results?

If an earlier stage fails, downstream stages are `NOT RUN`.

Output accuracy also records:

```text
Cases correct: N/3
```

## Human fixes

```text
Human fixes required: N
```

This is NOT a score. It records how much intervention was necessary after the
original attempt, so that (for example) a trivial signature fix and a full
rewrite remain distinguishable in later analysis.

Each fix uses:

```text
Fix N

Stage: Compile | Runtime | Output

Original fragment:
...

Correction:
...

Reason:
...

Failure category:
...

Documentation coverage:
...
```

## Failure taxonomy

```text
invalid-syntax
invented-api
wrong-signature
wrong-param-direction
wrong-return-behavior
wrong-type-usage
unsupported-construct
wrong-algorithm
wrong-output-format
doc-ambiguity
missing-docs
ignored-guidance
env-issue
other
```

Documentation coverage:

```text
DOC_CLEAR
DOC_WEAK
DOC_MISSING
DOC_CONFLICT
NOT_DOC_RELATED
```

- `DOC_CLEAR`: current documentation already explains the correct behavior
  sufficiently (e.g. the model ignored a clearly documented rule).
- `DOC_WEAK`: documented, but clarity or retrievability may be insufficient
  (consider when several models fail the same concept).
- `DOC_MISSING`: required LSP behavior is absent from the corpus.
- `DOC_CONFLICT`: relevant corpus evidence conflicts.
- `NOT_DOC_RELATED`: algorithmic, model, or environment failure rather than a
  documentation problem.

## Documentation feedback loop

```text
model attempt
→ preserve
→ compile/run
→ diagnose
→ classify documentation coverage
→ decide whether docs need improvement
→ update docs only if justified
→ regenerate llms artifacts (scripts/build_llms.py)
→ rerun later (new executions; history preserved)
```

## Leakage prevention

The solving model receives ONLY `llms-full.txt` + the solver prompt from the
case file. It must NOT receive: this README, complete case files,
evaluator-only expected outputs, evaluator notes, likely failure modes,
previous model responses, previous results, diagnoses, corrected solutions,
or aggregate results.

Evaluation artifacts are not LSP documentation and must never become input to
`llms.txt` or `llms-full.txt` (the generator consumes only `docs/**/*.md`).

## Reproducibility

Every execution records: suite version; exercise ID/version; model provider;
exact model name; execution date; repository commit when available;
`llms-full.txt` SHA-256; `llms-full.txt` byte size; documentation-context
confirmation; exact solver prompt; original model response; compilation result;
compiler error text when applicable; runtime result; actual output; expected
output; cases correct; human fixes; diagnosis.

The exact same solver prompt and exact same `llms-full.txt` bytes are used
across the three models for each exercise. Only the model changes.

## Freeze policy

This suite is `language-generation-v0.1`. Cases are frozen as E01 v1, E02 v1,
E03 v1. Once the first real model execution begins, solver prompts and
expected behavior are immutable. A defective exercise gets a new version with
a documented reason; v1 history is preserved. Documentation may evolve
independently, enabling comparisons such as "E02 v1: corpus v0.1 → FAIL,
corpus v0.2 → PASS" without changing the test.

## Results

| Model                | E01 Easy | E02 Medium     | E03 Hard       | Passed |
| -------------------- | -------- | -------------- | -------------- | ------ |
| Gemini 3.1 Pro (Low) | PASS     | FAIL (Compile) | PASS           | 2/3    |
| Nemotron 3 Ultra Free | PASS    | FAIL (Compile) | FAIL (Compile) | 1/3    |
| Muse Spark 1.3 Free | PASS      | PASS           | PASS           | 3/3    |

Details: `results/gemini-3-1-pro-low/`, `results/nemotron-3-ultra-free/` and
`results/muse-spark-1-3-free/` (prompt provenance, verbatim `.lsp` evidence,
per-exercise stage records). All 9 planned executions are complete; the table
is final for v0.1.

Corpus findings from this round (both preserved as evidence; v0.1 is now
frozen — no reruns, no corrections, no corpus changes on their basis yet):

- Finding #1 — arrays/indexing: two independent models used index 0 and the
  real Senior environment rejected both (`Erro indexando fora dos limites: 0`);
  official Senior article 23581 deepens the issue (see the Gemini E02 record).
- Finding #2 — maximum line length: a single-line message assignment reaching
  column 255 was refused (`linha para o compilador é muito grande`), with the
  evaluator observing the error persists even with the rule commented out.

### Methodological note — prior model-family exposure (recorded, not adjudicated)

Muse Spark 1.3 was also used as the primary coding agent during development
of this documentation corpus. The official evaluation run was performed in an
isolated context using the same supplied evaluation materials as the other
models, and no evidence of cross-session context leakage was observed.
However, prior model-family exposure to the project is recorded as a possible
confounding factor. This limitation is noted without discounting the 3/3
result.
