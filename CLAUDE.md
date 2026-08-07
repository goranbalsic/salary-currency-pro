---
title: Global Claude Toolkit — Universal Baseline
version: 2.1.0
last_reviewed: 2026-08-07
---

# GLOBAL_CLAUDE.md

Universal, repository-agnostic rules. This file is the copy source: install it into
another repository as that repository's `CLAUDE.md` to apply the baseline there
(see `scripts/install.ps1` / `scripts/install.sh`). It intentionally contains only
rules that hold across every project — nothing repository-specific.

For the full rationale behind each rule, see the `chapters/` handbook in this
toolkit. Repository-specific policy belongs in that repository's own
`PROJECT_CONSTITUTION.md` and `DECISIONS.md`, not here.

## The ten universal rules

1. **Inspect before acting.** Read relevant files, config, tests, and current
   behavior before proposing or making changes. Do not infer facts that can be
   directly checked.
2. **Reuse existing decisions.** Check `DECISIONS.md`, `PROJECT_STATUS.md`, and
   prior documentation before re-deciding something already settled.
3. **Do not invent.** Never fabricate facts, commands, flags, APIs, capabilities,
   source contents, or verification results. Never claim to have inspected,
   executed, generated, installed, opened, or verified something unless you
   actually did it.
4. **Label uncertainty.** State confidence (Confirmed / High / Medium / Low /
   Unknown) on non-trivial claims. Do not take risky action on Low/Unknown
   confidence without verification or explicit approval.
5. **Plan before large changes.** For non-trivial work, produce a bounded,
   file-level plan with dependencies, verification steps, and a rollback path
   before implementing.
6. **Minimize reversible changes.** Prefer the smallest coherent change that
   satisfies the requirement. Do not create major new components unless
   required, requested, or necessary — propose them first if not.
7. **Verify, don't assume.** Run proportionate checks (tests, types, lint,
   links, build, security, or manual review) after changes and report passed /
   failed / skipped / unavailable honestly.
8. **Ask before risk.** Pause for explicit approval before destructive,
   external, global, security-sensitive, privacy-sensitive, legal, licensing,
   expensive, irreversible, or materially uncertain actions.
9. **Follow project instructions.** Repository `CLAUDE.md`,
   `PROJECT_CONSTITUTION.md`, and `DECISIONS.md` take precedence over general
   habits — read them at the start of every session.
10. **Record decisions.** Write significant choices, rejected alternatives,
    confidence, and reversibility to that repository's `DECISIONS.md` as they
    are made, not retroactively.

## Scope note

Prompts, templates, checklists, and skills in this toolkit are on-demand
reference material — they apply only when explicitly invoked for a task, not
automatically on every turn. This file is the only piece meant to be copied
wholesale into another repository's operational instructions.

## Start or resume (repository-specific addition)

The section above is the unmodified universal baseline installed from
`GLOBAL_CLAUDE.md`. This repository has since adopted the Claude Global
Toolkit's optional memory-system bundle (see
`C:\Claude-Global-Toolkit\HOW_TO_USE.md` §3, and this repo's own
`DECISIONS.md` D-005) — read these, in order, at the start of every
session before doing anything else:

1. This file (the ten rules above still apply in full).
2. `PROJECT_CONTEXT.md` and `PROJECT_RULES.md`.
3. `DECISIONS.md` (significant choices, newest first).
4. `PROMPTS.md` — check for any large standing instruction marked Active.
5. The latest entry in `session_logs/`.
6. Inspect actual current state (`flutter analyze`, `flutter test -j 1` —
   note the `-j 1`: this project has a known test-runner concurrency bug,
   see `PROJECT_CONTEXT.md`) rather than trusting the files above without
   checking.
7. Resume at the "Next Recommended Action" in `PROJECT_CONTEXT.md`.

This repository does not have `PROJECT_STATUS.md`/`PROJECT_CONSTITUTION.md`/
`ROADMAP.md` — it adopted only the memory-system bundle, not the toolkit's
full governance structure (an explicit choice, not an oversight — see
`DECISIONS.md`).
