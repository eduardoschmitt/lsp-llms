# LSP HTTP and web services

Scope: the `Http*` helper family (object lifecycle, verbs, headers, status, cookies, encoding, redirect, proxy, SSL/SNI, timeout, download, attachment, Base64 auth helpers) and the Senior web-service port model (`Definir` service variables, `Executar`, parameter cleanup, WS grids). Transport only: JSON parsing lives in `../data/json.md`, file I/O in `../io/files.md`.

> Critical guidance for AI consumers: two different mechanisms live here — generic HTTP helpers driven by an `Alfa` object handle, and Senior web-service ports driven by declared service variables with grids. Never mix them, never invent verbs or helpers, and never assume REST/SOAP/fetch semantics. Responses arrive as `Alfa` (or files for download); nothing is parsed automatically.

## Mechanism A — HTTP helpers

Lifecycle as demonstrated: `HttpObjeto`, then per-object configuration, then a verb call, then optional status/header reads, then body parsed separately by the caller.

```lsp
Definir Alfa vaHTTP;
HttpObjeto(vaHTTP);
```

Request-executing verbs require such an object, which carries proxy, SSL/TLS, encoding, timeout, and cookie settings — either from the Senior "Configurações de Internet" screen (applied automatically) or configured in-rule (in-memory, per-object, overriding the center). Stated limits: no digital-certificate support; only request-composing parameters (headers, content-type, basic auth, etc.).

Programmatic configuration (source-faithful):

```lsp
Definir Alfa vaHTTP;

HttpObjeto(vaHTTP);

@ Settings specific to this request @
HttpAlteraConfiguracaoProxy(vaHTTP, 1, "proxy.empresa.com", 8080, 1);
HttpAlteraConfiguracaoSSL(vaHTTP, 2); @ Always SSL @
HttpAlteraCodifCaracPadrao(vaHTTP, "utf-8");
HttpSetaTimeout(vaHTTP, 30);

@ These settings affect only this vaHTTP object @
HttpGet(vaHTTP, "https://api.exemplo.com/dados", vaResposta);
```

## Verbs (all attested — no symmetry assumed)

| Function | Purpose per source | Signature |
|---|---|---|
| `HttpGet` | GET data | `HttpGet(Alfa Objeto, Alfa URL, Alfa end HTML);` |
| `HttpPost` | POST data | `HttpPost(Alfa Objeto, Alfa URL, Alfa Dados, Alfa end HTML);` |
| `HttpPut` | PUT full-resource update | `HttpPut(Alfa Objeto, Alfa URL, Alfa Dados, Alfa end HTML);` |
| `HttpPatch` | PATCH partial modification | `HttpPatch(Alfa end Objeto, Alfa URL, Alfa Dados, Alfa end Retorno);` |
| `HttpDelete` | DELETE resource | `HttpDelete(Alfa Objeto, Alfa URL, Alfa end HTML);` |
| `HttpDeleteBody` | DELETE with a message body (batch/specific deletes) | `HttpDeleteBody(Alfa Objeto, Alfa URL, Alfa Dados, Alfa end HTML);` |
| `HttpDownload` | download straight to disk (large files) | `HttpDownload(Alfa Objeto, Alfa URL, Alfa Arquivo);` |

No HEAD/OPTIONS/TRACE exists. Directions: `Objeto`/`URL`/`Dados` inputs; the trailing response variable output (`end`). `HttpPatch` (and several config functions below) mark the object itself `end` in the signature — recorded exactly as printed, without interpreting the marker beyond the demonstrated call shape. `HttpDownload` takes a destination path instead of a response variable and is recommended for large files so memory is not consumed; the destination directory must exist.

GET basic + status-checked forms (source-faithful):

```lsp
Definir Alfa vaHTTP;
Definir Alfa vaResposta;

HttpObjeto(vaHTTP);
HttpGet(vaHTTP, "https://www.senior.com.br/index.htm", vaResposta);
Mensagem(Retorna, vaResposta);
```

```lsp
Definir Alfa vaHTTP;
Definir Alfa vaResposta;
Definir Numero vnStatus;

HttpObjeto(vaHTTP);
HttpDesabilitaErroResposta(vaHTTP);

HttpGet(vaHTTP, "https://api.exemplo.com/usuarios", vaResposta);
HttpLeCodigoResposta(vaHTTP, vnStatus);

Se (vnStatus = 200) {
  @ Process the response @
  Mensagem(Retorna, "Dados recebidos com sucesso!");
} Senao {
  @ Handle the error @
  Mensagem(Erro, "Erro na requisição. Status: " + vnStatus);
}
```

