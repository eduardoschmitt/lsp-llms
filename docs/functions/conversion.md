# LSP type conversion functions

Scope: functions whose primary documented purpose is converting a value between types or representations: `Alfa`-to-`Numero` and `Numero`-to-`Alfa` (integer and decimal), `Alfa`-to-`Data`, masked conversion to `Alfa`, hour/minute-to-minutes, and the observed-but-unspecified date helpers `ConvDataInt`/`ConvDataExt`.

> Critical guidance for AI consumers: conversion direction, parameter order, and parameter direction are exactly as shown. The general shape is `Function(source, destination)` with an output parameter — never rewrite it as `destination = Function(source)`. Never generate intuitive names such as `NumeroParaAlfa` or `AlfaParaNumero`: zero occurrences exist in the source. Plain assignment between differently typed variables is not a conversion rule (see Assignment is not conversion).

## Conversion matrix (evidence only)

| Source | Target | Function | Behavior |
|---|---|---|---|
| `Numero` (integer part used) | `Alfa` | `IntParaAlfa` | output parameter |
| `Numero` (integer part used) | `Alfa` | `IntParaStr` | output parameter (stated equivalent of `IntParaAlfa`) |
| `Alfa` | `Numero` (integer) | `AlfaParaInt` | output parameter |
| `Alfa` | `Numero` (integer) | `StrParaInt` | output parameter (stated equivalent of `AlfaParaInt`) |
| `Numero` (decimals preserved) | `Alfa` | `DecimalParaAlfa` | output parameter |
| `Alfa` (Brazilian comma format) | `Numero` (decimal) | `AlfaParaDecimal` | output parameter |
| `Alfa` | `Data` | `AlfaParaData` | output parameter |
| `Numero`, `Data`/time value, or `Alfa` | `Alfa` (masked) | `ConverteMascara` | output parameter |
| hour + minute values | `Numero` (total minutes) | `HoraParaMinuto` | output parameter |
| `Alfa` date text | `Numero` date value | `ConvDataInt` | observed 2-argument shape only, unspecified |
| `Numero` date value | `Alfa` date text | `ConvDataExt` | observed 2-argument shape only, unspecified |

No symmetric counterpart may be assumed from any row. In particular, `NumeroParaAlfa` and `AlfaParaNumero` do not occur anywhere in the source and must not be generated.

On `Int` vs `Numero`: the source documents `Numero` as covering integers and decimals (`variables.md`), and `IntParaAlfa` as dropping decimal places. No distinct integer primitive type is documented; the `Int` prefix is naming only, not type-system evidence.

## IntParaAlfa

Purpose: convert an integer value to alphanumeric.

Signature (source-faithful):

```lsp
IntParaAlfa(<inteiro>, <texto>);
```

Parameters:

- `inteiro` — input. Integer value to convert.
- `texto` — output. `Alfa` variable receiving the result.

Example (source-faithful):

```lsp
Definir Numero vnInteiro;
Definir Alfa vaTexto;

vnInteiro = 123;
IntParaAlfa(vnInteiro, vaTexto); @ vaTexto will be "123" @
```

Source observations: `IntParaAlfa` drops the decimal places of a `Numero`. For fractional values use `DecimalParaAlfa` instead — for messages and logs with monetary amounts, weights, prices, or any non-integer `Numero`, prefer `DecimalParaAlfa` so decimal places are not lost.

Return behavior: output parameter. Every 1-argument or directly-assigned form in the source (`vaResultado = IntParaAlfa(vnNumero);`, `IntParaAlfa(vnIdade)` inside message parameters) sits inside a documented-incorrect block — with one exception noted under conflicts.

Conflict note: one presented-as-working file-processing example nests the call inside a concatenation expression:

```lsp
vaConteudo = "Linha " + IntParaAlfa(vnContador) + " do arquivo temporário";
```

This contradicts the output-parameter classification and the `Alfa`-only concatenation rule. Preserved as observed contradiction; the safe pattern remains the two-argument form with a prior conversion. (The same example also passes arithmetic and concatenation inside a later `AtualizaBarraProgresso(...)` call — further evidence for the parameters dispute in `../guides/limitations.md` L3, not resolved here.)

