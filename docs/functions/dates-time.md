# LSP date and time functions

Scope: current date/time, date construction and decomposition, date formatting, date arithmetic and comparison as documented, weekday and business-day functions, and `Data`-related conversion helpers. `Data` type fundamentals live in `../language/variables.md`.

> Critical guidance for AI consumers: this domain contains source contradictions (especially `DataHoje` output type, date literals, and `FormatarData` input). Follow only the forms given here, heed every conflict note, and verify against official Senior documentation before relying on disputed behavior. Never import calendar, epoch, timestamp, or formatting semantics from other languages.

## Representations in play

The source uses two date representations without ever defining the relationship between them:

- `Data` variables (e.g. `Definir Data vdData;`), manipulated with `DataHoje`, `MontaData`, `CodData`, comparisons, and direct arithmetic.
- Fractional `Numero` values where "the integer part is the date and the fraction is the hours" (from `DataHora`/`DataHoraUTC`), used with `FormatarData`, `Truncar` extraction, and business-day functions.

What is not documented: the epoch or origin of the day count, timezones (except that `DataHoraUTC` is UTC), calendar rules, valid year ranges, precision, storage, null/zero-date behavior. "Quantidade de dias" since an unspecified origin is the full extent of the representation evidence. Do not assume Unix timestamps, Delphi date numbers, or any other external encoding.

Demonstrated-but-unspecified interchange: `Numero` variables receive date values by plain assignment more than once (`vnDataSis = DatSis;`, `vnDataAtual = vdDataBase;`, `vnDataVencimento = vdDataVencimento;`). No conversion function is used in these lines and no rule explains them; treat cross-type assignment as demonstrated, not specified.

## DataHoje

Purpose: obtain the current system date (date only, no time).

Signature (source-faithful):

```lsp
DataHoje(<data>);
```

Parameters: the section names only `<data>` with no direction gloss.

Documentation conflict (unresolved): the overwhelming majority of usages fill a `Data` variable —

```lsp
DataHoje(vdDataAtual);
```

and the quick guide assigns `DataHoje` to `Data` — but two presented-as-working examples fill a `Numero` variable:

```lsp
Definir Numero vnDataHoje;
DataHoje(vnDataHoje);
```

```lsp
Definir Numero xHoje;
DataHoje(xHoje);
```

(A quick-reference card writes `DataHoje(data)` with a generic lowercase placeholder, which is not type evidence.) Whether `DataHoje` can fill a `Numero` is unresolved: about seventeen `Data`-typed usages against two `Numero`-typed ones. Follow the `Data` form.

## DataHora and DataHoraUTC

Purpose: return the current date and time as a fractional number. `DataHoraUTC` is the UTC (Tempo Universal Coordenado) variant.

Signatures (source-faithful):

```lsp
DataHora(<numeroDataHora>);
DataHoraUTC(<numeroDataHoraUTC>);
```

Parameters:

- `numeroDataHora` — output. `Numero` variable receiving the current date and time.
- `numeroDataHoraUTC` — output. `Numero` variable receiving the current UTC date and time.

Documented representation: the integer part is the date (a day count from an unspecified origin) and the fractional part is the time of day. Hour fractions are given explicitly:

- 1 hour: 1/24 = 0.04166666666
- 1 minute: 1/24/60 = 0.00069444444
- 1 second: 1/24/60/60 = 0.00001157407

Example (source-faithful excerpt):

```lsp
@ 2. Obtém data e hora local (número fracionário) @
DataHora(vnDataHoraAtual);
IntParaAlfa(vnDataHoraAtual, vaNumeroStr);

@ 3. Obtém data e hora UTC (número fracionário) @
DataHoraUTC(vnDataHoraUTC);
```

Time-of-day extraction via `Truncar` (source-faithful excerpt; `Truncar` itself is classified in `../guides/limitations.md`):

```lsp
@ Calcular apenas a parte fracionária (horas do dia) @
vnSomenteParte = vnDataHoraAtual - Truncar(vnDataHoraAtual);
vnHoras = vnSomenteParte * 24;
```

And (source-faithful excerpt):

