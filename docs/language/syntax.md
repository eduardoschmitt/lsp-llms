# LSP syntax and structure

Scope: statement termination, sequential structure, case sensitivity, code blocks, conditions in parentheses, comments, special-character escaping, and long-line continuation. Variable declarations, data types, operators, control-flow semantics, and built-in functions are out of scope for this file.

> Critical guidance for AI consumers: use only documented LSP syntax. Do not infer missing syntax from other languages. When behavior is not documented below, treat it as unknown and verify against official Senior documentation.

## Statement termination

Language behavior:

- Every command ends with a semicolon (`;`).
- Commands are written sequentially and execute in written order.

Example (source-faithful):

```lsp
Definir Numero vnX;
Definir Numero vnY;
Definir Numero vnResultado;
vnX = 10;
vnY = 20;
vnResultado = vnX + vnY;
Definir Alfa vaResultadoStr;
IntParaAlfa(vnResultado, vaResultadoStr);
Mensagem(Retorna, vaResultadoStr);
```

Minimal program (source-faithful):

```lsp
@ My first LSP program @
Definir Alfa vaMensagem;
vaMensagem = "Olá, mundo LSP!";
Mensagem(Retorna, vaMensagem);
```

Not documented in the available source: the exact compiler diagnostic or recovery behavior for a missing `;`.

## Case sensitivity

Language behavior:

- LSP does not distinguish uppercase from lowercase in variable declarations. The source presents the following as equivalent:

```lsp
Definir Alfa vaNomeVariavel;
Definir Alfa VANOMEVARIAVEL;
```

The introductory summary generalizes this as case-insensitive identifiers (`vaNome` = `VANOME` = `vanome`). The detailed syntax section demonstrates it specifically for variable declarations.

## Code blocks

Language behavior documented in the source:

- Code blocks are delimited with `{ }`, or alternatively with `Inicio` and `Fim;`. The `Inicio` / `Fim;` form is described as less common.
- A single-line block does not require `{ }` or `Inicio` / `Fim;`; the indented line below the condition is the block body.
- Conditions and repetition structures must be enclosed in parentheses `()`.

Single-line block (source-faithful; `<Condição>` is a placeholder, not literal LSP):

```lsp
Se (<Condição>)
  vn = 1; @ Block structure on a single line @
```

Block with `{ }` (source-faithful):

```lsp
Se (<Condição>) {
  @ Block structure @
}
```

Block with `Inicio` / `Fim;` (source-faithful):

```lsp
Se (<Condição>)
Inicio
  @ Block structure @
Fim;
```

Documented incorrect form: omitting the parentheses around the condition (source-faithful):

```lsp
Se vnX < vnY {
  @ Block structure @
}

@ OR @

Se vnX < vnY
Inicio
  @ Block structure @
Fim;
```

Indentation example from the source (convention, not a block-delimiter rule):

```lsp
Definir Numero vnX;
Definir Numero vnY;
Definir Numero vnSoma;
vnX = 5;
vnY = 15;

Se (vnX < vnY) {
  vnSoma = vnX + vnY;
}
```

> Documentation note: the source wording for the single-line-block rule is garbled in Portuguese ("basta adicionar identado na linha de baixo e identado"). The meaning above — one indented statement without delimiters — is the best faithful reading. Exact indentation requirements for that form are not documented.

## Comments

Language behavior:

- Comments explain code and are ignored by the compiler.
- Single-line comment: `@ ... @`.
- Multi-line comment: `/* ... */`.

Single-line comment (source-faithful):

```lsp
@ This is a single-line comment
Definir Numero vnX;
```

Multi-line comment (source-faithful):

```lsp
/*
  This is a
  multi-line comment
*/
Definir Numero vnX;
```

> Documentation note: the source text claims there are three comment types but enumerates only the two forms above. Only these two forms are documented. Do not invent a third comment form.

In examples, `@ ... @` is also used as an inline trailing annotation on the same line (for example, `Definir Alfa vaNome;        @ Text/String @`). The source does not define separate inline-comment semantics; treat it as the same `@`-delimited comment form.

## Special characters and escaping

Language behavior:

- Inside literal expressions in rules, the characters `"` (double quote) and `\` (backslash) must be preceded by `\` so they are treated literally rather than as special characters.

Example (source-faithful, preserved exactly including spacing):

```lsp
EnviaEMail("Joao","joao@senior.com.br", "", "", "Teste","\"\\\\Servidor\\teste.txt\"", "");
```

Not documented in the available source: escaping rules for any other characters, or behavior of `\` outside string literals (except line continuation below, which is documented separately).

## Long-line continuation

Language behavior:

- A trailing `\` at the end of a line continues a long string (documented especially for SQL cursor strings) on the next line.

Example of a long single-line string presented in the source as incorrect style (source-faithful):

```lsp
@ Incorrect - String too long for a single line @
Cur_Consulta.SQL "SELECT PRODUTO.NOME, PRODUTO.DESCRICAO, PRODUTO.PRECO, PRODUTO.DATA_CADASTRO, PRODUTO.ULTIMA_ATUALIZACAO, PRODUTO.ESTOQUE, PRODUTO.STATUS, CASE WHEN SYSDATE - PRODUTO.ULTIMA_ATUALIZACAO > 7 THEN 0 ELSE 1 END AS PRODUTO_ATUALIZADO FROM PRODUTOS PRODUTO, CATEGORIAS CAT WHERE CAT.COD_CATEGORIA = PRODUTO.COD_CATEGORIA AND PRODUTO.STATUS = 'A' AND PRODUTO.ESTOQUE > 0";
```

Corresponding multi-line form with `\` continuation (source-faithful):

```lsp
@ Correct - Line break with \ @
Cur_Consulta.SQL "SELECT PRODUTO.NOME,                               \
                        PRODUTO.DESCRICAO,                          \
                        PRODUTO.PRECO,                              \
                        PRODUTO.DATA_CADASTRO,                      \
                        PRODUTO.ULTIMA_ATUALIZACAO,                 \
                        PRODUTO.ESTOQUE,                            \
                        PRODUTO.STATUS,                             \
                        CASE WHEN SYSDATE - PRODUTO.ULTIMA_ATUALIZACAO > 7 THEN 0 ELSE 1 END AS PRODUTO_ATUALIZADO \
                 FROM PRODUTOS PRODUTO, CATEGORIAS CAT              \
                 WHERE CAT.COD_CATEGORIA = PRODUTO.COD_CATEGORIA    \
                   AND PRODUTO.STATUS = 'A'                         \
                   AND PRODUTO.ESTOQUE > 0";
```

The Correct/Incorrect marks above are source style guidance about readability, not compiler errors. The SQL text itself is an embedded database query, not LSP syntax; do not treat table names, columns, or SQL dialect features as LSP behavior.

## Formatting conventions (not language requirements)

The following are documented as community/Senior standards or recommendations. Do not enforce them as compiler rules:

- **Indentation:** 2 spaces per level (described as the Senior standard, "ao invés de 4"). Example blocks in the source consistently use 2 spaces.
- **Continuation layout:** place the continuing `\` around column 80, align continued columns for readability, keep spacing consistent, and indent 2 spaces per level.
- **Comment markers with correctness labels** (for example, `@ Incorrect @`, `@ Correct @`) are documentation style in the source, not a language feature.

## Common mistakes preserved from the source

Do not generate these forms:

- Missing parentheses around a condition: `Se vnX < vnY {`.
- Assuming a third comment syntax beyond `@ ... @` and `/* ... */`.
- Assuming indentation alone defines blocks in multi-line bodies without `{ }` or `Inicio` / `Fim;`. Only the single-line indented form is documented.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Início Rápido` ("Primeiro Programa LSP", "Conceitos Fundamentais", "Quebra de Linha em Strings Longas"), `Sintaxe e Estrutura` (including "Estrutura Básica", "Case Sensitivity", "Identação e Espaçamento", "Estruturas de Bloco"), `Caracteres com Comportamento Especial`, and `Comentários`. Portuguese explanatory prose was translated into English; LSP keywords, identifiers, literals, and code examples were preserved unchanged. Senior Sistemas is the authoritative source for official behavior.