POST with JSON body (source-faithful):

```lsp
Definir Alfa vaHTTP;
Definir Alfa vaResposta;
Definir Alfa vaDados;

HttpObjeto(vaHTTP);

@ Configure for JSON @
HttpAlteraCabecalhoRequisicao(vaHTTP, "Accept", "text/plain");
HttpAlteraCabecalhoRequisicao(vaHTTP, "Content-Type", "application/json");

@ JSON-formatted data @
vaDados = "{\"NomeParametro1\": \"valor1\", \"NomeParametro2\": \"valor2\"}";

HttpPost(vaHTTP, "https://exemplo.com/app/path", vaDados, vaResposta);
```

PUT with JSON (source-faithful):

```lsp
Definir Alfa vaHTTP;
Definir Alfa vaResposta;
Definir Alfa vaDados;

HttpObjeto(vaHTTP);

@ Configure headers @
HttpAlteraCabecalhoRequisicao(vaHTTP, "Content-Type", "application/json");
HttpAlteraCabecalhoRequisicao(vaHTTP, "Authorization", "Bearer token123");

@ Data for the update @
vaDados = "{\"nome\": \"João Silva\", \"status\": \"ativo\", \"email\": \"joao.silva@exemplo.com\"}";

HttpPut(vaHTTP, "https://api.exemplo.com/usuarios/123", vaDados, vaResposta);
```

DELETE with 204 check (source-faithful):

```lsp
Definir Alfa vaHTTP;
Definir Alfa vaResposta;
Definir Numero vnStatus;

HttpObjeto(vaHTTP);
HttpDesabilitaErroResposta(vaHTTP);

@ Configure authentication @
HttpAlteraCabecalhoRequisicao(vaHTTP, "Authorization", "Bearer token123");

HttpDelete(vaHTTP, "https://api.exemplo.com/usuarios/123", vaResposta);

@ Check the result @
HttpLeCodigoResposta(vaHTTP, vnStatus);
Se (vnStatus = 204) {
  Mensagem(Retorna, "Usuário excluído com sucesso!");
} Senao {
  Mensagem(Erro, "Erro ao excluir usuário. Status: " + vnStatus);
}
```

DELETE-with-body and PATCH (source-faithful excerpts):

```lsp
vaDados = "[{\"id\": \"123\"}]";
HttpDeleteBody(vaHTTP, "https://www.senior.com.br/registro", vaDados, vaResposta);
```

```lsp
vaDados = "[{\"id\": \"123\"}, {\"id\": \"456\"}, {\"id\": \"789\"}]";

HttpDeleteBody(vaHTTP, "https://api.exemplo.com/usuarios/lote", vaDados, vaResposta);
```

```lsp
@ Partial-modification data (only changed fields) @
vaDados = "{\"status\": \"ativo\", \"ultimo_acesso\": \"2024-01-15\"}";

HttpAlteraCabecalhoRequisicao(vaHTTP, "Content-Type", "application/json");
HttpPatch(vaHTTP, "https://api.exemplo.com/usuarios/123", vaDados, vaResposta);
```

Stated verb notes: PUT replaces the whole resource (include all needed fields); PATCH sends only changed fields; PUT/PATCH accept text format only, not binary files; default request Content-Type is `application/x-www-form-urlencoded; charset=windows-1252` (configure `application/json` for JSON; set UTF-8 explicitly when needed; malformed JSON yields error 400).

## URLs, bodies, responses

- URLs must be complete with protocol (`http://`/`https://`); special characters may error on some Senior systems. Example URLs are preserved verbatim throughout this page. URL/query encoding, DNS, redirects (beyond the 0/1 redirect control), default ports, and relative URLs are undocumented.
- Bodies are `Alfa` variables (`vaDados`); Content-Type is a separate header setting — no automatic serialization is documented. Response bodies land in the trailing `Alfa` variable; nothing is parsed automatically (JSON handling in `../data/json.md`).
- Concatenated-URL conflict (preserved): an introductory example calls `HttpGet(vaHTTP, "https://viacep.com.br/ws/" + vaCEP + "/json/", vaResposta);` — expression-built URL in working material vs. the conservative parameters guidance. Likewise `HttpAlteraCabecalhoRequisicao(vaHTTP, "Authorization", "Bearer " + vaToken);` builds a header value inline, and several `Mensagem` lines concatenate status values — all preserved as L3-family witnesses (see limitations L3), not rewritten.

