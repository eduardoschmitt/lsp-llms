# B02 — File write, count, and read-back

Suite: `backend-generation-v0.1`
Case version: v1
Difficulty: backend file contract (write → verify → read)
Status: READY — not yet executed

> Only the content inside `Solver prompt` is sent to the solving model.
> Evaluator-only sections must never be included in model context.

## Purpose

Test the documented file lifecycle end to end against a deterministic
on-disk contract: create/write text, count lines, check existence, read a
line back, and report everything in one message the evaluator can verify both
on screen and on disk.

## Solver prompt

```text
Write one self-contained LSP rule (no database, no input statements, no external dependencies).

The rule must work with the file path C:\temp\eval_b02.txt (use it exactly as shown).

The rule must, in one execution:

1. Create or open that file for writing and write exactly three text lines into it, in this order: Alpha, then Beta, then Gama.
2. Close the file.
3. Count how many lines the file contains.
4. Check whether the file exists.
5. Reopen the file for reading and read back its first line.
6. Close the file again.

Declare all variables used. The rule must compile and execute without any modification.

Produce exactly one final output using Mensagem(Retorna, ...), containing the results clearly identified, in this format:

B02 Linhas: <n> Primeira: <texto> Existe: <e>

where <n> is the counted number of lines, <texto> is the first line read back, and <e> is 1 when the file exists and 0 otherwise.
```

## Evaluator-only expected behavior

```text
B02 Linhas: 3 Primeira: Alpha Existe: 1
```

On-disk contract (verify independently of the message): after execution,
`C:\temp\eval_b02.txt` exists and contains the three lines `Alpha`, `Beta`,
`Gama` in order. The `Linhas: 3` expectation follows the documented
write-lines-then-count contract (`Gravarnl` + `LinhasArquivo`); if the Senior
environment counts differently, record the deviation as a finding rather than
editing the case.

## Evaluator notes

### Relevant documentation

`docs/io/files.md` (handle lifecycle `Abrir` → write → `Fechar`;
`Gravarnl`; `LinhasArquivo`; `Lernl`; `ArqExiste` 2-argument form),
`docs/functions/conversion.md` (`IntParaAlfa` for the count),
`docs/guides/limitations.md` (L3/L4 — the `ArqExiste` condition conflict).

### Expected/likely LSP mechanisms

`Abrir` with write and read modes; `Gravarnl` per line; `Fechar` after each
phase; `LinhasArquivo(path, count)`; `ArqExiste(path, flag)` with a
subsequent `Se (flag = 1)` comparison (not a direct call in the condition);
`Lernl` for the first line; `IntParaAlfa` for the count; one prebuilt
message.

### Likely failure modes

Invented file function or mode names; missing `Fechar`; `ArqExiste` called
directly in a condition; conversion inside `Mensagem` parameters;
assuming append vs. overwrite semantics (undocumented either way — the
evaluator should ensure a clean `C:\temp` file or note pre-existing content).

## Validation procedure

Ensure `C:\temp\eval_b02.txt` does not exist before the run (or record its
prior state). Copy the generated rule unchanged; compile once; execute once;
compare the single final message against the expected behavior above
(modulo trailing whitespace); then inspect the file on disk against the
on-disk contract.

## Freeze policy

B02 v1 is frozen once the first real execution begins. Defects get a new
version with a documented reason; v1 is preserved.
