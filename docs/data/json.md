# LSP JSON handling

Scope: how JSON text is held (`Alfa`), read field-by-field (`ValorElementoJson`), loaded as collections (`ListaRegraCarregarJson` + rule-list navigation), and parsed by hand with string functions. HTTP transport, file transport, and the full rule-list catalog belong to their own slices and appear here only at the boundary.

> Critical guidance for AI consumers: there is no JSON primitive, no object mapping, and no JSONPath. JSON lives in `Alfa` text; you read one field per call, navigate collections through rule-list functions, or scan the text manually. Never write JavaScript-style access (`obj.key`, `arr[0]`), never assume arrays map to LSP arrays, and never invent a JSON builder.

## Representation

All JSON payloads encountered in the inspected source are held in `Alfa` variables: assigned literals with `\"` escapes, HTTP response variables, and file-read accumulations alike. Processed form is either more `Alfa` variables (one extracted value each) or a rule-list identifier (`Numero`) walked with `ListaRegraPrimeiro`/`Proximo`/`ObterValor*` (see `collections.md` for that API). No JSON object, array, or value type exists on the LSP side.

## Approach 1 — ValorElementoJson (single fields)

Purpose: read one field's value from JSON text.

Signature (source-faithful):

```lsp
ValorElementoJson(Alfa aJson, Alfa aGrupo, Alfa aElemento, Alfa End aValor);
```

Parameters:

- `aJson` — input. `Alfa` holding the JSON content.
- `aGrupo` — input. Groups to traverse to reach the field; multiple levels separated by `";"`.
- `aElemento` — input. Field to read.
- `aValor` — output (`End`). `Alfa` receiving the field's value.

Basic example (source-faithful):

```lsp
Definir Alfa vaJSON;
Definir Alfa vaId;
Definir Alfa vaNome;

vaJSON = "{\"usuario\": {\"id\": 123, \"nome\": \"João Silva\"}}";

@ Extract the "id" element from the "usuario" group @
ValorElementoJson(vaJSON, "usuario", "id", vaId);
@ vaId will be "123" @

@ Extract the "nome" element from the "usuario" group @
ValorElementoJson(vaJSON, "usuario", "nome", vaNome);
@ vaNome will be "João Silva" @
```

Note the demonstrated numeric-to-`Alfa` retrieval: JSON `"id": 123` (a number) lands in `vaId` as `"123"`. That is demonstrated coercion in this example, not a specified conversion rule.

Nested groups and arrays (source-faithful excerpt):

```lsp
@ Extract the company data @
ValorElementoJson(vaJSON, "resultado;empresa", "nome", vaNomeEmpresa);

@ Extract location data (multiple ";"-separated levels) @
ValorElementoJson(vaJSON, "resultado;empresa;localizacao", "pais", vaPais);
ValorElementoJson(vaJSON, "resultado;empresa;localizacao", "estado", vaEstado);
ValorElementoJson(vaJSON, "resultado;empresa;localizacao;cidade", "nome", vaCidade);

@ Extract department data (first array element) @
ValorElementoJson(vaJSON, "resultado;empresa;departamentos", "nome", vaDepartamento);

@ Extract project data (first nested-array element) @
ValorElementoJson(vaJSON, "resultado;empresa;departamentos;projetos", "nome", vaProjeto);
ValorElementoJson(vaJSON, "resultado;empresa;departamentos;projetos", "versao", vaVersao);
```

Documented limits (source observations, translated):

1. Group parameter: `";"` separates nested levels (`"resultado;empresa;localizacao"`).
2. Arrays: the function cannot walk arrays; it always finds only the first occurrence of the element.
3. Dot notation: `resultado.empresa.nome` does not work, unlike other languages.
4. Indexed access: `resultado[0]` and `resultado[1]` do not work. This rejection is stated as a general property of the function — highly visible on purpose: never generate indexed JSON paths.
5. Case sensitivity: group and element names are case-sensitive; spelling must exactly match the JSON.

Missing-key, malformed-JSON, empty-JSON, and wrong-type behaviors are undocumented for this function. (The sibling loader errors on missing fields; that rule is stated only for the loader.)

## Approach 2 — ListaRegraCarregarJson (collections)

Purpose: load a JSON group's array of objects as rule-list rows (fields become columns, records become rows), then walk them with the rule-list API.

Lifecycle as documented: `ListaRegraCriarLista` first (it yields the list identifier), then load, then `ListaRegraPrimeiro`/`Proximo` with `"S"`/`"N"`, reading fields per record. Full call shapes and the `"S"`/`"N"` convention live in `collections.md` and are not repeated here.

Structural requirement: bare arrays cannot be read — the function works on objects containing arrays. A top-level array must first be wrapped in an object (source-faithful excerpt):

```lsp
@ Wrap the array in an object @
vaJSONModificado = "{\"usuarios\":" + vaJSONResposta + "}";

@ Create and load the list @
ListaRegraCriarLista(nListaUsuarios);
ListaRegraCarregarJson(nListaUsuarios, vaJSONModificado, "usuarios", "id;nome;email");
```

Stated load rule: fields are `";"`-separated, and a requested field missing from the JSON raises an error (nonexistent/unfindable). Nested arrays are not traversable with this approach — use manual parsing instead. Type-specific getters (`ListaRegraObterValorNumero`, `...Data`) appear in examples; the `Numero`-getter-into-`Alfa`-variable oddity is preserved in `collections.md` and not re-litigated here.

