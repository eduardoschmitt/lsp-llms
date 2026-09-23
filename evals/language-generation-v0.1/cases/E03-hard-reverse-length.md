# E03 — Hard — Word reverse + length

Suite: `language-generation-v0.1`
Case version: v1
Difficulty: Hard
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Meaningful composition with a destructive string API: per-character surgery,
counting, conversion, and repeated inline blocks (helper-function definitions
are undocumented, so logic must be inlined three times). Hard as composition,
not as algorithm or Senior knowledge.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must contain three hardcoded words: LSP, Senior and AB.

For each word, compute:
(a) its length in characters; and
(b) the word spelled backwards.

Declare all variables used.

Do not define helper functions.

The rule must compile and execute without any modification between the three cases.

Produce exactly one final output using Mensagem(Retorna, ...), containing the three results clearly identified in this format:

Caso 1: Original: LSP Tamanho: <n> Invertida: <r>
Caso 2: Original: Senior Tamanho: <n> Invertida: <r>
Caso 3: Original: AB Tamanho: <n> Invertida: <r>

The three result sections may appear sequentially in the same message. Line breaks are not required.

Where <n> is the length and <r> is the reversed word for that case.
```

## Evaluator-only expected output

```text
Caso 1: Original: LSP Tamanho: 3 Invertida: PSL
Caso 2: Original: Senior Tamanho: 6 Invertida: roineS
Caso 3: Original: AB Tamanho: 2 Invertida: BA
```

(Words are accent-free by design to avoid encoding confounds.)

## Evaluator notes

### Relevant documentation

`docs/functions/strings.md` (`TamanhoAlfa`, `CopiarAlfa` in-place semantics,
`+` on `Alfa` only), `docs/language/control-flow.md` (`Para`),
`docs/functions/conversion.md` (`IntParaAlfa`), `docs/guides/limitations.md`
(L3/L7).

### Expected/likely LSP mechanisms

`TamanhoAlfa` into a `Numero`; per-character extraction by copying the word
and applying `CopiarAlfa` (1-based positions) into a fresh copy, prepending
each character to an accumulator; `IntParaAlfa` for the length; one final
prebuilt message.

### Likely failure modes

Assuming `CopiarAlfa` is non-destructive or returns a value; 0-based
positions; `Numero` concatenation; conversion inside `Mensagem` parameters;
mid-block declarations inside the repeated blocks; defining helper functions
despite the prohibition.

## Validation procedure

Copy the generated rule unchanged; compile once; execute once; compare the
single final message against the expected output above (modulo trailing
whitespace). Score `Cases correct: N/3` per matching `Caso N:` line.

## Freeze policy

E03 v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
