# Critical LSP limitations and common pitfalls

Guardrail reference for code generation. Read this before writing LSP calls: the patterns marked invalid below are documented in the source as not working, even when they look natural to programmers from other languages.

> Critical guidance for AI consumers: always prepare values in variables first, then call functions with plain variables. Do not place concatenation, nested calls, arithmetic, or conversions inside function parameters. Do not use a function call as if it returned a value unless that exact function is documented as a direct-return exception. When a conflict note appears, follow the safest source-backed pattern and verify against official Senior documentation.

Scope of this file: only limitations and pitfalls needed to generate valid calls. Full function signatures, control-flow semantics, and database/HTTP details belong to later slices.

## L1 — Most functions fill an output parameter instead of returning a value

Classification: **Documented limitation**.

What the source says: most LSP functions do not return values directly; they fill a variable passed as a return (output) parameter. The executive summary phrases it as “use a return variable, not `=`”.

Do not generate (source-faithful incorrect forms):

```lsp
@ ERRO: Tentativa de retorno direto @
vnTamanho = TamanhoAlfa(vaTexto);
vnPosicao = PosicaoAlfa("@", vaEmail);
vnLinhas = LinhasArquivo(vaCaminho);
vnExiste = ArqExiste(vaCaminho);
vnQuantidade = ListaQuantidade(vaLista, ",");
vnResultado = HoraParaMinuto(1, 30);
vnValido = VrfAbrA(vaCodigo, "A..Z");
vnAtiva = VerificaAbaAtiva(vaDescricao);
```

Generate instead (source-faithful correct forms):

```lsp
@ CORRETO: Usar parâmetro de retorno @
TamanhoAlfa(vaTexto, vnTamanho);
PosicaoAlfa("@", vaEmail, vnPosicao);
LinhasArquivo(vaCaminho, vnLinhas);
ArqExiste(vaCaminho, vnExiste);
ListaQuantidade(vaLista, ",", vnQuantidade);
HoraParaMinuto(1, 30, vnResultado);
VrfAbrA(vaCodigo, "A..Z", vnValido);
VerificaAbaAtiva(vaDescricao, vnAtiva);
```

Functions the source places in the output-parameter family (summary table, presented as a summary — not necessarily exhaustive):

| Category | Functions |
|---|---|
| Strings | `TamanhoAlfa`, `TamanhoStr`, `PosicaoAlfa`, `PosicaoStr`, `ListaQuantidade` |
| Validation | `VrfAbrA`, `VrfAbrN`, `ArqExiste`, `VerificaAbaAtiva`, `EstaNulo` |
| System | `LinhasArquivo`, `HoraParaMinuto`, `ObtemIdiomaAtivo`, `RetornaValorCFG` |
| Conversion | `AlfaParaDecimal`, `AlfaParaInt`, `AlfaParaData`, `IntParaAlfa` |
| Dynamic handling | `PegarTipoVar`, `PegarValorVarAlf`, `PegarValorVarNum` |

Uncertainty: the table is a “Resumo”, and the rule says “most” (a maioria) functions. Membership of any function not listed above is not established by this file; check the function catalog when it exists.

## L2 — Direct-return exceptions exist; do not generalize either direction

Classification: **Documentation conflict or uncertainty** (general rule vs. documented exceptions).

What the source says: the following functions ARE documented as returning values directly (source-faithful):

```lsp
@ Estas funções SIM retornam valores diretamente @
vnRetorno = ConverteCodificacaoString(vaTexto, "UTF-8", vaDestino);
vnArquivo = Abrir("arquivo.txt", Ler);
vdData = CodData(vnDia, vnMes, vnAno);
vnRetorno = Mensagem(Retorna, "Mensagem [&Ok,&Cancelar]");
vnNulo = SQL_RetornarSeNulo(xCursor, "CAMPO");
vnTem = Lst.Primeiro();
vnTem = Lst.Proximo();
```

`Truncar` is a further direct-return case documented in the troubleshooting section (see L8): `vnParteInteira = Truncar(vnDataHora);` is marked correct while the two-argument form is marked incorrect — even though `Truncar` does not appear in the summary table of L1.

