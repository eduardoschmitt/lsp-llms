# LSP file operations

Scope: handle-based text file I/O (`Abrir`/`Ler`/`Lernl`/`Gravar`/`Gravarnl`/`Fechar`), whole-file loading (`CarregarTextoArq`), existence checks (`ArqExiste`), line counting (`LinhasArquivo`), and temporary-file creation/deletion. External program execution, BLOB/database file use, and report output are neighboring concerns referenced only at their boundaries.

> Critical guidance for AI consumers: open modes, read/write shapes, and cleanup below are exactly as demonstrated. Do not invent path, encoding, newline, error, or resource-management semantics. File handles are obtained from `Abrir` by direct return — one of the few documented direct-return forms — while most other file functions use output parameters or act in place.

## Mechanisms (not one filesystem abstraction)

- **Handle-based I/O**: `Abrir` a path for a mode, then `Ler`/`Lernl`/`Gravar`/`Gravarnl` through the returned handle, then `Fechar`. Demonstrated end to end.
- **Whole-file load**: `CarregarTextoArq` reads a text file's content into an `Alfa` variable with no handle.
- **Existence check**: `ArqExiste` reports 1/0 through an output variable.
- **Line count**: `LinhasArquivo` reports a file's line total through an output variable.
- **Temporary files**: `CriarArquivoTemporario` / `ExcluirArquivoTemporario` create and delete temp files.

## Abrir

Purpose: open the stated file for the stated mode. If the file does not exist, it is created. Returns a file handle.

Signature (source-faithful, direct return):

```lsp
Abrir ("<nome do arquivo>",<modo de abertura>);
```

Demonstrated (source-faithful):

```lsp
arq = Abrir("Teste.txt", Ler);
```

```lsp
vnArquivo = Abrir(vaCaminhoTemp, Gravarnl);
```

```lsp
vnArquivo = Abrir(vaCaminhoTemp, Lernl);
```

```lsp
xArquivo = Abrir("C:/Teste.jpg", Ler);
```

Open modes: the reserved-words table names `Ler` (read) and `Gravar` (write). Working examples additionally demonstrate `Lernl` and `Gravarnl` as modes, and one JSON-loading example demonstrates the string `"LerNL"`:

```lsp
vnArquivo = Abrir(vaArquivo, "LerNL");
```

No unifying rule for mode values is documented — bare words and one string spelling coexist without explanation. Modes beyond `Ler`, `Gravar`, `Lernl`, `Gravarnl`, and `"LerNL"` are undocumented. Return behavior: direct return into a variable in every occurrence.

Evaluation-verified correspondence (Senior Gestão Empresarial, 5.10.4.9): open mode must match the operation family — `Gravarnl` mode with `Gravarnl` calls and `Lernl` mode with `Lernl` calls compiled and executed, while mixing `Gravar` mode with `Gravarnl` calls failed at runtime (`Operação inválido para arquivos abertos para escrita alfanumérica`). See `evals/backend-generation-v0.1/results/gemini-3-1-pro-low/B02.corrected-modes.result.md`. Version-pinned observation, not a universal specification.

## Ler and Lernl

`Ler` purpose: read a stated character count from the handle's file into a variable.

Signature (source-faithful):

```lsp
Ler(<manipulador de arquivo>,<variável>,<tamanho>);
```

Demonstrated (source-faithful):

```lsp
Ler(arq, S, 20);
```

```lsp
Ler(xArquivo, xBlob, 9999999);
```

`Lernl` purpose: read one line from the handle's file into a variable.

Signature (source-faithful):

```lsp
Lernl(<manipulador de arquivo>,<variável>);
```

Demonstrated (source-faithful):

```lsp
Lernl(arq, S);
```

```lsp
Lernl(vnArquivo, vaConteudo);
```

No direct-return form of either exists in the source. Advancement, buffering, end-of-file signaling, and short-read behavior are undocumented — there is no file EOF function anywhere in the source. The one related loop form, `Enquanto (LerNL(vnArquivo, vaLinha) = 1)`, belongs to the observed-only `LerNL` below, not to `Ler`/`Lernl`.

## Gravar and Gravarnl

`Gravar` purpose: write a constant's or variable's value, for a stated character count, into the handle's file.

Signature (source-faithful):

```lsp
Gravar(<manipulador de arquivo>,<<variável> ou <constante>>,<tamanho>);
```

Demonstrated (source-faithful):

```lsp
Gravar(arq, S, 20);
```

`Gravarnl` purpose: write one line into the handle's file with a variable's or constant's value.

Signature (source-faithful):

```lsp
Gravarnl(<manipulador de arquivo>,<<variável> ou <constante>>);
```

Demonstrated (source-faithful):

```lsp
Gravarnl(arq, Str);
```

