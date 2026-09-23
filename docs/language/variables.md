# LSP variables, data types, declarations, and naming

Scope: the documented data types, `Definir` declaration syntax, `Alfa` / `Numero` / `Data` declarations (including sized `Alfa`), name constraints, the `va` / `vn` / `vd` naming convention, declaration placement, and initialization guidance. Array iteration, `Lista` / `Tabela` / `Cursor` / `Grid` structures, and conversion functions are out of scope except where the type list names them.

> Critical guidance for AI consumers: use only documented LSP syntax. Do not infer type behavior, defaults, scope, precision, or conversions from other languages. Naming prefixes are a documented convention, not a proven compiler requirement.

## Data types named in the source

The source lists the following supported data types:

- **Alfa**: character string.
- **Numero**: integer or decimal numbers.
- **Data**: dates.
- **Lista**: dynamic list in rules.
- **Tabela**: structure described in the source as similar to an object in JavaScript.
- **Grid**: grid structure.
- **Cursor**: structure for handling SQL queries.
- **Funcao**: programmer-defined functions.

Only `Alfa`, `Numero`, and `Data` declarations are documented in this file. The descriptions above are the source's own short glosses. `Lista`, `Tabela`, `Grid`, `Cursor`, and `Funcao` are named here so the list stays faithful; their declaration and use syntax belongs to later slices.

The quick-reference section repeats the core three with the same glosses:

```lsp
Definir Alfa vaNome;        @ Texto/String @
Definir Numero vnIdade;     @ Número (int/decimal) @
Definir Data vdNascimento;  @ Data @
```

## Declaring variables with `Definir`

Language behavior:

- Variables are declared with the `Definir` command.
- Syntax (source-faithful; placeholders, not literal LSP):

```text
Definir <Tipo> <Nome_da_Variável>;
```

- Examples (source-faithful):

```lsp
Definir Alfa vaNome;
Definir Numero vnIdade;
Definir Data vdNascimento;
```

- A variable name has a maximum of 100 characters and may contain `_` (underscore). Accents are not allowed in variable names.

Undeclared-variable behavior (as stated in the source):

- If a variable is not defined with `Definir`, it is treated as type `Numero`.

The source gives this as a flat statement without detail. Do not infer anything further about when or how implicit `Numero` typing applies.

## Variable-name constraints (as stated)

The source states the following rules:

- A variable name must not equal a function parameter name.
- A variable name must not equal a list field name.
- Do not use reserved words as variable names (best-practices restatement of the general reserved-word rule).

The source does not provide the compiler diagnostic for violating these rules.

## Sized `Alfa` and indexed access

Language behavior documented in the variables section:

- An `Alfa` variable may declare a maximum chain length (tamanho máximo da cadeia de caracteres).

```lsp
Definir Alfa vaNome[30];
```

- Variables are accessed directly by name:

```lsp
vaNome = "João";
vnIdade = 25;
```

- A sized variable is accessed by index. The index may be a fixed value, a variable, or a formula. Syntax (source-faithful; placeholders):

```text
<Nome_da_Variável>[<índice>] = <valor_atribuído>;
```

- Examples (source-faithful):

```lsp
Definir Alfa vaNome[30];
Definir Numero vnIndice;

vnIndice = 1;

@ Valor Fixo @
vaNome[1] = "Nome";

@ Valor Variável @
vaNome[vnIndice] = "Nome";

@ Valor Formula @
vaNome[vnIndice + 1 * 2 ] = "Nome";
```

> Documentation note (conflict, do not resolve): the same bracket syntax is used elsewhere with a different meaning. The later `Definição de Arrays` section documents `Definir Alfa vaNomes[10];` as an array holding multiple values of the same type, with zero-based examples (`vaNomes[0] = "João";`), while this section documents `Definir Alfa vaNome[30];` as one string with maximum length and one-based indexed examples (`vaNome[1] = "Nome";`). Both wordings are preserved here as found; a future arrays slice must reconcile indexing, sizing, and whether these are one mechanism or two.

## `Data` assignment rule (as stated)

The source states, under variable rules:

- For `Data` variables, use the `MontaData(dd,mm,yyyy,vdData)` function to assign a date, or assign the `DatSis` system variable.

This is the extent of the rule in this slice. `MontaData` parameters, return mechanics, date formats, and `DatSis` semantics belong to the dates and system-variables slices.

> Documentation note: the later Arrays section contains date examples that assign string literals (`vdDatas[0] = "01/01/2020";`). That conflicts with the `MontaData`-only assignment rule above. The conflict is recorded, not resolved.

## Declaration placement

Documented recommendation with error-avoidance rationale:

- Declare all variables at the start of the rule (regra). Declaring inside a conditional block, or not declaring at all, is given as the cause of the “Variável não definida” problem and “may cause errors” (PODE CAUSAR ERROS).

Incorrect form (source-faithful):

```lsp
@ Incorrect @
Se (vnCondicao = 1) {
  Definir Alfa vaVariavel;  @ Declaração no meio @
  vaVariavel = "valor";
}
```

