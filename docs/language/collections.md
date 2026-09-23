# LSP Lista, Tabela, and Grid

Scope: the `Lista` in-memory structure and its command API, the `ListaRegra*` rule-list API core, the `Tabela` declaration form, and the extent of documented `Grid` evidence. Cursor/database execution, web-service grid APIs, report-generator rules, and system registers are neighboring domains referenced only where they bound this one.

> Critical guidance for AI consumers: `Lista`, `Tabela`, and `Grid` are three different things. Do not substitute arrays for any of them, do not invent bracket indexing for them, and do not describe them with list/dataset/iterator semantics from other languages. `Lista` navigation (`Primeiro`, `Proximo`) returns values directly — the opposite of the usual LSP output-parameter pattern — exactly as documented below.

## Lista — declaration and fields

Purpose as stated: a dynamically allocated in-rule list for customizing the system without recompiling; the program defines the fields, fills values, and uses them in its logic.

Declaration has three phases — define the variable, add fields, lock the shape:

```lsp
/* Definition of the variables needed for the operation. */
definir lista Lst;

/* Definition of fields inside the list declared above. */
Lst.DefinirCampos();
Lst.AdicionarCampo("Empresa", numero);
Lst.AdicionarCampo("Tipo", alfa);
Lst.AdicionarCampo("Cadastro", numero);
Lst.AdicionarCampo("Nome", alfa, 100);
Lst.AdicionarCampo("Salario", numero);
Lst.AdicionarCampo("Afastamento", data);
Lst.EfetivarCampos();
```

Commands (source table):

- `tipo Lista` — declares a variable as a list; no additional parameter.
- `DefinirCampos` — starts the field-addition phase; fields may only be added after this call.
- `AdicionarCampo` — adds a field with type and optional size. Signature: `funcao <lista>.AdicionarCampo(alfa NomeCampo, <tipo> TipoInterno, numero Tamanho);`. `NomeCampo` must be an alphanumeric literal (constant) without spaces, accents, or a leading digit. `TipoInterno` is an internal primitive: `numero`, `alfa`, or `data`. `Tamanho` is optional, accepted only for alphanumeric fields; without it, `alfa` fields are unbounded (up to the memory limit). Other field types are unaffected.
- `EfetivarCampos` — ends field addition; from here the list receives values, and the interpreter builds internal control structures.

Stated consequence: assigning an over-100 value to the `Nome` field above raises a runtime error shown to the user. Declaration-placement rules apply: in the Report Generator the definition/addition/locking belongs in the "Funções Globais do Modelo Gerador" event (first rule compiled), in Import/Export in "Início da Execução" — and the list definition must be redeclared in every rule that uses it, or compilation fails (reports) or Access Violation follows (report web services, always in "1 - Local" mode). Compact form (source-faithful):

```lsp
@ In the "Funções Globais" event (Generator) or "Início da Execução" (Import/Export) event @
Definir Lista LstDados;
LstDados.DefinirCampos();
LstDados.AdicionarCampo("Codigo", numero);
LstDados.AdicionarCampo("Nome", alfa, 50);
LstDados.EfetivarCampos();

@ In each rule that uses the list @
Definir Lista LstDados;  @ REQUIRED: redeclare @

@ Now the list can be used normally @
LstDados.Adicionar();
LstDados.Codigo = 123;
LstDados.Nome = "Exemplo";
LstDados.Gravar();
```

Field-name rules: names come from `AdicionarCampo`; `TipoInterno` primitives are lowercase (`numero`, `alfa`, `data`) in every example. Keyword case is insignificant (`definir lista` and `Definir Lista` both occur), consistent with case-insensitivity.

## Lista — field access

Access is `listName.fieldName`, where the field was previously defined. Any other name after the dot that is not a procedure, function, property, or defined field causes a compilation error.

```lsp
Lst.Empresa = Cur.NumEmp;
frValorEmpresa = Lst.Empresa;
```

No bracket indexing on `Lista` is documented anywhere. The `arrays.md` bracket mechanism must not be transferred here.

