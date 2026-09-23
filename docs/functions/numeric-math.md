# LSP numeric and math functions

Scope: arithmetic operators as documented, truncation, rounding (including ABNT rules as stated), numeric formatting, value-to-words, unit multiplication and conversion, and division helpers. `Numero` type fundamentals live in `../language/variables.md`; type conversions to/from `Alfa`/`Data` live in `../functions/conversion.md` and `../functions/dates-time.md` and are referenced, not repeated.

> Critical guidance for AI consumers: rounding modes, precision handling, and formatting tokens are exactly as stated below. Do not import half-up/half-even/floor/ceiling semantics, IEEE-754 assumptions, or Delphi/C formatting knowledge. Several names (`Arredonda Valor Tipo Acerto` with and without spaces, `ArredondarValorEx`) vary across sections — copy the attested form, do not normalize it.

## Arithmetic operators (documented subset)

The source documents these arithmetic operators: `+` addition, `-` subtraction, `*` multiplication, `/` division, `++` increment by 1, `--` decrement by 1.

Demonstrated usage (source-faithful excerpts):

```lsp
vnSoma = vnA + vnB;         @ Addition @
vnSub = vnA - vnB;          @ Subtraction @
vnMult = vnA * vnB;         @ Multiplication @
vnDiv = vnA / vnB;          @ Division @
```

```lsp
vnDesconto = (vnValorOriginal * vnPorcentagem) / 100;
vnMedia = vnSomaValidos / vnTotalProcessados;
```

The `%` (modulo) operator does not exist in LSP; use `RestoDivisao` for remainders. Precedence, associativity, overflow, integer-division truncation, and evaluation order are undocumented — never assume them. `++`/`--` as loop counters are additionally shown in `../language/control-flow.md`.

Numeric literals are demonstrated as plain integers (`10`, `25`, `12345`) and dot-decimals (`1577.87`, `1234.6789`, `2.5`), including a negated factor (`vnIdade * -1`). Scientific notation, hexadecimal, separators, suffixes, and NaN/Infinity are undocumented.

## Truncar

Purpose: truncate a number to integer, removing the fractional part.

Signature (source-faithful, direct return):

```lsp
vnParteInteira = Truncar(<valor>);
```

Parameters:

- `valor` — input. `Numero` value whose fractional part is removed.

Example (source-faithful):

```lsp
Definir Numero vnValor;
Definir Numero vnValorTruncado;

vnValor = 1.12345;
vnValorTruncado = Truncar(vnValor);
@ vnValorTruncado will be 1 @
```

Financial-context usage (source-faithful excerpt):

```lsp
@ Truncates to integer @
vnValorTruncado = Truncar(vnValorOriginal);
IntParaAlfa(vnValorTruncado, vaValorTruncadoStr);
vaMensagem = "Valor truncado: R$ " + vaValorTruncadoStr;
Mensagem(Retorna, vaMensagem);
```

Return behavior: direct return in all 21 source occurrences. The two-argument form `Truncar(vnDataHora, vnParteInteira);` appears exactly once, inside a documented-incorrect block (see `../guides/limitations.md` L8). No output-parameter form exists anywhere in the source.

Date/time usage: `Truncar` splits the fractional `DataHora` day-count (`vnSomenteParte = vnDataHoraAtual - Truncar(vnDataHoraAtual);`), including with an arithmetic expression inside (`Truncar(pnInicial * vnMultiplicador)` in a community random-number example — preserved as observed; the parameters dispute in limitations L3 is not resolved here). See `../functions/dates-time.md` for the representation; `Truncar` itself is owned here.

## Arredonda

Purpose: round a value per a stated precision, in place.

Signature (source-faithful):

```lsp
Arredonda(<valor>, <decimais>);
```

The source additionally describes the signature as `Arredonda(Numero End Valor, Numero Decimais)` — the first parameter is the variable that receives the already-rounded value (in-place effect on that variable).

Parameters:

- `valor` — input/output. Variable being rounded; holds the rounded result.
- `decimais` — input. Numeric variable stating the decimal places for rounding.