```lsp
@ Nota: Use conversão para inteiro ou função Truncar @
vnParteInteira = Truncar(vnDataHora);
vnParteFracionaria = vnDataHora - vnParteInteira;
```

Source notes: both functions fill a `Numero` variable (output parameter). Do not treat the value as milliseconds, Unix time, or any dated epoch — the source never states one. One line describes `FormatarData` as formatting "millissegundos gerada pela função DataHora", contradicting the fractional-day account everywhere else; see `FormatarData` conflicts.

## Date literals and direct assignment

Documentation conflict (unresolved): one troubleshooting section marks direct date assignment incorrect —

```lsp
@ Incorrect @
vdData = 15/08/1990;
```

with `MontaData()` or `CodData()` as the fix — yet three presented-as-working examples assign day/month/year-looking values directly to `Data` variables:

```lsp
Definir Alfa vaDataStr;
Definir Data vdData;

vdData = 31/12/1900;
ConverteDataBanco(vdData, vaDataStr);
@ vaDataStr = "to_date('31/12/1900','DD/MM/YYYY')" ou formato do banco usado @
```

```lsp
Definir Alfa vaDataStr;
Definir Data vdData;

vdData = 31/12/1900;
ConverteDataToDB(vdData, vaDataStr);
@ vaDataStr = "to_date('31/12/1900','DD/MM/YYYY')" ou formato do banco usado @
```

```lsp
Definir Data vdData;
Definir Numero vnBissexto;

vdData = 02/07/2018;
AnoBissexto(vdData, vnBissexto);
@ vnBissexto será 0 (não bissexto) @
```

These are exactly four `Data`-variable assignments of `DD/MM/YYYY`-shaped values in the whole source: one labeled incorrect, three embedded without remark in conversion/leap-year examples. Whether `vdData = 31/12/1900;` is a date literal, an arithmetic expression the engine interprets, or simply an error in the examples cannot be established from the available material. Do not generate date literals; use `MontaData` or `CodData`, the only assignment mechanisms with explicit correct examples. The `to_date(...)` output strings are embedded database-dialect content, not LSP semantics.

## MontaData

Purpose: build a date from three variables, writing the result into a fourth parameter. Explicitly contrasted with `CodData` (which returns the date): `MontaData` writes to the 4th parameter.

Signature (source-faithful):

```lsp
MontaData(<dia>, <mes>, <ano>, <data>);
```

Parameters:

- `dia` — input. Day of the date to generate.
- `mes` — input. Month of the date to generate.
- `ano` — input. Year of the date to generate (must have 4 digits, e.g. 1998).
- `data` — output. Variable of type `Numero` or `Data` receiving the result.

Example (source-faithful):

```lsp
Definir Numero vnDia;
Definir Numero vnMes;
Definir Numero vnAno;
Definir Data vdData;

vnDia = 1;
vnMes = 9;
vnAno = 1998;

MontaData(vnDia, vnMes, vnAno, vdData);
@ vdData conterá "01/09/1998" @
```

Source observation: when the return variable is numeric it need not be defined with `Definir`; but if used in a cursor it must be defined as `Data`. The quoted result `"01/09/1998"` is a display form, not a claim about internal representation.

## CodData

Purpose: compose a date from day, month, and year. Returns the date (use in assignment).

Signature (source-faithful, direct return):

```lsp
vdData = CodData(<dia>, <mes>, <ano>);
```

Parameters:

- `dia` — input. Day value.
- `mes` — input. Month value.
- `ano` — input. Year value.

Example (source-faithful):

```lsp
Definir Data vdData;
Definir Numero vnDia;
Definir Numero vnMes;
Definir Numero vnAno;

vnDia = 10;
vnMes = 1;
vnAno = 2002;

vdData = CodData(vnDia, vnMes, vnAno);
```

Return behavior: direct return into a `Data` variable — a documented exception to the output-parameter default (also listed in `../guides/limitations.md` L2). Used with literals (`vdDataBase = CodData(21, 7, 2024);`) and with variables alike.

## DesMontaData and DecodData

Both decompose a date into day, month, and year. The source gives them near-identical shapes and no distinguishing semantics.