## Lista — record manipulation

Commands (source table):

- `Adicionar` — first data command; appends a grouped-values record at the end (insertion order holds only while no keys are defined).
- `Inserir` — like `Adicionar` but inserts at the current position (internally pointed, readable via `NumReg`).
- `Editar` — for updates: position first, call `Editar`, then change values.
- `Gravar` — commits changed field values (after `Adicionar`, `Inserir`, or `Editar`) for later retrieval.
- `Cancelar` — discards a virtual record being changed instead of committing it.
- `Excluir` — deletes only the currently positioned record; repeat for more.

Deletion pattern (source-faithful):

```lsp
Tem = Lst.Primeiro();
enquanto (Tem = 1) {
  se (Lst.Salario < 1000) {
    Lst.Excluir();
    se (Lst.FDA = 1)
      Tem = 0;
    senao
      Tem = 1;
  } senao
    Tem = Lst.Proximo();
}
```

`Limpar` deletes all records at once (miscellaneous commands).

## Lista — positioning and properties (direct return)

Navigation returns values directly (`var = Lst.Command();`), the documented opposite of the output-parameter default:

- `Primeiro` — positions at the first record (insertion-first or key-first); returns 1 if positioned, 0 otherwise.
- `Ultimo` — positions at the last record; returns 1/0 the same way.
- `Anterior` — moves to the immediately previous record, else IDA; returns 1 unless at IDA (0).
- `Proximo` — moves to the immediately next record, else FDA; returns 1 on success, 0 on failure.

Absolute positioning: `NumReg` returns the current record number zero-based (4th record reads 3), influenced by the active key; `SetaNumReg` positions absolutely (position = record order minus 1, key-influenced). Example: `Lst.SetaNumReg(5);` then field reads.

Miscellaneous: `IDA` returns 1 when at start-of-file; `FDA` returns 1 at end-of-file; `QtdRegistros` returns the retained record count (`frValorTotalReg = Lst.QtdRegistros;`).

Reading patterns (all three source-faithful; the last two bear on the conditions conflict):

```lsp
Tem = Lst.Primeiro();
enquanto (Tem = 1) {
  frValorNumReg = Lst.NumReg;
  frValorEmpresa = Lst.Empresa;
  dsValorTipo = Lst.Tipo;
  frValorCadastro = Lst.Cadastro;
  dsValorNome = Lst.Nome;
  frValorSalario = Lst.Salario;
  frValorAfastamento = Lst.Afastamento;
  ListaSecao("adDetalhe");
  Tem = Lst.Proximo();
}
```

```lsp
Lst.Primeiro();
enquanto (Lst.FDA = 0) {
  frValorNumReg = Lst.NumReg;
  frValorEmpresa = Lst.Empresa;
  dsValorTipo = Lst.Tipo;
  frValorCadastro = Lst.Cadastro;
  dsValorNome = Lst.Nome;
  frValorSalario = Lst.Salario;
  frValorAfastamento = Lst.Afastamento;
  ListaSecao("adDetalhe");
  Lst.Proximo();
}
```

```lsp
Lst.Primeiro();
Lst.Anterior();
enquanto (Lst.Proximo() = 1) {
  frValorNumReg = Lst.NumReg;
  frValorEmpresa = Lst.Empresa;
  dsValorTipo = Lst.Tipo;
  frValorCadastro = Lst.Cadastro;
  dsValorNome = Lst.Nome;
  frValorSalario = Lst.Salario;
  frValorAfastamento = Lst.Afastamento;
  ListaSecao("adDetalhe");
}
```

The third pattern (call directly in the condition, flagged by the source as unusual but usable; reverse traversal via `Ultimo`/`Anterior` likewise) contradicts the general no-calls-in-conditions guidance — preserved and linked to `../guides/limitations.md` L4, not resolved. `ListaSecao` is a report-generator call shown only as the surrounding use case.

## Lista — search by key

