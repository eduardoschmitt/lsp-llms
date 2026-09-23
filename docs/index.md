# Documentation index

Coverage map for the structured LSP reference. Each entry states whether the topic has been transformed yet.

## Language core

- [Syntax and structure](language/syntax.md) — available. Statement termination, case sensitivity, code blocks, conditions in parentheses, comments, escaping, line continuation, formatting conventions.
- [Variables, data types, declarations, and naming](language/variables.md) — available. Documented types, `Definir` syntax, sized `Alfa`, name constraints, `va`/`vn`/`vd` convention, declaration placement, initialization guidance.
- [Control flow](language/control-flow.md) — available. `Se`/`Senao`, `Para`, `Enquanto`, `Pare`, `Continue`, `VaPara` with labels. Includes recorded conflicts and explicitly undocumented behaviors.
- [Arrays and indexed values](language/arrays.md) — available. Bracket declarations, indexed assignment/reads, iteration, 0-based vs 1-based evidence. Centers on the unresolved `Alfa[N]` sized-string vs. array conflict.
- [Lista, Tabela, and Grid](language/collections.md) — available. `Lista` command API and navigation (direct-return 1/0), `ListaRegra*` core (`"S"`/`"N"`), `Tabela` declaration/access, `GerTab*`/Grid evidence boundaries. Full rule-list catalog deferred.

## Guides

- [Critical limitations and common pitfalls](guides/limitations.md) — available. Output-parameter calls, no-manipulation-in-parameters rule, `Mensagem` rules and payload ban, grid/table and `SQL_Retornar` restrictions, concatenation/type rules, `Truncar`, date pitfalls, non-existent constructs, `Cancel` contexts. Includes recorded documentation conflicts.

## Functions

- [String functions](functions/strings.md) — available. Concatenation, extraction, measurement, search, substitution, insertion, deletion, whitespace, case, accent/special-character, line-splitting, delimited lists, ASCII and encoding conversion, math on `Alfa`. Conversions (`IntParaAlfa`, `AlfaParaInt`, …) deferred to a future conversion slice.
- [Date and time functions](functions/dates-time.md) — available. Current date/time, construction, decomposition, formatting, demonstrated arithmetic and comparison, weekday/business-day functions. Includes recorded conflicts (output types, literals, masks).
- [Type conversion functions](functions/conversion.md) — available. Evidence-only conversion matrix, Alfa/Numero/Data/masked/hour-minute conversions, observed-only date helpers, failure catalog. Intuitive names (`NumeroParaAlfa`, `AlfaParaNumero`) confirmed absent.
- [Numeric and math functions](functions/numeric-math.md) — available. Operators subset, truncation, rounding (ABNT as stated), Delphi-style formatting, value-to-words, unit multiplication/conversion, division helpers. Name-variant conflicts preserved.

## Database

- [Cursors and SQL](database/cursors-sql.md) — available. Simple vs. complete cursors, lifecycle, placeholders and binds, returned columns, BOF/EOF navigation, `SelecaoTabelas`, `ExecSQL`/`ExecSQLEx`, transactions, SQL Senior 2 mode. Dynamic-SQL contradiction preserved.

## I/O

- [File operations](io/files.md) — available. Handle-based text I/O, whole-file loading, existence checks, line counting, temp files. Open-mode and `ArqExiste` conflicts preserved; encoding/newlines undocumented.

## Data

- [JSON handling](data/json.md) — available. `Alfa` representation, `ValorElementoJson` single-field reads, `ListaRegraCarregarJson` collections, manual string scanning. Indexed paths rejected; no builder API; null/boolean undocumented.

## Not yet transformed

The following domains exist in the source but have no structured file in this repository yet. Do not treat their absence as a statement about LSP.

- Operators
- Function definitions and calls (beyond the control-flow and limitations excerpts)
- Validation and security functions (string, date, conversion, numeric, and database functions are done)
- Rule lists (core `ListaRegra` in collections; full catalog deferred)
- Report Generator functions
- Files, Web Service, and HTTP integration (file operations and JSON are done)
- User interface (`Mensagem`, `EntradaValor`, `Cancel`)
- System variables and execution contexts
- Worked examples, patterns, and remaining troubleshooting (beyond the guardrail subset in the limitations guide)

## Source

Primary source is the community repository `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao` (single large `README.md` plus `exemplos/*.lsp`). Senior Sistemas is the authoritative source for official behavior.
