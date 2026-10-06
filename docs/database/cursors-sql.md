# LSP database, cursors, and SQL

Scope: the two cursor mechanisms (simple `Cursor` vs. complete `SQL_*`), cursor lifecycle, SQL text and placeholders, parameter binding, returned columns, navigation, direct-execution functions, transactions, and SQL Senior 2 mode. SQL dialect behavior itself is not taught here: table/column names and query text are preserved verbatim as the LSP-to-database interface.

> Critical guidance for AI consumers: simple cursors and complete cursors are different mechanisms — never mix their call forms (`SQL_Criar` + `SQL_AbrirCursor` is one pair; `Definir Cursor` + `.AbrirCursor()` is the other). Cursor handles are `Alfa` variables. Always close, and for complete cursors always destroy. Never invent `SQL_*` helpers, type mappings, or transaction semantics.

## Two mechanisms — do not mix

| | Simple cursor | Complete cursor |
|---|---|---|
| Declaration | `Definir Cursor Cur_X;` | `Definir Alfa vaX;` + `SQL_Criar(vaX)` |
| Command | `Cur_X.SQL "…"` | `SQL_DefinirComando(vaX, …)` |
| Open / close | `Cur_X.AbrirCursor()` / `.FecharCursor()` | `SQL_AbrirCursor(vaX)` / `SQL_FecharCursor(vaX)` |
| Loop | `Cur_X.Achou` / `.Proximo()` | `SQL_EOF(vaX)` / `SQL_Proximo(vaX)` |
| Cleanup | close only | `SQL_FecharCursor` + `SQL_Destruir` (always at the end) |

Stated rule: `SQL_Criar` + `SQL_AbrirCursor` is the correct complete-cursor pair. Using `.AbrirCursor` on an `SQL_Criar` handle, or `SQL_*` on a `Definir Cursor`, is wrong. Stated trade-offs: simple fits quick simple queries with fewer functions but less flexibility (no multiple parameters or advanced types, some SQL functions unavailable); complete supports complex multi-parameter work and both SQL dialects at the cost of more calls, with network/database-dependent performance.

## Simple cursor

Declaration with `Definir` plus the `Cursor` type; SQL attached as a property string; opened, looped over a found-property, advanced by method, closed (source-faithful):

```lsp
Definir Cursor curExemplo;
curExemplo.SQL "SELECT * FROM Tabela";
curExemplo.AbrirCursor();

Enquanto (curExemplo.Achou) {
  Mensagem(Retorna, curExemplo.Campo);
  curExemplo.Proximo();
}

curExemplo.FecharCursor();
```

So: `Achou` is read as a property in the loop condition and `Proximo()` as a method call — both attached to the cursor with dot syntax. Field reads use the same dot form (`curExemplo.Campo`), matching the `Lista` field-access shape documented in `collections.md` (name overlap only, not shared semantics). No destruction call exists for this mechanism.

### Simple-cursor parameters: direct `:variable` for values, `__Inserir` for dynamic fragments

Classification: **Project guidance** backed by **production excerpts** below and **source corroboration**. An earlier revision of this file presented `__inserir(:var)` as the parameter form; that framing was incorrect guidance and is corrected here. The source-faithful `__inserir` example underneath is preserved exactly as found, with its role clarified.

- Prefer direct `:variable` references inside the `.SQL` string for ordinary values (company codes, branch codes, product codes, dates, context-provided identifiers). This is the normal parameter form for simple cursors.
- Do NOT wrap simple values in `__Inserir(...)`. In particular, do not generate `WHERE CODPRO = __Inserir(:aCodPro)` when `:aCodPro` alone is the verified production pattern.
- Reserve `__Inserir(:var)` for dynamic SQL fragments: pieces of SQL text assembled at runtime, such as `ORDER BY` clauses or abrangencia (user-coverage) restriction strings. Source corroboration: the community source's `R038HSA` report example binds ordinary filters directly (`WHERE NUMEMP = :xnumemp AND TIPCOL = :xtipcol AND NUMCAD = :xnumcad`) while inserting only the assembled coverage fragment with `__Inserir(:xAbrMot)`; likewise its `R034FUN` example inserts an `ORDER BY` fragment (`__inserir(:vaOrderBy)` where `vaOrderBy = "ORDER BY CODFIL"`).
- `__Inserir` is therefore legitimate and documented — it is not universally invalid. The correction is about scope: values go through `:variable`; SQL text fragments go through `__Inserir(:var)`.

Source-faithful `__inserir` example (preserved exactly as found; annotation added):