Correct form (source-faithful):

```lsp
@ Correct @
Definir Alfa vaVariavel;  @ Declaração no início @
Se (vnCondicao = 1) {
  vaVariavel = "valor";
}
```

Related undeclared-variable fix (source-faithful):

```lsp
@ Incorrect @
DecodData(vdData, vnDia, vnMes, vnAno);
```

```lsp
@ Correct @
Definir Numero vnDia;
Definir Numero vnMes;
Definir Numero vnAno;
DecodData(vdData, vnDia, vnMes, vnAno);
```

Strength-of-rule note: the source presents top-of-rule declaration as the solution and as best practice (“Declare as variáveis no início do código ou da função”), and mid-block declaration as something that can cause errors — not with an explicit compiler-rejection statement. Document it as a strong documented recommendation that avoids a documented failure mode, not as a proven grammar restriction. Scope, lifetime, and visibility semantics are not documented in the inspected material.

## Initialization guidance (convention)

Best-practice statements from the source (recommendations, not language behavior):

- Initialize variables whenever possible at the start of the code or function.
- In reports (relatórios), declare and initialize variables in the Initialization (Inicialização) or Pre-Selection (Pré-Seleção) events.

No default values are documented in the inspected material. Do not assume zero, empty string, null, or any system date default.

## Naming convention `va` / `vn` / `vd` (convention, not compiler rule)

The source documents a type-prefix standard:

- `va`: `Alfa` variables (string/text).
- `vn`: `Numero` variables (integer/decimal).
- `vd`: `Data` variables (date/time).

Plus CamelCase after the prefix, descriptive and meaningful names.

Examples presented as correct (source-faithful):

```lsp
@ Variáveis Alfa @
Definir Alfa vaNomeCompleto;
Definir Alfa vaEmailUsuario;
Definir Alfa vaCaminhoArquivo;

@ Variáveis Número @
Definir Numero vnIdadeUsuario;
Definir Numero vnValorTotal;
Definir Numero vnContadorRegistros;

@ Variáveis Data @
Definir Data vdDataNascimento;
Definir Data vdDataCadastro;
Definir Data vdDataVencimento;
```

Minimal form (source-faithful):

```lsp
Definir Alfa vaNome;     @ va = variável alfa @
Definir Numero vnIdade;  @ vn = variável numero @
Definir Data vdData;     @ vd = variável data @
```

Forms the source labels incorrect **as convention violations** (source-faithful; preserved exactly, including terse names the same section otherwise discourages):

```lsp
@ Sem prefixo @
Definir Alfa nome; @ Incorreto @

@ Prefixo errado @
Definir Numero vaIdade; @ Incorreto: va é para Alfa @
```

```lsp
@ Nomes não descritivos @
Definir Alfa va1; @ Incorreto: não é descritivo @
Definir Numero vnX; @ Incorreto: muito genérico @
```

Convention status: the source says variables “must follow” (devem seguir) the prefix + CamelCase pattern and lists these under rules, but never states a compiler consequence for a missing or mismatched prefix. Treat `va` / `vn` / `vd` as a required-by-standard convention for this project’s generated code, not as a proven language requirement. Do not reject or “fix” otherwise-valid LSP solely for a prefix mismatch when translating source examples.

## Deliberately not inferred

From the inspected sections, the following are not documented and must not be filled in:

- Default values and nullability.
- Scope, lifetime, visibility (global vs. local vs. rule vs. function vs. event).
- Implicit conversions between `Alfa`, `Numero`, and `Data`.
- Numeric precision, range, or decimal separator behavior.
- String size semantics beyond “maximum chain length” (no encoding, byte-vs-character, truncation, or overflow behavior documented here).
- Date representation, range, or time-component behavior.
- Memory or performance characteristics.

## Common mistakes preserved from the source

- Using a variable without `Definir` (relies on undocumented implicit-`Numero` behavior; declare explicitly instead).
- Declaring inside a conditional block instead of at the start of the rule.
- Using accents, exceeding 100 characters, or reusing a function-parameter or list-field name.
- Assigning a `Data` variable without `MontaData` / `DatSis` (per the stated rule; note the recorded string-literal conflict above).
- Treating the `va` / `vn` / `vd` prefix as optional in new code (convention violation, not a proven compiler error).

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Tipos de Dados Essenciais` (quick-start summary), `Tipo de Dados e Variáveis` (type list, `Definir` syntax, sized `Alfa`, access forms, `Regras`, `Padrão de Nomenclatura`), `Regra #3: Padrão de Nomenclatura`, `Problema: “Variável não definida”`, `Problema #4: Variáveis Não Declaradas`, `Erro #3: Declaração de Variáveis no Meio do Código`, `Referência Rápida — Declaração de Variáveis`, and `Padrões e Boas Práticas` (declaration, initialization, naming). The `Definição de Arrays` section was inspected only to record the bracket-syntax conflict. Portuguese explanatory prose was translated into English; LSP keywords, identifiers, literals, and code examples were preserved unchanged. Senior Sistemas is the authoritative source for official behavior.
