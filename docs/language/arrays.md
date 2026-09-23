# LSP arrays and indexed values

Scope: bracket declarations (`Definir <Tipo> <name>[N]`), indexed access (`name[i]`), assignment through indexes, iteration over indexed values, and the unresolved `Alfa[N]` sized-string vs. array conflict. `Lista`, `Tabela`, `Grid`, database cursors, and JSON arrays are separate constructs and are not covered here.

> Critical guidance for AI consumers: bracket positions start at 1 for the tested constructs below — verified by Senior execution diagnostics and official Senior documentation, which contradict the 0-based community examples still quoted on this page for the record. `Definir Alfa vaNome[30];` constrains a string; `Definir Numero vnNotas[5];` with `vnNotas[1]` … `vnNotas[5]` is the demonstrated working collection form. Do not generate 0-based bracket access (`x[0]`), and do not generate bracketed declarations without matching the exact documented use below.

## What the source calls an array

Language description (source statements): arrays are variables with defined sizes that store multiple values of the same type; they are useful for fixed-size collections of data.

Documented array declarations (source-faithful):

```lsp
Definir Alfa vaNomes[10];
Definir Numero vnIdades[5];
Definir Data vdDatas[3];
```

Types with explicit array evidence: `Alfa`, `Numero`, and `Data` — each has a declaration, element assignments, element reads, and (for `Alfa`/`Numero`) loop iteration in the source. No other type has array evidence. Multidimensional arrays are never documented.