## Status, errors, timeout

- `HttpLeCodigoResposta(vaHTTP, vnStatus);` reads the numeric status into an output variable. Demonstrated checks: `= 200`, `= 201`, `= 204`, `>= 500`, and the range form `Se ((vnCodRes >= 200) e (vnCodRes <= 204))` for success vs. `Se ((vnCodRes < 200) ou (vnCodRes >= 300))` for errors. Each threshold is demonstrated usage, not a universal success rule.
- Documented code meanings: 200 OK, 201 Created, 204 No Content, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity, 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable.
- Error control: `HttpDesabilitaErroResposta(vaHTTP);` disables automatic 4xx/5xx exceptions for manual handling; `HttpHabilitaErroResposta(vaHTTP);` re-enables them (the default).

```lsp
@ Disables automatic exceptions for 4xx/5xx codes @
HttpDesabilitaErroResposta(vaHTTP);

@ Enables automatic exceptions (default) @
HttpHabilitaErroResposta(vaHTTP);
```

- `HttpSetaTimeout(Alfa Objeto, Numero Timeout);` — limit in seconds (demonstrated: 5, 10, 30, 60, 120; configure always, per expected speed). No retry/backoff API exists; the SSL section's multi-attempt pattern is manual re-execution, not a retry feature.

## Headers, cookies, encoding, redirect

- `HttpAlteraCabecalhoRequisicao(Alfa end Objeto, Alfa Nome, Alfa Valor);` — custom headers for all verbs. Name must not be empty; empty value removes the header. Demonstrated names: `Accept`, `Content-Type`, `Authorization`, `User-Agent`, `Accept-Charset`, `Cache-Control`, `Pragma`, `Accept-Encoding`, `Cache-Control`.
- `HttpLeCabecalhoResposta(Alfa end Objeto, Alfa Nome, Alfa end Valor);` — read-back after a request; empty when absent; first occurrence wins except `WWW-Authenticate`/`Proxy-Authenticate`, which may return multiples.
- Cookies: `HttpHabilitarCookies(Alfa Objeto);` / `HttpDesabilitarCookies(Alfa Objeto);` for automatic session storage/sending, kept for the object's session lifetime.

```lsp
@ Enable cookies to keep the session @
HttpHabilitarCookies(vaHTTP);

@ Log in @
HttpPost(vaHTTP, "https://app.exemplo.com/login", "user=admin&pass=123", vaResposta);

@ Session cookies are sent automatically @
HttpGet(vaHTTP, "https://app.exemplo.com/dashboard", vaResposta);

@ Disable cookies if needed @
HttpDesabilitarCookies(vaHTTP);
```

- Encoding: `HttpAlteraCodifCaracPadrao(Alfa end Objeto, Alfa Codificacao);` for server responses lacking a stated encoding; supported: UTF-8, ISO-8859-1, Windows-1252 (invalid values may yield empty/error). Conflict: the function section states default ISO-8859-1 while the observations state default windows-1252 — unresolved; configure explicitly.
- Redirect: `HttpAlteraRedirecionamento(Alfa Objeto, Numero AceitaRedirecionamento);` — 0 ignores, 1 follows 3xx automatically.
- `HttpNormalizaRetorno(Alfa end Objeto);` — canonical Unicode C normalization of accented response characters (two-code-point Á becomes one).

## Proxy, SSL, SNI, progress

- Proxy: `HttpAlteraConfiguracaoProxy(Alfa Objeto, Numero UsarProxy, Alfa Servidor, Numero Porta, Numero AutPorUsu);` (1/0 use; 1/0 auth) with demonstrated corporate values; read-back via `HttpLeConfiguracaoProxy` (four `end` outputs); credentials via `HttpAlteraAutenticacaoProxy(Alfa Objeto, Alfa Usuario, Alfa Senha);` / read-back variant. The exception micro-API (`Adiciona`/`LeContador`/`LeExcecao`/`ExcluiExcecao`/`LimpaExcecoes` + `Proxy`) is present in source; only `HttpAdicionaExcecaoProxy(vaHTTP, "localhost");` is demonstrated here — remaining members are name-only inventory for this slice, not specified behavior. A WEB 5.0 proxy limitation is noted in source without portable detail.
- SSL: `HttpAlteraConfiguracaoSSL(Alfa Objeto, …)` with values 0 = automatic, 1 = never, 2 = always; read-back variant exists. SNI: `HttpHabilitaSNI` / `HttpDesabilitaSNI` (modern APIs, cert-less HTTPS). No digital-certificate support, stated plainly. SeniorConfigCenter holds mandatory settings; three named error classes (EIdOSSLConnectError, SSL23 handshake failure, EIdIOHandlerPropInvalid) have scenario-based workarounds in source — summarized, not reproduced as diagnostics.
- Download progress: `HttpAlteraMostrarProgresso` / `HttpLeMostrarProgresso` exist; behavior not expanded here.
- Object reuse across requests and automatic connection pooling are stated; per-request pooling/timeout internals are not.