```lsp
Definir Cursor C;
Definir Numero vnCodEmp;
Definir Numero vnCodFil;
Definir Alfa vaOrderBy;

vnCodEmp = 1;
vnCodFil = 6;
vaOrderBy = "ORDER BY CODFIL";

C.SQL "SELECT NumEmp, TipCol, NumCad, NomFun, ValSal FROM R034FUN WHERE CodEmp = __inserir(:vnCodEmp) and CodFil = __inserir(:vnCodFil) __inserir(:vaOrderBy)";

C.AbrirCursor();
se (C.Achou) {
  // ...existing code...
}
C.FecharCursor();
```

Reading note: this source example wraps even plain values (`__inserir(:vnCodEmp)`, `__inserir(:vnCodFil)`) and is presented-as-documented, not as the preferred production pattern — prefer `:vnCodEmp` / `:vnCodFil` for such values. Only the trailing `__inserir(:vaOrderBy)` (a dynamic `ORDER BY` fragment) matches the legitimate dynamic-SQL use. The `// ...existing code...` line is preserved exactly as found; `//` is not a documented LSP comment form (only `@ ... @` and `/* ... */` are) and reads as an editorial placeholder, not LSP evidence.

### Production pattern A — product lookup by `CODPRO` (production excerpt)

The following is a real production excerpt provided by the project maintainer, reproduced with only the explanatory comment translated. It is not a standalone program: it has no rule wrapper and its input comes from the surrounding production rule.

```lsp
@ Get the OP origin through the Product Code @
Definir Cursor Cur_E075DER;
Definir Alfa aCodOri;

Cur_E075DER.Sql "SELECT CODORI FROM E075PRO WHERE CODEMP = 1 AND CODPRO =:aCodPro";
Cur_E075DER.AbrirCursor();
Se (Cur_E075DER.Achou) {
  aCodOri = Cur_E075DER.CodOri;
  Cur_E075DER.Proximo();
}
Cur_E075DER.FecharCursor();
```

Production-reported facts (maintainer-provided; not community-source claims):

- `E075PRO.CODPRO` is an `Alfa` field in Senior ERP. Previously generated code declared the input as `Numero`; that was wrong and must not be repeated.
- `aCodPro` is an `Alfa` variable supplied by the surrounding production rule; it is not declared in this excerpt.
- The cursor passes it directly as `:aCodPro`. No `__Inserir` is used.
- `Se (Cur_E075DER.Achou)` reads the `Achou` property in a condition, matching the documented simple-cursor shape (`Enquanto (curExemplo.Achou)` above).

Do not infer beyond the excerpt:

- Do not invent a `Numero` declaration for `aCodPro`. When a self-contained educational example is needed, declare it explicitly as `Alfa` with a string value and mark the example as adapted rather than production-verbatim.
- Do not rename `Cur_E075DER` merely because it queries `E075PRO`; cursor names need not match table names.
- Do not treat `Proximo()` after a single-row read as a mandatory pattern for every single-row query.
- Do not generalize "`CODPRO` is `Alfa`" to other tables or fields. Never infer a field's type from its name or from numeric-looking values.

Self-contained adapted form (project guidance; adapted, not production-verbatim):

```lsp
Definir Cursor Cur_E075DER;
Definir Alfa aCodPro;
Definir Alfa aCodOri;

aCodPro = "EXAMPLE-PRODUCT";
Cur_E075DER.Sql "SELECT CODORI FROM E075PRO WHERE CODEMP = 1 AND CODPRO =:aCodPro";
Cur_E075DER.AbrirCursor();
Se (Cur_E075DER.Achou) {
  aCodOri = Cur_E075DER.CodOri;
  Cur_E075DER.Proximo();
}
Cur_E075DER.FecharCursor();
```

### Production pattern B — context-provided company/branch variables and date handling (production excerpt)

Another real production excerpt from the same source. It is not a complete, independently executable program: some declarations belong to other parts of the original production rule.

```lsp
Definir Data dDataAnterior;
Definir Data dDataS17;

Definir Cursor Cur_E070FIL;
Definir Cursor Cur_E210MVP;
Definir Cursor Cur_PrecoMedioS9;

@ Assign to dDataAnterior the 1st day of the month before closing @
Cur_E070FIL.Sql "SELECT ESTPDI FROM E070FIL WHERE CODEMP=:VSCodEmp AND CODFIL=:VSFilDep";
Cur_E070FIL.AbrirCursor();
dDataAnterior = Cur_E070FIL.EstPdi;
Cur_E070FIL.FecharCursor();

DesmontaData(dDataAnterior,dia,mes,ano);
mes = mes - 1;

Se (mes = 0) {
  mes = 12;
  ano = ano - 1;
}

MontaData(1, mes, ano, dDataAnterior);
```

