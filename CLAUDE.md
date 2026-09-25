# salary-currency-pro

Universal operating rules come from the Claude Global Toolkit v3 managed
block below (`core/CLAUDE.core.md`) — do not duplicate them here.

## Project-specific notes

- The app is **Bilans** (package `rs.bilans.app`); see `README.md` for
  features, build commands and layout.
- Test runner: use `flutter test -j 1` (not default concurrency) — this
  project has a known test-runner concurrency bug.
- Before committing: `flutter analyze`, `dart format --set-exit-if-changed
  lib test` (160 columns, trailing commas preserved) and the full suite.
- Strings: edit `tool/l10n/<lang>/*.json`, never `lib/l10n/*.arb` directly;
  then `transliterate.py`, `check.py`, `merge.py`, `flutter gen-l10n`
  (see `README.md`). Every message exists in all 9 languages.
- Payroll parameters change every January (and minimum wages mid-year):
  update `lib/features/payroll/domain/payroll_rules.dart` with its sources.
- Store graphics and listing texts: `docs/launch/` (regenerate with
  `tool/launch/make_store_graphics.py`).
- v1 project history (`PROJECT_CONTEXT.md`, `PROJECT_RULES.md`,
  `DECISIONS.md`, `PROMPTS.md`, `OPEN_QUESTIONS.md`, `session_logs/`) is
  archived in `docs/archive/legacy-v1/` for reference. Run `/ctk:resume` to
  reconstruct the resume point from `.claude/ctk/STATE.md` and git evidence.

<!-- ctk:begin v=3.0.0 profile=full hash=b82e801275ef sep=0 -->
@C:\Claude-Global-Toolkit\core\CLAUDE.core.md
<!-- ctk:end -->