## Attachment and Base64 auth helpers

- `HttpSetAttachment(Alfa end Objeto, Alfa CaminhoArquivo);` — attaches a local file to POST/PUT/PATCH bodies (file must exist; one file per request — separate requests for more).

```lsp
@ Attach the file @
HttpSetAttachment(vaHTTP, "C:\\temp\\documento.pdf");

@ Configure headers @
HttpAlteraCabecalhoRequisicao(vaHTTP, "Authorization", "Bearer token123");

HttpPost(vaHTTP, "https://api.exemplo.com/upload", "", vaResposta);
```

- `Base64Encode(Alfa valor, Alfa end Base64Encode);` / `Base64Decode(Alfa valor, Alfa end Base64Decode);` — output-parameter codecs, documented for Basic auth (`vaCredencial = user + ":" + pass`, encode, prefix `"Basic "`) and JWT/token handling. Expected outputs (`dmFsb3IgcGFyYSBjb252ZXJ0ZXI=`) are demonstrated, not specified test vectors.

Basic + token flow (source-faithful excerpts):

```lsp
@ Encode the credentials @
Base64Encode(vaCredenciais, vaBase64);
vaAuth = "Basic " + vaBase64;

@ Use vaAuth in the Authorization header @
HttpAlteraCabecalhoRequisicao(vaHTTP, "Authorization", vaAuth);
```

```lsp
@ Extract the token from the JSON @
ValorElementoJson(vaJSON, "", "token", vaToken);

@ Success log @
Mensagem(Retorna, "Token gerado com sucesso!");
```

```lsp
@ Error handling @
Se ((vnCodRes < 200) ou (vnCodRes >= 300)) {
  IntParaAlfa(vnCodRes, vaCodRes);
  vaMsgUsu = "Erro HTTP [" + vaCodRes + "]: Falha na autenticação. Verifique as credenciais.";
  Mensagem(Erro, vaMsgUsu);
}
```

Community auth examples (observed-consistent): Basic header from Base64(`user:pass`), Bearer header from a token variable, `HttpGet` + `ValorElementoJson(vaJSON, "", "token", vaToken)` extraction.

## Mechanism B — Senior web-service ports

A separate, context-specific model: declare a service variable, set parameters (including table-typed grids), execute, and manage automatic input cleanup.

```lsp
Definir interno.com.senior.g5.rh.fp.calculoFolha.Calcular vCalcula;
```

```lsp
Definir xServico.xPorta wsPorta;
```

- Execution modes by number: 1 Local, 2 Sync, 3 Async; Agendado (scheduled) is unavailable in LSP rules. `ModoExecucao = 1` belongs only to web-service-instance rules (not Cliente-Servidor, BrowserAccess, WindowsAccess, Web 5.0, or automatic processes).
- `nomePorta.Executar();` runs the port's operation.
- Parameter cleanup: `DesatLimpezaParamEnt()` keeps inputs across executions; `AtivaLimpezaParamEnt()` restores auto-cleanup; `LimparParamsEntrada()` clears on demand. Default is automatic cleanup enabled — stated three times, including the "called or not, default holds" form.

Two-execution reuse pattern (source-faithful excerpt):

```lsp
@ Disable automatic cleanup to reuse parameters @
wsPorta.DesatLimpezaParamEnt();

@ === FIRST EXECUTION === @
@ Configure parameters for the first person @
wsPorta.codPessoa = vnCodPessoa1;
wsPorta.nomPessoa = vaNomPessoa1;

@ Configure contact data (table type) @
wsPorta.dadosContato.CriarLinha();
wsPorta.dadosContato.telContato = vaTelContato;
wsPorta.dadosContato.nomContato = vaNomContato;

@ Execute the first insertion @
wsPorta.Executar(); @ First execution @
```

