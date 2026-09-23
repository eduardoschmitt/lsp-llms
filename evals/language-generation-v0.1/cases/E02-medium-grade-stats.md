# E02 — Medium — Grade sum and max

Suite: `language-generation-v0.1`
Case version: v1
Difficulty: Medium
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Combine multi-value handling, aggregation (sum), comparison (max), branching,
conversion, and display in one rule — small reasoning, manually inspectable.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must contain three hardcoded groups of five integer grades each:

Group 1: 70, 85, 90, 60, 65
Group 2: 100, 100, 95, 88, 92
Group 3: 0, 15, 7, 22, 9

For each group, compute the sum of the five grades and the maximum of the five grades.

Declare all variables used. The rule must compile and execute without any modification between the three cases.

Produce exactly one final output using Mensagem(Retorna, ...), containing the three results clearly identified in this format:

Caso 1: Turma 1 - Soma: <soma> Max: <maximo>
Caso 2: Turma 2 - Soma: <soma> Max: <maximo>
Caso 3: Turma 3 - Soma: <soma> Max: <maximo>

The three result sections may appear sequentially in the same message. Line breaks are not required.

Where <soma> and <maximo> are the computed values for that group.
```

## Evaluator-only expected output

```text
Caso 1: Turma 1 - Soma: 370 Max: 90
Caso 2: Turma 2 - Soma: 475 Max: 100
Caso 3: Turma 3 - Soma: 53 Max: 22
```

## Evaluator notes

### Relevant documentation

`docs/language/arrays.md` (only if the model chooses arrays),
`docs/language/control-flow.md`, `docs/functions/conversion.md`,
`docs/guides/limitations.md` (L3/L7).

### Expected/likely LSP mechanisms

Do NOT require a specific implementation strategy. Valid solutions may use
scalar variables, documented arrays, or another documented valid LSP
mechanism. Correct observable behavior is what matters; record the chosen
strategy as diagnostic context, not score. If arrays are used, the documented
arrays-section pattern applies (0-based demonstrated use; the `Alfa[N]`
conflict is unrelated to `Numero` collections but index-base deviations are
prime diagnostics).

### Likely failure modes

1-based indexing where 0-based was used; undeclared loop counters; direct
`Numero` concatenation; conversion inside `Mensagem` parameters; overbuilt
`Lista` machinery (valid if correct, but a smell for misreading the problem).

## Validation procedure

Copy the generated rule unchanged; compile once; execute once; compare the
single final message against the expected output above (modulo trailing
whitespace). Score `Cases correct: N/3` per matching `Caso N:` line.

## Freeze policy

E02 v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
