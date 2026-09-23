# Documentation index

Coverage map for the structured LSP reference. Each entry states whether the topic has been transformed yet.

## Language core

- [Syntax and structure](language/syntax.md) — available. Statement termination, case sensitivity, code blocks, conditions in parentheses, comments, escaping, line continuation, formatting conventions.
- [Variables, data types, declarations, and naming](language/variables.md) — available. Documented types, `Definir` syntax, sized `Alfa`, name constraints, `va`/`vn`/`vd` convention, declaration placement, initialization guidance.

## Not yet transformed

The following domains exist in the source but have no structured file in this repository yet. Do not treat their absence as a statement about LSP.

- Operators
- Control flow (`Se`, `Senao`, `Para`, `Enquanto`, `Pare`, `Continue`, `VaPara`, `Cancel`)
- String, date, number, and conversion functions
- Validation and security functions
- Cursors and database access
- Rule lists
- Report Generator functions
- Files, JSON, Web Service, and HTTP integration
- User interface (`Mensagem`, `EntradaValor`, `Cancel`)
- System variables and execution contexts
- Limitations, common errors, patterns, and worked examples

## Source

Primary source is the community repository `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao` (single large `README.md` plus `exemplos/*.lsp`). Senior Sistemas is the authoritative source for official behavior.