Guidance: treat each function individually. The L1 pattern is the default; only the functions listed here (plus `Truncar`) have source backing for `variable = Function(...)` form in the inspected material. In particular, `Mensagem` returns a value (button index; see L4) but its *input* parameters still obey L3 — do not confuse the two directions.

## L3 — No manipulation inside function parameters; prepare values first

Classification: **Documented limitation**.

What the source says: LSP does not support manipulations/operations inside function parameters. Listed as not permitted: concatenation with `+`, nested function calls, math operations, type conversions. Golden rule: always do the manipulations BEFORE passing to the function. `Mensagem` is called out as extremely sensitive to this limitation.

Do not generate (source-faithful):

```lsp
@ ERRO: Concatenação no parâmetro @
Mensagem(Retorna, "Resultado: " + vaValor + " pontos");

@ ERRO: Função dentro de parâmetro @
Mensagem(Retorna, "Idade: " + IntParaAlfa(vnIdade));

@ ERRO: Operação matemática no parâmetro @
SubstAlfa("]}", vaObjeto + "]}", vaTexto);

@ ERRO: Múltiplas concatenações @
Mensagem(Retorna, vaNome + " - " + vaEmail + " (" + IntParaAlfa(vnId) + ")");
```

Generate instead (source-faithful):

```lsp
@ CORRETO: Fazer manipulações antes @
Definir Alfa vaMensagem;
Definir Alfa vaIdade;

IntParaAlfa(vnIdade, vaIdade);
vaMensagem = "Resultado: " + vaValor + " pontos";
Mensagem(Retorna, vaMensagem);

@ CORRETO: Para SubstAlfa @
vaObjeto = vaObjeto + "]}";
SubstAlfa("]}", vaObjeto, vaTexto);

@ CORRETO: Para múltiplas concatenações @
vaMensagem = vaNome + " - " + vaEmail + " (" + vaIdade + ")";
Mensagem(Retorna, vaMensagem);
```

Cheat-sheet form of the same rule (source-faithful):

```lsp
@ NUNCA FAÇA @
Mensagem(Retorna, "Valor: " + IntParaAlfa(vnNumero));  @ Erro! @
vnTamanho = TamanhoAlfa(vaTexto);                      @ Erro! @
AlfaParaDecimal(vaTexto, Grid.Campo);                  @ Erro! @

@  SEMPRE FAÇA @
IntParaAlfa(vnNumero, vaNumeroStr);
vaMensagem = "Valor: " + vaNumeroStr;
Mensagem(Retorna, vaMensagem);

TamanhoAlfa(vaTexto, vnTamanho);

AlfaParaDecimal(vaTexto, vnValor);
Grid.Campo = vnValor;
```

Final golden-rule form (source-faithful): wrong `Mensagem(Retorna, "Total: " + IntParaAlfa(vnSoma + vnExtra));` vs. right:

```lsp
vnTotal = vnSoma + vnExtra;
IntParaAlfa(vnTotal, vaTotalStr);
vaMensagem = "Total: " + vaTotalStr;
Mensagem(Retorna, vaMensagem);
```

Conflict note: one introductory example passes concatenation directly to `HttpGet` — `HttpGet(vaHTTP, "https://viacep.com.br/ws/" + vaCEP + "/json/", vaResposta);` — inside a section of presented-as-working examples. That contradicts the absolute “does not support” wording above. Until resolved against official Senior documentation, follow the safe pattern (build the URL in a variable first, as the dedicated CEP/HTTP examples do with `vaURL`) and treat the absolute scope (“every function”) as uncertain. The rule is at minimum solid for `Mensagem`, `TamanhoAlfa`, and `SubstAlfa`, which have explicit incorrect/correct pairs.

## L4 — Do not call output-parameter functions inside conditions

Classification: **Documentation conflict or uncertainty** (explicit incorrect examples exist AND contradicting presented-as-working examples exist).

Documented incorrect forms (source-faithful):

```lsp
@ ERRO MUITO COMUM: Usar em condicionais @
Se (TamanhoAlfa(vaCNPJ) <> 14) {
  Mensagem(Erro, "CNPJ deve ter 14 dígitos");
}

Se (ArqExiste(vaCaminho)) {
  Mensagem(Retorna, "Arquivo encontrado");
}
```

