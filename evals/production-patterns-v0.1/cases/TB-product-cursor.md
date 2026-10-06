# TB — Product cursor

Suite: `production-patterns-v0.1`
Case version: v1
Difficulty: medium (static parameterization check)
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Check whether the model treats `E075PRO.CODPRO` as `Alfa`, passes the
input with a direct `:variable` parameter, avoids unnecessary
`__Inserir`, and follows documented simple-cursor syntax. This is the
regression case for the previously observed failure where generated
code declared the product-code input as `Numero` and wrapped it in
`__Inserir`.

## Solver prompt

```text
Write one LSP rule fragment that looks up the origin of a manufacturing order's product.

The fragment must:

1. Declare a simple Cursor and the variables it needs (all declarations at the top).
2. Query table E075PRO for column CODORI, filtering by company code 1 and by the CODPRO column using an Alfa input variable that holds the product code.
3. Open the cursor, read the origin into an Alfa variable when a record is found, advance and close the cursor following documented simple-cursor syntax.

Keep the SQL faithful to the documented production pattern for this lookup. Do not use __Inserir for the product-code value.
```

## Evaluator-only static checklist

Apply to the response text without modification. Each item is PASS/FAIL
with the supporting verbatim fragment recorded.

1. **`CODPRO` treated as `Alfa`:** the product-code input variable is
   declared `Definir Alfa ...` (preferred prefix `a`, e.g. `aCodPro`)
   or is explicitly identified as a context-provided `Alfa` variable.
   Any `Definir Numero` declaration for the product-code input fails
   this item.
2. **Direct parameter:** the SQL `WHERE` clause references the variable
   directly as `:variable` (e.g. `CODPRO =:aCodPro`); no `__Inserir`
   wraps the product-code value.
3. **No unnecessary `__Inserir`:** `__Inserir`/`__inserir` does not
   appear for any simple value in the fragment. (A dynamic SQL text
   fragment such as an assembled `ORDER BY` would be a legitimate use,
   but this prompt requires none — any occurrence fails this item.)
4. **Documented cursor operations:** `Definir Cursor ...;`,
   `.Sql "..."`, `.AbrirCursor()`, `.Achou`, field read via dot access,
   `.FecharCursor()` — the simple-cursor lifecycle with no
   `SQL_Criar`/`SQL_Definir*`/`SQL_Destruir` mixing and no invented
   cursor calls.
5. **No type guessing:** the response does not claim the field type was
   derived from the column name or from a numeric-looking value.

## Evaluator notes

### Relevant documentation

`docs/database/cursors-sql.md` (production pattern A: E075PRO lookup
with `:aCodPro`; direct-`:variable` vs. `__Inserir` scoping),
`docs/language/variables.md` (preferred `a` prefix; prefixes are not
types), `docs/guides/limitations.md` (L12 declaration placement).

### Likely failure modes

`Definir Numero` for the product code (the frozen regression); `WHERE
CODPRO = __Inserir(:aCodPro)`; complete-cursor calls on a simple cursor;
invented cursor-name-must-match-table claims; `Proximo()` presented as
mandatory for single-row queries.

## Validation procedure

Static inspection only: check each checklist item against the verbatim
response and record PASS/FAIL with fragments. Do NOT compile or execute
in Senior ERP (the table and input come from the production context);
do not claim runtime success. Record `Static: N/5 items passed`.

## Freeze policy

TB v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
