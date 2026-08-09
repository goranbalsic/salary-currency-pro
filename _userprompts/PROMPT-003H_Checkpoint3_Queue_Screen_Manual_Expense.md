# PROMPT-003H Checkpoint 3: Queue Screen + Manual Expense Handoff

Status: Active. Continues PROMPT-003H (Stage C item 10 — offline fiscal
receipt QR scanner shell), governed by PROMPT-003D's hard network
boundary. Register progress in PROMPTS.md. All existing rules stay in
force: session-start read order, 9-language l10n lockstep, real tests
(`flutter test -j 1`), `flutter analyze` clean, honest reporting, one
increment at a time, checkpoint discipline, no monetization gating yet.

Checkpoint 1 (data model, Serbia adapter, future-fetch boundary,
persistence, tests) landed at e006c3a. Checkpoint 2 (scanner UI, camera
permissions, manual entry) landed at cb00aa3. This is checkpoint 3 of 4
for item 10 — after checkpoint 4 (final regression + release evidence +
push), item 10 is closed and this prompt's stop condition applies: STOP,
do not proceed into Stage D (monetization) without explicit go-ahead.

---

## Before you write code

1. **Audit first.** Read the checkpoint 1 data model, the Serbia adapter,
   the persistence layer, and the checkpoint 2 scanner UI / manual-entry
   flow before adding anything new. Reuse the existing scan-record model
   and storage; do not introduce a parallel queue data structure.
2. Re-confirm the hard network boundary is still respected: the fetch
   point that would retrieve receipt contents from `suf.purs.gov.rs`
   remains a single documented TODO behind one service interface — no
   webview, no live fetch, no implied fiscal verification anywhere in
   this checkpoint's UI copy or logic.
3. If anything from checkpoint 1/2 already partially covers the queue
   screen or handoff, report the overlap and close only the gap rather
   than rebuilding it.

---

## What to build

### 3.1 — Queue screen

- List view of all scanned receipts in local storage, each showing scan
  timestamp, raw payload/URL (or a truncated, clearly-labeled preview),
  and status: **"scanned, awaiting fetch."** No other status states are
  approved yet (no "verified," no "fetched" — those depend on the
  not-yet-approved network step).
- Empty state when no scans exist yet, localized across all 9 languages.
- Sort by most recent scan first. Support deleting a queued scan (with
  confirmation) for the case where the user scanned by mistake.
- Each queue item is tappable and leads into the manual expense handoff
  (3.2) — this is the only forward action available on a queued item in
  this stage.

### 3.2 — Manual expense creation from a scan

- From a queue item, open a form pre-filled with whatever the scan
  payload already deterministically provides (e.g., merchant identifier
  or timestamp fields already parsed by the Serbia adapter) and require
  the user to **type the amount** manually — no amount may be inferred
  or fetched.
- On save, create an expense entry through the **existing expense
  tracker's** creation path — do not build a second expense model. Link
  the new expense record back to the originating scan record so the
  queue item can reflect it was converted (e.g., "linked to expense" —
  still no claim of fiscal verification).
- Once linked, decide and document whether the item stays in the queue
  (marked linked) or is removed — pick the option consistent with how
  the existing expense tracker treats source-linked records, and note
  the decision in DECISIONS.md.
- Cancel/back must leave the scan record untouched in the queue.

### 3.3 — Copy and disclosure discipline

- Nowhere in the queue screen or handoff form may copy imply the receipt
  has been validated, verified, or fetched from the tax authority. Use
  neutral language ("scanned," "awaiting fetch," "linked to expense").
- If a QR payload doesn't match the Serbia adapter's known format, show
  it as "unrecognized format" in the queue rather than guessing at
  fields — same honest-gaps standard as every other engine.

---

## Testing bar

- Widget tests for the queue screen: empty state, populated list,
  delete-with-confirmation, and unrecognized-format display.
- Widget/unit tests for the manual handoff: pre-fill behavior from a
  known-good scan payload, required-amount validation, successful save
  creating a linked expense via the existing tracker, and cancel leaving
  the queue unchanged.
- Regression check that no code path in this checkpoint calls out to
  `suf.purs.gov.rs` or any network client — assert this at the test
  level if feasible (e.g., no network client is invoked from the queue
  or handoff modules).
- No test may assert a "verified" or "fetched" status — those states do
  not exist yet.

## Report format (then continue to checkpoint 4, or STOP if this is the session's last action)

Implemented / tested (`flutter test -j 1` count) / l10n key count across
all 9 languages / `flutter analyze` status / DECISIONS.md entries
(queue-vs-linked-removal decision, any new dependency) / OPEN_QUESTIONS.md
additions if any / what's next (checkpoint 4: final regression + release
evidence + push, closing item 10 — then STOP for Stage D go-ahead).
