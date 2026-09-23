# lsp-llms

LSP documentation structured for LLM consumption.

`lsp-llms` reorganizes documentation for **LSP — Linguagem Senior de Programação (Senior Programming Language)** into structured, machine-friendly reference material in English for LLMs, coding agents, AI assistants, and retrieval workflows.

## What is here

```text
docs/           # structured reference, one topic per file
docs/index.md   # navigation map and coverage status
llms.txt        # generated compact entry point (do not edit)
llms-full.txt   # generated consolidated corpus (do not edit)
scripts/        # deterministic generator (Python 3, stdlib only)
evals/          # evaluation suites (test artifacts, never corpus input)
```

The generated artifacts are reproducible from `docs/`:

```bash
python scripts/build_llms.py
python scripts/build_llms.py --check
```

`llms.txt` provides a compact map of the available documentation.

`llms-full.txt` contains the complete documented corpus in deterministic order, with each source file preserved verbatim behind a `SOURCE:` marker.

Do not edit either generated file manually.

## Using with AI tools

For focused work, start with `docs/index.md` and retrieve only the relevant topic.

For full-context use, provide `llms-full.txt` to the model.

The documentation intentionally preserves uncertainty and contradictions found in the source material. LLMs should not infer undocumented LSP behavior from other programming languages.

## Source and provenance

This project does **not** define LSP.

Its primary community source is:

* **LSP Community Documentation by Bruno Campos**
  https://github.com/brunoleocam/Documentacao-LSP-Linguagem-Senior-de-Programacao

The original material is primarily in Brazilian Portuguese. Explanatory documentation is translated into English while LSP code, keywords, function names, identifiers, literals, payloads, and source-specific terminology are preserved where required.

**Senior Sistemas Official Documentation** remains the authoritative source for official LSP and Senior product behavior:

* https://documentacao.senior.com.br/

When the available evidence is incomplete, contradictory, or ambiguous, this project records that uncertainty instead of silently guessing or normalizing the language.

## Documentation principles

* No invented functions, parameters, return values, syntax, or execution contexts.
* Source examples are preserved rather than silently modernized or corrected.
* Community recommendations are distinguished from documented language behavior.
* Conflicts are made explicit.
* Coverage is incremental: an undocumented topic means it has not been transformed yet, not that it does not exist in LSP.

See `AGENTS.md` for the full source-fidelity and contribution rules.

## Current coverage

The current corpus includes:

* language syntax and variables;
* control flow and arrays;
* Lista, ListaRegra, Tabela, and Grid-related structures;
* known limitations and generation guardrails;
* strings;
* dates and time;
* conversions;
* numeric and math functions;
* database cursors and SQL APIs;
* file operations;
* JSON;
* HTTP and Web Services.

See `docs/index.md` for the canonical coverage map.

## Project status

The first structured corpus and deterministic `llms.txt` / `llms-full.txt` generation pipeline are available.

The next phase focuses on evaluation: testing whether LLMs generate more accurate LSP when using this corpus and documenting the resulting failures, regressions, and documentation improvements.

## Tested environment

Evaluation runs so far were executed against:

```text
Product: Senior Gestão Empresarial
Version: 5.10.4.9
```

LSP APIs, signatures, and behaviors can vary between Senior ecosystem versions. Empirical results under `evals/` are valid for the recorded environment and must not be automatically treated as universal. See `evals/README.md` for the environment policy.

## Acknowledgements

This project was built with information and references from multiple sources.

Special thanks to:

* **Bruno Campos**, for the community LSP documentation that served as the primary transformation source.
* **Senior Sistemas**, for the official product and language documentation.
* Everyone who documents and shares knowledge about LSP and the Senior ecosystem.

## AI assistance

This project was developed with AI-assisted engineering using:

* **Muse Spark 1.3 Free** — primary coding agent for repository analysis, documentation transformation, implementation, and validation.
* **OpenAI GPT-5.6 Sol** — project planning, architecture decisions, prompt design, review, and validation guidance.

AI-generated work is reviewed against the source material and follows the source-fidelity rules defined in `AGENTS.md`.