Documented working access (verified by v0.1 evaluation diagnostics): element
positions run 1-based. Two independent generated rules using `vnNotas[0]` failed
with `Erro indexando fora dos limites: 0`, and minimal corrections shifting only
`0..4` to `1..5` compiled and produced correct results 3/3 in both cases (see
`evals/language-generation-v0.1/POSTMORTEM.md`, Finding #1). Official Senior
support article 23581 independently establishes 1-based vector positions and
recommends dynamic lists for collection-like needs (see Provenance).

## The `Alfa[N]` conflict

This is the central unresolved ambiguity of this slice. Both forms below are documented in different sections with the same surface syntax:

Sized string (variables section): `[30]` is the maximum chain length of one string.

```lsp
Definir Alfa vaNome[30];
```

Array (arrays section): `[10]` declares a multi-value collection.

```lsp
Definir Alfa vaNomes[10];
```

The sections agree on nothing else either:

| Aspect | Sized-string section | Arrays section |
|---|---|---|
| Meaning of `[N]` | maximum string length | collection of values |
| First index demonstrated | `vaNome[1]` | `vaNomes[0]` |
| Index kinds | fixed, variable, formula | literal and loop-variable only |
| Assignment shown | single indexed writes | per-element writes |

No passage in the community documentation states whether these are one mechanism or two, and no rule there disambiguates `Definir Alfa x[N];` in isolation. Possible readings (same mechanism with inconsistent examples, two mechanisms sharing syntax, erroneous examples) all lack decisive evidence from that material alone — the ambiguity is preserved, not resolved. It is now bounded by external evidence (see above): 0-based access failed Senior execution while 1-based access passed, and the official Senior article describes 1-based char positions for `Alfa[N]`.

Conservative project guidance (not compiler semantics): do not generate 0-based bracket access for these constructs — Senior execution rejected index 0 (`Erro indexando fora dos limites: 0`) while 1-based corrections passed 3/3 (see Finding #1 in `evals/language-generation-v0.1/POSTMORTEM.md`). Do not generate `Definir Alfa name[N];` intending an array unless the surrounding code matches the arrays-section pattern element-for-element (per-element assignment from `[1]`, loop-variable reads); do not generate it intending a bounded string unless matching the variables-section pattern; never infer capacity, growth, or bounds behavior from `[N]`.

## Index base

The community documentation demonstrates two different bases without explaining why:

- Arrays-section collections are written and read starting at `[0]`: a `[3]`-declared collection is filled and read at indexes 0, 1, 2, and loops run `i = 0; i < 3; i++`. This 0-based use is now contradicted evidence (see below), not a valid pattern.
- The sized-string section writes `vaNome[1]` first; the `GerTabAlf`/`GerTabNum` system arrays (different construct, future system domain) are written at `[1]`.

Evaluation and official evidence converge on 1-based positions for the tested constructs: Senior execution rejected `[0]` and accepted `[1]` … `[5]` (POSTMORTEM Finding #1), and official Senior article 23581 describes 1-based vector positions. Generate 1-based access for these constructs; never generate `[0]`.

## Indexed assignment and reads

Array-section assignment (source-faithful):

```lsp
vaNomes[0] = "João";
vaNomes[1] = "Maria";
vaNomes[2] = "Pedro";

vnIdades[0] = 25;
vnIdades[1] = 30;
vnIdades[2] = 35;

vdDatas[0] = "01/01/2020";
vdDatas[1] = "15/03/2021";
vdDatas[2] = "10/10/2022";
```

Array-section reads (source-faithful excerpts):

```lsp
Mensagem(Retorna, vaNomes[0]); @ Displays "João" @
Definir Alfa vaIdadeStr;
IntParaAlfa(vnIdades[1], vaIdadeStr);
Mensagem(Retorna, vaIdadeStr); @ Displays 30 @
Mensagem(Retorna, vdDatas[2]); @ Displays "10/10/2022" @
```

Established: `collection[index] = value;` writes and `value`/`call(collection[index])` reads are demonstrated for all three types. Copy/reference semantics, coercion, and out-of-range behavior are undocumented.

Sized-string indexed writes (variables section, source-faithful):

```lsp
Definir Alfa vaNome[30];
Definir Numero vnIndice;

vnIndice = 1;

@ Fixed value @
vaNome[1] = "Nome";

@ Variable value @
vaNome[vnIndice] = "Nome";

@ Formula value @
vaNome[vnIndice + 1 * 2 ] = "Nome";
```

The variables section additionally states an index may be a fixed value, a variable, or a formula. That statement sits in the sized-string context; whether it also governs array collections is unstated. Formula indexes appear nowhere in the arrays section.

Date note: `vdDatas[0] = "01/01/2020";` assigns an `Alfa` date-text literal into a `Data` collection element. This is preserved exactly as found and deepens the date-literal conflict owned by `../functions/dates-time.md` — it must not be read as establishing date-literal support.

## Iteration

Arrays are documented as iterable with `Para` or `Enquanto` (control-flow semantics in `control-flow.md`, not repeated here). Source pattern (source-faithful):

```lsp
Definir Alfa vaIdadeStr;

Para (i = 0; i < 3; i++) {
  Mensagem(Retorna, vaNomes[i]);
}

Definir Numero j;
j = 0;
Enquanto (j < 3) {
  IntParaAlfa(vnIdades[j], vaIdadeStr);
  Mensagem(Retorna, vaIdadeStr);
  j++;
}
```

Complete declaration-to-iteration example (source-faithful):

```lsp
Definir Alfa vaNomes[3];
Definir Numero vnIdades[3];
Definir Data vdDatas[3];
Definir Alfa vaIdadeStr;

vaNomes[0] = "João";
vaNomes[1] = "Maria";
vaNomes[2] = "Pedro";

vnIdades[0] = 25;
vnIdades[1] = 30;
vnIdades[2] = 35;

vdDatas[0] = "01/01/2020";
vdDatas[1] = "15/03/2021";
vdDatas[2] = "10/10/2022";

Para (i = 0; i < 3; i++) {
  Mensagem(Retorna, vaNomes[i]);
}

Definir Numero j;
j = 0;
Enquanto (j < 3) {
  IntParaAlfa(vnIdades[j], vaIdadeStr);
  Mensagem(Retorna, vaIdadeStr);
  j++;
}
```

Loop bounds here (`i < 3` over a `[3]` collection) are demonstrated pairings, not a length rule: never infer collection length from loop bounds. The bare loop variable `i` (no `Definir`, no `va`/`vn` prefix) recurs here — the same declaration conflict recorded in `control-flow.md` — and is preserved, not endorsed. Evaluation evidence: 1-based loops of the shape `Para (vnI = 1; vnI <= 5; vnI++)` over `[5]`-declared collections compiled and executed correctly in both v0.1 diagnostics (see POSTMORTEM Finding #1); the 0-based loop shapes above did not.

## Explicitly not arrays

- `GerTabAlf[1]` / `GerTabNum[1]`: system-variable registers with their own single-array-in-memory restriction — future system domain.
- `Acumulador[1].Media_Mensal`: `Tabela` row access — documented in `collections.md`.
- `resultado[0]` / `resultado[1]`: JSON-path fragments in `ValorElementoJson` limitation notes (documented as not working there) — documented in `../data/json.md`.
- `Lista*` / `ListaRegra*`: dynamic and rule lists — documented in `collections.md`.
- `Cur_Consulta.SQL`, grid fields, cursor handles: not bracket collections.

## Deliberately not documented

Minimum/maximum valid index, out-of-bounds diagnostics, automatic growth, bounds checking, default element values, element count vs. capacity meaning of `[N]`, memory layout, performance, multidimensional or ragged collections, and any disambiguation of the `Alfa[N]` conflict — none stated, none inferred.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Tipo de Dados e Variáveis` (sized-`Alfa` declaration and fixed/variable/formula access), `Definição de Arrays` in full (description, declaration, assignment, access, iteration, complete example), plus bracket-occurrence sweeps across the whole README (declaration inventory; `[0]`/`[1]` access inventory; `Tabela`, `GerTab*`, and JSON-path exclusions) and all `exemplos/*.lsp` (no bracket declarations found). Post-v0.1 evidence added: official Senior support article 23581 (`Indexando fora dos limites` — 1-based vector positions for `Alfa[N]`, dynamic-list recommendation; paraphrased, not copied) and the v0.1 evaluation diagnostics (0-based rejection, 1-based 3/3 passes; see `evals/language-generation-v0.1/POSTMORTEM.md`, Finding #1). Current evidence base is community documentation, community examples, Senior execution results, and the cited official article. Senior Sistemas is the authoritative source for official behavior.