## Approach 3 — manual string scanning (complex cases)

For nested arrays, complex structures, or custom logic, the source prescribes hand parsing with `PosicaoAlfa`, `LerPosicaoAlfa`, `CopiarAlfa`, and `SubstAlfa` (all owned by `strings.md`): locate a `"key":` marker, skip spaces by ASCII code, scan to a comma or `}`, copy the span, strip spaces. The community `ManipulacaoJSON.lsp` applies exactly this to freight-quote JSON (`"vltotal":`, `"prazo":`, `"status":`, `"servico":`) with call shapes consistent with the strings reference. No new semantics are introduced here; follow the strings signatures.

## JSON arrays (synthesis)

- `ValorElementoJson`: first occurrence only; indexed paths rejected outright.
- `ListaRegraCarregarJson`: whole group arrays become rows; bare arrays must be wrapped; nested arrays unsupported.
- Manual scanning: the only documented route into nested arrays.
- LSP `arrays.md` collections are never connected to JSON arrays in the source. Never transfer semantics between them.

## JSON objects (synthesis)

Objects are navigated as `";"`-separated group paths ending in a field name. They are never mapped to `Lista`, `Tabela`, `Grid`, or language objects. `Tabela`-shaped thinking ("columns") appears only in the loader's fields-become-columns description.

## Types, null, booleans

- Retrieval is demonstrated only into `Alfa` (`ValorElementoJson`'s 4th parameter is `Alfa End`; numeric JSON values land as text). No boolean, null, or typed retrieval exists for this function.
- JSON `true` occurs once in community test data (`"ativo": true`) with no retrieval demonstrated. JSON `null`, missing-value defaults, and malformed-input behavior are entirely undocumented. Never map JSON `null` to any LSP default.
- The loader's missing-field error is the only documented failure in this domain.

## Generation (none documented)

No JSON-building API exists in the source. JSON text is produced by `Alfa` assignment with `\"` escapes:

```lsp
vaJSON = "{\"usuario\": {\"nome\": \"João\", \"token\": \"abc123\"}}";
```

Escaping follows the string rules in `syntax.md` (backslash before `"` and `\`). One anomaly is preserved: a complex example builds display text with `"\n"` inside concatenation (`vaRetorno = "Empresa: " + vaNomeEmpresa + "\n" + ...`), while the strings reference states LSP has no `\n` escape. Whether `"\n"` is meaningful or a source slip is unresolved — do not rely on it.

## File and HTTP boundaries

- Files: the JSON-loading example accumulates text with `Abrir(vaArquivo, "LerNL");` + `Enquanto (LerNL(vnArquivo, vaLinha) = 1)` (see `io/files.md`: `LerNL` is observed-only). No encoding is ever stated.
- HTTP: ViaCEP/reqres examples feed response variables straight into the three approaches (see `../integration/http-webservices.md` for transport). Response-size caution from limitations (large payloads into `Mensagem`) applies to JSON responses as well.
- `ConverteTexto` (`"JSON"` codes) converts character escapes, not data structures — owned by `strings.md`, not a JSON API.

## Conservative project guidance

- Hold JSON in `Alfa`; read fields with `ValorElementoJson` (group `";"`, exact case); load collections only through create-then-load rule lists; hand-scan anything nested.
- Never generate `resultado[0]`, dot paths, typed getters, builders, or null handling.
- Wrap top-level arrays before loading; expect an error for missing loader fields; verify navigation status (`"S"`/`"N"` or 1/0 per API).

All guidance is project caution unless independently backed above.

## Deferred (inspected, not this domain)

- Full `ListaRegra*` catalog beyond JSON loading/reading: future rule-list/Senior slice.
- `ConverteTexto`, `PosicaoAlfa`, `LerPosicaoAlfa`, `CopiarAlfa`, `SubstAlfa`: strings slice owns them.
- `LerNL`, `Abrir` modes, temp files: I/O slice owns them.
- `HttpGet`/`HttpObjeto`/status/headers/auth: documented in `../integration/http-webservices.md`.
- `Mensagem`-payload limits: limitations slice owns them.

## Conflicts and uncertainty on this page

1. Indexed JSON paths rejected (general statement) — no counter-evidence; highly visible by design.
2. `"\n"` inside a working concatenation vs. the no-`\n` rule. Unresolved.
3. `ListaRegraObterValorNumero`-into-`Alfa` (inherited from collections findings). Unresolved there.
4. `Mensagem` with concatenation inside JSON-example lines vs. parameters guidance. Inherited from limitations L3.
5. Numeric JSON values retrieved as `Alfa` text: demonstrated twice, specified never.

## Deliberately not documented

Missing-key behavior for `ValorElementoJson`, malformed/empty input handling, load-failure modes beyond the missing-field error, type coercion rules, boolean/null representation, encoding, size limits, performance beyond the source's own comparison claims (which are reproduced as claims, not verified facts), and any grammar of supported JSON.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Manipulação de JSON` in full (three approaches, comparison claims, usage recommendations, tips), `ValorElementoJson` reference (signature table, basic/nested/API examples, five observations), `ListaRegraCarregarJson` section plus the JSON-processing example (wrap requirement, missing-field error), large-payload limitation, plus whole-repo sweeps (75 `ValorElementoJson` occurrences, no builder API, no JSON null/boolean/malformed semantics) and `ManipulacaoJSON.lsp` (approach conformance, test-data payloads). Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
