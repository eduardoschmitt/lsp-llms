# lsp-llms

LSP documentation structured for LLM consumption.

`lsp-llms` transforms community documentation for **LSP — Linguagem Senior de Programação (Senior Programming Language)** into small, structured, machine-friendly reference documents in English, intended for large language models, coding agents, AI coding assistants, and retrieval systems.

## Source and provenance

This project does **not** define LSP. It reorganizes existing documentation.

Primary source:

```text
brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao
https://github.com/brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao
```

That source is community-maintained, primarily in Brazilian Portuguese. Explanatory prose here is translated into English; LSP code, keywords, function names, and identifiers are preserved unchanged.

**Senior Sistemas** remains the authoritative source for official LSP and Senior product behavior. Where this project is uncertain or the source is ambiguous, it says so explicitly instead of guessing.

## What is here

```text
docs/           # structured reference, one topic per file
docs/index.md   # navigation map and coverage status
```

Planned LLM entry points (`llms.txt`, `llms-full.txt`) will be added after enough structured documentation exists and will be generated deterministically from `docs/`. They are intentionally not present yet.

## How to use with AI tools

1. Start at `docs/index.md` to find the relevant topic.
2. Retrieve only the topic file needed (for example, `docs/language/syntax.md`).
3. Treat each file as the working reference for that topic; do not infer undocumented behavior from other languages.
4. If a behavior is marked as not documented or ambiguous, verify against official Senior documentation before relying on it.

## Scope and limitations

* Faithful transformation only: no invented functions, parameters, return values, syntax, or execution contexts.
* Code examples preserve source semantics; they are not modernized or silently corrected.
* Community conventions are labeled as conventions, not language requirements.
* Conflicts in the source are recorded rather than silently resolved.
* Coverage is incremental. Undocumented topics mean “not yet transformed,” not “does not exist in LSP.”

## Status

Early incremental build. Currently available: syntax core, variables, limitations-guardrail, control-flow, string-function, date/time, conversion, and arrays slices. See `docs/index.md` for coverage.

## Acknowledgements

This project was built with information and references from multiple sources. Special thanks to:

* **LSP Community Documentation by Bruno Campos** — https://github.com/brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao
* **Senior Sistemas Official Documentation** — https://documentacao.senior.com.br/

Thanks to everyone who contributes to documenting and sharing knowledge about LSP and the Senior ecosystem.

## AI Assistance

This project was developed with AI-assisted engineering using:

* **Muse Spark 1.3 Free** — used as the primary coding agent for repository analysis, documentation transformation, implementation, and validation.
* **OpenAI GPT-5.6 Sol** — used for project planning, architecture decisions, prompt design, review, and validation guidance.

AI-generated work is reviewed against the project's source material and follows the source-fidelity rules defined in `AGENTS.md`.
