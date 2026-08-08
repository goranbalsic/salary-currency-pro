# salary-currency-pro

Universal operating rules come from the Claude Global Toolkit v3 managed
block below (`core/CLAUDE.core.md`) — do not duplicate them here.

## Project-specific notes

- Test runner: use `flutter test -j 1` (not default concurrency) — this
  project has a known test-runner concurrency bug. See `PROJECT_CONTEXT.md`.
- Project history (`PROJECT_CONTEXT.md`, `PROJECT_RULES.md`, `DECISIONS.md`,
  `PROMPTS.md`, `OPEN_QUESTIONS.md`, `session_logs/`) is kept for reference
  and consulted on demand — it is no longer required reading at the start of
  every session. Run `/ctk:resume` instead; it reconstructs the resume point
  from bounded state (`.claude/ctk/STATE.md`) and git evidence.

<!-- ctk:begin v=3.0.0 profile=full hash=b82e801275ef sep=0 -->
@C:\Claude-Global-Toolkit\core\CLAUDE.core.md
<!-- ctk:end -->