Signatures (source-faithful):

```lsp
DesMontaData(<data>, <dia>, <mes>, <ano>);
DecodData(<data>, <dia>, <mes>, <ano>);
```

`DesMontaData` parameters:

- `data` — input. Field/variable to decompose.
- `dia`, `mes`, `ano` — outputs. `Numero` variables receiving the day, month, and year.

Example (source-faithful):

```lsp
Definir Data vdDataEmissao;
Definir Numero vnDia;
Definir Numero vnMes;
Definir Numero vnAno;

vdDataEmissao = E140NFV.DatEmi;
DesMontaData(vdDataEmissao, vnDia, vnMes, vnAno);
@ Se a data fosse 24/04/1995: vnDia=24, vnMes=04, vnAno=1995 @
```

`DecodData` has a signature block but no parameter glosses and no dedicated example; it is exercised in validation examples through the same `(data, dia, mes, ano)` shape. Do not treat the two as interchangeable on semantic grounds — the source never says that — but no behavioral difference is documented either.

## ConverteDataBanco, ConverteDataToDB, ConverteDataSqlSenior2

Purpose: convert a date to a database-query string form. All three write into an `Alfa` variable.

Signatures (source-faithful):

```lsp
ConverteDataBanco(<datNum>, <datAlf>);
ConverteDataToDB(<datNum>, <datAlf>);
ConverteDataSqlSenior2(<datNum>, <datSql>);
```

Parameters (`ConverteDataBanco` / `ConverteDataToDB`):

- `datNum` — input. Table field or variable to convert.
- `datAlf` — output. `Alfa` variable holding the conversion result.

`ConverteDataSqlSenior2` parameters:

- `datNum` — input. Date to convert.
- `datSql` — output. Date in SQL Senior 2 format.

Examples (source-faithful; both embed the disputed literal assignment from the literals conflict):

```lsp
Definir Alfa vaDataStr;
Definir Data vdData;

vdData = 31/12/1900;
ConverteDataBanco(vdData, vaDataStr);
@ vaDataStr = "to_date('31/12/1900','DD/MM/YYYY')" ou formato do banco usado @
```

```lsp
Definir Alfa vaSqlAux;
ConverteDataSqlSenior2(DatSis, vaSqlAux);
vaSqlAux = "E000LPA.DATINI = " + vaSqlAux;
InsClauSQLWhere("Detalhe_000LPA", vaSqlAux);
```

Source hierarchy note: use `ConverteDataSqlSenior2` instead of `ConverteDataToDB` and `ConverteDataBanco` when inserting a date into a SQL Senior 2 command. The `to_date(...)` strings are embedded database-dialect output, not LSP behavior. `DatSis` (system date) is demonstrated directly as the input here.

## AnoBissexto

Purpose: report whether the year of a given base date is a leap year.

Signature (source-faithful):

```lsp
AnoBissexto(<data>, <bissexto>);
```

Parameters:

- `data` — input. Base date to check.
- `bissexto` — output. `0` if the year is not a leap year, `1` if it is.

Example (source-faithful; embeds the disputed literal assignment):

```lsp
Definir Data vdData;
Definir Numero vnBissexto;

vdData = 02/07/2018;
AnoBissexto(vdData, vnBissexto);
@ vnBissexto será 0 (não bissexto) @
```

No calendar rules beyond this mapping are documented.

## FormatarData

Purpose: format a date value into an `Alfa` string per a mask.

Signature (source-faithful):

```lsp
FormatarData(<data>, <formato>, <dataFormatada>);
```

Parameters:

- `data` — input. Numeric date value (`Numero`).
- `formato` — input. Format mask (`Alfa`).
- `dataFormatada` — output. `Alfa` variable receiving the formatted date.

Type restriction: `FormatarData` accepts only `Numero` (from `DataHora`), not `Data`. The incorrect/correct pair (source-faithful):

```lsp
@ Incorrect: FormatarData does NOT accept the Data type @
Definir Data vdData;
DataHoje(vdData);
FormatarData(vdData, "dd/MM/yyyy", vaFormatada); @ Error! @

@ Correct: use DataHora (returns Numero) @
Definir Numero vnDataHora;
DataHora(vnDataHora);
FormatarData(vnDataHora, "dd/MM/yyyy", vaFormatada); @ Works! @
```