```lsp
@ ❌ INCORRETO @
Se (EstaNulo(vaDado, vnEhNulo) = 0) {  @ Função não retorna valor @
```

Documented correct pattern (source-faithful): execute first, compare the filled variable afterwards.

```lsp
@ CORRETO: Usar em condicionais @
Definir Numero vnTamanhoCNPJ;
TamanhoAlfa(vaCNPJ, vnTamanhoCNPJ);
Se (vnTamanhoCNPJ <> 14) {
  Mensagem(Erro, "CNPJ deve ter 14 dígitos");
}

Definir Numero vnArquivoExiste;
ArqExiste(vaCaminho, vnArquivoExiste);
Se (vnArquivoExiste = 1) {
  Mensagem(Retorna, "Arquivo encontrado");
}
```

```lsp
@ ✅ CORRETO @
EstaNulo(vaDado, vnEhNulo);  @ Executa função primeiro @
Se (vnEhNulo = 0) {          @ Compara variável preenchida @
```

Contradicting source examples (presented as working, same forbidden shape): `Se (TamanhoAlfa(vaCNPJ) <> 14)` in the introductory practical examples; `Se (TamanhoAlfa(vaValorTimeout) > 0)` in a configuration-loading function; `Se (TamanhoAlfa(vaFotoFuncionario) > 0)` in a blob-retrieval function; `Se (ArqExiste(vaCaminhoArquivo) = 1)` in an external-tools function; `Se (SQL_Proximo(vaSQL) = 1)` in a sales-report function. Placeholder-style examples (`Se (operacaoCritica() = 1)`, `Se (vlEncomendas.VaiParaChave() = 1)`) also use call-in-condition shape but with illustrative rather than LSP-established function names — do not treat those names as LSP evidence.

Guidance: always use the call-first pattern; it is the only form with explicit correct examples for `TamanhoAlfa`, `ArqExiste`, and `EstaNulo`. The scope of the prohibition beyond those functions is uncertain given the contradictions.

## L5 — `Mensagem` input rules and large-payload ban

Classification: **Documented limitation** (input concatenation ban and large-payload ban); **Language behavior** (button-index return, message types).

Input rules (source-backed “Regras Importantes” + “FUNDAMENTAL”):

1. No concatenation or any manipulation directly in `Mensagem()` parameters.
2. Build the text in an `Alfa` variable first, then pass that variable.
3. A plain string literal without concatenation is acceptable.

Source-faithful forms:

```lsp
Mensagem(Retorna, "Operação concluída com sucesso!");
Mensagem(Erro, "Ocorreu um erro na operação.");
```

```lsp
Definir Alfa vaResultado;
vaResultado = "Mensagem já formatada";
Mensagem(Retorna, vaResultado);
```

```lsp
Definir Alfa vaMensagem;
vaMensagem = "Aluno: " + vaNome + vaEnter + "Média: " + vaMedia;
Mensagem(Retorna, vaMensagem);
```

```lsp
@ ERRO: Concatenação no parâmetro - NÃO FUNCIONA @
Mensagem(Retorna, "Aluno: " + vaNome + vaEnter + "Média: " + vaMedia);
```

Large-payload ban: NEVER pass large JSON (similarly XML or long logs) to `Mensagem`; the source says it can hang the Senior system (travar o sistema Senior / travamento). Source-faithful dangerous forms:

```lsp
@ PERIGOSO - Pode travar o sistema @
Mensagem(Retorna, vaJSONResposta);  @ JSON grande @
Mensagem(Retorna, vaXMLCompleto);   @ XML grande @
Mensagem(Retorna, vaLogCompleto);   @ Log extenso @
```

Source-faithful safe alternatives (show a summary, not the payload):

```lsp
@  SEGURO - Mostrar apenas informações resumidas @
Definir Alfa vaMensagem;
Definir Numero vnTamanho;
Definir Alfa vaTamanhoStr;
TamanhoAlfa(vaJSONResposta, vnTamanho);
IntParaAlfa(vnTamanho, vaTamanhoStr);
vaMensagem = "JSON recebido com " + vaTamanhoStr + " caracteres";
Mensagem(Retorna, vaMensagem);

@  SEGURO - Mostrar apenas parte do conteúdo @
Definir Alfa vaJSONTrecho;
vaJSONTrecho = vaJSONResposta;
CopiarAlfa(vaJSONTrecho, 1, 50);
vaMensagem = "JSON início: " + vaJSONTrecho + "...";
Mensagem(Retorna, vaMensagem);
```

