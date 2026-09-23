# B01 — JSON composition

Suite: `backend-generation-v0.1`
Case version: v1
Difficulty: backend composition (multiple JSON operations in one rule)
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Test whether the model can compose several documented JSON capabilities in
one rule: read nested single fields, load an array group into a rule-list
structure, walk it, read per-record fields, and combine everything into one
observable result — rather than calling a single function.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must contain this hardcoded JSON text (keep it exactly as shown, including all punctuation):

{"empresa": {"nome": "Tech", "cidade": "SP"}, "itens": [{"cod": "A1", "qtd": 2}, {"cod": "B2", "qtd": 5}]}

The rule must, in one execution:

1. Read the company's name and city out of the nested "empresa" group.
2. Load the array under the "itens" group so that each object can be processed as a record with its "cod" and "qtd" fields.
3. Read the "cod" and "qtd" of the first record.
4. Read the "cod" and "qtd" of the second record.

Declare all variables used. The rule must compile and execute without any modification.

Produce exactly one final output using Mensagem(Retorna, ...), containing all results clearly identified, in this format:

JSON Empresa: <nome> (<cidade>) Item1: <cod1> x<qtd1> Item2: <cod2> x<qtd2>

where <nome>, <cidade>, <cod1>, <qtd1>, <cod2> and <qtd2> are the values read from the JSON above.
```

## Evaluator-only expected behavior

```text
JSON Empresa: Tech (SP) Item1: A1 x2 Item2: B2 x5
```

## Evaluator notes

### Relevant documentation

`docs/data/json.md` (single-field reads with `";"` groups; rule-list loading
with create-first lifecycle, wrap requirement, `"S"`/`"N"` navigation;
first-occurrence array behavior), `docs/language/collections.md`
(rule-list core API), `docs/functions/strings.md` (only if manual fallback —
not expected), `docs/guides/limitations.md` (L3).

### Expected/likely LSP mechanisms

`ValorElementoJson` with `"empresa"` group for name/city;
`ListaRegraCriarLista` + `ListaRegraCarregarJson` with group `"itens"` and
fields `"cod;qtd"`; `ListaRegraPrimeiro`/`ListaRegraProximo` with `"S"`/`"N"`
checks; `ListaRegraObterValorAlfa` per field; one prebuilt message variable.
Numeric `qtd` values retrieved as `Alfa` text (demonstrated pattern).

### Likely failure modes

Dot-notation or indexed paths (`itens[0]` — explicitly rejected);
`ListaRegraCarregarJson` without prior create; missing-field errors from a
wrong fields string; invented JSON getters/builders; conversion calls inside
`Mensagem` parameters; treating the array as an LSP array.

## Validation procedure

Copy the generated rule unchanged; compile once; execute once; compare the
single final message against the expected behavior above (modulo trailing
whitespace). Any deviation in field values fails the run; record which part
(name/city/item1/item2) diverged.

## Freeze policy

B01 v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
