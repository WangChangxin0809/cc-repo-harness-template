# docs/ routing table

- **Covers**: mapping "what I am about to do" to "what to read, then where to edit".
- **Does not cover**: the knowledge itself — that lives in the document being
  pointed at. Detail written back into this table is paid by every reader who
  did not need it.

## Directories, partitioned by why you opened them

| Directory | You are here because | Shape |
|---|---|---|
| `how-to/` | I need to do a thing | Ordered steps: action → command → criterion |
| `reference/` | I need to look up a fact | Tables and rules, keyed for lookup |
| `decisions/` | Why is it like this? | Numbered from the PR, superseded not edited |
| `exec-plans/` | What are we in the middle of? | One folder per plan: `README.md` owns state, `steps/` owns substance |

**This top level is fixed; inside each directory, organise however suits the
material.** `scripts/gates/check_docs_layout.py` holds the top level and checks
nothing below it. A directory that forks a required name — `adr/`, `howto/`,
`plans/` — is an error even when routed, because two spellings of one bucket
both accumulate documents and merging them later is a migration. Additions are
fine once a row below routes into them.

Two things are deliberately not directories. **A symptom and its fix belong in
the failure output** of the guard or gate that detects it, not in a file nobody
opens while stuck. **Generated is a property**: such a file lives where its
content belongs and declares its source in its own first line, and the gate is
that regenerating leaves an empty `git diff`.

A plan past a few steps is a folder, not a file. `README.md` carries the goal,
the abort condition, and every step's state; a step earns its own file under
`steps/` only when it has decisions to record. Step files never restate status —
nobody reopens a finished one to change `doing` to `done` — and each opens with
`## Consulted` saying what was searched before the work started, or why nothing
was. The routing table below points at the `README.md` only.

## I want to X -> read Y -> then edit Z

| I want to | Read first | Then edit |
|---|---|---|
| Understand the system | [ARCHITECTURE.md](../ARCHITECTURE.md) | — |
| Know why the repo is shaped this way | [0001](decisions/0001-agent-conventions.md) | — |
| See what is in flight | [tech debt](exec-plans/tech-debt-tracker.md) | — |
