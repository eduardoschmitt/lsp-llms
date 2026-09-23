# LSP control flow

Scope: conditional execution (`Se`, `Senao`), counted and conditional loops (`Para`, `Enquanto`), loop control (`Pare`, `Continue`), and explicit jumps (`VaPara` with labels). Condition operators, `++`/`--` operator semantics, function mechanics, and `Cancel(n)` contexts belong to other slices; they appear here only where the source requires them to explain a construct.

> Critical guidance for AI consumers: use only the documented forms below. Do not import loop, `break`, `continue`, truthiness, or `goto` semantics from other languages. Several behaviors (bound inclusivity, loop-variable scope, `Continue` in `Enquanto`) are explicitly undocumented or conflicted — the gaps are part of this reference.

## Conditional execution

### Se

Syntax (source-backed summary form):

```text
Se (condition) { }
```

Language behavior:

- `Se` (If) poses a comparison/question answered true or false. Parentheses around the condition are required (see `syntax.md`; the source marks `Se vnX < vnY {` incorrect).
- Compound conditions join with `e` (And — all must be true) and `ou` (Or — one suffices), per the reserved-words table.

Valid source example — simple conditional (source-faithful):

```lsp
Definir Numero vnIdade;
vnIdade = 20;
Se (vnIdade >= 18) {
  Mensagem(Retorna, "Maior de idade");
} Senao {
  Mensagem(Retorna, "Menor de idade");
}
```

### Senao

Syntax (source-backed summary form):

```text
Se (condition) { } Senao { }
```

Language behavior:

- `Senao` (Else) is the exit taken when the `Se` answer is false.

Chained conditions are demonstrated with repeated `Senao Se` (source-faithful):

```lsp
Definir Numero vnNota;
Definir Alfa vaConceito;
Definir Alfa vaMensagem;

vnNota = 85;

Se (vnNota >= 90) {
  vaConceito = "Excelente";
} Senao Se (vnNota >= 80) {
  vaConceito = "Bom";
} Senao Se (vnNota >= 70) {
  vaConceito = "Regular";
} Senao Se (vnNota >= 60) {
  vaConceito = "Suficiente";
} Senao {
  vaConceito = "Insuficiente";
}

vaMensagem = "Conceito: " + vaConceito;
Mensagem(Retorna, vaMensagem);
```

Complex and nested conditions with `e` and inner parentheses are demonstrated (source-faithful):

```lsp
Definir Numero vnIdade;
Definir Alfa vaCategoria;
Definir Numero vnRenda;
Definir Numero vnPontuacao;

vnIdade = 25;
vaCategoria = "PREMIUM";
vnRenda = 5000;

Se ((vnIdade >= 18) e (vnIdade <= 65) e (vaCategoria = "PREMIUM") e (vnRenda > 3000)) {
  vnPontuacao = 100;
  Mensagem(Retorna, " Cliente aprovado com pontuação máxima!");
} Senao Se ((vnIdade >= 18) e (vnRenda > 1500)) {
  vnPontuacao = 70;
  Mensagem(Retorna, "Cliente aprovado com restrições");
} Senao {
  vnPontuacao = 0;
  Mensagem(Retorna, "Cliente não aprovado");
}
```

Classification: language syntax plus illustrative examples. Whether `Senao Se` is a distinct chained construct or plain nesting is not stated — only the demonstrated shape is documented.

Condition-content conflict: the source both forbids output-parameter function calls directly inside conditions and shows that shape in presented-as-working examples. This conflict is preserved in `../guides/limitations.md` (L4) and is not resolved here. Generate conditions with plain variables and comparisons.

## Loops

### Para

Syntax per the reserved-words table (placeholders, not literal LSP):

```text
Para (<initial value>; <condition>; <counter>)
```

The table describes the behavior as: execute a command block a set number of times; an initial value is given and incremented by the counter value until the condition is false.

Documented loop-header shape (source-faithful):

```lsp
Definir Alfa vaIStr;
Para (i = 0; i < 10; i++) {
  IntParaAlfa(i, vaIStr);
  Mensagem(Retorna, vaIStr);
}
```

```lsp
Para (vnI = 1; vnI <= 10; vnI++) {
  Se (vnI = 5) {
    Pare;
  }
}
```

Established:

- The header has three `;`-separated parts: initialization, condition, counter.
- `++` and `--` appear as the counter step and are listed in the source `Operadores` section as increment/decrement by 1.

Deliberately not documented (do not infer):

