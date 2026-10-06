# TA — Naming conventions

Suite: `production-patterns-v0.1`
Case version: v1
Difficulty: easy (static naming check)
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Check whether the model generates new LSP variables with the preferred
production prefixes (`a`, `n`, `d`), preserves existing identifiers when
extending legacy code, and does not treat prefixes as mandatory syntax.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule starts from this existing legacy fragment, which you must keep unchanged (do not rename any of its identifiers):

Definir Alfa vaNome;
Definir Numero vnIdade;
vaNome = "Teste";
vnIdade = 30;

Extend the rule as follows, declaring every new variable at the top of the rule alongside the existing declarations:

1. Add one new Alfa variable holding a product code, one new Numero variable holding a quantity, and one new Data variable holding a reference date built with MontaData.
2. Build a short summary text combining the product code and quantity (convert the number before concatenating), and show it with Mensagem(Retorna, ...).

Declare all variables used. Use the project's preferred naming prefixes for the new variables.
```

## Evaluator-only static checklist

Apply to the response text without modification. Each item is PASS/FAIL
with the supporting verbatim fragment recorded.

1. **Preferred prefixes for new code:** the new Alfa, Numero, and Data
   variables use the `a`, `n`, and `d` prefixes respectively.
   Expected shape (names may vary, prefixes must not):
   `Definir Alfa a...;`, `Definir Numero n...;`, `Definir Data d...;`.
2. **Legacy identifiers preserved:** `vaNome` and `vnIdade` appear
   unchanged; no rename of either identifier to another convention.
3. **No syntax claim:** the response does not state or imply that a
   prefix is required by the LSP compiler (e.g. no "must use `a` or the
   code will not compile"). A wrong-prefix variable presented as a
   convention violation is acceptable; presented as a compiler error
   fails this item.
4. **Declarations valid:** every variable used is declared with
   `Definir <Tipo> <Nome>;` at the top of the rule; the `Data` variable
   is assigned via `MontaData` (or `DatSis`); the number is converted
   (e.g. `IntParaAlfa`) before concatenation; `Mensagem` receives a
   plain variable or literal, not an inline concatenation.

## Evaluator notes

### Relevant documentation

`docs/language/variables.md` (production `a` / `n` / `d` guidance as
project guidance; `va` / `vn` / `vd` as community convention;
declaration placement; `MontaData` assignment rule),
`docs/guides/limitations.md` (L3, L7).

### Likely failure modes

New variables using `va`/`vn`/`vd` instead of the preferred prefixes
(weak fail of item 1 only — still valid LSP); renaming legacy
identifiers; claiming prefixes are compiler-enforced; mid-block
`Definir`; direct `Numero` concatenation.

## Validation procedure

Static inspection only: check each checklist item against the verbatim
response and record PASS/FAIL with fragments. Do NOT compile or execute
in Senior ERP; do not claim runtime success. Record
`Static: N/4 items passed`.

## Freeze policy

TA v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