Example (source-faithful):

```lsp
Definir Numero vnValor;
vnValor = 1577.87;
Arredonda(vnValor, 1);
@ vnValor will be 1577.90 @

Arredonda(vnValor, 0);
@ vnValor will be 1578.00 @
```

A second source passage gives the same shape with the precision in a `Numero` variable and adds: prefer `Decimais` in a `Numero` variable (e.g. `vnCasas`), not a literal, if the debugger or compiler is sensitive. That sensitivity is stated as a conditional caution, not an established rule.

No rounding mode (half-up, half-even, floor, ceiling) is stated for `Arredonda` — do not infer one from the examples.

## ArredondaABNT

Purpose: apply the ABNT rounding rule per a stated precision.

Signature (source-faithful):

```lsp
ArredondaABNT(<valor>, <decimais>);
```

Parameters: same roles as `Arredonda` (`valor` rounded in place; `decimais` decimal places).

ABNT rules as stated in the source (translated prose, technical content unchanged):

- When the digit to keep is followed by a digit below 5, the kept digit is unchanged.
- When followed by a digit above 5, or equal to 5 followed by a non-zero digit, add one unit to the kept digit.
- When the kept digit is odd, followed by 5 and then zeros, add one unit to the kept digit.
- When the kept digit is even, followed by 5 and then zeros, the kept digit is unchanged.

Example (source-faithful):

```lsp
Definir Numero vnValor;
vnValor = 1577.87;
ArredondaABNT(vnValor, 1);
@ vnValor will be 1577.90 @

ArredondaABNT(vnValor, 0);
@ vnValor will be 1578.00 @
```

These rules are the source's own account — not a reconstruction of any external ABNT standard. Behavior outside the stated rules (negatives, exact halves beyond the patterns, precision handling) is undocumented.

## ArredondarValor and ArredondarValorEx

Purpose: round a value per a stated precision.

Signature (source-faithful):

```lsp
ArredondarValor(<valorVariavel>, <precisao>);
```

Parameters:

- `valorVariavel` — input/output. Field or variable to round.
- `precisao` — input. Decimal places for precision. Stated: informing 0 (zero) rounds the integer part of the result.

Example (source-faithful):

```lsp
Definir Numero vnVlrNum;
vnVlrNum = 1577.87;
ArredondarValor(vnVlrNum, 1); @ Return will be 1577.90 @
ArredondarValor(vnVlrNum, 0); @ Return will be 1578.00 @
```

`ArredondarValorEx`: no dedicated section exists. Two source notes state it usually shows the same behavior as `ArredondarValor` in test environments, advising to standardize on one in code:

```lsp
Definir Numero vnValor;
Definir Numero vnCasas;

vnValor = 1577.87;
vnCasas = 2;
ArredondarValorEx(vnValor, vnCasas);
```

A further source comment observes that a 3-parameter `Arredondar` does not exist in LSP. No signature beyond the demonstrated 2-argument shape is documented for the `Ex` variant; do not treat the equivalence notes as a specification.

## Arredonda Valor Tipo Acerto (spaced and unspaced names)

Purpose: round an "acerto"-type value per a stated precision.

Name conflict (unresolved): the heading and main example write the name with spaces —

```lsp
Arredonda Valor Tipo Acerto(<valor>, <tipoAcerto>);
```

— while a summary passage and a second example write `ArredondaValorTipoAcerto` (no spaces) and call the spaced form a "nome com espaços". Both spellings have working examples (5 spaced vs. 4 unspaced occurrences). Copy the attested spelling; the source never reconciles them.

Parameters:

- `valor` — input/output. Any value to round.
- `tipoAcerto` — input. Type 1: the passed value is rounded to two decimal places. Type 2: the value is rounded ignoring the third decimal place.

Example, spaced form (source-faithful):

```lsp
Definir Numero vnValor;
vnValor = 1475.12845;
Arredonda Valor Tipo Acerto(vnValor, 1); @ Returns 1475.13 @
Arredonda Valor Tipo Acerto(vnValor, 2); @ Returns 1475.12 @
```