Production-reported facts:

- `:VSCodEmp` and `:VSFilDep` are identifiers supplied by the surrounding execution context (rule/report environment). They are used directly as `:variable` parameters — no `__Inserir`, no redeclaration, no renaming. Preserve context-provided names exactly.
- The excerpt demonstrates ordinary cursor value reads (`dDataAnterior = Cur_E070FIL.EstPdi;`) and date decomposition/reconstruction around the query. `MontaData` / `DesMontaData` signatures are documented in `../functions/dates-time.md`.
- Spelling note: `DesmontaData` here vs `DesMontaData` in the community source. LSP identifiers are documented as case-insensitive (`../language/syntax.md`), so this is a spelling variant of the same function, not a different function.
- `dia`, `mes`, and `ano` have no declarations in the excerpt; they come from the surrounding rule. In self-contained code, declare them at the top (e.g. `Definir Numero` for each) per the declaration-placement rule in `../language/variables.md`.
- Unused declarations in the excerpt (`dDataS17`, `Cur_E210MVP`, `Cur_PrecoMedioS9`) belong to other parts of the original production rule. Do not assume every declaration in a production excerpt is used by the visible fragment.

Generation rules from these patterns (project guidance):

1. Prefer `:variable` for ordinary cursor SQL parameters.
2. Avoid unnecessary `__Inserir` for simple values; keep `__Inserir` for dynamic SQL construction where the source documents it.
3. Recognize variables supplied by the execution context; preserve their names and avoid unnecessary redeclarations.
4. Respect actual Senior ERP database field types when verified by production evidence.
5. Never guess field types based on names or numeric-looking values.
6. Keep SQL examples faithful to verified production patterns rather than plausible reconstructions.

## Complete cursor lifecycle

Mandatory order as documented (translated prose, calls verbatim):

1. `Definir Alfa xCursor;` — the parameter of `SQL_Criar` must be a `Definir Alfa` variable (the cursor handle). Not `Numero`, `Data`, or `Lista`.
2. `SQL_Criar(xCursor);`
3. For native SQL / `JOIN` / subquery: `SQL_UsarAbrangencia(xCursor, 0)` + `SQL_UsarSQLSenior2(xCursor, 0)` — required in those cases, otherwise omittable (the cursor default is SQL Senior 2).
4. `SQL_DefinirComando(xCursor, …);` — only after step 3 when step 3 applies.
5. Binds (`SQL_DefinirAlfa` / `SQL_DefinirInteiro` / …) wherever `:param` appears.
6. `SQL_AbrirCursor(xCursor);` — opens the transaction/connection and executes the defined command.
7. Read / loop (`SQL_EOF`, `SQL_Retornar*`, `SQL_Proximo`).
8. `SQL_FecharCursor(xCursor);` + `SQL_Destruir(xCursor);` — always at the end (avoids leaks / stuck transactions).

Canonical full pattern (source-faithful; banner comments translated, code unchanged):

```lsp
Definir Funcao exemploCursorCompleto();

@ Global variables @
Definir Alfa xCursor;
Definir Alfa vaSQL;
Definir Alfa vaNomeCliente;
Definir Numero vnCodigoCliente;
Definir Numero vnValorTotal;
Definir Data vdDataCadastro;
Definir Numero vnContador;

exemploCursorCompleto();

Funcao exemploCursorCompleto(); {
  vnContador = 0;

  @ ===== 1. SQL PREPARATION ===== @
  vaSQL = "SELECT NOME_CLIENTE, CODIGO_CLIENTE, VALOR_TOTAL, DATA_CADASTRO \
             FROM CLIENTES                                                 \
            WHERE STATUS = 'A'                                             \
            ORDER BY NOME_CLIENTE";

  @ ===== 2. CURSOR CREATION AND CONFIGURATION ===== @
  SQL_Criar(xCursor);
  SQL_UsarAbrangencia(xCursor, 0);          @ 0 = No abrangência (required with native SQL) @
  SQL_UsarSQLSenior2(xCursor, 0);           @ 0 = Native SQL, non-zero = SQL Senior 2; always before DefinirComando @
  SQL_DefinirComando(xCursor, vaSQL);

  @ ===== 3. CURSOR OPENING AND EXECUTION ===== @
  SQL_AbrirCursor(xCursor);

  @ ===== 4. ITERATING OVER RESULTS ===== @
  Enquanto (SQL_EOF(xCursor) = 0) {
    @ Extract current-record data @
    SQL_RetornarAlfa(xCursor, "NOME_CLIENTE", vaNomeCliente);
    SQL_RetornarInteiro(xCursor, "CODIGO_CLIENTE", vnCodigoCliente);
    SQL_RetornarFlutuante(xCursor, "VALOR_TOTAL", vnValorTotal);
    SQL_RetornarData(xCursor, "DATA_CADASTRO", vdDataCadastro);

    @ Process data (example) @
    vnContador++;

    @ Advance to the next record @
    SQL_Proximo(xCursor);
  }

  @ ===== 5. FINALIZATION AND CLEANUP ===== @
  SQL_FecharCursor(xCursor);
  SQL_Destruir(xCursor);

  @ ===== 6. FINAL RESULT ===== @
  Definir Alfa vaMensagem;
  Definir Alfa vaContadorStr;
  IntParaAlfa(vnContador, vaContadorStr);
  vaMensagem = "Processados " + vaContadorStr + " clientes";
  Mensagem(Retorna, vaMensagem);
}
```