## AlfaParaInt and StrParaInt

Purpose: convert an alphanumeric value to integer.

Signatures (source-faithful):

```lsp
AlfaParaInt(<texto>, <inteiro>);
StrParaInt(<texto>, <inteiro>);
```

Parameters (`AlfaParaInt`; `StrParaInt` glosses identically):

- `texto` — input. Alphanumeric value to convert.
- `inteiro` — output. Variable receiving the converted value.

Examples (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Numero vnInteiro;

vaTexto = "123";
AlfaParaInt(vaTexto, vnInteiro); @ vnInteiro will be 123 @
```

```lsp
Definir Alfa vaTexto;
Definir Numero vnInteiro;

vaTexto = "456";
StrParaInt(vaTexto, vnInteiro); @ vnInteiro will be 456 @
```

Source notes: `StrParaInt` is stated equivalent to `AlfaParaInt` and kept for compatibility. Both carry the same grid/table intermediate-variable requirement as `AlfaParaDecimal` (see below). Return behavior: output parameter; all 12 + 4 occurrences consistent.

## DecimalParaAlfa and IntParaStr

`DecimalParaAlfa` purpose: convert a `Numero` value to alphanumeric preserving the decimal part in the resulting string (displayed per the environment).

Signature (source-faithful):

```lsp
DecimalParaAlfa(<numero>, <texto>);
```

Parameters:

- `numero` — input. `Numero` value, integer or with decimals.
- `texto` — output. `Alfa` variable receiving the textual representation.

Example (source-faithful):

```lsp
Definir Numero vnValor;
Definir Alfa vaTexto;

vnValor = 123.45;
DecimalParaAlfa(vnValor, vaTexto); @ vaTexto suitable for displaying the decimal @
```

`IntParaStr` purpose: convert an integer value to alphanumeric (`String`). Stated equivalent of `IntParaAlfa`, kept for compatibility.

Signature (source-faithful):

```lsp
IntParaStr(<inteiro>, <texto>);
```

Parameters:

- `inteiro` — input. Integer value to convert.
- `texto` — output. Alphanumeric variable receiving the result.

Example (source-faithful):

```lsp
Definir Numero vnInteiro;
Definir Alfa vaTexto;

vnInteiro = 789;
IntParaStr(vnInteiro, vaTexto); @ vaTexto will be "789" @
```

Return behavior: output parameter for both; all occurrences consistent (27 and 4; the single 1-argument `DecimalParaAlfa()` occurrence is a prose mention, not a call).

## AlfaParaDecimal

Purpose: convert an alphanumeric value to decimal.

Signature (source-faithful):

```lsp
AlfaParaDecimal(<texto>, <decimal>);
```

Parameters:

- `texto` — input. Alphanumeric value to convert (Brazilian format with comma).
- `decimal` — output. Variable receiving the converted value.

Example (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Numero vnDecimal;

vaTexto = "123,45";  @ Brazilian format with comma @
AlfaParaDecimal(vaTexto, vnDecimal); @ vnDecimal will be 123.45 @
```

Grid/table requirement (source-faithful incorrect/correct pair — the same pattern is cited for `AlfaParaInt`, `StrParaInt`, `IntParaStr`, and `AlfaParaData`):

```lsp
@ Incorrect - Does not work directly in grid fields @
AlfaParaDecimal(vaTexto, MinhaGrid.CampoDecimal);

@ Correct - Use an intermediate variable @
Definir Numero vnValor;
AlfaParaDecimal(vaTexto, vnValor);
MinhaGrid.CampoDecimal = vnValor;
```

Return behavior: output parameter; conversion output must land in a plain variable first, never directly in a grid/table field.

## AlfaParaData

Purpose: convert an alphanumeric value to the `Data` type.

Signature (source-faithful):

```lsp
AlfaParaData(<texto>, <data>);
```

No parameter glosses are given.

Example (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Data vdData;

vaTexto = "01/01/2020";
AlfaParaData(vaTexto, vdData); @ vdData will be 01/01/2020 @
```

Source note: for grids/tables use an intermediate variable as shown under `AlfaParaDecimal`. Return behavior: output parameter; all 5 occurrences consistent. Date semantics (validity, formats beyond the demonstrated `"01/01/2020"`) belong to `dates-time.md`, which owns the date-assignment rules and conflicts.

## ConverteMascara

Purpose: convert an input value (numeric, date, time, or character string) to a character-string value with a presentation mask.

Signature (source-faithful):

```lsp
ConverteMascara(<tipoDado>, <valorOrigem>, <alfaDestino>, <mascara>);
```

Parameters:

- `tipoDado` — input. Code for the origin value's type: `1` number, `2` money (value), `3` date, `4` time, `5` Alfa.
- `valorOrigem` — input. Field/variable/value to convert.
- `alfaDestino` — output. Variable receiving the conversion result.
- `mascara` — input. Specifies the result's presentation format.

Example, CPF and CNPJ (source-faithful):

```lsp
Definir Alfa vaInscricaoStr;
Definir Numero vnNumCgc;
Definir Numero vnTipoInscricao;

vnNumCgc = 12345678901;
vnTipoInscricao = 3; @ CPF @

Se (vnTipoInscricao = 1) { @ CNPJ @
  ConverteMascara(1, vnNumCgc, vaInscricaoStr, "99.999.999/9999-99");
} Senao Se (vnTipoInscricao = 3) { @ CPF @
  ConverteMascara(1, vnNumCgc, vaInscricaoStr, "999.999.999-99");
}
@ vaInscricaoStr will be "123.456.789-01" @
```

Source observation: when the data type is 5 (Alfa), `valorOrigem` is passed as 0 (zero) and `alfaDestino` receives the Alfa field to convert, then holds the conversion result. Mask strings (`"999.999.999-99"`, `"99.999.999/9999-99"`, `"99999999"`) are demonstrated literals; no mask-token specification is documented — do not invent mask syntax. Return behavior: output parameter; all 37 calls use 4 arguments. A community HTTP example demonstrates `ConverteMascara(1, vnCepApi, vaCepApi, "99999999");`.

## HoraParaMinuto

Purpose: convert hour and minute values into total minutes.

Signature (source-faithful):

```lsp
HoraParaMinuto(<hora>, <minuto>, <minutos>);
```

Parameters:

- `hora` — input. Whole-hour value.
- `minuto` — input. Minute value within the hour.
- `minutos` — output. Variable receiving the total in minutes.

Example (source-faithful):

```lsp
Definir Numero vnResultado;
Definir Alfa vaResultadoStr;
Definir Alfa vaMensagem;

HoraParaMinuto(1, 30, vnResultado);
IntParaAlfa(vnResultado, vaResultadoStr);

@ vnResultado will be 90 (1 hour and 30 minutes = 90 minutes) @
vaMensagem = "Resultado: " + vaResultadoStr + " minutos";
Mensagem(Retorna, vaMensagem);
```

Return behavior: output parameter. The 2-argument form `vnResultado = HoraParaMinuto(1, 30);` appears exactly once, inside a documented-incorrect block. This function converts time units numerically; clock/time-of-day semantics belong to future domains.

## ConvDataInt and ConvDataExt (observed only)

Status: used in business-day examples with no dedicated documentation section. Recorded here as observed shapes, not specified APIs.

Observed usage (source-faithful excerpts):

```lsp
vaDataAlf = "25/12/2024";
ConvDataInt(vaDataAlf, vnData);
```

```lsp
ConvDataExt(vnDataAnt, vaDataAntStr);
ConvDataExt(vnDataPos, vaDataPosStr);
```

```lsp
vaDataOriginal = "20/12/2024";
ConvDataInt(vaDataOriginal, vnData);

@ Applies the UltimoDia function @
UltimoDia(vnData);

@ Converts the result to string @
ConvDataExt(vnData, vaDataUltimoDia);
```

What can be said: both appear with exactly 2 arguments; the first position consistently holds the source representation and the second receives into the other representation. Parameter direction, types beyond the demonstrated `Alfa`/`Numero` variables, validity rules, and format support are undocumented — directions are therefore classified unknown. Do not present these as established conversion APIs.

## Conversion failures (source-backed)

- Wrong-target assignment: `Definir Numero vnValor;` then `vnValor = "123";` is marked incorrect; fix with `AlfaParaInt` (troubleshooting pair, preserved in limitations).
- `Numero` in concatenation: `vaMensagem = "Idade: " + vnIdade;` is a concatenation error; fix with `IntParaAlfa` first.
- Output-parameter misuse: `vaResultado = IntParaAlfa(vnNumero);` and `vnResultado = HoraParaMinuto(1, 30);` are documented errors; use the destination-parameter forms.
- Intuitive names: `NumeroParaAlfa` and `AlfaParaNumero` occur zero times in the entire source (README plus all 32 examples, re-confirmed for this slice). Generating them is hallucination, not conversion.
- No runtime diagnostics, error codes, or failure values for invalid conversion input are documented — do not invent any.

## Assignment is not conversion

Demonstrated `Data`-to-`Numero` assignments (`vnDataSis = DatSis;`, `vnDataAtual = vdDataBase;`, `vnDataVencimento = vdDataVencimento;`) show assignment working across types in those examples, but the source defines no implicit-conversion rule. They are observations attached to `dates-time.md`, not conversion semantics, and no symmetric or general rule follows from them.

## Deferred (inspected, not this domain)

- `CaracterParaAlfa`, `RetornaAscII`: ASCII/character conversion — documented in `strings.md`.
- `ConverteCodificacaoString`, `ConverteTexto`: encoding conversion — documented in `strings.md`.
- `ConverteDataBanco`, `ConverteDataToDB`, `ConverteDataSqlSenior2`: database string forms — documented in `dates-time.md`.
- `CodData`, `DecodData`, `DesMontaData`, `MontaData`: date construction/decomposition — documented in `dates-time.md`.
- `Formatar`, `FormatarN`: Delphi-style number formatting — future numbers domain (formatting, not conversion per the representation distinction).
- `RestoDivisao`, `Dividir`, `Truncar`, `Arredonda*`: numeric operations — future numbers domain.
- `DeixaNumeros` (keep only digits): validation domain.
- `Extenso`, `ExtensoMoeda`: value-to-words — future numbers domain.

## Conflicts and uncertainty on this page

1. The `IntParaAlfa`-in-concatenation working example (file-processing section) vs. output-parameter classification and the `Alfa`-only concatenation rule. Preserved; safe pattern is the 2-argument form.
2. `MontaData`'s 4th parameter accepts `Numero` or `Data`, and a numeric return variable "need not be defined" — recorded in `dates-time.md`; its interaction with `AlfaParaData`'s `Data`-only output is unstated.
3. `ConvDataInt`/`ConvDataExt` have consistent observed shapes but no prose specification; classified unknown rather than promoted.
4. `IntParaAlfa`'s decimal-dropping is stated; rounding vs. truncation mechanism, negative handling, and invalid-input behavior are unstated.

## Deliberately not documented

Rounding/truncation mechanisms, decimal and thousands separators (beyond the demonstrated Brazilian comma input), locale, precision, overflow, invalid-input/empty-string behavior, mask-token language, money/date/time input formats beyond demonstrated literals, and any implicit conversion rules — none stated, none inferred. Demonstrated literals (`"123,45"`, `"999.999.999-99"`, `"25/12/2024"`) are examples, not format specifications.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Cast de Variável` in full (`AlfaParaData`, `AlfaParaDecimal` with grid pair, `AlfaParaInt`, `IntParaAlfa` with decimal-dropping note, `DecimalParaAlfa`, `StrParaInt`/`IntParaStr` equivalence statements, `ConverteMascara` with type codes and tipo-5 observation), `HoraParaMinuto` section with numeric-validation example, quick-reference conversion card (consistent arities), troubleshooting pairs (undeclared-variable fix, type-mismatch assignment, `Numero` concatenation, output-parameter misuse, cheat-sheet traps), limitation sections (return-parameter table, grid rule, golden-rule examples), date sections for cross-evidence (`MontaData` numeric observation, `Data`to`Numero` assignments, `ConvDataInt`/`ConvDataExt` usages, `FormatarData`-adjacent notes), and `BuscarCepAPI.lsp` (`ConverteMascara` usage). Repository-wide name/arity/contradiction sweeps covered the README plus all `exemplos/*.lsp`. Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