```lsp
Gravarnl(vnArquivo, vaConteudo);
```

Overwrite vs. append, newline insertion mechanics, encoding, and partial-write behavior are undocumented. Whether `Gravarnl` adds any line-break characters is unstated — do not assume it.

## Fechar

Purpose: close a file previously opened by `Abrir`.

Signature (source-faithful):

```lsp
Fechar (<manipulador do arquivo>);
```

Demonstrated (source-faithful):

```lsp
Fechar(arq);
```

```lsp
Fechar(vnArquivo);
```

Every open-then-use example closes its handle. Whether cleanup is mandatory, what double-close does, and what happens to unclosed handles are undocumented.

## Full read-write lifecycle (demonstrated)

The temporary-file example exercises the whole handle lifecycle (source-faithful excerpt):

```lsp
@ 1. Creates a temporary file @
CriarArquivoTemporario("processamento_", vaCaminhoTemp);
vaMensagem = "Arquivo temporário criado: " + vaCaminhoTemp;
Mensagem(Retorna, vaMensagem);

@ 2. Writes data to the file @
vnArquivo = Abrir(vaCaminhoTemp, Gravarnl);
Para (vnContador = 1; vnContador <= 10; vnContador++) {
  vaConteudo = "Linha " + IntParaAlfa(vnContador) + " do arquivo temporário";
  Gravarnl(vnArquivo, vaConteudo);
}
Fechar(vnArquivo);
```

Note: the `vaConteudo = "Linha " + IntParaAlfa(vnContador) + ...` line nests a conversion call inside concatenation in presented-as-working material — the same contradiction recorded for conversion guidance, preserved here without resolution.

## CarregarTextoArq

Purpose: load a text file's content into an alphanumeric variable.

Signature (source-faithful):

```lsp
CarregarTextoArq(<arquivo>, <texto>);
```

Parameters:

- `arquivo` — input. Variable holding the file path to read.
- `texto` — output. Variable receiving the file's text.

Demonstrated (source-faithful):

```lsp
Definir Alfa vaTexto;
CarregarTextoArq("C:\\Senior\\Sapiens\\Arquivo.txt", vaTexto);
```

Text-vs-binary scope, failure behavior, size limits, and encoding are undocumented. A literal path is demonstrated in the path position; treat that as demonstrated, not as a general rule.

## ArqExiste

Purpose: check whether a physical file exists at the stated location.

Signature (source-faithful):

```lsp
ArqExiste(<caminhoArquivo>, <existe>);
```

Parameters:

- `caminhoArquivo` — input. Full file path.
- `existe` — output. Receives 1 if it exists, 0 if not.

Demonstrated (source-faithful excerpt):

```lsp
@ Checks the data file @
ArqExiste(vaCaminhoArquivo, vnExisteArquivo);
Se (vnExisteArquivo = 1) {
  Mensagem(Retorna, "Arquivo de dados encontrado");
} Senao {
  Definir Alfa vaMensagem;
  vaMensagem = "Arquivo de dados não encontrado: " + vaCaminhoArquivo;
  Mensagem(Erro, vaMensagem);
}
```

Documentation conflict (preserved, linked to `../guides/limitations.md` L4): the 2-argument output-parameter form above is the specified one, yet presented-as-working examples also use `Se (ArqExiste(vaCaminhoArquivo) = 1)` and even bare `Se ((vaArquivo <> "") e (ArqExiste(vaArquivo)))`. The 1-argument direct forms appear both in documented-incorrect blocks (`vnExiste = ArqExiste(vaCaminho);`) and in working examples — unresolved. Version evidence: on Senior Gestão Empresarial 5.10.4.9 the 2-argument call was rejected (`Muitos parâmetros na chamada da função "ARQEXISTE"`) while the 1-argument form executed and reported correctly (see `evals/backend-generation-v0.1/results/gemini-3-1-pro-low/B02.result.md`). Follow the 2-argument form unless targeting that verified environment.

## LinhasArquivo

Purpose: count a file's lines through a return parameter.

Signature (source-faithful):

```lsp
LinhasArquivo(<caminhoArquivo>, <linhas>);
```

Parameters:

- `caminhoArquivo` — input. Path of the file to analyze.
- `linhas` — output. Variable receiving the line count.

Demonstrated (source-faithful excerpt):

```lsp
@ 3. Checks the created file @
LinhasArquivo(vaCaminhoTemp, vnLinhas);
IntParaAlfa(vnLinhas, vaQuantidadeStr);
vaMensagem = "Arquivo criado com " + vaQuantidadeStr + " linhas";
Mensagem(Retorna, vaMensagem);
```

What counts as a "line" is undocumented.

## Temporary files

