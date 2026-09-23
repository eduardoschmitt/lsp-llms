You are participating in an evaluation of LLM code generation for LSP (Linguagem Senior de Programação).

## Files provided

You have been given:

* `llms-full.txt` — the only source of LSP language knowledge for this evaluation;
* `E01-easy-sum-evens.md`;
* `E02-medium-grade-stats.md`;
* `E03-hard-reverse-length.md`.

## IMPORTANT: You must solve ALL THREE exercises

There are exactly THREE independent exercises:

1. E01 — Easy — Sum of evens
2. E02 — Medium — Grade sum and max
3. E03 — Hard — Word reverse + length

You must produce THREE independent LSP rules.

Do NOT stop after E01.

Completing only one or two exercises is an incomplete response.

Each exercise contains three internal test cases. Those three test cases must be handled by that exercise's single rule.

Therefore the required deliverable is:

* one complete LSP rule for E01, handling all 3 E01 cases;
* one complete LSP rule for E02, handling all 3 E02 cases;
* one complete LSP rule for E03, handling all 3 E03 cases.

Total: exactly THREE complete and independent LSP rules.

## Source of truth

Use `llms-full.txt` as your only source of LSP language knowledge.

Do not rely on assumptions from other programming languages.

Do not invent syntax, functions, parameters, return values, language features, APIs, or runtime behavior.

When LSP differs from languages you already know, follow `llms-full.txt`.

For each exercise, use ONLY the content under its `Solver prompt` section as the exercise specification.

Do NOT use evaluator-only expected outputs, evaluator notes, likely failure modes, validation procedures, or other evaluator-only content as solving guidance.

## Task

Read and solve E01, E02 and E03 completely.

Each generated rule must:

* be self-contained;
* follow its exercise requirements exactly;
* declare everything it uses;
* require no manual code modification;
* process all three hardcoded cases belonging to that exercise in one execution;
* compile as LSP;
* produce the requested observable output.

The three rules are independent. Do not combine E01, E02 and E03 into one large LSP rule.

## Before answering

Review EACH of the three implementations against `llms-full.txt`.

Verify every LSP construct and function you use against the supplied documentation rather than assuming behavior from another programming language.

Before finishing, explicitly ensure internally that:

* E01 has been solved;
* E02 has been solved;
* E03 has been solved.

Do not finish your response until all three solutions are present.

## Required output

Create exactly these three solution files:

`E01.lsp`
`E02.lsp`
`E03.lsp`

Their contents must be only the complete LSP rule for the corresponding exercise.

Do not put explanations, analysis, documentation excerpts, expected outputs, Markdown code fences, or commentary inside the `.lsp` files.

Do not create any additional solution files.

Your task is complete only when all three files contain their respective complete LSP rules.