Stated warnings: always close and destroy after use; for INNER JOIN / subquery / native SQL the abrangência+Senior2 pair is required before the command; cursors from `SQL_Criar` do not inherit any rule-global Senior-2 flag — only `SQL_UsarSQLSenior2` counts; with native SQL and abrangência enabled the runtime stops with an abrangência error. For aggregates (`COUNT`, `SUM`, …) use a SELECT alias and the same name in `SQL_Retornar*` (e.g. `COUNT(*) AS conta` with `SQL_RetornarInteiro(xCursor, "conta", vnConta)`). A runtime note adds that an `UPDATE`/`DELETE` via cursor affecting zero rows may make Sapiens show a message and cancel the rule — not a static diagnostic.

DML through cursors is demonstrated (source-faithful INSERT):

```lsp
Definir Alfa xCursor;
Definir Alfa xBlob;

SQL_Criar(xCursor);

@ Inserts a new record into the intervals table. @
SQL_DefinirComando(xCursor, "INSERT INTO R006INT VALUES (9999, 'Exemplo de intervalo')");
SQL_AbrirCursor(xCursor);

/* All database operations happen between abrirCursor and fecharCursor. */

SQL_FecharCursor(xCursor);
SQL_Destruir(xCursor);
```

## SQL text, placeholders, and binds