Grid role (the deferred collections pointer, resolved as WS-specific): grids are port parameter structures — created per input row (`service.Grid.CriarLinha();`), read back per output row with `QtdLinhas` count and settable `LinhaAtual`:

```lsp
nomeWebService.NomeGrid.CriarLinha();
variavel = nomeWebService.NomeGrid.QtdLinhas;
nomeWebService.NomeGrid.LinhaAtual = numeroLinha;
```

Input-fill and output-read patterns plus a freight-quote worked example and a Cursor-to-Lista-to-Grid performance recommendation live in source; the WS grid API is owned here, general `Grid` semantics remain undocumented per `collections.md`. WS-Security (`WSSeguranca` XML header) and default implicit-login params (`usuario`/`user`, `senha`/`password`, central-config opt-out) are stated mechanics — recorded without SOAP-envelope interpretation.

## Boundaries

- JSON: response bodies parse via `../data/json.md` mechanisms only; transport never parses.
- Files: `HttpDownload` destinations and `HttpSetAttachment` sources obey `../io/files.md` path discipline (verbatim paths, no portability claims).
- Large responses into `Mensagem` inherit the payload caution from limitations.
- `ConverteTexto`/`ConverteCodificacaoString` are strings-owned; decimal-format conversion notes are transport-adjacent claims, not encoding specs.

## Conservative project guidance

- One mechanism per integration; exact call shapes; `HttpObjeto` first, always.
- Never invent verbs/helpers/headers/auth flows; never assume status semantics beyond demonstrated checks; configure timeouts explicitly.
- Treat bodies as `Alfa`; set Content-Type deliberately; do not assume serialization, encoding, retries, redirects, or certificate behavior.
- Keep WS ports, grids, and cleanup calls inside their documented pattern; do not mix with HTTP helpers.

All guidance is project caution unless independently backed above.

## Deferred (inspected, not this domain)

- Proxy-exception micro-API beyond `AdicionaExcecaoProxy` (name inventory only).
- Full SSL-scenario walkthroughs and SeniorConfigCenter screen detail (summarized).
- Corporate-config mega-example (pattern summarized; per-call shapes covered).
- ViaCEP/IBGE/reqres worked API examples and `ExemploHTTP_*` cruises (usage consistent with documented calls; transport detail owned here, parsing owned by json.md).
- `HttpAdicionaExcecaoProxy` siblings, progress APIs: present, unspecified here.

## Conflicts and uncertainty on this page

1. Expression-built URL/headers in working examples vs. parameters guidance. Preserved (L3 family).
2. `Mensagem` + concatenation/status-Numero lines in working HTTP examples. Preserved (L3 family).
3. Quick-ref card 3-arg `HttpPost(http, url, dados)` (and 2-arg `ValorElementoJson(json, path)`) vs. specified arities. Cards are lossy summaries; specified forms govern.
4. Encoding defaults (ISO-8859-1 vs. windows-1252). Unresolved; configure explicitly.
5. `end` on object parameters (`HttpPatch`, header/codec/proxy calls) unexplained. Preserved verbatim, uninterpreted.
6. Success thresholds vary by example (200, 201, 204, 200–204). Demonstrated per case only.

## Deliberately not documented

Redirect internals, retry/backoff, connection pooling/timeout internals, DNS, URL %-encoding, certificate validation, protocol versions, proxy auth flows, cookie security, JWT structure, SOAP/WSDL mechanics, server-side behavior, and any REST semantics beyond the verb table.

## Provenance

Transformed from `brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao/README.md`: `Chamada de Web Service` (modes, WS-Security, auth, port functions, full reuse example, grid entry/exit/output patterns, Lista optimization pointer), `Chamada HTTP` in full (overview table, object setup, access-config/limitations, all seven verb sections, timeout, attachment, Base64, auth system, advanced headers/cookies/response/proxy/SSL/SNI/progress families, helpers, corporate example, practices, status table, observations), `Resolução de Problemas SSL/HTTPS` (error classes and scenario workarounds, summarized), plus whole-repo name/arity sweeps and `ExemplosAutenticacaoHTTP.lsp` / `BuscarCepAPI.lsp` / `ExemploCRUD.lsp` conformance checks. Current evidence base is community documentation and community examples; official Senior documentation was not locally available for this slice. Senior Sistemas is the authoritative source for official behavior.