Official-documentation example quoted in the source (source-faithful):

```lsp
Definir Numero vnDataHora;        @ NUMERO type required @
Definir Alfa vaDataFormatada;

@ DataHora returns a fractional number @
DataHora(vnDataHora);

@ FormatarData accepts NUMERO, not Data @
FormatarData(vnDataHora, "yyyy-MM-dd'T'HH:mm:ss'Z'", vaDataFormatada);
@ Result: "2024-01-15T14:30:45Z" @
```

Demonstrated masks (source-faithful excerpt):

```lsp
@ Brazilian format @
FormatarData(vnDataHora, "dd/MM/yyyy", vaFormatoBR);

@ American format @
FormatarData(vnDataHora, "MM/dd/yyyy", vaFormatoUS);

@ ISO 8601 format @
FormatarData(vnDataHora, "yyyy-MM-dd", vaFormatoISO);
```

Mask table as documented: `dd` day (01–31), `MM` month (01–12), `yyyy` 4-digit year, `yy` 2-digit year, `HH` hour (00–23), `mm` minute (00–59), `ss` second (00–59). Only these tokens are documented — never invent others.

Documentation conflicts:

1. The section demands lowercase masks (`yyyy`, `dd`; "NEVER use capitals") while simultaneously documenting uppercase `MM`, `HH`. The contradiction is internal and unresolved; copy masks exactly as shown.
2. The intro calls the input "milliseconds generated by DataHora" while every other passage says fractional days. Unresolved; the fractional account has the examples behind it.
3. A quick-reference card shows a 2-argument shorthand `FormatarData(data, formato)` against the documented 3-argument signature. Unresolved; use the 3-argument form.
4. A note adds that `FormatarData` only formats dates, not hours, "para variáveis do tipo Data", pointing at `HorSis` for the current time — consistent with the `Numero`-only restriction in effect, if not in wording.

## ExtensoMes, ExtensoSemana, DataExtenso

Date-to-words functions. Each takes a date and fills an `Alfa` variable.

Signatures (source-faithful):

```lsp
ExtensoMes(<datMon>, <extMes>);
ExtensoSemana(<datMon>, <extSem>);
DataExtenso(<data>, <extenso>);
```

- `datMon` — input. Field/variable whose month (or weekday) wording is wanted.
- `extMes` / `extSem` — outputs. `Alfa` variables receiving the month / weekday wording.
- `data` — input. Field/variable whose full wording is wanted.
- `extenso` — output. Variable returning the date wording.

Examples (source-faithful):

```lsp
Definir Alfa vaMesExt;
Definir Data vdData;

DataHoje(vdData);
ExtensoMes(vdData, vaMesExt);
@ Se a data fosse 31/12/1900, vaMesExt seria "Dezembro" @
```

```lsp
Definir Alfa vaSemExt;
Definir Data vdData;

DataHoje(vdData);
ExtensoSemana(vdData, vaSemExt);
@ Se a data fosse 31/12/1900, vaSemExt seria "Sexta-Feira" @
```

```lsp
Definir Data vdData;
Definir Alfa vaExtenso;

vdData = E210MVP.DatMov;
DataExtenso(vdData, vaExtenso);
@ vaExtenso vai conter a data por extenso @
```

The "Se a data fosse…" comments are hypothetical illustrations, not executed assertions. No weekday-numbering or month-name tables beyond these examples are documented here (`RetDiaSemana` below gives the numeric mapping).

## RetDiaSemana

Purpose: return the weekday of an input date as a number.

Signature (source-faithful):

```lsp
RetDiaSemana(<pData>, <pDia>);
```

Parameters:

- `pData` — input. Described as the numeric variable holding the current date.
- `pDia` — output. Numeric variable returning the weekday.

Documented mapping: 0 = Sunday, 1 = Monday, 2 = Tuesday, 3 = Wednesday, 4 = Thursday, 5 = Friday, 6 = Saturday.