- `SetarChave` — enters key-editing state, clearing current key values.
- `EditarChave` — same without clearing (for near-match keys).
- `VaiParaChave` — positions at the first record matching the configured key; no repositioning when absent; returns 1 on match, 0 otherwise.
- `Chave` — procedure configuring the active key as `;`-separated field names; empty (`""`) means no key. Keys also drive ordering (below).

```lsp
/* Configures the record key to proceed with a search. */
Lst.Chave("Cadastro;Nome");

/* Configures the key to search for the record with Cadastro 10. */
Lst.SetarChave();
Lst.Cadastro = 10;
se (Lst.VaiParaChave()) {
  frValorEspecial6 = Lst.NumReg;
  frValorEspecial1 = Lst.Empresa;
  dsValorEspecial2 = Lst.Tipo;
  frValorEspecial3 = Lst.Cadastro;
  dsValorEspecial4 = Lst.Nome;
  frValorEspecial5 = Lst.Salario;
  frValorEspecial7 = Lst.Afastamento;
  ListaSecao("adValoresEspeciais");
}
```

Observed-only: community examples also call `vlClientes.LimparChave();`, which has no documented section or row anywhere in the source. It is recorded as observed community-example usage with unknown semantics — never generate it on the authority of this page.

## Lista — ordering and memory

Ordering is key-driven and can be redefined at any time on a filled list (source-faithful excerpt):

```lsp
@ 1. Sort by code (ascending) @
vlClientes.Chave("Codigo");

@ 2. Sort by name (alphabetical) @
vlClientes.Chave("Nome");

@ 3. Sort by city then by name @
vlClientes.Chave("Cidade;Nome");

@ 4. Descending sort (use an auxiliary field or specific logic) @
@ For descending order, create an auxiliary field or reorganize the data @
```

Stated: the list reorganizes automatically, no reload needed, ordering is always ascending (descending needs auxiliary fields). Memory release is the list's own responsibility — no user call exists; remove records individually or with `Limpar`. Cursors-vs-lists guidance: cursors suit fresh or single-pass data (with the noted cost that `Anterior` and re-sorting need new SQL); lists suit repeated navigation, computed storage, and unknown-count accumulation with report/printing reuse. Cursor execution itself is documented in `../database/cursors-sql.md`.

## ListaRegra — rule-list API core

`ListaRegra*` manipulates special lists loadable directly from JSON or other structured sources — a separate API from `Lista`, sharing only the word "list". Do not merge them.

Creation and loading:

```lsp
ListaRegraCriarLista(<numeroLista>);
```

- `numeroLista` — output. Numeric variable receiving the created list's identifier.

```lsp
ListaRegraCriarLista(nLista);
@ nLista now holds the created list identifier @
```

```lsp
ListaRegraCarregarJson(Numero aLista, Alfa aJson, Alfa aGrupo, Alfa aCampos);
```

- `aLista` — input. Memory address of the created list.
- `aJson` — input. JSON file content.
- `aGrupo` — input. JSON group to read.
- `aCampos` — input. `;`-separated fields to read; a missing field errors as nonexistent/unfindable.
- Return type: none. Requires a prior `ListaRegraCriarLista`. Cannot read bare arrays — only objects containing arrays.

Navigation uses `Alfa` `"S"`/`"N"` outputs (not 1/0):

```lsp
ListaRegraPrimeiro(<numeroLista>, <achou>);
ListaRegraProximo(<numeroLista>, <achou>);
```

- `numeroLista` — input. List identifier.
- `achou` — output. `Alfa` receiving `"S"` on record / `"N"` on empty (`Primeiro`) or end (`Proximo`).

```lsp
Definir Numero nLista;
Definir Alfa vaAchou;

ListaRegraPrimeiro(nLista, vaAchou);
Se (vaAchou = "S") {
  @ List positioned at the first record @
  Mensagem(Retorna, "Primeiro registro encontrado");
} Senao {
  @ Empty list @
  Mensagem(Retorna, "Lista vazia");
}
```