Example, unspaced form (source-faithful):

```lsp
Definir Numero vnValor;
Definir Numero vnTipoAcerto;

vnValor = 1475.12845;
vnTipoAcerto = 1;
ArredondaValorTipoAcerto(vnValor, vnTipoAcerto);
@ Type 1: rounds to two decimal places (e.g.: 1475,13 in the doc) @

vnValor = 1475.12845;
vnTipoAcerto = 2;
ArredondaValorTipoAcerto(vnValor, vnTipoAcerto);
@ Type 2: ignores the third decimal place (e.g.: 1475,12 in the doc) @
```

The parenthetical doc values use comma decimals (`1475,13`) while the code comments use dots (`1475.13`) — preserved exactly as found; no separator rule follows from this. A portal note warns versions and products (ERP vs. HCM) may differ and to always validate on your system version.

## Dividir and RestoDivisao

`Dividir` purpose: division with error control for division by zero.

Signature (source-faithful):

```lsp
Dividir(<dividendo>, <divisor>, <resultado>);
```

No parameter glosses and no dedicated example are given; the zero-division error control is stated but its diagnostics are not. Do not infer them.

`RestoDivisao` purpose: the remainder of a division (modulo operation).

Signature (source-faithful):

```lsp
RestoDivisao(<dividendo>, <divisor>, <resto>);
```

Parameters (from the operators section):

- `dividendo` — input. Field/variable being divided.
- `divisor` — input. Field/variable dividing it.
- `resto` — output. Variable receiving the remainder.

Example (source-faithful):

```lsp
Definir Numero vnDividendo;
Definir Numero vnDivisor;
Definir Numero vnResto;

vnDividendo = 1500;
vnDivisor = 400;

RestoDivisao(vnDividendo, vnDivisor, vnResto);
@ vnResto will be 300 @
```

Stated constraint: input values must obligatorily be integers. Syntax restated as `RestoDivisao(Dividendo, Divisor, Resto);`. All 16 occurrences use the 3-argument output-parameter shape.

## Formatar and FormatarN

Number formatting in the style of Borland Delphi 2.0. These format for textual presentation; they are not type conversions (see conversion.md for the distinction policy).

`Formatar` signature (source-faithful, direct return):

```lsp
<variável> = Formatar(<dado>, "<formato>");
```

Parameters:

- `dado` — input. Numeric variable to convert.
- `formato` — input. Conversion format. Demonstrated: `%3.0f` for value 354 and `%3.2f` for value 345,43.

Example (source-faithful):

```lsp
Definir Alfa vaFmt;
vaFmt = Formatar(123, "%s");
```

`FormatarN` signature (source-faithful, output parameter):

```lsp
FormatarN(<dado>, "<formato>", "<separador decimal>", <variável>);
```

Parameters:

- `dado` — input. Numeric variable to convert.
- `formato` — input. Conversion format.
- `separador decimal` — input. The decimal-places separator to use.
- `variável` — output. Stores the formatting result.

Example (source-faithful):

```lsp
Definir Alfa vaFmt;
FormatarN(123, "%3.2f", ".", vaFmt);
```

Return behavior differs as shown: `Formatar` assigns directly, `FormatarN` fills its fourth argument. Only the demonstrated masks (`%s`, `%3.0f`, `%3.2f`, separator `"."`) are documented — never invent tokens or explain Delphi semantics.

## Extenso and ExtensoMoeda

Value-to-words functions with numeric input and `Alfa` line outputs.

`Extenso` purpose: generate the words ("extenso") of a value.

Signature (source-faithful):

```lsp
Extenso(<valor>, <tamanhoLinha1>, <tamanhoLinha2>, <tamanhoLinha3>, <linha1>, <linha2>, <linha3>);
```

Parameters:

- `valor` — input. Field/variable whose words are wanted.
- `tamanhoLinha1/2/3` — inputs. Character counts used on each line for generating the words.
- `linha1/2/3` — outputs. Variables receiving each words line.