Example (source-faithful excerpt):

```lsp
@ Obtém a data atual do sistema @
vnDataSis = DatSis;

@ Retorna o dia da semana @
RetDiaSemana(vnDataSis, vnDiaSemana);
```

The full example maps each number to a Portuguese day name with `Se`/`Senao Se` branches and displays it; the mapping above is the normative content. Note `vnDataSis = DatSis;` assigns the system date into a `Numero` variable — demonstrated, unexplained (see Representations).

## RetDiaUtilAntPos

Purpose: check whether a date is a business day, returning the immediately previous and next business days (if the given date is a business day, both outputs carry it).

Signature (source-faithful):

```lsp
RetDiaUtilAntPos(<pData>, <pCEP>, <pDataAnt>, <pDataPos>);
```

Parameters:

- `pData` — input. Numeric variable holding the current date.
- `pCEP` — input. Numeric variable holding the location postal code.
- `pDataAnt` — output. Numeric variable returning the immediately previous business day (or the given date if it already is one).
- `pDataPos` — output. Numeric variable returning the immediately next business day (or the given date if it already is one).

Example (source-faithful excerpt):

```lsp
@ Exemplo com data de Natal (25/12/2024) @
vaDataAlf = "25/12/2024";
ConvDataInt(vaDataAlf, vnData);
vnCEP = 89107000;

@ Verifica dias úteis anteriores e posteriores @
RetDiaUtilAntPos(vnData, vnCEP, vnDataAnt, vnDataPos);
```

`ConvDataInt`/`ConvDataExt` (Alfa-to-number and number-to-Alfa date helpers) have no dedicated sections; their shapes are only demonstrated here and under `UltimoDia`. Do not document them as specified functions. No rule is given for how weekends, holidays, or the postal code affect the result — do not infer one.

## RetornarDiasUteisMes, RetornarDiasUteisPeriodo, RetornarQtdDiasAno

Business-day and year-length counters. All take `Data` inputs and return counts into `Numero` outputs.

Signatures (source-faithful):

```lsp
RetornarDiasUteisMes(<aDatabase>, <aTipoRetorno>, <aQtdDiasUteis>);
RetornarDiasUteisPeriodo(<aDataIni>, <aDataFim>, <aQtdDiasUteis>);
RetornarQtdDiasAno(<aData>, <aTipoAno>, <aQtdDiasAno>);
```

- `RetornarDiasUteisMes`: counts business days of a month from a base `Data` date. `aTipoRetorno`: 0 = whole month; 1 = from the first of the month through the base date's day.
- `RetornarDiasUteisPeriodo`: counts business days between two `Data` dates. Documented observation: the end date must be greater than or equal to the start date, or the return is zero.
- `RetornarQtdDiasAno`: counts year days from a base `Data` date. `aTipoAno`: 0 = business year (252 days); 1 = commercial year (360 days); 2 = civil year (365 or 366 days for leap years).

Examples (source-faithful excerpts):

```lsp
@ Define uma data de exemplo (21/07/2024) @
vdDataBase = CodData(21, 7, 2024);

@ Obtém quantidade de dias úteis do mês inteiro @
RetornarDiasUteisMes(vdDataBase, 0, vnQtdDiasUteisTotal);

@ Obtém quantidade de dias úteis até a data base @
RetornarDiasUteisMes(vdDataBase, 1, vnQtdDiasUteisAteData);
```

```lsp
@ Define período de exemplo (21/06/2024 a 18/08/2024) @
vdDataInicial = CodData(21, 6, 2024);
vdDataFinal = CodData(18, 8, 2024);

@ Calcula quantidade de dias úteis no período @
RetornarDiasUteisPeriodo(vdDataInicial, vdDataFinal, vnQtdDiasUteis);
```

```lsp
@ Define uma data de exemplo (02/07/2024) @
vdData = CodData(2, 7, 2024);

@ Obtém quantidade de dias para cada tipo de ano @
  RetornarQtdDiasAno(vdData, 0, vnDiasUtil);       @ Ano útil @
  RetornarQtdDiasAno(vdData, 1, vnDiasComercial);  @ Ano comercial @
  RetornarQtdDiasAno(vdData, 2, vnDiasCivil);      @ Ano civil @
```