- Inclusive vs. exclusive bounds. Both `i < 10` and `vnI <= 10` shapes appear; no rule states what the boundary does beyond the condition-until-false description.
- When or how the counter updates relative to the condition test and the body.
- Loop-variable declaration, scope, or lifetime. One example uses a bare `i` with no `Definir` and no `va`/`vn`/`vd` prefix — see conflicts below.

Uncertainty: the reserved-words table writes the syntax with a trailing semicolon after the closing parenthesis (`Para (...);`), while every `Para` example omits it (`Para (...) {`). Follow the examples; the table’s semicolon reads as sentence punctuation, but the source never clarifies this.

### Enquanto

Syntax per the reserved-words table (placeholders):

```text
Enquanto (<condition>)
```

Language behavior per the table: execute a command block repeatedly until the condition is false.

Documented shape (source-faithful):

```lsp
Definir Numero vnContador;
Definir Alfa vaContadorStr;
vnContador = 0;

Enquanto (vnContador < 10) {
  IntParaAlfa(vnContador, vaContadorStr);
  Mensagem(Retorna, vaContadorStr);
  vnContador++;
}
```

Established: the block repeats while the condition holds; the examples advance a counter variable manually inside the body. Truthiness rules, evaluation timing, and any maximum iteration behavior are not documented. The infinite-loop troubleshooting (`Enquanto (vnContador > 0)` without updating the control variable vs. a bounded, incremented form) is preserved in the limitations slice’s error catalog and stays there.

## Loop control

### Pare

Language behavior per the reserved-words table: interrupts execution of a `Para` or `Enquanto` repetition block; execution continues with the rules after the block.

Documented limitation (explicit scope rule): `Pare;` may only be used inside `Para` or `Enquanto` loops. Used outside these contexts, it causes a compilation error.

Valid source examples (source-faithful; correctness annotations translated per repository style, code unchanged):

```lsp
@ Dentro de loop Para @
Para (vnI = 1; vnI <= 10; vnI++) {
  Se (vnI = 5) {
    Pare;  @ Correct: dentro do loop Para @
  }
}

@ Dentro de loop Enquanto @
Enquanto (vnContador > 0) {
  Se (vnContador = 3) {
    Pare;  @ Correct: dentro do loop Enquanto @
  }
  vnContador--;
}
```

Intentionally invalid source example with the documented fix (source-faithful):

```lsp
@ Incorrect: dentro de função, fora de loops @
Funcao validarDados(); {
  Se (vnTamanho < 5) {
    Mensagem(Erro, "Tamanho inválido");
    Pare;  @ ERRO: Pare só funciona em loops! @
  }
}

@ Correct: usar Cancel(1) para interromper função @
Funcao validarDados(); {
  Se (vnTamanho < 5) {
    Mensagem(Erro, "Tamanho inválido");
    Cancel(1);  @ Correct: para interromper função @
  }
}
```

Practical source example combining both commands (source-faithful):

```lsp
Definir Funcao exemploControleFluxo();

@ Variáveis globais @
Definir Numero vnContador;
Definir Alfa vaDados;
Definir Numero vnTamanho;

exemploControleFluxo();

Funcao exemploControleFluxo(); {
  @ Loop com Pare - usar Pare @
  vnContador = 1;
  Para (vnContador = 1; vnContador <= 10; vnContador++) {
    Se (vnContador = 5) {
      Pare;  @ Correct: saindo de loop @
    }
  }

  @ Validação final - usar Cancel(1) @
  TamanhoAlfa(vaDados, vnTamanho);
  Se (vnTamanho < 3) {
    Cancel(1);  @ Correct: saindo de função @
  }

  Mensagem(Retorna, "Processamento concluído!");
}
```

Source summary (community guidance): to interrupt loops use `Pare;`; to interrupt functions, error handling, and validations use `Cancel(1);` — never `Pare;` outside loops, and always `Cancel(1);` after error messages. Full `Cancel(n)` contexts live in `../guides/limitations.md` (L11).

Comparative note (analogy, not equivalence): `Pare` resembles `break` in other languages only in that it exits the repetition block. The source establishes neither labeled breaks, nor multi-level exits, nor any value-returning behavior. A community loop example comments that `Pare` stops “only the inner loop” in nested `Enquanto` loops — treat that as illustrative example behavior, not a normative nested-loop rule.

Standalone loop-exit example (source-faithful):

```lsp
Definir Alfa vaContadorStr;
Para (vnContador = 0; vnContador < 10; vnContador++) {
  Se (vnContador = 5) {
    Pare;
  }
  IntParaAlfa(vnContador, vaContadorStr);
  Mensagem(Retorna, vaContadorStr);
}
```

