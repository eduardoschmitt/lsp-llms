# B03 — HTTP request construction and status handling

Suite: `backend-generation-v0.1`
Case version: v1
Difficulty: backend calling-convention compliance (shape over network effect)
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Test whether the model reproduces the documented HTTP calling conventions:
object lifecycle, header configuration, timeout, request execution, status
inspection, and branching — without depending on any real network outcome.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must perform an HTTP GET request to this exact URL:

https://www.senior.com.br/index.htm

The rule must, in one execution:

1. Create an HTTP communication object.
2. Configure a 30-second timeout for its requests.
3. Send an HTTP GET request to the URL above and hold the response body in a variable.
4. Read the numeric HTTP response status code into a separate variable.
5. If the status code equals 200, show that the request succeeded; otherwise show that it failed together with the status code.

Declare all variables used. The rule must compile and execute without any modification.

Produce exactly one final output using Mensagem(Retorna, ...), in one of these two shapes:

HTTP OK Corpo: <corpo>
HTTP ERRO Status: <codigo>

Use the first shape when the status code equals 200 (with <corpo> replaced by a short fixed confirmation text, not the full response body), and the second shape otherwise (with <codigo> replaced by the status code).
```

## Evaluator-only expected behavior

Primary assertion (environment-independent): the rule **compiles** with the
documented call shapes — object creation first, timeout configuration,
GET with `(object, URL, response)` positions, status read into a separate
numeric variable, and a status branch.

Runtime behavior depends on network reachability of the example URL and is
recorded as observed, not asserted:

- If the environment reaches the URL with status 200, expect
  `HTTP OK Corpo: OK` (or any short fixed confirmation text in place of the
  full body — the exact confirmation wording is the model's choice and is
  validated only for the `HTTP OK Corpo: ` prefix).
- Otherwise, expect the `HTTP ERRO Status: <codigo>` shape with whatever
  status or error the environment yields, recorded verbatim.

A COMPILE failure fails the case regardless of network conditions. A
RUNTIME/OUTPUT deviation caused solely by sandbox network restrictions is
recorded as an environment observation, not an LSP-generation failure — but
only with explicit evaluator evidence that the network (not the code) was
the cause.

## Evaluator notes

### Relevant documentation

`docs/integration/http-webservices.md` (object lifecycle, verb signatures,
timeout, `HttpLeCodigoResposta`, `HttpDesabilitaErroResposta`,
`Mensagem`-with-status patterns), `docs/functions/conversion.md`
(`IntParaAlfa` if the model converts the code), `docs/guides/limitations.md`
(L3 — concatenation inside parameters).

### Expected/likely LSP mechanisms

`HttpObjeto` first; `HttpSetaTimeout(vaHTTP, 30)`; `HttpGet` with response
variable; `HttpLeCodigoResposta` into a `Numero`; `Se` on 200 with two
message branches. Manual error control (`HttpDesabilitaErroResposta`) is
acceptable but not required.

### Likely failure modes

Invented verbs/helpers (`HttpHead`, `HttpFetch`, …); wrong argument order
(URL/response swapped); invented status-reading API; response assumed parsed
(e.g. direct JSON field access on the body); `Numero` status concatenated
directly into an error message; missing object creation.

## Validation procedure

Copy the generated rule unchanged; compile once (primary assertion);
execute once in the evaluator's environment; record the status branch taken
and the exact final message. Classify RUNTIME/OUTPUT against the behavior
above, separating code defects from proven network restrictions.

## Freeze policy

B03 v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