SQL is built in an `Alfa` variable first (with `\` line continuation), then handed to `SQL_DefinirComando`. Security rule as stated: NEVER concatenate variables directly into SQL strings; ALWAYS use `:variable` parameter placeholders (injection safety, performance, maintainability, Senior recommendation).

Intentionally invalid form (source-faithful):

```lsp
@ Dangerous - vulnerable to SQL Injection @
Definir Alfa vaSQL;
Definir Numero vnCodigoCliente;
Definir Alfa vaNomeCliente;

vnCodigoCliente = 123;
vaNomeCliente = "João Silva";

@ DIRECT CONCATENATION - NEVER USE! @
vaSQL = "SELECT * FROM CLIENTES WHERE CODIGO = " + vnCodigoCliente + " AND NOME = '" + vaNomeCliente + "'";
```

Documented form (source-faithful):

```lsp
@ Safe - using placeholders @
Definir Alfa vaSQL;
Definir Numero vnCodigoCliente;
Definir Alfa vaNomeCliente;

vnCodigoCliente = 123;
vaNomeCliente = "João Silva";

@ PLACEHOLDERS - ALWAYS USE! @
vaSQL = "SELECT * FROM CLIENTES WHERE CODIGO = :vnCodigoCliente AND NOME = :vaNomeCliente";

@ Configure parameters on the cursor @
SQL_DefinirInteiro(xCursor, "vnCodigoCliente", vnCodigoCliente);
SQL_DefinirAlfa(xCursor, "vaNomeCliente", vaNomeCliente);
```

Placeholder convention: the same variable name preceded by `:` (`:vnCodigoEmpresa` for `vnCodigoEmpresa`); the `SQL_Definir*` call names it without the colon. Multi-line placeholder query (source-faithful excerpt):

```lsp
vaSQL = "SELECT CODIGO, NOME, STATUS, DATA_CADASTRO \
           FROM CLIENTES                            \
          WHERE CODIGO = :vnCodigoCliente           \
            AND STATUS = :vaStatusCliente           \
            AND DATA_CADASTRO BETWEEN :vdDataInicio AND :vdDataFim \
          ORDER BY NOME";
```

Bind functions (all `Bind(cursor, "name", value)` shape; directions: cursor input, name input, value input):

- `SQL_DefinirAlfa`, `SQL_DefinirInteiro`, `SQL_DefinirData` — demonstrated with calls (including a literal value: `SQL_DefinirInteiro(xCursor, "xNumero", 123);`).
- `SQL_DefinirBlob` — demonstrated once: `SQL_DefinirBlob(xCursor, "xBlob", xBlob);` for a file read in binary. A `:BLOB(vaBlob)` placeholder spelling is demonstrated inside an `ExecSQLEx` INSERT string.
- `SQL_DefinirFlutuante`, `SQL_DefinirBoleano` — listed in the function table only (float like 1,5; boolean 1/0); no demonstrated calls. Signature shapes unconfirmed beyond the table.

The `:` marks substitution before execution and avoids `Alfa` conversion for concatenation (source's stated rationale). No injection-protection, escaping, or prepared-statement mechanics beyond this are documented.

Dynamic-SQL conflict (preserved): the `ExecSQL`/`ExecSQLEx` examples below build statements by concatenation throughout, while this section forbids it. Both are presented-as-documented; the contradiction is not resolved. Do not add injection advice of your own.

## Returned columns

One function per data type; each fills a plain variable (source quick reference):

| Function | Column kind | Shape |
|---|---|---|
| `SQL_RetornarAlfa` | text/string | `SQL_RetornarAlfa(cursor, "CAMPO", variavel)` |
| `SQL_RetornarInteiro` | whole number | `SQL_RetornarInteiro(cursor, "CAMPO", variavel)` |
| `SQL_RetornarFlutuante` | decimal number | `SQL_RetornarFlutuante(cursor, "CAMPO", variavel)` |
| `SQL_RetornarData` | date | `SQL_RetornarData(cursor, "CAMPO", variavel)` |
| `SQL_RetornarBoleano` | boolean (1/0) | `SQL_RetornarBoleano(cursor, "CAMPO", variavel)` |
| `SQL_RetornarBlob` | binary/file | `SQL_RetornarBlob(cursor, "CAMPO", variavel)` |
| `SQL_RetornarSeNulo` | NULL check | `resultado = SQL_RetornarSeNulo(cursor, "CAMPO")` (direct return) |

Typed-destination demo (source-faithful excerpt):

```lsp
@ 1. SQL_RetornarAlfa - For text fields @
SQL_RetornarAlfa(xCursor, "NOMFUN", vaNomeFuncionario);

@ 2. SQL_RetornarInteiro - For whole-number fields @
SQL_RetornarInteiro(xCursor, "CODFIL", vnCodigoFilial);

@ 3. SQL_RetornarData - For date fields @
SQL_RetornarData(xCursor, "DATNAS", vdDataNascimento);

@ 4. SQL_RetornarFlutuante - For decimal-number fields @
SQL_RetornarFlutuante(xCursor, "VALSALARIO", vnSalario);

@ 5. SQL_RetornarBoleano - For boolean fields (1/0) @
SQL_RetornarBoleano(xCursor, "DEFFIS", vnDeficienteFisico);
```

Stated type notes: `Inteiro` on `5.45` yields only `5`; `Flutuante` yields `5.45`; Double columns obligatorily need `Flutuante`. `Boleano` is 1/0. `SeNulo` returns 1 for NULL and 0 otherwise — detecting neither `""` nor `0` — for pre-processing validation. Each type needs its specific function (mandatory; the sequence cannot be simplified, though conditional retrieval is the documented optimization).

Parameter-variable restriction: never pass `p`-prefixed function parameters directly to `SQL_Retornar*` — Senior returns nothing into them; use locals then assign (full pair in `../guides/limitations.md` L6). The same intermediate-variable rule covers Grid/Table fields. No automatic type conversion is documented.

## Navigation: BOF, EOF, Proximo

`SQL_BOF(Alfa Objeto);` and `SQL_EOF(Alfa Objeto);` return directly: 1 when at BOF (before first) / EOF (after last), 0 otherwise. At either position all records read null. Guard example (source-faithful):

```lsp
Definir Alfa xCursor;
Definir Numero xFormula;

xFormula = 0;
SQL_Criar(xCursor);
SQL_DefinirComando(xCursor, "SELECT R034FUN.CODFIL FROM R034FUN WHERE R034FUN.CODFIL = 1 AND R034FUN.NUMEMP = 1");

@ Test protecting the counter @
@ If not at BOF (initial position), process normally @
Se (SQL_BOF(xCursor) = 0) {
  SQL_Proximo(xCursor);
  xFormula++;
}

SQL_FecharCursor(xCursor);
SQL_Destruir(xCursor);
```

Canonical EOF loop (source-faithful):

```lsp
Definir Alfa xCursor;
Definir Numero xFormula;

xFormula = 0;
SQL_Criar(xCursor);
SQL_DefinirComando(xCursor, "SELECT R034FUN.CODFIL FROM R034FUN WHERE R034FUN.CODFIL = 1 AND R034FUN.NUMEMP = 1");
SQL_AbrirCursor(xCursor);

@ Loop until the end of the records @
Enquanto (SQL_EOF(xCursor) = 0) {
  SQL_Proximo(xCursor);
  xFormula++;
}

SQL_FecharCursor(xCursor);
SQL_Destruir(xCursor);
```

`SQL_Proximo` advances the cursor; no dedicated signature block exists — its form is established by consistent usage (`SQL_Proximo(xCursor);`). Calls in conditions (`Enquanto (SQL_EOF(xCursor) = 0)`, `Se (SQL_RetornarSeNulo(xCursor, "NOMFUN") = 0)`, `Se (SQL_BOF(xCursor) = 0)`) extend the conditions conflict family — linked to limitations L4, not resolved. There is no `SQL_Achou` anywhere in the source (zero occurrences); the simple cursor's `Achou` property is a different mechanism — never conflate them.

## SelecaoTabelas

Purpose: run a more elaborate SELECT (aggregates like `COUNT()`/`SUM()`, `GROUP BY`, `UNION`) with all data collapsed into one `Alfa` variable.

Signature (source-faithful):

```lsp
SelecaoTabelas(<pSqlSel>, <pCpoRet>, <pTemMas>);
```

Parameters:

- `pSqlSel` — input. SELECT instruction, or `"+"` to fetch the next record.
- `pCpoRet` — output. Result data (`;`-separated for multiple fields).
- `pTemMas` — output. Returns `'+'` when the command yields more than one row.

Stated notes: the SQL start is fixed at SELECT (damage prevention); everything converts to a single `Alfa`; navigate rows by passing `"+"`.

Example (source-faithful excerpt):

```lsp
@ === EXEMPLO 1: CONTAGEM POR ESTADO === @
vaSQL = "SIGUFS, COUNT(*) FROM E085CLI GROUP BY SIGUFS";
SelecaoTabelas(vaSQL, vaRetorno, vaMais);

vnContador = 1;
Enquanto (vaMais = "+") {
  @ Process the current record @
  Definir Alfa vaMensagem;
  Definir Alfa vaContadorStr;
  IntParaAlfa(vnContador, vaContadorStr);
  vaMensagem = "Registro " + vaContadorStr + ": " + vaRetorno;
  Mensagem(Retorna, vaMensagem);

  @ Fetch the next record @
  SelecaoTabelas("+", vaRetorno, vaMais);
  vnContador++;
}
```

Result shape demonstrated: `"1500.50;25"` (sum;count), split by the caller with string functions. No cursor handle, no per-type returns, no transaction role documented.

## ExecSQL and ExecSQLEx

`ExecSQL(<ComandoSQL>);` executes INSERT/UPDATE/DELETE with a single `Alfa` command and no status output. `ExecSQLEx(<ComandoSQL>, <Sucesso>, <Mensagem>);` adds error control: `Sucesso` numeric returns 0 for success, 1 for error; `Mensagem` Alfa returns the error message. Preference rule as stated: always use `ExecSQLEx` for INSERT/UPDATE (Senior recommendation; error control, message, transaction handling).

INSERT via `ExecSQL` (source-faithful):

```lsp
Definir Funcao exemploExecSQLInsert();

@ Global variables @
Definir Alfa vaSQL;
Definir Numero vnCodEmp;
Definir Alfa vaNomEmp;

exemploExecSQLInsert();

Funcao exemploExecSQLInsert(); {
  @ Define the insertion data @
  vnCodEmp = 999;
  vaNomEmp = "EMPRESA TESTE LTDA";

  @ Build the SQL command @
  Definir Alfa vaCodEmpStr;
  IntParaAlfa(vnCodEmp, vaCodEmpStr);
  vaSQL = "INSERT INTO R030EMP (NUMEMP, NOMEMP) VALUES (" + vaCodEmpStr + ", '" + vaNomEmp + "')";

  @ Execute the command @
  ExecSQL(vaSQL);

  Mensagem(Retorna, "Empresa inserida com sucesso!");
}
```

UPDATE/DELETE examples follow the same build-then-execute shape. `ExecSQLEx` adds the status check (source-faithful excerpt):

```lsp
ExecSQLEx(vaSQL, vnErro, vaMensagemErro);
Se (vnErro = 0) {
  FinalizarTransacao();
  Mensagem(Retorna, "Empresa e funcionário inseridos com sucesso!");
} Senao {
  DesfazerTransacao();
  Mensagem(Erro, "Erro ao inserir funcionário: " + vaMensagemErro);
}
```

Note: the `Mensagem(Erro, ... + vaMensagemErro)` line concatenates inside a function parameter in presented-as-working material — an L3-family witness; see `../guides/limitations.md` L3. The excerpt is preserved for the transaction pattern, not as endorsement of that call shape.

All these examples build SQL by concatenation — the dynamic-SQL conflict noted above. The `:BLOB(vaBlob)` placeholder spelling is demonstrated in an `ExecSQLEx` INSERT.

## Transactions

- `IniciarTransacao();` — starts a database transaction.
- `FinalizarTransacao();` — finalizes, executing COMMIT.
- `DesfazerTransacao();` — undoes, executing ROLLBACK.

Stated rules: an error between start and finalize auto-rolls-back, except while debugging; transactions must be explicitly opened/closed when rules need them; the user-section validation routine alters the database when no transaction is active; during debugging, failed transactions are not auto-finalized. No isolation levels, nesting, savepoints, or auto-commit rules are documented. Combined flow excerpt (source-faithful):

```lsp
@ Start the transaction @
IniciarTransacao();

@ Execute SQL operations @
vaSQL = "INSERT INTO R030EMP (NUMEMP, NOMEMP) VALUES (2000, 'EMPRESA TRANSACAO')";
ExecSQLEx(vaSQL, vnErro, vaMensagemErro);

Se (vnErro = 0) {
  @ Check the user permission @
  Se (vnCodUsu = 1) {
    DesfazerTransacao();
    Mensagem(Erro, "O usuário 1 não tem permissão para esta operação");
  } Senao {
    @ Continue with more operations @
    vaSQL = "UPDATE R030EMP SET NOMEMP = 'EMPRESA TRANSACAO CONFIRMADA' WHERE NUMEMP = 2000";
    ExecSQLEx(vaSQL, vnErro, vaMensagemErro);

    Se (vnErro = 0) {
      FinalizarTransacao();
      Mensagem(Retorna, "Transação completada com sucesso!");
    } Senao {
      DesfazerTransacao();
      Mensagem(Erro, "Erro na atualização: " + vaMensagemErro);
    }
  }
} Senao {
  DesfazerTransacao();
  Mensagem(Erro, "Erro na inserção: " + vaMensagemErro);
}
```

## SQL Senior 2 mode

A Senior-standard SQL wording for information-generator rules (reports, queries), calculation rules, and text import/export, easing learning and translation across supported databases. Activation is per-tool UI configuration (report generator menus, import/export definitions, query-model screens, rule-editor compile option) — UI paths preserved as tool facts, not LSP semantics.

Restrictions as stated: no aggregate functions inside SELECT (`SUM`, `COUNT`, `MAX`); native commands (`TO_DATE`, `CONVERT`) must be replaced by Senior SQL 2 wording; `JOIN`/`UNION` have no working guarantee inside rules.

Mode flag: `SQL_UsarSQLSenior2(xCursor, 0)` selects native syntax, non-zero selects Senior 2, and cursors do not inherit any rule-global flag. Default is Senior 2; native (or unsupported constructs like JOINs/subqueries) requires the `SQL_UsarAbrangencia(xCursor, 0)` + `SQL_UsarSQLSenior2(xCursor, 0)` pair before `SQL_DefinirComando`. `SQL_UsarAbrangencia` itself only informs whether user-coverage ("abrangência de usuários") applies; Senior terminology preserved without further interpretation.

## ListaRegra verdict for this slice

None of the deferred `ListaRegra*` catalog (search, extended navigation, row add/alter/delete, permissions, `TotalLinhas`, `LiberarLista`, `SalvarLista` to .txt/.csv) executes SQL, binds parameters, or touches cursors. They remain deferred to a future rule-list/Senior slice; the JSON-loading core already lives in `collections.md`.

## Conservative project guidance

- Choose one mechanism per cursor and preserve its exact lifecycle; never cross the simple/complete call forms.
- Declare complete-cursor handles as `Definir Alfa`; bind with the matching `SQL_Definir*` before opening.
- Always `SQL_FecharCursor` + `SQL_Destruir`; never skip cleanup.
- For simple cursors, pass ordinary values as direct `:variable` references; reserve `__Inserir(:var)` for dynamic SQL text fragments (see the simple-cursor parameters section).
- Match `:name` placeholders with `SQL_Definir*(xCursor, "name", value)`; use per-tool Senior-2/native settings deliberately.
- Return columns only into plain variables of matching kind via the type-specific function; never into `p`-parameters or Grid/Table fields without the intermediate-variable pattern.
- Preserve context-provided variable names (`:VSCodEmp`, `:VSFilDep`, and similar); never redeclare or rename them.
- Never guess database field types from names or values; follow production-verified types where recorded.
- Never invent type mappings, transaction semantics, or error diagnostics.

All guidance is project caution unless independently backed above.

## Deferred (inspected, not this domain)

- `ListaSecao`, report controls/SQL-clause builders: reports domain.
- Web-service grid patterns: covered in `../integration/http-webservices.md` (WS grid API).
- `ValorElementoJson`, JSON arrays: documented in `../data/json.md`.
- `MontaData`/`CodData` in date-flavored SQL strings: dates-time owns them.
- `ArqExiste` guards around SQL file reads: validation/files domains.

## Conflicts and uncertainty on this page

1. Placeholder-only rule vs. concatenation-built `ExecSQL`/`ExecSQLEx`/transfer examples throughout. Both presented-as-documented; unresolved.
2. `SQL_EOF`/`SQL_BOF`/`SQL_RetornarSeNulo` directly in conditions vs. the general calls-in-conditions guidance. Linked to limitations L4.
3. `Se (vnCodRes >= 200)`-style HTTP-adjacent checks are not SQL; no confusion introduced here, but `SQL_Proximo`-in-`Se` never appears — iteration is always EOF-loop demonstrated.
4. `SQL_Criar` handle described as Alfa-only while simple-cursor handles are `Cursor`-typed; no unified handle model exists.
5. No cleanup-failure, double-destroy, empty-result, or invalid-SQL diagnostics are documented beyond the auto-cancel note and `ExecSQLEx` status outputs.
6. The community source's `R034FUN` example wraps plain simple-cursor values in `__inserir(...)`, while verified production patterns pass the same kind of values directly (`:aCodPro`, `:VSCodEmp`). The source form is preserved as presented-as-documented; the direct form is the preferred production pattern. Not resolved beyond that scoping.
7. `E075PRO.CODPRO`-is-`Alfa` and the `:VSCodEmp` / `:VSFilDep` context variables are maintainer-provided production reports, not community-source statements. They are scoped to exactly what was observed; no general Senior ERP schema claim follows.

## Deliberately not documented

Result ordering, locking, isolation, fetch sizes, connection pooling, timeouts, database type mappings, NULL-vs-empty beyond `SeNulo`, aggregate support beyond the alias pattern, stored procedures, multi-statement commands, and any SQL dialect grammar.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Definição de Cursor` in full (simple/complete patterns, no-mixing table, trade-offs, return-function catalog with quick reference, BOF/EOF control functions, observations, optimization guide with limitation table), `Funções SQL` in full (function table, `SQL_Criar` lifecycle with native/JOIN rules, placeholder security rule with naming convention and full example, SQL Senior 2 activation/restrictions, INSERT/SELECT/UPDATE examples, `__inserir` and `SQL_Definir` parameter passing, `SelecaoTabelas` with consolidated example, `ExecSQL`/`ExecSQLEx` with BLOB and transaction examples, transaction functions with observations and transfer example), plus whole-repo name/arity sweeps and `//`-comment anomaly review. The `R038HSA` abrangencia/report example (direct `:xnumemp`-style binds alongside `__Inserir(:xAbrMot)` for the assembled coverage fragment) corroborates the direct-value vs. dynamic-fragment scoping. Deferred `ListaRegra` families re-checked against the collections boundary. Production excerpts (E075PRO product lookup; E070FIL company/branch/date handling) and the `E075PRO.CODPRO`-is-`Alfa` field-type report were provided by the project maintainer and are marked as such where used. Current evidence base is community documentation, community examples, and maintainer-provided production excerpts; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