Return behavior (documented, input/output distinction matters): with button labels in brackets, `Mensagem` returns the chosen button’s sequence starting at 0 (source-faithful):

```lsp
Definir Numero vnRetorno;

vnRetorno = Mensagem(retorna,"Processo Concluído [&Ok!!!]"); @ O valor da variável vnRetorno será: 0 @

vnRetorno = Mensagem(retorna,"Deseja Sair ? [&Sim,&Não]"); @ O valor da variável vnRetorno será: 0 para Sim e 1 para Não @

vnRetorno = Mensagem(retorna,"Escolha uma opção ? [&Voltar,&Avançar, $Cancelar]"); @ O valor da variável vnRetorno será: 0 para Voltar, 1 para Avançar e 2 para Cancelar @
```

Message types per the source: `Retorna` shows a warning message with the bracket-specified buttons (`&` marks the accelerator key); `Erro` and `Refaz` raise an exception, show an error message, and abort the rule. The lowercase `retorna` spelling in the button examples coexists with uppercase `Retorna` elsewhere — consistent with documented case-insensitivity, not a separate function.

## L6 — Conversion results must not target grid/table fields or `p`-parameters directly

Classification: **Documented limitation**.

Grid/table restriction: conversion functions cannot assign directly into grid or table fields. Use an intermediate variable, then assign (source-faithful):

```lsp
@ ERRO: Atribuição direta em grid @
AlfaParaDecimal(vaTexto, MinhaGrid.CampoDecimal);
AlfaParaInt(vaTexto, MinhaTabela.CampoInteiro);
AlfaParaData(vaTexto, MinhaGrid.CampoData);
```

```lsp
@ CORRETO: Usar variável intermediária @
Definir Numero vnValorDecimal;
Definir Numero vnValorInteiro;
Definir Data vdDataConvertida;

AlfaParaDecimal(vaTexto, vnValorDecimal);
MinhaGrid.CampoDecimal = vnValorDecimal;

AlfaParaInt(vaTexto, vnValorInteiro);
MinhaTabela.CampoInteiro = vnValorInteiro;

AlfaParaData(vaTexto, vdDataConvertida);
MinhaGrid.CampoData = vdDataConvertida;
```

Golden rule for grids: always use an intermediate variable for conversions in grids/tables. Scope note: plain assignment of an already-converted variable (`Grid.Campo = vnValor;`) is shown as correct — the ban covers conversion-function outputs, not all assignment.

`SQL_Retornar` parameter restriction (critical rule): NEVER use `p`-prefixed function-parameter variables directly in `SQL_Retornar*` calls — Senior does not return values into them. Use locals, then assign to the parameters (source-faithful):

```lsp
@ ❌ INCORRETO - NÃO FUNCIONA @
Funcao minhaFuncao(Numero pCodigo, Numero End pResultado); {
  SQL_RetornarInteiro(xCursor, "CODIGO", pCodigo);      @ ERRO: não retorna valor @
  SQL_RetornarInteiro(xCursor, "RESULTADO", pResultado); @ ERRO: não retorna valor @
}
```

```lsp
@ ✅ CORRETO - FUNCIONA @
Funcao minhaFuncao(Numero pCodigo, Numero End pResultado); {
  Definir Numero vnCodigoTemp;
  Definir Numero vnResultadoTemp;

  SQL_RetornarInteiro(xCursor, "CODIGO", vnCodigoTemp);
  SQL_RetornarInteiro(xCursor, "RESULTADO", vnResultadoTemp);

  @ Atribuir valores às variáveis de parâmetro @
  pCodigo = vnCodigoTemp;
  pResultado = vnResultadoTemp;
}
```

## L7 — Only `Alfa` concatenates; mismatched assignment needs conversion

Classification: **Documented limitation**; examples also serve as **Common error / troubleshooting observation**.

Concatenation (source “REGRA CRÍTICA”: only `Alfa` variables can be concatenated):