### Continue

Documented behavior (reserved-words table, single sentence): continues execution of a loop made with the `Para` command — i.e., when the loop body should be skipped in a given case, test the condition and use this command. Syntax: `Continue;`.

What is established: the keyword exists, is written `Continue;`, and skips to further loop execution in the demonstrated sense above.

What is not established: everything else. There is no prose example in the main documentation, no stated interaction with the `Para` counter, and no stated behavior for nested loops.

Documentation conflict: the table scopes `Continue` to `Para` loops, but the community example `exemplos/ExemploControleLoop.lsp` uses `Continue;` six times inside `Enquanto` loops (selective processing, nested-matrix skips), with manual counter increments placed before each `Continue`. Example-level evidence therefore contradicts the `Para`-only scoping. Until resolved against official Senior documentation, use `Continue` only in `Para` loops (the sole normatively scoped context) and treat the `Enquanto` usage as unverified community-example behavior. The example’s remark that controls “affect only the current loop” is likewise illustrative, not normative.

## Explicit jumps

### VaPara

Documented syntax (reserved-words table and control-flow summary):

```text
VaPara <rótulo>;
```

Language behavior per the table: diverts (desvia) execution of the rule to the given label.

Label form: the single source example writes the label as a bare name followed by a colon on its own line. Those two labels (`menorDeIdade:`, `fim:`) are the only label occurrences found in the inspected source.

Source example (source-faithful):

```lsp
Definir Numero vnIdade;
vnIdade = 20;

Se (vnIdade < 18) {
  VaPara menorDeIdade;
}

Mensagem(Retorna, "Maior de idade");
VaPara fim;

menorDeIdade:
Mensagem(Retorna, "Menor de idade");

fim:
```

Deliberately not documented: label naming rules, forward/backward jump permissions, jumping into or out of blocks, loops, or functions, interaction with variable state, and any warning for or against use. The tableʼs parenthetical “(Goto)” is a naming gloss, not a grant of conventional `goto` semantics. Do not infer any of the above.

## Cancel (minimum context)

`Cancel(1)` is the documented way to interrupt function/rule execution after error messages; `Pare` must not be used for that purpose. All `Cancel(1)`/`Cancel(2)`/`Cancel(3)` contexts and the screen-event limitation are classified in `../guides/limitations.md` (L11) and are not duplicated here.

## Known documentation conflicts

1. **Function calls inside conditions** — explicit incorrect examples vs. presented-as-working examples (`TamanhoAlfa`, `ArqExiste`, `SQL_Proximo` in conditions). Preserved in `../guides/limitations.md` (L4).
2. **`Continue` scope** — reserved-words table (`Para` loops) vs. six `Enquanto`-loop usages in `exemplos/ExemploControleLoop.lsp`. Unresolved; `Para`-only use is the safe pattern.
3. **`Para` header punctuation** — table shows a trailing `;` after `)`, all examples omit it. Follow the examples; flagged as likely sentence punctuation.
4. **Loop-variable requirements** — `Para (i = 0; …)` uses an undeclared, prefix-less `i`, conflicting with the declaration and naming guidance in `variables.md`. Declaration, scope, and lifetime of loop variables are undocumented.
5. **Mid-block declarations** — the same community loop example declares variables inside `Se`/loop bodies throughout, conflicting with the declare-at-top guidance in `variables.md`. Community-example evidence vs. community guidance; unresolved.
6. **Bound and timing semantics** — inclusivity, counter-update timing, `Enquanto` evaluation details, `Pare`/`Continue` in nested loops beyond one illustrative comment: all undocumented. Not inferred.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Palavras Reservadas` table rows (`Se`, `Senao`, `e`, `ou`, `Para`, `Enquanto`, `Pare`, `Continue`, `Vapara`); `Controle de Fluxo` (summary table, `Pare` scope rule with correct/incorrect pairs, `Cancel(1)` vs `Pare` practice table, worked `exemploControleFluxo`, progressive `Se`/`Senao` levels 1–3, `Estrutura de Repetição`, `Pare`, `VaPara`); `Operadores` (only to confirm `++`/`--` are listed as increment/decrement by 1); `Regra #5`, loop-infinite troubleshooting, and quick-reference control structures as consistency checks. `exemplos/ExemploControleLoop.lsp` was inspected solely for `Pare`/`Continue`/declaration conflicts. Portuguese prose translated into English; correctness annotations in comments rendered as `Correct`/`Incorrect` per repository style with code unchanged. Senior Sistemas is the authoritative source for official behavior.
