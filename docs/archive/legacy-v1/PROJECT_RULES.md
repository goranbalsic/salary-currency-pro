# Project Rules

This repository already has `CLAUDE.md` (the installed `GLOBAL_CLAUDE.md`
ten universal rules). Per `templates/project-rules.md`'s own instruction,
sections already fully covered there are trimmed to a pointer instead of
restated — only the genuinely new content (contradiction handling, prompt
classification, decision-quality comparison) is written out in full.

## Source of Truth and Session Start

The repository is the source of truth; do not rely on chat history
persisting across restarts. **Canonical session-start read order:**

1. `CLAUDE.md` (ten universal rules).
2. This file and `PROJECT_CONTEXT.md`.
3. `DECISIONS.md` (significant choices, newest first).
4. `PROMPTS.md` — check for any large standing instruction marked Active.
5. Latest entry in `session_logs/`.
6. Inspect actual current repository state (`flutter analyze`,
   `flutter test -j 1`, `git status` if this becomes a git repo) — do not
   assume the files above are still accurate without checking.
7. Resume at the "Next Recommended Action" in `PROJECT_CONTEXT.md`.

## Autonomous Decision-Making

Already covered: `CLAUDE.md` rules 1–10, especially rule 8 ("ask before
risk") and rule 6 ("minimize reversible changes... propose first"). In
short: make ordinary decisions independently using the user's stated
goals and this file's context; do not repeatedly ask about minor choices.

## Context Preservation

Already covered in spirit by `CLAUDE.md` rule 10 ("record decisions"). In
this repository: an important prompt, requirement, preference, idea,
correction, or decision goes into one of `PROJECT_CONTEXT.md`, this file,
`PROMPTS.md`, `DECISIONS.md`, `IDEAS.md`, `OPEN_QUESTIONS.md`, or a
`session_logs/` entry — pick the narrowest file whose stated purpose
matches, and don't copy the same content into more than one.

## Prompt Management (net new)

Do not treat every prompt as permanent. Classify each large or important
prompt in `PROMPTS.md` as one of: Active, Reference, Experimental,
Superseded, Archived. Preserve the original inline in `PROMPTS.md` when
supplied in chat (this repo has no `sources/` directory for document
originals), plus a concise summary so future sessions don't have to
reread the full text.

## Contradiction Handling (net new)

When instructions conflict:

1. Identify the conflict explicitly — don't silently pick one side.
2. Determine which instruction is newer.
3. Determine which is more specific to the situation at hand.
4. Check whether the newer instruction intentionally changes prior
   direction, or is just silent on it.
5. Check both against `PROJECT_CONTEXT.md`'s current goals/constraints.
6. Prefer whichever option best serves the user's current objective.
7. Record the resolution in `DECISIONS.md`.
8. Ask the user only if the conflict can't be resolved safely with the
   above steps.

Example already applied this session: the mega-prompt (`PROMPTS.md`
PROMPT-001) asked for full business-SaaS features; a later, more specific
instruction (PROMPT-002) explicitly gated that behind finishing the
offline product first. Resolved by treating PROMPT-002 as narrowing
PROMPT-001's scope, not replacing it — recorded in `DECISIONS.md` D-001.

## Decision Quality (net new)

Not all ideas are equally good. When comparing alternatives, weigh:
alignment with the user's actual goal, expected value, simplicity,
reliability, cost, time, risk, maintainability, reversibility, evidence,
and compatibility with existing work (this app's existing persistence
conventions, theme system, validators, navigation helpers). Select the
strongest practical option; if there's no clear winner, state the
trade-offs briefly and pick the safest reversible option. Use a
comparison table only for genuinely non-trivial choices — proportionate
effort, per `CLAUDE.md` rule 6.

## Scope Control

Already covered: `CLAUDE.md` rule 6 ("minimize reversible changes... do
not create major new components unless required"). In short: stay on the
current highest-value objective, park other ideas in `IDEAS.md` rather
than building them immediately.

## Evidence and Verification

Already covered: `CLAUDE.md` rules 3–4 ("do not invent," "label
uncertainty"). This repository additionally uses a work-status vocabulary
in `DECISIONS.md`/`IDEAS.md`/`OPEN_QUESTIONS.md` where it adds clarity:
Proposed, Planned, In progress, Implemented, Tested, Verified, Partially
verified, Blocked, Rejected, Superseded.

## Memory Maintenance

At the end of every meaningful session: update `PROJECT_CONTEXT.md` if
anything material changed, record any significant decision in
`DECISIONS.md`, save any large new prompt to `PROMPTS.md`, update
`IDEAS.md`/`OPEN_QUESTIONS.md`, write a `session_logs/` entry, and state
what was verified and the next recommended action.