## UltimoDia

Purpose: find the last day of the month/year of a given date, writing back into the same variable.

Signature (source-faithful):

```lsp
UltimoDia(<DatAtu>);
```

Parameters:

- `DatAtu` — input/output. Numeric field/variable whose month's last day is wanted; the return lands in the variable itself.

Documented restriction: it cannot be a system or table field, because the return goes into the variable itself.

Example (source-faithful excerpt):

```lsp
@ Define uma data de exemplo (20/12/2024) @
vaDataOriginal = "20/12/2024";
ConvDataInt(vaDataOriginal, vnData);

@ Aplica a função UltimoDia @
UltimoDia(vnData);

@ Converte o resultado para string @
ConvDataExt(vnData, vaDataUltimoDia);
```

Expected result per the source comment: 31/12/2024.

## Date arithmetic (demonstrated patterns)

The source states there is no function for computing future or past dates, and advises direct arithmetic on `Data` variables (or converting to number with `DataHora`).

Demonstrated patterns (source-faithful excerpts; note the future/past computations are shown inside comments while the conversions are active code):

```lsp
@ Para calcular datas futuras, use operação direta @
@ vdDataVencimento = vdDataBase + 30; @

@ Para formatação, converta para número @
Definir Numero vnDataVencimento;
vnDataVencimento = vdDataVencimento;
FormatarData(vnDataVencimento, "dd/MM/yyyy", vaDataVencimentoStr);

@ Para calcular datas passadas, use operação direta @
@ vdDataLimite = vdDataBase - 15; @

@ Para formatação, converta para número @
Definir Numero vnDataLimite;
vnDataLimite = vdDataLimite;
FormatarData(vnDataLimite, "dd/MM/yyyy", vaDataLimiteStr);
```

Fractional time math on `DataHora` numbers is active code (see `DataHora` section: `+ (1/24)` per hour, `Truncar` splitting, `* 24` extraction).

Classification: the `Data ± days` shape is advised prose with commented illustration — weaker evidence than the executed `Numero` conversions and fractional math. Day/month/year overflow, month-end, and leap-year arithmetic behavior are undocumented. Do not generate date arithmetic beyond these demonstrated shapes without verification.

## Date comparison (demonstrated)

`Data` variables are compared with relational operators in executed example code (source-faithful excerpt):

```lsp
@ 3. Verifica se a data é válida (não futura) @
Se (vdDataNascimento > vdDataAtual) {
  Mensagem(Erro, "Data de nascimento não pode ser futura!");
}
```

```lsp
@ 2. Validações @
Se (vdDataInicio > vdDataFim) {
  Mensagem(Erro, "Data inicial não pode ser maior que a final!");
} Senao Se (vdDataFim < vdDataAtual) {
  Mensagem(Erro, "Período já expirado!");
} Senao Se (vdDataInicio > vdDataAtual) {
  Mensagem(Retorna, "Período ainda não iniciado");
} Senao Se ((vdDataAtual >= vdDataInicio) e (vdDataAtual <= vdDataFim)) {
  Mensagem(Retorna, "Período ativo");
} Senao {
  Mensagem(Retorna, "Fora do período");
}
```

Classification: demonstrated valid syntax in working validation examples. This shows `>`, `<`, `>=`, `<=` used between `Data` variables — but no ordering specification is stated. Do not promote these excerpts into a complete comparison specification (null handling, type mixing, and equality semantics are undocumented).

## Related but out of scope