```lsp
@ ❌ INCORRETO - ERRO DE CONCATENAÇÃO @
Definir Numero vnIdade;
Definir Alfa vaMensagem;
vnIdade = 25;
vaMensagem = "Idade: " + vnIdade;  @ ERRO: Numero não concatena @
```

```lsp
@ ✅ CORRETO - CONVERSÃO ANTES DA CONCATENAÇÃO @
Definir Numero vnIdade;
Definir Alfa vaIdadeStr;
Definir Alfa vaMensagem;
vnIdade = 25;
IntParaAlfa(vnIdade, vaIdadeStr);  @ Converte para Alfa @
vaMensagem = "Idade: " + vaIdadeStr;  @ Concatena apenas Alfas @
```

Assignment across types:

```lsp
@ ❌ INCORRETO - ERRO DE TIPO @
Definir Numero vnValor;
vnValor = "123";  @ Tentando atribuir string a número @
```

```lsp
@ ✅ CORRETO - CONVERSÃO ADEQUADA @
Definir Numero vnValor;
Definir Alfa vaTexto;
vaTexto = "123";
AlfaParaInt(vaTexto, vnValor);
```

Scope note: the source establishes this for `Numero` in `+` concatenation and for string-to-`Numero` assignment. `Data` in concatenation and other type pairs are not addressed — do not generalize.

## L8 — `Truncar` uses direct return; the two-argument form is marked wrong

Classification: **Documented limitation** (two-argument form) + **Documentation conflict or uncertainty** (against the general output-parameter rule).

Source troubleshooting (source-faithful):

```lsp
@ ❌ INCORRETO @
Truncar(vnDataHora, vnParteInteira);
```

```lsp
@ ✅ CORRETO @
vnParteInteira = Truncar(vnDataHora);  @ Sintaxe correta: Truncar(valor) retorna o valor truncado @
```

Consistent direct-return usages elsewhere in the source include `vnSomenteParte = vnDataHoraAtual - Truncar(vnDataHoraAtual);`, `vnValorTruncado = Truncar(vnValor);`, and the template `vnParteInteira = Truncar(<valor>);`. So within the inspected material `Truncar(value)` returning the truncated value is consistently documented — it is an exception to L1, not a contradiction internal to `Truncar` itself. Note the L1 summary table does not list `Truncar` at all; do not rely on that table for exhaustiveness.

## L9 — Date pitfalls: literals, `FormatarData` input type, `DataHoje` vs `DataHora`

Classification: **Documented limitation** (literal ban, `FormatarData` input type); **Documentation conflict or uncertainty** (`DataHoje` variable type).

No direct date literal (source-faithful):

```lsp
@ ❌ INCORRETO @
vdData = 15/08/1990;
```

Solution per the source: use `MontaData()` or `CodData()` (signatures belong to the dates slice; the variables file records the `MontaData` assignment rule).

`FormatarData` accepts only `Numero`, not `Data` (source-faithful):

```lsp
@ ❌ INCORRETO: FormatarData NÃO aceita tipo Data @
Definir Data vdData;
DataHoje(vdData);
FormatarData(vdData, "dd/MM/yyyy", vaData);  @ ERRO: FormatarData só aceita Numero @

@ ✅ CORRETO: FormatarData aceita apenas NUMERO (de DataHora) @
Definir Numero vnDataHora;         @ Correto: DataHora retorna Numero @
DataHora(vnDataHora);              @ Correto: Obtém número fracionário @
FormatarData(vnDataHora, "dd/MM/yyyy", vaData);  @ Correto: Funciona! @
```

Supporting statements: `DataHora` and `DataHoraUTC` return fractional numbers, not `Data` variables; the quick guide assigns `DataHoje` → `Data` (comparisons/operations) and `DataHora` → `Numero` (formatting/math).

Conflict: one `EntradaValor` date example fills a `Numero` variable with `DataHoje`:

```lsp
Definir Numero vnDataHoje;
DataHoje(vnDataHoje);
```

against many `Data`-typed `DataHoje(vdData…)` examples and the guide table (`DataHoje` → Tipo Data). Whether `DataHoje` can fill a `Numero` is unresolved in the inspected material — follow the `Data`-typed form, which has the explicit correct example above.

## L10 — Non-existent constructs from other languages