- `CriarArquivoTemporario(<prefixo>, <caminhoArquivo>);` — creates a uniquely named temporary file; prefix input, path output.
- `ExcluirArquivoTemporario(<caminhoArquivo>);` — deletes a previously created temporary file.

Demonstrated (source-faithful excerpts):

```lsp
@ 1. Creates a temporary file @
CriarArquivoTemporario("processamento_", vaCaminhoTemp);
```

```lsp
@ 5. Removes the temporary file @
ExcluirArquivoTemporario(vaCaminhoTemp);
Mensagem(Retorna, "Arquivo temporário removido");
```

Uniqueness mechanics, temp-directory location, and delete-failure behavior are undocumented.

## Paths (demonstrated only)

Attested path spellings (preserved exactly; each is example evidence, not a platform rule):

```lsp
arq = Abrir("Teste.txt", Ler);
```

```lsp
vaCaminhoArquivo = "C:\\temp\\dados.txt";
vaCaminhoConfig = "C:\\config\\app.ini";
vaCaminhoLog = "C:\\logs\\sistema.log";
```

```lsp
xArquivo = Abrir("C:/Teste.jpg", Ler);
```

```lsp
CarregarTextoArq("C:\\Senior\\Sapiens\\Arquivo.txt", vaTexto);
```

No claim about separators, drives, relative bases, working directories, UNC, variables, permissions, or portability is documented. Do not infer any.

## Observed-only: LerNL

`LerNL` appears twice with no dedicated section: `Abrir(vaArquivo, "LerNL");` and `Enquanto (LerNL(vnArquivo, vaLinha) = 1) { vaConteudoJson = vaConteudoJson + vaLinha; }` in the JSON-loading example. The loop shape suggests line reading with a 1/0 status return, but that is inference from one example — recorded as observed-only with unknown classification. Do not present `LerNL` as specified.

## Boundaries (deferred with description)

- `ExecProg(<comando>, <parametros>, <aguardarTermino>);` (e.g. `ExecProg(vaComando, vaParametros, 0);` for notepad/explorer/cmd) executes external programs — a system-integration API, not file I/O. Deferred to a future system slice.
- `SQL_DefinirBlob` and file-to-BLOB reads (`Ler(vnArquivo, vaBlob, 9999999);` after `Abrir(..., Ler)`) belong to the database slice, which owns BLOB semantics.
- Report file output (`Personalização do Nome do Arquivo Gerado`) and import/export file rules belong to future report/import slices.
- `ListaRegraSalvarLista` (saves lists to .txt/.csv): rule-list/file boundary, deferred with the rule-list catalog.

## Conservative project guidance

- Use exactly the demonstrated lifecycle: `Abrir` (direct return) to `Ler`/`Lernl`/`Gravar`/`Gravarnl` to `Fechar`; `ArqExiste`/`LinhasArquivo`/`CarregarTextoArq` need no handle.
- Never invent file function names (`FileExists`, `ReadLn2`, `DeleteFile`, …) or mode values beyond the attested ones.
- Do not assume path portability, default encoding, newline behavior, append/overwrite choice, or error diagnostics.
- Do not place `ArqExiste(...)` directly in conditions on analogy — the evidence conflicts (follow the 2-argument form).
- Treat `LerNL` as observed-only.

All guidance is project caution unless independently backed above.

## Conflicts and uncertainty on this page

1. `ArqExiste` 2-argument specification vs. 1-argument working uses (one with `= 1`, one bare). Unresolved; linked to limitations L4.
2. Open-mode spellings (`Ler`/`Gravar` per table; `Lernl`/`Gravarnl` and `"LerNL"` demonstrated) with no unifying rule. Unresolved.
3. Nested conversion call inside a working concatenation line in the temp-file example. Preserved from conversion findings.
4. Arithmetic plus concatenation inside a working `AtualizaBarraProgresso(...)` call in the same example. Further L3-family evidence, preserved.

## Deliberately not documented

EOF signaling, read/write failure modes, missing-file behavior beyond create-on-open, permissions, locking, sharing, buffering, seek/rewind, directories, file deletion other than temp files, encoding and newline mechanics, handle limits and lifetime, and any security model.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Manipulação de Arquivos` in full (`Abrir`, `Ler`, `Lernl`, `Gravar`, `Gravarnl`, `Fechar`), `Gerenciamento Avançado de Arquivos` (`CriarArquivoTemporario`, `ExcluirArquivoTemporario`, `LinhasArquivo` with temp-file example, `ExecProg` inspected for the deferral boundary), `Validação de Arquivos` (`ArqExiste` with multi-file example), `CarregarTextoArq` (strings section, adopted here), the `LerNL` JSON-loading example (observed-only evidence), reserved-words table rows for file commands, plus whole-repo name/arity sweeps. Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
