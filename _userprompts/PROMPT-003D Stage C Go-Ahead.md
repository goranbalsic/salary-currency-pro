# PROMPT-003D: Stage C Go-Ahead — Balkan Differentiators

Status: Active. Explicit go-ahead to start PROMPT-003 Stage C (items
10–13). Register in PROMPTS.md. All existing rules stay in force:
session-start read order, l10n lockstep across all 9 languages, real
tests, `flutter analyze` clean, honest reporting, one increment at a
time, checkpoint discipline.

## Housekeeping first (cheap, do before any Stage C code)

1. **APK size clarity:** Stage B reported 60.8MB for
   `flutter build apk --release` — a fat all-ABI APK, not comparable to
   Stage A's per-ABI numbers (19.3–22.9MB). Rebuild with
   `--split-per-abi`, record current per-ABI sizes in the session log,
   and confirm the <30MB per-ABI budget still holds after the widget +
   desugaring changes. From now on, always report per-ABI or AAB
   download size, never fat-APK size.
2. Confirm the device-unverified checklist is current in
   PROJECT_CONTEXT.md (consent dialog, icon variants, both widgets,
   notifications — Stage C will add the QR scanner). The user will test
   everything on a real device once the app is feature-complete.

## Stage C scope (PROMPT-003 items 10–13, in this order)

**Order of work: 11 → 12 → 13 → 10.** Items 11–13 are fully offline and
ship complete; item 10 has a hard network boundary (below), so it goes
last.

### Item 11 — Paušal & freelancer compliance pack (Serbia first)

- Running paušal turnover tracker vs the 6,000,000 RSD annual limit and
  the 8M RSD PDV threshold, fed by the existing invoice tracker;
  early-warning states at 70/85/95%; foreign-currency invoices convert
  at the invoice-date rate using stored rates.
- Monthly obligation reminder (due the 15th) via the existing local
  notification system — off by default like all others.
- Frilenser Model A vs Model B quarterly comparison calculator, same
  sourced-formula standard as every other engine: official source,
  effective-date label. If any current figure cannot be sourced to the
  existing standard, exclude it and record in OPEN_QUESTIONS.md — the
  Samooporezivanje precedent applies.
- Other countries' equivalents are OUT of scope for this pass — Serbia
  done excellently first.

### Item 12 — Invoice PDF + NBS IPS QR

- Professional PDF invoice generation from the existing invoice tracker,
  fully offline, in the invoice's language (respect the app's l10n) —
  clean layout, itemization, totals, VAT handling consistent with the
  invoice model.
- For Serbian RSD invoices: embed an NBS IPS QR code (NBS "IPS QR"
  specification — local text encoding into QR, no network). Validate the
  encoded payload against the NBS spec's mandatory fields; unit-test the
  payload builder thoroughly (account format, amount format, payment
  code, character set).
- PDF must render correctly with Cyrillic and all 9 languages' glyphs —
  bundle a font that covers them; test this explicitly.

### Item 13 — Cross-border pack

- Net-salary comparison across all 9 countries for the same gross (the
  engines already exist — this is a comparison UI + result table/chart).
- Employer "total cost of employment" view per country.
- Per-diem / mileage official rates only where sourceable to the
  existing standard; otherwise exclude and document.

### Item 10 — Fiscal receipt QR scanner (HARD NETWORK BOUNDARY)

- Build ONLY the offline shell in this stage: camera QR scan (Serbia's
  suf.purs.gov.rs URL format detection, per-country adapter
  architecture), local storage of scanned receipt URLs/raw payloads,
  queue UI showing "scanned, awaiting fetch," and manual expense
  creation from a scan (user types the amount).
- The network fetch that retrieves receipt contents is NOT approved yet.
  Mark the fetch point clearly in code (single service interface, one
  TODO), document it in DECISIONS.md, and STOP there. It will be
  approved separately alongside the Phase 12 online review.
- Camera permission handling must be graceful (denied → clear
  explanation, feature degrades, nothing else breaks).

## Working rules for this stage

- One item per increment, full report after each (implemented / tested /
  l10n count / analyze / per-ABI size if a release build was run /
  what's next), checkpoint properly at every session end — assume any
  session may be the last before a token limit.
- New dependencies: minimal, mainstream, and justified in DECISIONS.md
  (QR scan, PDF, QR generation likely each need one well-known package).
  Nothing that phones home; the privacy promise holds.
- Every new tax/compliance figure follows the sourcing standard with
  effective dates — no exceptions, exclusions documented.
- Paywall/monetization wiring for these features comes in Stage D — do
  NOT gate anything yet, but keep each feature behind a clean service
  boundary so gating is a one-line change later.
- After item 10's offline shell is done and reported: STOP. Stage D
  (monetization) needs explicit go-ahead.
