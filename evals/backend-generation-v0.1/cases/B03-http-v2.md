# B03 v2 — HTTP request, status, and response-body check

Suite: `backend-generation-v0.1`
Case version: v2 (supersedes the v1 endpoint strategy; v1 file
`B03-http.md` is preserved unchanged)
Difficulty: backend calling-convention compliance plus response parsing
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Rationale for v2

B03 v1 validated the HTTP mechanism end to end but its output contract could
not distinguish a working request from an endpoint failure (live 404). v2
targets a stable request-echo endpoint and additionally requires reading a
field out of the response body, so a passing run proves request + status +
response handling — using only documented APIs.

Endpoint choice: `https://httpbin.org/get`, a request-echo test service
whose documented purpose is answering GET requests with the request data.
Verified live during case design: HTTP 200 with a flat JSON body containing
`"url": "https://httpbin.org/get"` at top level. If the service is ever
unreachable or changes shape, that is environment evidence, not a case
defect — record it and revisit.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must perform an HTTP GET request to this exact URL:

https://httpbin.org/get

The rule must, in one execution:

1. Create an HTTP communication object.
2. Configure a 30-second timeout for its requests.
3. Send an HTTP GET request to the URL above and hold the response body in a variable.
4. Read the numeric HTTP response status code into a separate variable.
5. If the status code equals 200, read the "url" field out of the JSON response body into another variable.
6. If the status code equals 200, show the extracted URL; otherwise show the failure status code.

Declare all variables used. The rule must compile and execute without any modification.

Produce exactly one final output using Mensagem(Retorna, ...), in one of these two shapes:

HTTP OK: <url>
HTTP ERRO Status: <codigo>

Use the first shape when the status code equals 200 (with <url> replaced by the "url" value read from the response body), and the second shape otherwise (with <codigo> replaced by the status code).
```

## Evaluator-only expected behavior

With a reachable httpbin service:

```text
HTTP OK: https://httpbin.org/get
```

Primary assertion (environment-independent): the rule **compiles** with
documented call shapes, reads the status into a separate numeric variable,
and reads the `"url"` field through a documented JSON mechanism. Runtime and
output are graded only when the endpoint is reachable; proven network
restrictions are recorded as environment evidence, never as code defects.

## Evaluator notes

### Relevant documentation

`docs/integration/http-webservices.md` (object lifecycle, verb signatures,
timeout, `HttpLeCodigoResposta`, status branches), `docs/data/json.md`
(`ValorElementoJson` with empty group for top-level fields),
`docs/functions/conversion.md` (`IntParaAlfa` if the code converts),
`docs/guides/limitations.md` (L3).

### Expected/likely LSP mechanisms

`HttpObjeto` first; `HttpSetaTimeout(…, 30)`; `HttpGet` with response
variable; `HttpLeCodigoResposta` into a `Numero`; `Se (vnStatus = 200)` with
`ValorElementoJson(vaResposta, "", "url", vaURL)` on the success branch and
an error branch otherwise. Manual error control acceptable but not required.

### Likely failure modes

Invented verbs/helpers; wrong argument order; invented status-reading API;
assuming the body is parsed automatically; direct JSON field access on the
body; `Numero` status concatenated directly; missing object creation;
group/path invention for the top-level `"url"` field (empty group is the
demonstrated form).

## Validation procedure

Copy the generated rule unchanged; compile once (primary assertion);
execute once with network access to httpbin.org; compare the single final
message against the expected behavior above (modulo trailing whitespace).
On non-200 or unreachable service, record the exact observed behavior and
classify environment vs. code causes explicitly.

## Freeze policy

B03 v2 is frozen once its first real execution begins. Defects get a new
version with a documented reason; v1 and v2 files are preserved.