Stated constraint: at most two decimal places after the comma are covered; three or more are rounded to the two-place real value.

Example (source-faithful):

```lsp
Definir Alfa vaExtLin1;
Definir Alfa vaExtLin2;
Definir Alfa vaExtLin3;
Definir Numero vnQuantidade;

vnQuantidade = 1577350;
Extenso(vnQuantidade, 30, 30, 30, vaExtLin1, vaExtLin2, vaExtLin3);
@ vaExtLin1 = "Um milhao, quinhentos e ******" @
@ vaExtLin2 = "setenta e sete mil e *********" @
@ vaExtLin3 = "trezentos e cinquenta reais **" @
```

`ExtensoMoeda` purpose: generate the words of a value with a stated currency.

Signature (source-faithful):

```lsp
ExtensoMoeda(<vlrExt>, <tamLn1>, <tamLn2>, <tamLn3>, <moeIS>, <moeIP>, <moeDS>, <moeDP>, <extLn1>, <extLn2>, <extLn3>);
```

Parameters:

- `vlrExt` — input. Field/variable whose words are wanted.
- `tamLn1/2/3` — inputs. Character counts per words line.
- `moeIS` / `moeIP` — inputs. Currency, integer part singular / plural.
- `moeDS` / `moeDP` — inputs. Currency, decimal part singular / plural.
- `extLn1/2/3` — outputs. Variables receiving each words line.

Example (source-faithful):

```lsp
Definir Alfa vaExtLin1;
Definir Alfa vaExtLin2;
Definir Alfa vaExtLin3;
Definir Numero vnValorSalario;

vnValorSalario = 1577.95;
ExtensoMoeda(vnValorSalario, 30, 30, 30, "dólar", "dólares", "cent", "cents", vaExtLin1, vaExtLin2, vaExtLin3);
@ vaExtLin1 = "um mil, quinhentos e setenta *" @
@ vaExtLin2 = "e sete dólares e noventa e ***" @
@ vaExtLin3 = "cinco cents ******************" @
```

Demonstrated outputs are Portuguese words — recorded as demonstrated output, not as a specified output language (the source never states one). The `*` padding and line-splitting mechanics beyond the size parameters are undocumented.

## MultiplicaValor

Purpose: multiply a number in alphanumeric format by a numeric multiplication factor, returning the result in an alphanumeric variable.

Signature (source-faithful):

```lsp
MultiplicaValor(<multiplicando>, <fator>, <retorno>);
```

Parameters:

- `multiplicando` — input. Field/variable holding the value to multiply.
- `fator` — input. Field/variable holding the multiplication factor.
- `retorno` — output. Field/variable returning the multiplication result.

Example (source-faithful):

```lsp
Definir Alfa vaNumOriginal;
Definir Alfa vaNumMultiplicado;
Definir Numero vnFator;

vaNumOriginal = "0000237259400000216555";
vnFator = 5;
MultiplicaValor(vaNumOriginal, vnFator, vaNumMultiplicado);
@ vaNumMultiplicado will be "1186297000001082775" @
```

This function is documented here (not in conversion) because its purpose is multiplication; its `Alfa` input/output is part of that purpose, not a general conversion license. A cheat-sheet line confirms the same shape (`MultiplicaValor(vaNumero, vnFator, vaResultado);` glossed as numeric-string multiplication). Precision, overflow, and decimal handling are undocumented.

## ConverteUnidadeMedida

Purpose: compute the converted quantity from one measure unit (from) to another (to).

Signature (source-faithful):

```lsp
ConverteUnidadeMedida(<codPro>, <codDer>, <uniMedDe>, <uniMedPara>, <qtde>, <codFor>, <qtdDec>, <codEmp>, <qtdCnv>);
```

Parameters:

- `codPro` — input, optional. Product code.
- `codDer` — input, optional. Derivation code.
- `uniMedDe` — input, required. Origin measure unit.
- `uniMedPara` — input, required. Destination measure unit.
- `qtde` — input, required. Quantity to convert.
- `codFor` — input, optional. Supplier code.
- `qtdDec` — input, required. Decimal count used in the conversion; if precision is unknown, inform 5.
- `codEmp` — input, optional. Company code; if zero is informed, the logged-in company is used.
- `qtdCnv` — output. Converted quantity from origin to destination unit.

Example (source-faithful):

```lsp
Definir Numero vnQtdConv;
ConverteUnidadeMedida("", "", "KM", "M", 100, 0, 3, 0, vnQtdConv);
@ vnQtdConv will be 100000 (100 km = 100000 metros) @
```

Classification note: product, supplier, and company parameters are Senior-ecosystem identifiers whose business semantics belong to a future Senior domain; the function is documented here because its primary purpose is unit-quantity conversion and no Senior domain exists yet. Conversion factors, supported units, and rounding are undocumented — only the demonstrated KM-to-M case is evidenced.

## Deferred (inspected, not this domain)

- `IntParaAlfa`, `DecimalParaAlfa` (display helpers in numeric examples): conversion slice owns them.
- `HoraParaMinuto`: conversion slice owns it (numeric time-unit conversion, referenced here only by name).
- `DataHora` fractional math, `vnData = vdData;` assignment: dates-time owns representation questions.
- `DeixaNumeros`, `VrfAbrA`/`VrfAbrN`: validation domain.
- `RestoDivisao` is owned here; `%` stays non-existent.
- `aleatorio` (lowercase, in `Aleatorio.lsp`): a community user function, not a builtin — never document it as one. Its body demonstrates `Truncar` on expressions and `RestoDivisao` partitioning consistent with this page.

## Conflicts and uncertainty on this page

1. `Arredonda Valor Tipo Acerto` (spaced, 5 occurrences with working example) vs. `ArredondaValorTipoAcerto` (unspaced, 4 occurrences with working example and a "nome com espaços" remark). Both attested; unresolved.
2. `ArredondarValorEx` has usage notes and an example but no specification; its equivalence to `ArredondarValor` is environment-dependent ("in test", "many environments") plus a version/product variance warning (ERP vs. HCM).
3. `Arredonda`'s literal-vs-variable precision caution ("if the debugger or compiler is sensitive") is conditional and unresolved.
4. A community example nests `Truncar(...)` over an arithmetic expression and notes precision caution around `Arredonda` with zero decimals ("evita 2 virar 1") — observed community caution, not specified behavior.
5. `Formatar` returns directly while `FormatarN` uses an output parameter; no unifying rule is stated.
6. Comma-vs-dot decimals across examples (`1475,13` in prose vs. `1475.13` in code comments; `"123,45"` conversion input) imply nothing universal — no separator rule is documented.

## Deliberately not documented

Rounding modes beyond the ABNT rules as stated, precision/scale/storage/overflow semantics, negative-number and exact-half behavior outside the ABNT patterns, error diagnostics (including division-by-zero handling beyond its existence), mask languages beyond demonstrated tokens, output language of words functions, padding mechanics, unit catalogs and factors, holiday/business calendars, and random-number builtins (none documented).

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Operações Matemáticas e Formatação` (`MultiplicaValor`, `ConverteUnidadeMedida`, `Arredonda` with in-place OBS, `ArredondaABNT` with rules, `ArredondarValor` with `Ex` note, spaced `Arredonda Valor Tipo Acerto`), `Operações Numéricas Avançadas` (rounding summary with `End`-parameter semantics and version warning, `ArredondarValorEx`/`ArredondaValorTipoAcerto` examples, `Truncar` section with financial example, `Dividir`, `RestoDivisao`), `Operadores` (operator inventory and `%` absence), `Extenso`/`ExtensoMoeda` sections, `Formatar`/`FormatarN` sections, quick-reference arithmetic and math lines, cheat-sheet math/extenso lines, troubleshooting pairs, and `Aleatorio.lsp` (community user function inspected for `Truncar`/`RestoDivisao` consistency). Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
