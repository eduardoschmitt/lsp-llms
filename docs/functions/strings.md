# LSP string functions

Scope: functions whose primary documented purpose is string/text manipulation: concatenation, extraction, measurement, search, substitution, insertion, deletion, whitespace cleanup, case conversion, accent/special-character handling, line splitting, delimited-list separation, ASCII conversion, encoding conversion, and math on `Alfa` values.

> Critical guidance for AI consumers: most functions below fill an output variable or modify a variable in place instead of returning a value. Never rewrite `Function(input, outputVar)` as `outputVar = Function(input)` unless that exact form is documented. As a conservative project rule, prepare values in variables first instead of placing concatenation, arithmetic, or nested calls inside function parameters. This is the safe pattern, not a proven universal rule: the source also contains examples that contradict its absolute scope, preserved in `../guides/limitations.md` (L3). `Alfa` fundamentals live in `../language/variables.md` and are not repeated here except where a function requires them.

## Concatenation operator `+`

Purpose: join `Alfa` values with `+`.

Documented rule: only `Alfa`-type variables (and string literals joined with `Alfa`) may be concatenated. `Numero` values must first be converted (for example with `IntParaAlfa` or `DecimalParaAlfa`, documented in the future conversion slice).

Correct (source-faithful):

```lsp
Definir Numero vnNumero;
Definir Alfa vaNumero;     @ Alfa variable that receives the converted value @
Definir Alfa vaResultado;

vnNumero = 10;
IntParaAlfa(vnNumero, vaNumero);  @ Converts the number to Alfa @
vaResultado = "O número é " + vaNumero;  @ Concatenate only Alfa values @
```

Incorrect (source-faithful):

```lsp
Definir Numero vnNumero;
Definir Alfa vaResultado;

vnNumero = 10;
vaResultado = "O número é " + vnNumero;  @ Error: Numero cannot be concatenated! @
```

Documented matrix: `Alfa` + `Alfa` allowed; `"string"` + `Alfa` allowed; `Alfa` + `Numero`, `"string"` + `Numero`, and `Numero` + `Numero` are errors (numeric addition uses arithmetic operators instead). Whether concatenation is allowed inside function parameters is disputed in the source — follow the conservative prepare-first pattern and see `../guides/limitations.md` (L3); that conflict is not resolved here.

## CaracterParaAlfa

Purpose: convert a character held as its ASCII code into the corresponding alphanumeric value.

Signature (source-faithful):

```lsp
CaracterParaAlfa(<caractere>, <destino>);
```

Parameters:

- `caractere` — input. Field/variable holding the ASCII code of a character. Demonstrated with literals (`65`, `13`).
- `destino` — output. Variable receiving the conversion result.

Example (source-faithful):

```lsp
Definir Alfa vaLetra;
Definir Alfa vaEnter;

@ Converting an ASCII code to a character @
CaracterParaAlfa(65, vaLetra); @ vaLetra will be "A" @

@ Line break @
CaracterParaAlfa(13, vaEnter); @ vaEnter will be a line break @
```

Line-break usage (source-faithful): LSP has no `\n` escape; obtain the break character and concatenate it:

```lsp
Definir Alfa vaEnter;
Definir Alfa vaMensagem;

CaracterParaAlfa(13, vaEnter);
vaMensagem = "Primeira linha" + vaEnter + "Segunda linha";
```

Source notes: ASCII 13 is the documented line-break code. One observation states that when sending email with Senior's "convert line breaks to HTML" option enabled, Windows line breaks (ASCII 13 and 10) become `<br/>` tags — an environment behavior, not an LSP rule. Return behavior: output parameter; no direct-return form documented.

## RetornaAscII

Purpose: return the ASCII character corresponding to a number.

Signature (source-faithful):

```lsp
RetornaAscII(<xNumero>, <xCarAscII>);
```

Parameters:

- `xNumero` — input. `Numero` variable whose ASCII character is wanted.
- `xCarAscII` — output. `Alfa` variable receiving the corresponding ASCII character.

Example, letters (source-faithful excerpt):

```lsp
vnCodigo = 65;  @ ASCII code of the letter 'A' @
RetornaAscII(vnCodigo, vaCaracter);
vaMensagem = "Código 65 = " + vaCaracter;
Mensagem(Retorna, vaMensagem);  @ Result: "Código 65 = A" @
```

Example, building a string in a loop (source-faithful excerpt):