Classification: **Documented limitation** (each item explicitly “does not exist” in the source).

`Chr()` does not exist in LSP (source-faithful):

```lsp
@ ❌ INCORRETO @
vaStrProcura = "Primeira linha" + Chr(13) + Chr(10) + "Segunda linha";
```

Named alternative (no signature documented in the inspected sections; belongs to the function catalog):

```lsp
@ ✅ CORRETO @
Definir Alfa vaEnter;
CaracterParaAlfa(13, vaEnter);
vaStrProcura = "Primeira linha" + vaEnter + "Segunda linha";
```

The `Retorna;` command does not exist (source-faithful):

```lsp
@ ❌ NUNCA USE - NÃO EXISTE NA LSP @
Mensagem(Erro, "Dado inválido");
Retorna;
```

Documented pattern — interrupt with `Cancel(1)` (flow-interruption semantics belong to control flow; the call form is recorded here only as the named replacement):

```lsp
@ ✅ SEMPRE USE - PADRÃO CORRETO @
Mensagem(Erro, "Dado inválido");
Cancel(1);
```

Distinguish: `Retorna` as a `Mensagem` message *type* (`Mensagem(Retorna, vaMensagem)`) exists and is used throughout; only the standalone `Retorna;` flow command is documented as non-existent.

## L11 — `Cancel(n)` meaning depends on context

Classification: **Language behavior** (report-generator contexts); **Documented limitation** (screen-event rules).

Source statements:

- In screen-event rules, `Cancel(n)` only cancels the rule’s execution regardless of the passed value; to raise an error, use `Mensagem(Erro, "mensagem")` (or system-code handling of the `Cancel(n)` return).
- In the Report Generator: `Cancel(1)` cancels the rule and the control’s printing; in `Definição\Seleção` and `Detalhe\Antes_de_Imprimir` it excludes the current detail record; in `Definição\Pré-Seleção` it cancels the whole report. `Cancel(2)` prints the `ValStr` content in description-type controls then exits the rule. `Cancel(3)` is only for formula-type controls (formula ordering), excluding the current record.

Source-faithful call forms:

```lsp
Cancel(1); @ Cancela a execução da regra e a impressão do controle @
Cancel(2); @ Imprime o conteúdo da variável ValStr em controles do tipo descrição e depois sai da regra @
Cancel(3); @ Exclui o registro atual do relatório em controles do tipo fórmula @
```

Scope note: `ValStr`/`ValRet` mechanics and event semantics belong to later slices. Do not use `Cancel` outside a documented context on the assumption it behaves like `break`/`return` from other languages.

## L12 — Declaration placement (guardrail pointer)

Classification: **Community guidance** + **Common error / troubleshooting observation**.

Declaring inside a conditional block, or not declaring at all, is the documented cause of “Variável não definida” / “may cause errors”. Full incorrect/correct pairs live in `../language/variables.md` (Declaration placement); follow that file’s call-first, declare-at-top pattern when generating code. Not repeated here to avoid a second maintained copy.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Conceitos Fundamentais` / `Lembre-se Sempre`; `Debugging e Troubleshooting`; `Avisos Importantes para Iniciantes` (Limitações #1–#2, Regras #3–#5); `Erros Comuns e Soluções` (`Chr`, `FormatarData`, date literal, undeclared variables, `Truncar`, Erros #1–#6); `Conceitos Mentais` #1–#2 (return-parameter and manipulate-first models) and `Exemplos Práticos` (contradiction evidence); `LIMITAÇÕES CRÍTICAS DA LSP` in full (executive summary, parameter manipulation, `Mensagem` sensitivity, JSON/payload ban, `SQL_Retornar` parameter rule, direct-vs-output return with exception list and summary table, grid/table assignment); `Mensagens` (input rules, types, button-index return); `EntradaValor` (only for the `DataHoje(vnDataHoje)` conflict evidence); `Cancel` (context meanings); `Padrões e Boas Práticas` (supporting conventions); `Cheat Sheet — Armadilhas Comuns` and `LEMBRETE FINAL: Regra de Ouro`. Portuguese prose translated into English; LSP identifiers, literals, and code examples preserved unchanged. Senior Sistemas is the authoritative source for official behavior.