```lsp
Definir Numero nLista;
Definir Alfa vaAchou;

ListaRegraProximo(nLista, vaAchou);
Se (vaAchou = "S") {
  @ Moved to the next record @
  Mensagem(Retorna, "Próximo registro encontrado");
} Senao {
  @ Reached the end of the list @
  Mensagem(Retorna, "Fim da lista");
}
```

Field reading:

```lsp
ListaRegraObterValorAlfa(<numeroLista>, <nomeCampo>, <valor>, <obteve>);
```

- `numeroLista` — input. List identifier.
- `nomeCampo` — input. Field name to obtain.
- `valor` — output. `Alfa` receiving the field value.
- `obteve` — output. `Alfa` receiving `"S"`/`"N"` for obtained or not.

```lsp
Definir Numero nLista;
Definir Alfa vaNome;
Definir Alfa vaIdade;
Definir Alfa vaObteve;

@ Obtain the current record's name @
ListaRegraObterValorAlfa(nLista, "nome", vaNome, vaObteve);
Se (vaObteve = "S") {
  Mensagem(Retorna, "Nome: " + vaNome);
}

@ Obtain the current record's age @
ListaRegraObterValorAlfa(nLista, "idade", vaIdade, vaObteve);
Se (vaObteve = "S") {
  Mensagem(Retorna, "Idade: " + vaIdade);
}
```

Note: those two `Mensagem` lines concatenate inside parameters — preserved for the getter shapes, not endorsed; see limitations L3. Sibling getters `ListaRegraObterValorNumero` / `ListaRegraObterValorData` appear in examples with the same shape.

Full-catalog deferral: roughly forty further `ListaRegra*` functions (search, extended navigation, row manipulation, permissions, utilities) fill a dedicated source catalog. They remain deferred to a future rule-list/Senior slice (the database slice covers cursors/SQL, not this catalog) — this page establishes only the create/load/navigate/read core above.

## Tabela

Declaration form (source-faithful; the `Acumulador` example is the only full declaration in the source):

```lsp
Definir Tabela Acumulador[12] = {
  Numero Media_Mensal;
  Numero Movimento[31];
  Alfa Nome_Mes[14];
};
```

Stated: declares a `Tabela` variable with rows and columns; each column is a name with a specific information type; rows are indexed from 1 to N. `{`/`}` may be replaced by `Inicio`/`Fim`. The example is a 12-occurrence table with numeric `Media_Mensal`, numeric `Movimento` occurring 31 times (one per day), and 14-position alphanumeric `Nome_Mes`.

Access form (source-faithful):

```lsp
x1 = Acumulador[1].Media_Mensal + 1;
x1 = Acumulador[x2+1].Movimento[x3+1];
Acumulador[1].Nome_Mes = "Janeiro";
Acumulador[2].Nome_Mes = "Fevereiro";
```

So `Tabela` rows accept `[N]` indexing (1-based in every demonstration) with `.column` field access, including indexed columns and expression indexes (`x2+1`). Insertion, removal, navigation, and key semantics for `Tabela` are undocumented. The type-list gloss calls it JavaScript-object-like — a naming gloss only, not semantics. Never infer SQL-table behavior. `MinhaTabela.CampoInteiro` appears solely in conversion-restriction examples (intermediate variable required — see limitations L6).

## GerTab* (deferred with description)

`GerTabAlf` (2000-occurrence alphanumeric system variable) and `GerTabNum` (999-occurrence numeric float) are described as system variables/registers, demonstrated with 1-based writes (`GerTabAlf[1] = "xxx";`), cleared by `LimpaGerTabAlf();` / `LimpaGerTabNum();`, and restricted to a single simultaneous array in memory (no distinct values per same indexer; use different indexers or dynamic lists). The source never ties them to `Tabela` operations — they are recorded here as system registers and deferred to a future system/reports slice. Their 1-based writes must not be used as evidence for generic arrays or `Tabela`.

## Grid (minimal evidence)

