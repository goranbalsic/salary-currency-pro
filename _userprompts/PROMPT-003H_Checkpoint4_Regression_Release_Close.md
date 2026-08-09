# PROMPT-003H Checkpoint 4: Final Regression + Release Evidence + Close Item 10

Status: Active. Final checkpoint of PROMPT-003H (Stage C item 10 —
offline fiscal receipt QR scanner shell), governed by PROMPT-003D's hard
network boundary. Register progress in PROMPTS.md. All existing rules
stay in force: session-start read order, 9-language l10n lockstep, real
tests (`flutter test -j 1`), `flutter analyze` clean, honest reporting,
checkpoint discipline.

Checkpoint 1 (data model, Serbia adapter, future-fetch boundary,
persistence, tests) landed at e006c3a. Checkpoint 2 (scanner UI, camera
permissions, manual entry) landed at cb00aa3. Checkpoint 3 (queue screen,
manual expense handoff) is complete. This checkpoint closes item 10.

---

## Decision on the size overage — already made, do not reopen

Two of three release ABIs exceed the 30MB per-ABI budget because of
`mobile_scanner`'s bundled ML Kit barcode library:

| ABI | Size | Budget | Status |
|---|---|---|---|
| arm64-v8a | 31.5MB | 30MB | over |
| x86_64 | 33.8MB | 30MB | over |

**Decision: accept and disclose, no fix this pass.** A modest overage
(current numbers, roughly 5–13% over budget) is acceptable given the
offline/local-only scanning tradeoff that motivated the ML Kit-backed
plugin choice. This is explicitly **not** a green light for unbounded
growth — if any future change pushes a release build toward something
like double the budget (e.g. approaching or exceeding ~60MB per ABI),
that crosses from "reasonable, disclosed overage" into "needs a real
fix," and should be flagged rather than absorbed under this same
decision.

Do not spend this checkpoint investigating lighter-weight QR/barcode
alternatives to `mobile_scanner` — that was considered and explicitly
deferred, not assigned as follow-up work. No TODO, no open item, no
"consider trimming later" note tied to this checkpoint.

---

## What to do

### 4.1 — Record the decision honestly

- In `DECISIONS.md`, add an entry for item 10 stating the real per-ABI
  numbers (arm64-v8a 31.5MB, x86_64 33.8MB, and armeabi-v7a's actual
  number — confirm it, don't assume it's under budget), the cause
  (`mobile_scanner`'s ML Kit barcode dependency), the decision (accept,
  disclose, no fix planned), and the rationale (offline-only scanning
  was the point of item 10; the overage is modest, not runaway).
- Do **not** write "comfortably under budget" or any equivalent
  soft-pedaling language anywhere in `DECISIONS.md` or
  `PROJECT_CONTEXT.md`. State the numbers and the breach plainly.
- Update `PROJECT_CONTEXT.md`'s size-budget section to reflect the new
  real per-ABI numbers for all three ABIs, replacing whatever was there
  from Stage B/C housekeeping.

### 4.2 — Final regression

- Run the full test suite (`flutter test -j 1`); record the count.
- Run `flutter analyze`; confirm clean, or list and justify any
  remaining warnings.
- Confirm l10n key parity across all 9 languages for everything added in
  checkpoints 1–3 (scanner UI, permissions, manual entry, queue screen,
  manual expense handoff) — no missing keys, no leftover English
  fallbacks.
- Rebuild release with `--split-per-abi`, capture the final per-ABI
  sizes for the release-evidence record (these are the numbers that go
  into DECISIONS.md per 4.1 — do not report fat-APK size).
- Sanity-check the network boundary one more time: confirm no code path
  introduced across checkpoints 1–3 calls out to `suf.purs.gov.rs` or
  any network client; the single documented TODO fetch-point interface
  is still the only mention of it.

### 4.3 — Close item 10

- Confirm all four checkpoints for item 10 are committed and pushed to
  `main`.
- Mark item 10 closed in PROMPTS.md / wherever Stage C progress is
  tracked.
- Report per the format below, then **STOP**. Stage D (monetization)
  requires a separate explicit go-ahead — do not begin any Stage D
  scoping or code in this session.

---

## Report format

Implemented / tested (`flutter test -j 1` count) / l10n key count across
all 9 languages / `flutter analyze` status / final per-ABI release sizes
(all three ABIs) / DECISIONS.md entry text (the honest overage
disclosure) / PROJECT_CONTEXT.md updates / confirmation of push to
`main` / item 10 closed. Then stop and await Stage D go-ahead.
