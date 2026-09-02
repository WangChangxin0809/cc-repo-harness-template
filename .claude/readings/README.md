# Readings

Answers a person or an agent gave once, kept so nobody is asked again.

This is machine-written state, not documentation — it lives under `.claude/`
rather than `docs/` for that reason. Each file holds the answers from one
reading of this repository: which candidates were looked at, and what was
decided about each.

## The one convention that matters

**An answer is matched by the `file` it names, never by the `id` a run gave
it.** The candidate list is rebuilt from the tree on every run and renumbers
every time, so an answer keyed by id silently starts applying to a different
candidate the moment anything is added or removed.

An answer may also carry `moved`: the commit at which the document it is about
last changed. It stops applying the moment that document is edited again —
which is correct, because the dismissal was about a sentence that no longer
exists.

## Why keep them at all

Without this, every reading rediscovers the same candidates that were never
findings and never will be, and someone spends a turn dismissing them again.
The cost is not the turn. It is that the reading is then scored on how many
times a human had to re-answer a question this repository already answered.