No Grid declaration, initialization, or iteration is documented. The entire `Grid` evidence is: `MinhaGrid.CampoDecimal` / `.CampoData` / `Grid.Campo` as conversion targets requiring intermediate variables (limitations L6), and a web-service grid API (`nomeWebService.NomeGrid.CriarLinha();`, `QtdLinhas`, `LinhaAtual`, entry/exit patterns, Cursor-to-Lista-to-Grid pipeline) documented in `../integration/http-webservices.md`. Whether a Grid is a UI widget, a result container, or something else is unstated — no characterization is given here beyond the field-write restriction.

## Conservative project guidance

- Never substitute arrays (`arrays.md`) for `Lista`, `Tabela`, or `Grid`, in either direction.
- Never invent `name[i]` access on `Lista` fields or `Grid` fields; only `Tabela` demonstrates it.
- Preserve navigation idioms exactly: `var = Lst.Primeiro();` … `var = Lst.Proximo();` with 1/0, vs. `ListaRegraPrimeiro(id, achou);` with `"S"`/`"N"`.
- Use intermediate variables for conversion output into `Tabela`/`Grid` fields, per limitations L6.
- Redeclare `Definir Lista <name>;` in every rule that uses it when targeting reports, web services, or import/export flows.

All guidance above is project caution, not compiler semantics.

## Deferred constructs and functions

- Full `ListaRegra*` catalog (~40 search/navigate/manipulate/permission/utility functions): still deferred to a future rule-list/Senior slice.
- `ListaSecao`, `InsClauSQLWhere`, cursor methods (`Cur.AbrirCursor()`, `Cur.Achou`, `Cur.Proximo()`): report/database/WS domains (cursor shares `Proximo`/`Achou` names — name overlap only).
- `GerTabAlf`/`GerTabNum` + `LimpaGerTab*`: future system/reports slice.
- Web-service grid API (`CriarLinha`, `QtdLinhas`, `LinhaAtual`): documented in `../integration/http-webservices.md` (Senior web-service ports).
- `ValorElementoJson`, JSON arrays: documented in `../data/json.md`.
- `LimparChave`: observed-only, unknown semantics (see search section).

## Conflicts and uncertainty on this page

1. `enquanto (Lst.Proximo() = 1)` and `se (Lst.VaiParaChave())` place calls directly in conditions — contradicting the general guidance, consistent with the L4 conflict family. Linked, not resolved.
2. `LimparChave()` is used in two community examples with zero documentation. Unknown; do not generate from this page.
3. `NumReg` is zero-based while every demonstrated `Tabela`/system write is 1-based; `Lista` ordering is key-dependent, so "first" is not positional. No unified index model exists.
4. `ListaRegraObterValorNumero(vnLstIte, "id", vaId, vaObteve);` passes an `Alfa` variable where a number getter writes — preserved as found; type strictness unstated.
5. `Lista` vs `ListaRegra`: similar names, disjoint APIs and return conventions (1/0 vs `"S"`/`"N"`); never merged here.

## Deliberately not documented

Empty-structure behavior, post-final `Proximo`, invalid field/index access, missing-field diagnostics, null/default values, initialization defaults beyond the shown phases, multi-key semantics, descending order mechanics, memory limits, concurrency, and any formal relation between `Lista`, `Tabela`, `Grid`, arrays, cursors, or JSON structures.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Definição de Listas` in full (rationale, definition/field/record/positioning/search/absolute/misc command tables, declaration/assignment/usage/deletion/reading-algorithm examples, availability note, cursor-vs-list comparison, dynamic-sorting guide, report/WS/import critical contexts), `Funções de Lista de Regras` core (`ListaRegraCriarLista`, `ListaRegraCarregarJson` with JSON example, `ListaRegraPrimeiro`/`Proximo`, `ListaRegraObterValorAlfa`, JSON-processing example; full catalog skimmed for the deferral boundary), `Definição de Tabelas` in full, `GerTab*`/`LimpaGerTab*` sections (deferral description only), web-service grid API (deferral pointer only), plus `ExemploListaDinamica.lsp` and `ExemploListasDinamicasRelacionadas.lsp` (usage consistency, `LimparChave` observation). Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