```lsp
vaSenha = "";
Para (vnContador = 1; vnContador <= 4; vnContador++) {
  vnCodigo = 65 + vnContador - 1;  @ A, B, C, D @
  RetornaAscII(vnCodigo, vaCaracter);
  vaSenha = vaSenha + vaCaracter;
}
vaMensagem = "Senha gerada: " + vaSenha;
Mensagem(Retorna, vaMensagem);  @ Result: "Senha gerada: ABCD" @
```

Source notes: despite the `Retorna-` name, the documented form uses an output parameter, not a direct return. The source gives no distinction between `RetornaAscII` and `CaracterParaAlfa` — both convert a numeric code to an `Alfa` character. Do not invent one; see conflicts.

## CopiarAlfa and CopiarStr

Purpose: copy part of an alphanumeric variable/field, modifying the source variable itself to hold only the copied part.

Signatures (source-faithful):

```lsp
CopiarAlfa(<variavel>, <posicao>, <tamanho>);
CopiarStr(<variavel>, <posicao>, <tamanho>);
```

Parameters:

- `variavel` — input/output. Variable holding the text; it is modified to contain only the copied part.
- `posicao` — input. Start position, 1-based.
- `tamanho` — input. Number of characters to copy.

Example (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Alfa vaNome;
Definir Alfa vaSobrenome;

@ To extract "João" @
vaTexto = "João Silva Santos";
vaNome = vaTexto;  @ Copy it first @
CopiarAlfa(vaNome, 1, 4); @ vaNome will be "João" @

@ To extract "Silva" @
vaSobrenome = vaTexto;  @ Copy it first @
CopiarAlfa(vaSobrenome, 6, 5); @ vaSobrenome will be "Silva" @
```

Official-Senior example quoted in the source (source-faithful):

```lsp
Definir Alfa exemplo;
exemplo = "texto de exemplo";
CopiarAlfa(exemplo, 12, 3);
@ After the call, the "exemplo" variable content would be "emp" @
```

Return behavior: in-place side effect on the first variable; no separate output variable and no direct return. Because the source is destructive, copy the value to another variable first when the original must be kept. No `= CopiarAlfa(...)` usage exists anywhere in the source.

Source notes: `CopiarStr` is documented only as a paired signature with no separate parameters, examples, or stated difference. Indexing is 1-based per the parameter description.

## TamanhoAlfa and TamanhoStr

Purpose: obtain the length of an alphanumeric variable/field via a return parameter.

Signatures (source-faithful):

```lsp
TamanhoAlfa(<origem>, <tamanho>);
TamanhoStr(<origem>, <tamanho>);
```

Parameters:

- `origem` — input. Field/variable whose length is wanted.
- `tamanho` — output. `Numero` variable receiving the length.

Example (source-faithful):

```lsp
Definir Alfa vaSenha;
Definir Numero vnTamanho;
Definir Alfa vaMensagem;
Definir Alfa vaNumeroStr;

vaSenha = "minhasenha123";
TamanhoAlfa(vaSenha, vnTamanho);

Se (vnTamanho < 8) {
  vaMensagem = "Senha deve ter pelo menos 8 caracteres";
  Mensagem(Erro, vaMensagem);
} Senao {
  IntParaAlfa(vnTamanho, vaNumeroStr);
  vaMensagem = "Senha válida com " + vaNumeroStr + " caracteres";
  Mensagem(Retorna, vaMensagem);
}
```

Return behavior: output parameter only — explicitly not a direct return. `vnTamanho = TamanhoAlfa(vaTexto);` is a documented error (see `../guides/limitations.md` L1), and five such incorrect forms appear in the source, all inside incorrect-example blocks. Calling inside conditions (`Se (TamanhoAlfa(vaCNPJ) <> 14)`) is conflicted — see limitations L4, not resolved here. `TamanhoStr` has no separate documentation beyond the paired signature.

## PosicaoAlfa and PosicaoStr

Purpose: find a subtext inside a field/variable, returning the start position through a parameter.

Signatures (source-faithful):

```lsp
PosicaoAlfa(<subtexto>, <texto>, <posicao>);
PosicaoStr(<subtexto>, <texto>, <posicao>);
```

Parameters:

- `subtexto` — input. Text being searched for. Demonstrated with literals (`"@"`, `"."`).
- `texto` — input. Field/variable to search in.
- `posicao` — output. Variable receiving the start position, or 0 when not found.

Example (source-faithful):

```lsp
Definir Alfa vaEmail;
Definir Numero vnPosArroba;
Definir Numero vnPosPonto;

vaEmail = "usuario@empresa.com.br";
PosicaoAlfa("@", vaEmail, vnPosArroba);
PosicaoAlfa(".", vaEmail, vnPosPonto);

Se (vnPosArroba = 0) {
  Mensagem(Erro, "Email inválido: falta @");
} Senao Se (vnPosPonto = 0) {
  Mensagem(Erro, "Email inválido: falta domínio");
} Senao {
  Mensagem(Retorna, "Email válido!");
}
```

Return behavior: output parameter, not a direct return. The only `vnPosicao = PosicaoAlfa(...)` occurrence in the source is inside a documented-incorrect block. `PosicaoStr` has no separate documentation beyond the paired signature.

## SubstAlfa and SubstAlfaUmaVez

Purpose: replace text spans inside a string.

Signatures (source-faithful):

```lsp
SubstAlfa(<subtexto>, <novoTexto>, <texto>);      @ Replaces all occurrences @
SubstAlfaUmaVez(<subtexto>, <novoTexto>, <texto>); @ Replaces only the first @
```

Parameters:

- `subtexto` — input. Text to find and replace.
- `novoTexto` — input. Replacement text.
- `texto` — input/output. Variable holding the original text; receives the result.

Example (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Alfa vaTextoLimpo;

vaTexto = "João--Silva--Santos";
vaTextoLimpo = vaTexto;

@ Replaces all double dashes with a single space @
SubstAlfa("--", " ", vaTextoLimpo);
@ vaTextoLimpo will be "João Silva Santos" @

@ Example with SubstAlfaUmaVez @
vaTexto = "teste teste teste";
SubstAlfaUmaVez("teste", "TESTE", vaTexto);
@ vaTexto will be "TESTE teste teste" (only the first one) @
```

Return behavior: in-place on the third variable; no direct-return usage exists in the source. The documented distinction is scope: all occurrences vs. first only. Literals are demonstrated in the first two positions.

## TrocaString

Purpose: advanced substitution with more control options (the source states no further detail about what the extra control is).

Signature (source-faithful):

```lsp
TrocaString(<texto>, <textoAntigo>, <textoNovo>);
```

Example (source-faithful):

```lsp
Definir Alfa vaTemplate;
Definir Alfa vaNomeUsuario;
Definir Alfa vaEmpresa;
Definir Alfa vaMensagemFinal;

vaTemplate = "Olá __NOME__, bem-vindo à __EMPRESA__!";
vaNomeUsuario = "João Silva";
vaEmpresa = "Senior Sistemas";

vaMensagemFinal = vaTemplate;
TrocaString(vaMensagemFinal, "__NOME__", vaNomeUsuario);
TrocaString(vaMensagemFinal, "__EMPRESA__", vaEmpresa);
@ vaMensagemFinal will be "Olá João Silva, bem-vindo à Senior Sistemas!" @
```

Return behavior: in-place on the first variable, consistent with all usages (including `TrocaString(vaURL, "__NUMCEP__", vaCepApi);` in a community HTTP example). Parameters are not individually described in the source. No documented distinction from `SubstAlfa` beyond the “more control options” phrase — see conflicts.

## Concatena

Purpose: concatenate up to 3 `Alfa` fields/variables into a single variable.

Signature (source-faithful; documented twice in near-identical sections):

```lsp
Concatena(<str1>, <str2>, <str3>, <destino>);
```

Parameters:

- `str1`, `str2`, `str3` — inputs. Fields/variables to concatenate.
- `destino` — output. Variable receiving the concatenation result.

Example (source-faithful):

```lsp
Definir Alfa vaTexto1;
Definir Alfa vaTexto2;
Definir Alfa vaTexto3;
Definir Alfa vaResultado;

vaTexto1 = "Pedro Luiz Souza";
vaTexto2 = " - ";
vaTexto3 = "Pedrão";

Concatena(vaTexto1, vaTexto2, vaTexto3, vaResultado);
@ vaResultado will be "Pedro Luiz Souza - Pedrão" @
```

A second source example demonstrates a literal in an input position (source-faithful excerpt):

```lsp
vaNome = "Pedro Luiz Souza";
vaApelido = "Pedrão";

Concatena(vaNome, " - ", vaApelido, vaResultado);
@ vaResultado will be "Pedro Luiz Souza - Pedrão" @
```

Return behavior: output parameter. Whether fewer than 3 inputs are allowed is not documented — both examples pass exactly 3 inputs. Demonstrated usage accepts a string literal as an input; the parameter gloss says “Campo/Variável”, so treat literal acceptance as demonstrated, not as a general rule.

## ConverteParaMaiusculo and ConverteParaMinusculo

Purpose: convert a variable’s content to uppercase or lowercase.

Signatures (source-faithful):

```lsp
ConverteParaMaiusculo(<texto>);
ConverteParaMinusculo(<texto>);
```

No parameter glosses are given. Example (source-faithful):

```lsp
Definir Alfa vaNome;
Definir Alfa vaEmail;

vaNome = "joão SILVA santos";
vaEmail = "USUARIO@EMPRESA.COM.BR";

@ Standardizes the email (all lowercase) @
ConverteParaMinusculo(vaEmail);
@ vaEmail will be "usuario@empresa.com.br" @

@ For proper names @
ConverteParaMaiusculo(vaNome); @ Becomes "JOÃO SILVA SANTOS" @
```

Return behavior: in-place on the single variable in all usages (7 and 4 source occurrences, all consistent). Accented characters are preserved with case applied (`"joão SILVA santos"` becomes `"JOÃO SILVA SANTOS"`). No stated difference between the two beyond direction.

## DeletarAlfa and DeletarStr

Purpose: remove a number of characters from a given position.

`DeletarAlfa` signature (source-faithful):

```lsp
DeletarAlfa(<texto>, <posicao>, <quantidade>);
```

No parameter glosses are given for `DeletarAlfa`. Example, CPF formatting (source-faithful):

```lsp
Definir Alfa vaCPF;

vaCPF = "123.456.789-10";

@ Removes the CPF formatting @
DeletarAlfa(vaCPF, 4, 1);  @ Removes the first dot @
DeletarAlfa(vaCPF, 7, 1);  @ Removes the second dot @
DeletarAlfa(vaCPF, 10, 1); @ Removes the dash @
@ vaCPF will be "12345678910" @
```

`DeletarStr` signature (source-faithful):

```lsp
DeletarStr(<origem>, <posicao>, <quantidade>);
```

Parameters (the only `Deletar` parameter glosses in the source, given under `DeletarStr`):

- `origem` — the variable whose part will be deleted.
- `posicao` — start position of the deletion.
- `quantidade` — number of characters to delete.

Example (source-faithful):

```lsp
Definir Alfa vaOrigem;
vaOrigem = "Senior empresa de Sistemas";
DeletarStr(vaOrigem, 8, 11);
@ vaOrigem will be "Senior Sistemas" @
```

Return behavior: in-place on the first variable in all usages (11 `DeletarAlfa` occurrences, all consistent).

## InserirAlfa and InserirStr

Purpose: insert characters into a variable/field starting at the given position.

Signatures (source-faithful):

```lsp
InserirAlfa(<valor>, <origem>, <posicao>);
InserirStr(<valor>, <origem>, <posicao>);
```

Parameters (identical glosses under both names):

- `valor` — input. Variable holding the string to insert. A literal (`"empresa de "`) is demonstrated in this position.
- `origem` — input/output. Origin string; receives the insertion content.
- `posicao` — input. Position in `origem` from which `valor` is inserted.

Example (source-faithful, same under both names):

```lsp
Definir Alfa vaOrigem;
vaOrigem = "Senior Sistemas";
InserirAlfa("empresa de ", vaOrigem, 8);
@ vaOrigem will be "Senior empresa de Sistemas" @
```

Source observation (both sections): the origin variable’s content is truncated if its defined size is not respected. No size/overflow mechanics beyond that sentence are documented. No stated difference between the `Alfa` and `Str` variants.

## LimpaEspacos, LimpaEspacosDireita, LimpaEspacosEsquerda

Purpose: remove blank spaces from the edges of an alphanumeric variable.

Signatures (source-faithful):

```lsp
LimpaEspacos(<texto>);
LimpaEspacosDireita(<texto>);
LimpaEspacosEsquerda(<texto>);
```

- `LimpaEspacos` cleans both sides; `LimpaEspacosDireita` the right side; `LimpaEspacosEsquerda` the left side.

Examples (source-faithful):

```lsp
Definir Alfa vaTexto;
vaTexto = "  texto com espaços  ";
LimpaEspacos(vaTexto);
@ vaTexto will be "texto com espaços" @
```

```lsp
Definir Alfa vaTexto;
vaTexto = "  texto com espaços  ";
LimpaEspacosDireita(vaTexto);
@ vaTexto will be "  texto com espaços" @
```

```lsp
Definir Alfa vaTexto;
vaTexto = "  texto com espaços  ";
LimpaEspacosEsquerda(vaTexto);
@ vaTexto will be "texto com espaços  " @
```

Return behavior: in-place on the single variable; no parameter glosses, no direct-return form, no documented definition of “blank space” beyond the examples. The source demonstrates variables only, not literals, in the argument position.

## QuebraTexto

Purpose: assign line breaks to a text per a given line length for printing, and report how many lines the text will need.

Signature (source-faithful):

```lsp
QuebraTexto(<texto>, <tamanhoLinha>, <quantidadeLinhas>);
```

Parameters:

- `texto` — input. Field/variable to print across lines.
- `tamanhoLinha` — input. Maximum characters per line. Demonstrated with literal `30`.
- `quantidadeLinhas` — output. Number of lines needed to print the text.

Example (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Alfa vaFrase;
Definir Numero vnNumLin;
Definir Numero vnLinAtu;

vaTexto = "Vamos ver o que acontece quando usamos estas funções para controle de impressão de linhas de um texto mais extenso";
QuebraTexto(vaTexto, 30, vnNumLin);

vnLinAtu = 1;
Enquanto (vnLinAtu <= vnNumLin) {
  BuscaLinhaTexto(vaTexto, vnLinAtu, vaFrase);
  @ Processes each line @
  vnLinAtu++;
}
```

Source notes: the example depends on `BuscaLinhaTexto(Alfa Texto, Numero NroLin, Alfa End LinTex)`, whose signature is quoted but whose behavior belongs to the future printing/report domain — not documented here. Whether `QuebraTexto` also modifies `texto` is not stated; only the line-count output is documented.

## ProcuraEnter

Purpose: find a line-break character (#13 or #10) in a string and split the string around the first break.

Signature (source-faithful):

```lsp
ProcuraEnter(<strProcura>, <strImp>, <strResto>);
```

Parameters:

- `strProcura` — input. String in which the enter/newline is searched.
- `strImp` — output (marked “retorno”). First part of the string, up to the first newline character.
- `strResto` — output (marked “retorno”). Remainder after the first newline character.

Example (source-faithful):

```lsp
Definir Alfa vaStrProcura;
Definir Alfa vaStrImp;
Definir Alfa vaStrResto;

vaStrProcura = "Primeira linha" + vaEnter + "Segunda linha";
ProcuraEnter(vaStrProcura, vaStrImp, vaStrResto);
@ vaStrImp will be "Primeira linha" @
@ vaStrResto will be "Segunda linha" @
```

Source observation: to print each enter-separated note, print `StrImp` then keep searching `StrResto`. (`vaEnter` here is the break character obtained via `CaracterParaAlfa(13, vaEnter)`.) Whether the input is modified is not stated.

## CalculaAlfa

Purpose: perform math operations on alphanumeric values.

Signature (source-faithful):

```lsp
CalculaAlfa(<operacao>, <argumento1>, <argumento2>, <resultado>);
```

Parameters:

- `operacao` — input. Operation to perform: `"+"` sum, `"-"` subtraction, `"*"` multiplication.
- `argumento1`, `argumento2` — inputs. Fields holding the calculation arguments.
- `resultado` — output. `Alfa` variable receiving the calculation result.

Example (source-faithful):

```lsp
Definir Alfa vaOperacao;
Definir Alfa vaArg1;
Definir Alfa vaArg2;
Definir Alfa vaResultado;

vaOperacao = "+";
vaArg1 = "100";
vaArg2 = "50";
CalculaAlfa(vaOperacao, vaArg1, vaArg2, vaResultado);
@ vaResultado will be "150" @
```

Source observations: only sum, subtraction, and multiplication exist; all calculations use integers — a non-integer input causes an error; and this function is much slower than direct calculation (`c = a + b`). Only the documented operators may be assumed.

## LerPosicaoAlfa

Purpose: identify which character sits at a position of an `Alfa` field/variable, as its ASCII code.

Signature (source-faithful):

```lsp
LerPosicaoAlfa(<origem>, <destino>, <posicao>);
```

Parameters:

- `origem` — input. `Alfa` field/variable to inspect.
- `destino` — output. `Numero` variable receiving the ASCII code of the character read.
- `posicao` — input. Position to inspect. Demonstrated 1-based (`vnPosicao = 1` reads the first character).

Example (source-faithful):

```lsp
Definir Alfa vaTexto;
Definir Numero vnCodigoCaractere;
Definir Numero vnPosicao;

vaTexto = "TESTE";
vnPosicao = 1;

@ Gets the ASCII code of the first character @
LerPosicaoAlfa(vaTexto, vnCodigoCaractere, vnPosicao);
@ vnCodigoCaractere will be 84 (ASCII code of 'T') @

@ Comparison with the ASCII code @
Se (vnCodigoCaractere = 84) { @ 'T' @
  Mensagem(Retorna, "Primeiro caractere é T");
}

@ To compare directly with a character, use single quotes @
Se (vnCodigoCaractere = 'T') {
  Mensagem(Retorna, "Primeiro caractere é T");
}
```

Source observations: the function returns the ASCII code, not the character — use `CopiarAlfa` to get the character as a string. The single-quote comparison (`= 'T'`) is demonstrated usage in this example only; do not generalize single-quote literal semantics beyond it.

## ListaItem and ListaQuantidade

Purpose: split and count delimited (concatenated-list) strings. These operate on plain `Alfa` text and are distinct from the `ListaRegra*` rule-list API (future database/rule-list domain).

`ListaItem` signature (source-faithful):

```lsp
ListaItem(<texto>, <separador>, <indice>, <item>);
```

No parameter glosses are given. Demonstrated positions: text, separator literal (`";"`), 1-based index literal, output variable.

Example, CSV processing (source-faithful):

```lsp
Definir Alfa vaLinhaCsv;
Definir Alfa vaNome;
Definir Alfa vaIdade;
Definir Alfa vaCargo;

vaLinhaCsv = "João Silva;30;Desenvolvedor;São Paulo";

ListaItem(vaLinhaCsv, ";", 1, vaNome);    @ vaNome = "João Silva" @
ListaItem(vaLinhaCsv, ";", 2, vaIdade);   @ vaIdade = "30" @
ListaItem(vaLinhaCsv, ";", 3, vaCargo);   @ vaCargo = "Desenvolvedor" @
```

A loop example demonstrates a variable index (source-faithful excerpt):

```lsp
Para (vnContador = 1; vnContador <= vnQuantidade; vnContador++) {
  ListaItem(vaLista, ",", vnContador, vaItem);
  Mensagem(Retorna, "Item " + vaItem + " processado");
}
```

Note: that loop-excerpt line `Mensagem(Retorna, "Item " + vaItem + " processado");` concatenates inside a function parameter, which the limitations slice flags as restricted — the excerpt is preserved for the `ListaItem` call shape, not as endorsement of the `Mensagem` call shape.

`ListaQuantidade` signature (source-faithful):

```lsp
ListaQuantidade(<texto>, <separador>, <quantidade>);
```

Parameters:

- `texto` — input. Text with separated items.
- `separador` — input. Item separator character.
- `quantidade` — output. Variable receiving the item count.

Example (source-faithful):

```lsp
Definir Alfa vaEmails;
Definir Numero vnQuantidade;
Definir Alfa vaMensagem;
Definir Alfa vaQuantidadeStr;

vaEmails = "user1@teste.com,user2@teste.com,user3@teste.com";
ListaQuantidade(vaEmails, ",", vnQuantidade);

IntParaAlfa(vnQuantidade, vaQuantidadeStr);
vaMensagem = "Total de emails: " + vaQuantidadeStr;
Mensagem(Retorna, vaMensagem); @ "Total de emails: 3" @
```

Return behavior: output parameter, following the LSP pattern. `vnQuantidade = ListaQuantidade(vaLista, ",");` is a documented error (see `../guides/limitations.md` L1).

## ConverteCodificacaoString

Purpose: change the encoding of a text in a variable, for use in web-service communication.

Signature (source-faithful, direct return):

```lsp
vnRetorno = ConverteCodificacaoString(<textoOrigem>, <codificacao>, <textoDestino>);
```

Parameters:

- `textoOrigem` — input. Original text needing conversion.
- `codificacao` — input. Target encoding name: `"UTF-8"` or `"WINDOWS-1252"`.
- `textoDestino` — output. Holds the converted text.
- Direct return into a `Numero` variable: `0` conversion succeeded; `1` text has characters unsupported by the encoding.

Example (source-faithful):

```lsp
Definir Alfa vaTextoOriginal;
Definir Alfa vaTextoCodificado;
Definir Numero vnRetorno;

vaTextoOriginal = "Acentuação especial";

vnRetorno = ConverteCodificacaoString(vaTextoOriginal, "UTF-8", vaTextoCodificado);

Se (vnRetorno = 1) {
  Mensagem(Retorna, "Encontrado caracteres incompatíveis!");
} Senao {
  Mensagem(Retorna, "Conversão realizada com sucesso!");
}
```

Source observation: if the system does not support the given encoding, the message "A codificação X não é suportada. Verifique a documentação" is emitted. This function is a documented direct-return exception (see `../guides/limitations.md` L2): it both returns a status code and fills a destination variable. Only the two named encodings are documented.

## ConverteTexto

Purpose: substitute special characters per a stated encoding pattern, returning a new converted text.

Signature (source-faithful):

```lsp
ConverteTexto(<codificacao>, <textoOrigem>, <textoDestino>);
```

Parameters:

- `codificacao` — input. Origin-text encoding; supported format: `"JSON"`.
- `textoOrigem` — input. Text with characters to convert.
- `textoDestino` — output. Variable receiving the converted text.

Example (source-faithful):

```lsp
Definir Alfa vaTextoOrigem;
Definir Alfa vaTextoDestino;

vaTextoOrigem = "\\u00c1gua";

ConverteTexto("JSON", vaTextoOrigem, vaTextoDestino);
@ vaTextoDestino receives the value "Água" @
```

Source observation: use only for character-set conversion, not for converting datasets such as JSON structures. The source carries a large supported-code table (for example `\\u0021` becomes `!`, `\\u0041` becomes `A`, `\\u00C1` becomes `Á`); the full table is not reproduced here — consult the source `ConverteTexto` section for the complete mapping. Only `"JSON"` is documented as a supported format.

## RetiraCaracteresEspeciais

Purpose: remove special characters, keeping only letters and numbers.

Signature (source-faithful):

```lsp
RetiraCaracteresEspeciais(<Retorno>);
```

Parameters:

- `Retorno` — input/output. `Alfa` variable that takes the field to clean and returns it without special characters.

Example, company name and phone (source-faithful excerpt):

```lsp
vaTextoOriginal = "João & Pessoa Ltda.";
vaTextoLimpo = vaTextoOriginal;
RetiraCaracteresEspeciais(vaTextoLimpo);
vaMensagem = "Original: " + vaTextoOriginal + " | Limpo: " + vaTextoLimpo;
Mensagem(Retorna, vaMensagem);  @ Result: "JoaoPessoaLtda" @

vaTextoOriginal = "(47) 99999-8888";
vaTextoLimpo = vaTextoOriginal;
RetiraCaracteresEspeciais(vaTextoLimpo);
vaMensagem = "Telefone original: " + vaTextoOriginal + " | Apenas números: " + vaTextoLimpo;
Mensagem(Retorna, vaMensagem);  @ Result: "4799998888" @
```

Return behavior: single-argument in-place modification; no direct return. Accent removal is demonstrated (`"João & Pessoa Ltda."` becomes `"JoaoPessoaLtda"`), and email punctuation is stripped (`"usuario@empresa.com.br"` becomes `"usuarioempresacombr"`). What counts as “special” beyond the examples is not defined — do not generalize.

## RetiraAcentuacao

Purpose: take an accented string and return it without accents.

Signature (source-faithful):

```lsp
RetiraAcentuacao(<pString>);
```

Parameters:

- `pString` — input/output. `Alfa` variable that takes a string and returns it per the documented behavior below.

Example (source-faithful excerpt):

```lsp
vaTextoOriginal = "José António da Silva";
vaTextoSemAcento = vaTextoOriginal;
RetiraAcentuacao(vaTextoSemAcento);
vaMensagem = "Original: " + vaTextoOriginal + " | Sem acento: " + vaTextoSemAcento;
Mensagem(Retorna, vaMensagem);  @ Result: "JOSE ANTONIO DA SILVA" @
```

Documentation conflict: the prose claims the function returns the string "sem acentuação e em maiúsculo" (unaccented and uppercase), and Example 1 and the address example (`"Rua das Açucenas, 123 - São José"` becomes `"RUA DAS ACUCENAS, 123 - SAO JOSE"`) match that — but Example 2 (`"ÇçÁáàÉéÚúÍí"` becomes `"CcAaaEeUuIi"`) preserves mixed case, contradicting the uppercase claim. Case behavior is therefore unresolved: expect accent removal; do not rely on uppercasing.

## Similar functions and documented distinctions

- `CopiarAlfa` vs `CopiarStr`, `TamanhoAlfa` vs `TamanhoStr`, `PosicaoAlfa` vs `PosicaoStr`, `DeletarAlfa` vs `DeletarStr`, `InserirAlfa` vs `InserirStr`: documented only as paired signatures with identical examples and glosses. No source distinction found. Do not choose one over the other on semantic grounds.
- `SubstAlfa` (all occurrences) vs `SubstAlfaUmaVez` (first only): the one stated distinction in this family.
- `SubstAlfa` vs `TrocaString`: argument order differs (`SubstAlfa` takes the target text last; `TrocaString` takes it first) and `TrocaString` claims “more control options” without detail. No selection guidance exists — record, do not invent.
- `CaracterParaAlfa` vs `RetornaAscII`: both convert a numeric ASCII code to an `Alfa` character; the source states no difference. `LerPosicaoAlfa` is the inverse direction (character becomes ASCII code into a `Numero` variable).
- `ListaItem` / `ListaQuantidade` (plain-text split/count) vs `ListaRegra*` (rule-list API): different domains; the latter belongs to the future rule-list/database documentation.
- `ConverteParaMaiusculo` / `ConverteParaMinusculo` vs `RetiraAcentuacao`: case functions convert in place without touching accents per their examples; `RetiraAcentuacao` also strips accents with disputed case behavior (see conflict above).
- `DeixaNumeros` (keep only digits) is documented in the validation domain, not here — see deferred list.

## Deliberately deferred (inspected, not documented on this page)

- General conversions — `AlfaParaData`, `AlfaParaDecimal`, `AlfaParaInt`, `IntParaAlfa`, `DecimalParaAlfa`, `StrParaInt` (stated equivalent of `AlfaParaInt`), `IntParaStr` (stated equivalent of `IntParaAlfa`), `ConverteMascara`: the source gives them a dedicated `Cast de Variável` section. They belong to a future conversion slice. `NumeroParaAlfa` and `AlfaParaNumero` were searched for and occur zero times — they are not documented and must not be generated.
- `CarregarTextoArq(<arquivo>, <texto>)`: file reading into an `Alfa` variable — belongs to the future files domain despite the `Alfa` output.
- `DeixaNumeros`: dedicated validation-domain section — belongs to the future validation slice.
- `BuscaLinhaTexto`: quoted only as a `QuebraTexto` dependency; printing/report behavior — belongs to a future domain.
- `ValorElementoJson` and HTTP/file/database/report functions accepting `Alfa`: cross-domain, excluded per scope.

## Conflicts and uncertainty on this page

1. `RetiraAcentuacao` uppercase claim vs. its own Example 2 (above).
2. Arithmetic inside string-function parameters in presented-as-working material — `CopiarAlfa(vaEmail, vnPosArroba + 1, vnTamanho - vnPosArroba);`, `CopiarAlfa(vaValorFrete, vnInicio, vnFim - vnInicio);` — vs. the no-manipulation-in-parameters rule (`../guides/limitations.md` L3). Preserved, not resolved.
3. `TamanhoAlfa`/`ListaQuantidade` direct-return and in-condition forms are documented errors with contradicting presented-as-working examples — preserved in limitations L1/L4.
4. Literals in positions glossed as “Variável” (`InserirAlfa("empresa de ", …)`, `Concatena(vaNome, " - ", …)`, `CaracterParaAlfa(65, …)`, `QuebraTexto(vaTexto, 30, …)`): demonstrated acceptance only; not a general rule.
5. The single-quote comparison (`Se (vnCodigoCaractere = 'T')`) is demonstrated once under `LerPosicaoAlfa`; single-quote literal semantics are otherwise undocumented.
6. `Alfa`+`Alfa` concatenation with `+` is documented; whether `Concatena` accepts fewer than 3 inputs is undocumented.

## Deliberately not documented

Implicit conversions, text encoding of `Alfa` values, maximum lengths, truncation on assignment, Unicode/locale/case-folding rules, null and empty-string behavior, whitespace definitions, 0- vs 1-based indexing beyond the stated `CopiarAlfa` 1-based positions, error values for not-found positions other than `PosicaoAlfa`’s documented 0, and performance characteristics — none are stated in the inspected material and none are inferred.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Manipulação Avançada de Strings` (summary table, email example, concatenation rules, line-break rules, `CaracterParaAlfa`, basic functions `CopiarAlfa`/`TamanhoAlfa`/`PosicaoAlfa`/`SubstAlfa`/`Concatena`, advanced functions `DeletarAlfa`/`InserirAlfa`/`LimpaEspacos`/`QuebraTexto`/`ProcuraEnter`/`CalculaAlfa`/`CarregarTextoArq` (inspected only)/`ConverteParaMaiusculo`/`TrocaString`/`LerPosicaoAlfa`, list functions `ListaItem`/`ListaQuantidade`, encoding functions `ConverteCodificacaoString`/`ConverteTexto` with its code table noted but not reproduced), `Funções Adicionais de Manipulação de Strings` (`RetornaAscII`, `RetiraCaracteresEspeciais`, `RetiraAcentuacao`), and `Cast de Variável` (inspected only for the deferral decision). Cross-checked against limitation/troubleshooting sections, quick-reference cards, the email/CSV exercises, `BuscarCepAPI.lsp` (`TrocaString`, `ConverteMascara` usage noted), and `ManipulacaoJSON.lsp` (manual `PosicaoAlfa`/`LerPosicaoAlfa`/`CopiarAlfa`/`SubstAlfa` usage consistent with documented signatures). Portuguese prose translated into English; function names, parameter order, identifiers, literals, and code semantics preserved. Current evidence base is the community documentation and community examples listed above; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
