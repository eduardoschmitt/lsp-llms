# LSP arrays and indexed values

Scope: bracket declarations (`Definir <Tipo> <name>[N]`), indexed access (`name[i]`), assignment through indexes, iteration over indexed values, and the unresolved `Alfa[N]` sized-string vs. array conflict. `Lista`, `Tabela`, `Grid`, database cursors, and JSON arrays are separate constructs and are not covered here.

> Critical guidance for AI consumers: bracket syntax has two documented meanings that the source never reconciles. `Definir Alfa vaNome[30];` is documented as a maximum string length, while `Definir Alfa vaNomes[10];` is documented as an array. Do not assume `[N]` means array size, and do not generate bracketed declarations without matching the exact documented use below.

## What the source calls an array

Language description (source statements): arrays are variables with defined sizes that store multiple values of the same type; they are useful for fixed-size collections of data.

Documented array declarations (source-faithful):

```lsp
Definir Alfa vaNomes[10];
Definir Numero vnIdades[5];
Definir Data vdDatas[3];
```

Types with explicit array evidence: `Alfa`, `Numero`, and `Data` — each has a declaration, element assignments, element reads, and (for `Alfa`/`Numero`) loop iteration in the source. No other type has array evidence. Multidimensional arrays are never documented.

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

No passage states whether these are one mechanism or two, and no rule disambiguates `Definir Alfa x[N];` in isolation. Possible readings (same mechanism with inconsistent examples, two mechanisms sharing syntax, erroneous examples) all lack decisive evidence — the ambiguity is preserved, not resolved.

Conservative project guidance (not compiler semantics): do not generate `Definir Alfa name[N];` intending an array unless the surrounding code matches the arrays-section pattern element-for-element (per-element assignment from `[0]`, loop-variable reads); do not generate it intending a bounded string unless matching the variables-section pattern; never infer capacity, growth, or bounds behavior from `[N]`.

## Index base

The source demonstrates two different bases without explaining why:

- Arrays-section collections start at `[0]`: a `[3]`-declared collection is filled and read at indexes 0, 1, 2, and loops run `i = 0; i < 3; i++`.
- The sized-string section writes `vaNome[1]` first; the `GerTabAlf`/`GerTabNum` system arrays (different construct, future system domain) are written at `[1]`.

Whether the base depends on construct, type, or nothing at all is undocumented. Do not normalize to zero-based or one-based expectations. Generate only the base demonstrated for the exact construct being used.

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

Loop bounds here (`i < 3` over a `[3]` collection) are demonstrated pairings, not a length rule: never infer collection length from loop bounds. The bare loop variable `i` (no `Definir`, no `va`/`vn` prefix) recurs here — the same declaration conflict recorded in `control-flow.md` — and is preserved, not endorsed.

## Explicitly not arrays

- `GerTabAlf[1]` / `GerTabNum[1]`: system-variable registers with their own single-array-in-memory restriction — future system domain.
- `Acumulador[1].Media_Mensal`: `Tabela` row access — future table domain.
- `resultado[0]` / `resultado[1]`: JSON-path fragments in `ValorElementoJson` limitation notes (documented as not working there) — future JSON domain.
- `Lista*` / `ListaRegra*`: dynamic and rule lists — future list domains.
- `Cur_Consulta.SQL`, grid fields, cursor handles: not bracket collections.

## Deliberately not documented

Minimum/maximum valid index, out-of-bounds diagnostics, automatic growth, bounds checking, default element values, element count vs. capacity meaning of `[N]`, memory layout, performance, multidimensional or ragged collections, and any disambiguation of the `Alfa[N]` conflict — none stated, none inferred.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Tipo de Dados e Variáveis` (sized-`Alfa` declaration and fixed/variable/formula access), `Definição de Arrays` in full (description, declaration, assignment, access, iteration, complete example), plus bracket-occurrence sweeps across the whole README (declaration inventory; `[0]`/`[1]` access inventory; `Tabela`, `GerTab*`, and JSON-path exclusions) and all `exemplos/*.lsp` (no bracket declarations found). Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