- `HorSis` (system time variable, demonstrated as `Alfa` `"HH:MM:SS"` text manipulated with `CopiarAlfa`) and `DatSis` (system date): system-variable domain owns their semantics; behaviors here use them only as demonstrated inputs.
- `AlfaParaData`: conversion slice (already deferred); referenced by the date-assignment rule, not documented here.
- `Truncar`: classified in `../guides/limitations.md`; used here only as demonstrated in fractional-date splitting.
- `IntParaAlfa` / `DecimalParaAlfa`: conversion slice; appear in date examples only as display helpers.
- `HoraParaMinuto`: numeric minutes conversion — belongs to the future numbers domain despite the time flavor.
- `Extenso`, `ExtensoMoeda` (value-to-words with currency): numeric/monetary domain despite sitting among date sections.
- `MultiplicaValor`, `ConverteUnidadeMedida`, `Arredonda`, `ArredondaABNT`, `ArredondarValor`, `Arredonda Valor Tipo Acerto`: numeric operations under a misplaced heading; not date functions.
- `Formatar`, `FormatarN`: Delphi-style number formatting; numbers domain.
- `ConvDataInt`, `ConvDataExt`: Alfa-to-number and number-to-Alfa date helpers with no dedicated sections — observed usage only (`ConvDataInt(vaDataAlf, vnData)` / `ConvDataExt(vnData, vaDataStr)`); not specified functions. A future conversion slice may adopt them on finding dedicated evidence.
- `DataInicialFinal` (report-generator function using `DataHoje(xHoje)` with a `Numero` variable): report domain; noted here only as the second `DataHoje`-with-`Numero` witness.

## Conflicts and uncertainty on this page

1. `DataHoje` output type: ~17 `Data` usages and guide-table backing vs. 2 `Numero` examples (`vnDataHoje`, `xHoje`). Unresolved; use `Data`.
2. Date literals: 1 incorrect (`15/08/1990`) vs. 3 unexplained presented-as-valid (`31/12/1900` twice, `02/07/2018`). Unresolved; never generate literals.
3. `FormatarData` input: `Numero`-only is multiply attested, but a 2-arg quick-ref shorthand and the loose "millissegundos" wording exist alongside. Use the 3-arg `Numero` form.
4. Mask case: lowercase demanded while `MM`/`HH` documented. Copy masks verbatim.
5. `DesMontaData` vs `DecodData`: identical shapes, no distinction stated.
6. `ConverteDataBanco` vs `ConverteDataToDB`: duplicate sections/examples; hierarchy note favors `ConverteDataSqlSenior2` for SQL Senior 2.
7. `Data`-to-`Numero` plain assignment (`DatSis`, `vdDataBase`, `vdDataVencimento` into `Numero`): demonstrated repeatedly, never specified.
8. `DataHora` representation: fractional-day account vs. one "milliseconds" line; epoch never stated.

## Deliberately not documented

Internal representation, epoch, timezone handling beyond the UTC label, locale, calendar implementation, year ranges, leap-year rules beyond `AnoBissexto`'s 0/1, daylight saving, precision, storage, null/zero dates, holiday/CEP logic for business days, month-end and overflow arithmetic, ordering semantics beyond demonstrated comparisons, and error behavior — none stated, none inferred.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Funções de Data Atual` (`DataHoje`, `DataHora`, `DataHoraUTC`, full retrieval example), time-component approaches (`HorSis`+`CopiarAlfa` inspected for usage only; `DataHora` fractional approach), `Construção e Decomposição` (`CodData`, `MontaData` with numeric-return observation, `DesMontaData`, `ConverteDataBanco`, `ConverteDataSqlSenior2` with hierarchy note, `ConverteDataToDB`, `AnoBissexto`, `DecodData` with validation example), `Operações Aritméticas com Datas`, `Formatação Avançada` (`FormatarData` with masks, official example, incorrect/correct pair, multi-format example), `Funções de Extenso` (`ExtensoMes`, `ExtensoSemana`, `DataExtenso`; `Extenso`/`ExtensoMoeda` inspected only), misplaced numeric sections inspected only for classification, `Funções Avançadas de Data e Dias Úteis` (`RetDiaSemana`, `RetDiaUtilAntPos`, `RetornarDiasUteisMes/Periodo/QtdDiasAno`, `UltimoDia`; `Formatar`/`FormatarN` and `LimpaGerTab*` inspected only), `Validação e Comparação de Datas` (period-validation comparisons), plus the `Chr`/`FormatarData`/date-literal troubleshooting, `EntradaValor` (`DataHoje(vnDataHoje)` witness), and report-generator `DataInicialFinal` (`DataHoje(xHoje)` witness). Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
