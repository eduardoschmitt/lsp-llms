# TC — Existing context variables

Suite: `production-patterns-v0.1`
Case version: v1
Difficulty: medium (static context-variable check)
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Check whether the model preserves execution-context variable names,
avoids unnecessary redeclarations, and uses direct SQL parameters when
adapting a cursor that depends on its surrounding Senior environment.

## Solver prompt

```text
Write one LSP rule fragment for a report that reads the closing stock date of a branch.

The execution context already provides two identifiers: VSCodEmp (company) and VSFilDep (branch). They must be used exactly as provided: do not redeclare them and do not rename them.

The fragment must:

1. Declare a simple Cursor and a Data variable for the result (declarations at the top, not counting the two context identifiers which must NOT be declared).
2. Query table E070FIL for column ESTPDI, filtering by company and branch using the context identifiers as direct SQL parameters.
3. Open the cursor, read the value into the Data variable, and close the cursor following documented simple-cursor syntax.

Keep the SQL faithful to the documented production pattern for this lookup. Do not use __Inserir for the company or branch values.
```

## Evaluator-only static checklist

Apply to the response text without modification. Each item is PASS/FAIL
with the supporting verbatim fragment recorded.

1. **Names preserved:** `:VSCodEmp` and `:VSFilDep` appear in the SQL
   with exactly these spellings (case variations acceptable only as
   documented case-insensitivity allows; any rename such as
   `:vnCodEmp` fails this item).
2. **No redeclaration:** neither `VSCodEmp` nor `VSFilDep` is the target
   of a `Definir` declaration. Declaring either fails this item.
3. **Direct parameters:** both values are passed as direct `:variable`
   references; no `__Inserir` wraps either of them.
4. **Documented cursor operations:** `Definir Cursor ...;`,
   `.Sql "..."`, `.AbrirCursor()`, value read via dot access,
   `.FecharCursor()` — the simple-cursor lifecycle with no
   complete-cursor call mixing and no invented calls.
5. **Result handling:** the `ESTPDI` value is read into the declared
   `Data` variable; the response does not invent a field type for any
   other column.

## Evaluator notes

### Relevant documentation

`docs/database/cursors-sql.md` (production pattern B: E070FIL lookup
with `:VSCodEmp` / `:VSFilDep`; context-variable rules),
`docs/language/variables.md` (declaration placement),
`docs/guides/limitations.md` (L12).

### Likely failure modes

Redeclaring the context identifiers; renaming them to `va`/`vn`-style
locals; wrapping them in `__Inserir`; complete-cursor calls on a simple
cursor; inventing surrounding rule scaffolding that redefines the
context.

## Validation procedure

Static inspection only: check each checklist item against the verbatim
response and record PASS/FAIL with fragments. Do NOT compile or execute
in Senior ERP (context identifiers exist only in the Senior
environment); do not claim runtime success. Record
`Static: N/5 items passed`.

## Freeze policy

TC v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
