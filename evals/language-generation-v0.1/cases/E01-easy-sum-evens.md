# E01 — Easy — Sum of evens

Suite: `language-generation-v0.1`
Case version: v1
Difficulty: Easy
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Baseline syntactic validity: declare variables, loop, branch, convert a number
for display, and show results. The algorithm is trivial; the challenge is
generating end-to-end valid LSP.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must contain three hardcoded integer values: N = 10, N = 100 and N = 7.

For each value, compute the sum of all even numbers from 1 to N (inclusive).

Declare all variables used. The rule must compile and execute without any modification between the three cases.

Produce exactly one final output using Mensagem(Retorna, ...), containing the three results clearly identified in this format:

Caso 1: Soma pares ate 10: <soma>
Caso 2: Soma pares ate 100: <soma>
Caso 3: Soma pares ate 7: <soma>

The three result sections may appear sequentially in the same message. Line breaks are not required.

Where <soma> is the computed sum for that case.
```

## Evaluator-only expected output

```text
Caso 1: Soma pares ate 10: 30
Caso 2: Soma pares ate 100: 2550
Caso 3: Soma pares ate 7: 12
```

(10 → 2+4+6+8+10 = 30; 100 → 2·(1+…+50) = 2550; 7 → 2+4+6 = 12.)

## Evaluator notes

### Relevant documentation

`docs/language/syntax.md` (termination, blocks), `docs/language/variables.md`
(declarations, naming), `docs/language/control-flow.md` (`Para`, `Se`),
`docs/functions/conversion.md` (`IntParaAlfa`), `docs/functions/numeric-math.md`
(`RestoDivisao`), `docs/guides/limitations.md` (L3/L7).

### Expected/likely LSP mechanisms

Top declarations with `va`/`vn` prefixes; a `Para` loop per case (or one loop
reused); evenness via `RestoDivisao`; `IntParaAlfa` into intermediate `Alfa`
variables before concatenation; one final `Mensagem(Retorna, vaMsg)`.

### Likely failure modes

Direct `Numero` concatenation; conversion call inside `Mensagem` parameters;
mid-block `Definir`; return-value misuse of `RestoDivisao`; invented evenness
helpers.

## Validation procedure

Copy the generated rule unchanged; compile once; execute once; compare the
single final message against the expected output above (modulo trailing
whitespace). Score `Cases correct: N/3` per matching `Caso N:` line.

## Freeze policy

E01 v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
