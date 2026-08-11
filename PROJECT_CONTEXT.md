# Project Context

## Last Updated (newest first)

- Date: 2026-08-11. Full UI/UX redesign, interaction test, code review,
  and release rebuild — `_userprompts/MEGAPROMPT_Full_Redesign_Full_Test_Ready_For_Play.md`,
  recorded as **D-036**. Presentation/usability only: refined (not
  replaced) the existing Material 3 palette with real spacing/radius/
  typography tokens and 6 new shared widgets, redesigned every screen
  group in 11 scoped commits, unified empty states app-wide, and added
  a native splash screen. Fixed 2 real bugs found during the pass: a
  dark-mode icon-color contrast regression (caught and fixed within the
  same checkpoint) and a use-after-dispose crash in the scenario-rename
  dialog (same bug class as an earlier fix, now regression-tested).
  Diagnosed but deliberately did not unilaterally fix the Cross-Border
  Comparison's "—" values for 5/9 countries (**QUESTION-011** in
  `OPEN_QUESTIONS.md`) — a documented D-031 no-network-call design
  constraint, not a bug; shipped a safer visible-guidance banner and
  left the network-call question for the owner. Version bumped
  1.0.0+1 → 1.0.1+2. 526/526 tests (525 + 1 new regression test),
  `flutter analyze` clean, 584 l10n keys × 9 locales unchanged (no
  strings touched). Production AAB (71.5MB) + split APKs rebuilt and
  re-verified genuinely signed (same real certificate as D-035,
  `apksigner`/`jarsigner`); arm64-v8a still under the 30MB budget
  (29.7MB), x86_64 still over (32.1MB, honestly disclosed, not
  described as under). Full before/after evidence under
  `_redesign_evidence/`. See `DECISIONS.md` D-036 for the complete
  per-checkpoint record. Owner next steps unchanged from before this
  pass (real-device QA, Firebase Test Lab, Play upload, Billing
  products, closed testing) — see `UI_REDESIGN_HANDOFF.md` and
  `PLAY_CONSOLE_CHECKLIST.md`.

- Date: 2026-08-09 (later same day, after item 10 below). Stage D
  (monetization) went from go-ahead to a real, signed release candidate
  in one session — three prompts, all recorded in `PROMPTS.md`/
  `DECISIONS.md`, none skipped: **PROMPT-003I** (Stage D go-ahead —
  `EntitlementService`, four Pro gates, new paywall, D-033) →
  **PROMPT-003J** (dev/prod Gradle build matrix, dev-only Entitlement
  Preview simulator, QA audit, release-signing scaffold, D-034) →
  **NEXT_ACTION** (removed the dormant Google Mobile Ads/UMP SDK
  completely, then built and verified the *actually signed* production
  release once the owner created their real upload keystore, D-035).
  Free/Pro rules, final: Salary Calculator home-country-only for Free;
  Cross-Border live+employer-cost free, one saved comparison free/
  unlimited Pro; Invoice PDF and the paušal/VAT pack Pro; Freelance Tax
  Screen and the QR scanner fully free; no ads. Removing the ad SDK also
  dropped its entire transitive WebView chain (zero WebView dependency
  now) and **measurably shrank the app** — arm64-v8a moved from 31.5MB to
  **29.4MB, now under the 30MB budget**; only x86_64 remains over (31.8MB,
  down from 33.8MB). The production AAB/split APKs were built and
  verified as genuinely signed (`apksigner`/`jarsigner`, real certificate,
  not the Android debug cert) — see `PROJECT_CONTEXT.md`'s own
  "Development Setup" section below for the exact commands and
  `PLAY_CONSOLE_CHECKLIST.md` for what the owner still needs to do in
  Play Console itself. 525/525 tests, 584 l10n keys × 9 locales,
  `flutter analyze` clean throughout. **No physical Android device
  exists in this environment at any point in this work — every claim
  above is a real build/signing/binary inspection or a widget test, never
  a claimed device/Billing verification; see `DEVICE_TEST_CHECKLIST.md`.**

- Date: 2026-08-09. PROMPT-003H Stage C item 10 (Offline Fiscal-Receipt QR
  Scanner Shell) done, all four checkpoints — see `DECISIONS.md` D-032.
  Built: `FiscalReceiptScan` model + `SerbiaReceiptAdapter`/
  `ReceiptAdapterRegistry` (local URL-shape classification only) +
  `FiscalReceiptScanService` (checkpoint 1); `FiscalReceiptScannerScreen`
  using `mobile_scanner` with camera-permission-on-entry, always-available
  manual entry (checkpoint 2); `FiscalReceiptQueueScreen` + a manual
  expense handoff sheet that creates a real `ExpenseEntry` via the
  existing `ExpenseService` and links back to the scan, never removing it
  from the queue (checkpoint 3). Hard network boundary held across all
  four checkpoints (verified by diffing the full item-10 range): no code
  calls `suf.purs.gov.rs` or any network client; the one future-fetch
  interface (`FiscalReceiptFetchService`) stays unimplemented behind a
  single Phase-12-approval TODO. 56 new tests this item, `flutter test -j 1`
  **490/490** (was 434 before item 10), 36 new l10n keys × 9 languages
  (554/554 lockstep), `flutter analyze` clean.
  **Release size budget breach, accepted and disclosed, not fixed:** real
  split-APK build measured **armeabi-v7a 28.1MB, arm64-v8a 31.5MB, x86_64
  33.8MB** (up from item 13's 23.3/25.0/26.5MB) — arm64-v8a and x86_64 are
  now **over** the 30MB-per-ABI budget (D-012), caused by
  `mobile_scanner`'s bundled ML Kit barcode library. Decision: accept this
  modest (~5–13%) overage as the disclosed cost of on-device, no-forced-
  network scanning; not a green light for further growth — see D-032
  checkpoint 4 for the exact threshold that would force a real fix.
  **Per PROMPT-003D's own stop condition: stopped here — Stage D
  (monetization) needs a separate explicit go-ahead.**
- Date: 2026-08-08 (later same day). PROMPT-003G Stage C item 13
  (Cross-Border Pack) done — see `DECISIONS.md` D-031,
  `OPEN_QUESTIONS.md` QUESTION-010. Built: an offline, local-first
  cross-border salary/employer-cost comparison across all 9 countries
  from one "same gross" EUR figure (`lib/models/cross_border_comparison.dart`,
  `lib/services/cross_border_comparison_service.dart`,
  `lib/screens/tools/cross_border_screen.dart`), a new cache-only
  `ExchangeRateService.getCachedRateOnly` (never a live fetch, additive —
  doesn't touch the existing live currency converter), and a real
  `DataTable` UI with explicit unavailable-row states (never a guessed
  rate) plus a full per-country breakdown detail sheet. Per-diem/mileage
  deliberately excluded for all 9 countries — not sourceable to the
  project's evidence standard in one session, same "exclude and
  document" pattern as QUESTION-008/009. 42 new tests, `flutter analyze`
  clean, `flutter test -j 1` **434/434** (was 402), 20 new l10n keys × 9
  languages (518/518 lockstep). Release build: split APKs
  **23.3MB/25.0MB/26.5MB** (armeabi-v7a/arm64-v8a/x86_64), up from item
  12's 20.7/22.9/24.3MB (new comparison feature, no new native deps),
  comfortably under the 30MB per-ABI budget. **Per PROMPT-003G's own
  stop condition: stopped here — Stage C item 10 has not been started
  and needs its own approved prompt; order stays 13 → 10.**
- Date: 2026-08-08 (later same day). PROMPT-003F Stage C item 12
  (Invoice PDF + NBS IPS QR, Enhanced) done — see `DECISIONS.md` D-030,
  `OPEN_QUESTIONS.md` QUESTION-009. This entry was missing from this
  file when item 12 actually shipped (its own checkpoints, `PROMPTS.md`,
  and `DECISIONS.md` D-030 correctly recorded it as done at the time —
  only this summary file's own "Last Updated" log lagged); added now,
  during item 13's session-start audit, for an accurate record. Built:
  `BusinessProfile` model/service/Settings section, invoice line-item
  itemization, a content/layout-split PDF pipeline
  (`InvoicePdfContent`/`InvoicePdfService`) with bundled Noto Sans
  fonts (~275 KB) fixing a Cyrillic/Latin-Extended glyph gap, an
  `NbsIpsPayloadBuilder` validated against the sourced NBS spec's own
  worked examples for eligible Serbian RSD invoices, and a new
  `lib/utils/money.dart` deterministic-rounding helper now shared by
  invoice math and (as of item 13) the cross-border comparison's
  derived figures. `flutter test -j 1` 402/402, l10n in lockstep,
  automated l10n-parity test added. Three genuine sourcing gaps disclosed
  rather than guessed — `OPEN_QUESTIONS.md` QUESTION-009.
- Date: 2026-08-08 (later same day). PROMPT-003D Stage C item 11 (Serbia
  paušal & freelancer compliance pack) done, per the user's sourced-figure
  narrowing prompt PROMPT-003E — see `DECISIONS.md` D-029,
  `OPEN_QUESTIONS.md` QUESTION-008. Built: the paušal turnover tracker
  (`PausalTrackerService` + `PausalTrackerScreen`, dual-window
  calendar-year/rolling-12-month tracking against the sourced 6M/8M RSD
  limits, 70/85/95/exceeded states, invoices with no capturable exchange
  rate excluded and counted rather than guessed); the monthly reminder's
  lead-time + assessed-amount extension (additive to Stage B item 7's
  existing reminder, `NotificationService`); the Model A vs Model B
  quarterly comparator in `FreelanceTaxScreen`. Audit-first pass caught
  and fixed a real pre-existing bug: `RsFreelanceStrategy` charged the
  health contribution unconditionally, though the sourced formula waives
  it when the freelancer is insured elsewhere. `flutter analyze` clean,
  `flutter test -j 1` **304/304** (was 276), l10n **32 new keys × 9
  languages**, all in lockstep (verified via a real `flutter gen-l10n`
  run). No release build this item (pure Dart/JSON/l10n change, no native
  code touched). **Per PROMPT-003E's own instruction: stopped here,
  awaiting approval before Stage C item 12 (Invoice PDF + NBS IPS QR).**
- Date: 2026-08-08 (later same day). PROMPT-003 Stage B (retention
  mechanics, items 5–9: recurring transactions, Fixed-Cost Radar, local
  notifications, Android home-screen widgets, one-at-a-time financial
  mirror insights) fully implemented and committed (`af64bb4`..`195ccc7`)
  — see `DECISIONS.md` D-023 through D-028. The user then supplied
  `_userprompts/PROMPT-003D Stage C Go-Ahead.md`, an explicit go-ahead for
  Stage C (items 10–13, working order 11→12→13→10), satisfying Stage B's
  own stop condition; registered as `PROMPT-003D` in `PROMPTS.md`.
  Housekeeping the go-ahead prompt required before any Stage C code:
  Stage B's only release build (D-027) was a fat all-ABI APK (60.8MB, not
  comparable to a per-ABI figure) — re-ran a real
  `flutter build apk --release --split-per-abi`, got **20.7MB /
  22.9MB / 24.3MB** (armeabi-v7a/arm64-v8a/x86_64), up slightly from
  Stage A's 19.4/21.6/23.0MB (new deps: `home_widget`, `workmanager`,
  `flutter_local_notifications`, `timezone`) but comfortably under the
  30MB per-ABI budget. `flutter test -j 1`: 276/276 passing, unchanged.
  Device-unverified checklist below updated to include the two new
  widgets and notifications alongside the pre-existing consent-dialog/
  icon gap. **Stage C item 11 (Serbia paušal/freelancer compliance pack)
  is next.**
- Date: 2026-08-08 (later same day). PROMPT-005 (Version Control,
  Bulgaria Euro Migration, Serbia Tool Consolidation) fully implemented,
  Parts 0–5, own STOP condition in force. This repository now has a git
  repository (10 commits, clean tree) — the single highest-risk gap
  flagged at the end of the previous entry is closed. Bulgaria's
  BGN→EUR bug (QUESTION-007) and the two-overlapping-Serbia-tools issue
  (QUESTION-006) are both resolved. See `session_logs/
  2026-08-08-session-02.md` and `DECISIONS.md` D-020 through D-022
  (plus D-021 for Part 1/2). 218/218 tests passing, l10n 390/390.
  **Do not start further scope (QUESTION-005, PROMPT-003 Stage B, or
  anything else) without explicit instruction — see Next Recommended
  Action below.**

## Superseded entry (still accurate as history)

- Date: 2026-08-08
- Updated by: Claude Code session that first verified the D-016 icon swap
  left un-verified at the end of the prior session (`flutter analyze`/
  `test`/a real release build — all clean, see D-016's addendum), then
  received and fully implemented **PROMPT-004** (Per-Country Freelancer
  Calculator + Store Listing De-Serbianisation) end to end: Part 1 (store
  listing fix, all 9 locales, D-018), Part 2 (remote-updatable
  `tax_rules.json` data layer with bundled fallback, D-017), Part 3 (10
  per-country freelancer self-assessment calculator engines + a new
  Tools-hub screen, D-019), Part 4 (table-driven tests, schema test,
  fetch test, 9-language l10n lockstep, disclaimer, this report). Per
  PROMPT-004's own explicit stop condition, work **stopped here and did
  not proceed to any further scope**. See
  `session_logs/2026-08-08-session-01.md`.
- Prior entry (2026-08-07): completed **all of PROMPT-003 Stage A**
  (items 1–4, D-010 through D-013), then, given an explicit follow-up
  prompt (`PROMPT-003A`) approving and speccing both items Stage A had
  deliberately left open, **implemented the UMP/GDPR consent flow and a
  real app icon** (D-014, D-015) — closing Stage A completely. Per
  PROMPT-003A's own explicit stop condition, work stopped and did not
  proceed to Stage B. See `session_logs/2026-08-07-session-04.md`.
- Current status: **PROMPT-004 (`PROMPTS.md`) is now fully implemented
  (Parts 1–4) and its own STOP condition is in force — do not start
  Stage B of PROMPT-003, or any of PROMPT-004's own follow-on open
  questions (QUESTION-005/006/007), without explicit instruction.** App
  now has a real 9-country (10-regime) freelancer self-assessment
  calculator alongside the existing Serbia-only one (D-019), a
  remote-updatable tax-rules data layer (D-017, remote URL still a
  placeholder — QUESTION-005), and a corrected, de-Serbianized store
  listing in all 9 locales (D-018). 186/186 tests passing, `flutter
  analyze` clean, l10n 399/399 keys in lockstep across all 9 `.arb`
  files. Below this point, the record predates PROMPT-004 and describes
  Phases 1–10 of the offline-completion plan and PROMPT-003 Stage A,
  both still accurate as history but no longer the active next step.
  Phases 1–10 of the offline-completion plan
  done and tested. Phase 11 (final visual polish) has one completed
  increment (empty-state icons, D-007) and is otherwise paused. Work is
  on **PROMPT-003** (`PROMPTS.md`). **Stage A (commercial trust & first
  impression) is now completely done, including its two closure items:**
  1. Onboarding — implemented, tested, and visually confirmed (D-009,
     D-010).
  2. Trust surface — new Settings section + VAT/self-taxation dated
     labels, visually confirmed (D-011).
  3. Performance & size budget — R8/shrinking enabled, a real gradle
     conflict (manual `splits.abi` vs. the Flutter plugin's own NDK
     filter management) found and corrected, real release builds
     measured: split APKs 19.3–23.0MB (comfortably under the 30MB
     target). Cold-start timing and list virtualization audited but left
     open — no device/emulator available to verify safely (D-012,
     `OPEN_QUESTIONS.md` QUESTION-004).
  4. Play Store readiness checklist — store listing text for all 9
     languages (`store_listing/`), data-safety-form answers from a real
     code audit (D-013).
  5. **UMP/GDPR ad consent — implemented** (D-014): `google_mobile_ads`'
     bundled ConsentInformation/ConsentForm APIs gate `MobileAds` init
     and all ad loads; a "Privacy & ad preferences" Settings entry lets
     users reopen the form. **Not verified on a real device/emulator —
     none available this session.**
  6. **Real app icon — designed and generated** (D-015): SVG source in
     `branding/` (exchange-arrows glyph, navy/gold), full adaptive icon
     (foreground/background/Android-13+-monochrome) generated via
     `flutter_launcher_icons`, all platforms. Real release builds
     succeeded with the new icon compiled in. **Not verified on a real
     device home screen — none available this session.**
- **One real remaining gap before either can be trusted in production:**
  on-device verification of both the consent flow and the icon's actual
  rendering — flagged honestly in `DECISIONS.md` D-014/D-015 rather than
  claimed as done. Everything else about both is implemented, tested at
  the Dart/build level, and documented.

## Project Identity

Salary & Currency Pro — a Flutter (Dart) mobile app, positioned as a
Balkan regional personal-finance "super-app." Originally a Serbia-only
salary calculator, repositioned to cover 9 countries (Serbia, Croatia,
Bosnia & Herzegovina, Montenegro, North Macedonia, Slovenia, Bulgaria,
Albania, Romania) and 9 languages, intended for monetized Google Play
release. Fully offline-capable by design — no backend, no accounts, no
server — currency conversion is the one feature that touches the network,
and it degrades to a cached rate when offline.

## Purpose

Give Balkan individuals and freelancers a trustworthy, single app for
payroll math, currency conversion, everyday financial calculators, and
(as of this session) real ongoing expense/budget/invoice tracking —
without asking them to hand data to a server or create an account.

## User Goals

- Publish this on Google Play and make money from it (free tier + ads,
  Pro subscription removes ads).
- Have a product that "real Balkan individuals and businesses could
  confidently use" — commercial-quality, not a developer demo.
- Keep the app genuinely offline-first; explicitly deferred all
  backend/multi-tenant SaaS ideas (team workspaces, invoicing sync,
  accountant portals, bank integration) until the offline product is
  "genuinely complete," per the user's own stated gate — see
  `PROMPTS.md` PROMPT-002.

## Desired Outcome

An app where a user can install it, use every feature with no internet
connection, close and reopen it, and trust that their data is accurate,
private, and still there — the offline-completion definition of done the
user stated explicitly (see `PROMPTS.md` PROMPT-002's "Definition of
finished").

## Current State

See the toolkit's own `PROJECT_STATUS.md`-style ledger doesn't exist here
yet (this repo didn't adopt the toolkit's full SRC-001 structure, only
this memory bundle — see `DECISIONS.md` D-005) — so this section is the
closest equivalent. As of this update:

- **Core payroll/currency/toolkit calculators**: complete, tested, stable
  (prior sessions — see `session_logs/` for this session's work only;
  earlier history lives in this session's originating conversation, not a
  separate file).
- **Expense/income tracker** (`lib/models/expense_entry.dart`,
  `lib/services/expense_service.dart`,
  `lib/screens/expenses/expense_tracker_screen.dart`): create/edit/delete
  with undo, search/filter/sort, month navigation, per-currency summaries,
  spending-by-category breakdown, month-over-month insights, CSV export.
- **Category budgets + savings goals**
  (`lib/models/budget.dart`/`lib/services/budget_service.dart`/
  `lib/screens/budgets/budgets_screen.dart`): monthly per-category spending
  limits compared to real spend; savings goals with manually-logged
  progress (explicitly not automated — no bank connection exists).
- **Settings data management**: export-all-data (CSV, clipboard) and a
  strongly double-confirmed delete-all-local-data action, plus an explicit
  offline-status explanation.
- **Minimal offline "business mode"**: an invoice tracker
  (`lib/models/invoice.dart`/`lib/services/invoice_service.dart`/
  `lib/screens/business/invoices_screen.dart`) — client, amount, issue/due
  dates, paid/unpaid/derived-overdue. Deliberately does not include team
  workspaces, roles, or accountant PDF reports — see `IDEAS.md`.
- All new l10n keys added across all 9 languages in lockstep (verified by
  key-count check every batch) — no known English leakage. Key count is
  336/locale across all 9 `lib/l10n/app_*.arb` files as of this update
  (unchanged by this session's Phase 11 work — no new strings were
  needed, see below).
- `flutter analyze`: clean (3 pre-existing cosmetic doc-comment notes
  only, unrelated to any session's changes so far). Full test suite:
  121/121 passing as of this update (check the latest `flutter test -j 1`
  run rather than trusting this number in a future session).
- **Empty-state icons added to the expense tracker, budgets/goals
  (savings-goals card), and invoices screens** (`DECISIONS.md` D-007) —
  all three already had correct empty-state *messages* from earlier
  phases; this added the icon half of the app's existing icon+text
  empty-state convention (established in `my_scenarios_screen.dart`) so
  the three newer screens visually match it. No new l10n strings.

## Development Setup — Running dev/prod Builds in Android Studio

PROMPT-003J (checkpoint 1, `DECISIONS.md` D-034) added a real dev/prod
Gradle flavor split. These are the exact commands/steps verified this
stage — a real `flutter build` + `aapt dump badging` confirmed each
claim below, not guessed. **A flavor-less build/run now fails to label
itself correctly** — always specify a flavor.

### Owner: running the dev build on your own phone from Android Studio

1. Open Android Studio → **Open** → select this repo's root folder (the
   one containing `pubspec.yaml`), not the `android/` subfolder.
2. Let Gradle sync finish (first sync after this change may take a few
   minutes — the flavor split adds two new build variants).
3. Connect your Android phone via USB with USB debugging enabled (or use
   any already-configured emulator).
4. In the Run/Debug configuration dropdown (top toolbar), select
   **"main_dev.dart (dev)"** — this repo's `.idea/runConfigurations/`
   ships this config already (committed via a narrow `.gitignore`
   exception specifically so it reaches you after `git pull`; everything
   else under `.idea/` stays local-only, as before).
5. Press **Run** (▶). The installed app will be labeled
   "Salary & Currency Pro (DEV)" with a red "DEV" ribbon on its icon —
   installs alongside a real prod install without overwriting it
   (distinct application ID: `rs.salarycurrencypro.salary_currency_pro.dev`).
6. On first launch, Settings → the gold-bordered **"Entitlement Preview
   (Dev)"** card lets you simulate Free/Trialing/Pro/Lifetime/Expired
   against every real Free/Pro gate in the app — it defaults to fully
   unlocked Pro. This card only exists in dev builds; it is
   compile-time absent from `main_prod.dart`/`main.dart` builds.

### Command-line equivalents (verified this stage)

```text
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor prod -t lib/main_prod.dart
flutter build apk --debug --flavor dev -t lib/main_dev.dart
flutter build apk --debug --flavor prod -t lib/main_prod.dart
flutter build apk --release --flavor prod -t lib/main_prod.dart --split-per-abi
```

The bare `flutter run`/`flutter build` (no `-t`, using `lib/main.dart`)
still works, but **requires `--flavor prod` explicitly** now that flavors
exist — `lib/main.dart` itself always initializes the prod flavor
internally regardless, but Gradle needs the flag to pick a variant at
all. The existing `.idea/runConfigurations/main.dart` config was updated
to pass this automatically; prefer the dedicated
`main_dev.dart (dev)`/`main_prod.dart (prod)` configs for new use.

### What's still open (see `DEVICE_TEST_CHECKLIST.md`)

Every claim above is either a real build/`aapt` inspection or a widget
test against a platform double — none of it is a real-device touch/visual
pass. No physical Android device or emulator exists in the coding
environment that built this; the owner's own phone run above is the first
real-device verification this feature gets.

### Release signing — the one owner action still required before Play upload

PROMPT-003J checkpoint 4 added the standard Flutter `key.properties`
scaffold (`android/app/build.gradle.kts`), but **every release artifact
built in this environment so far is still signed with the debug
keystore** — Google Play does not accept that. Real signing needs a real
keystore this environment cannot generate (it would need to be a secret
only the owner holds). To finish this:

1. Generate a real upload keystore (run this yourself, not in a shared/
   AI-assisted terminal, since it prompts for passwords):
   ```text
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   Store the resulting `upload-keystore.jks` **outside the repo** (e.g.
   `android/upload-keystore.jks` is fine since `*.jks` is gitignored, but
   keep an independent backup somewhere safe — a lost upload key means
   losing the ability to ever update the app on Play again).
2. Copy `android/key.properties.example` to `android/key.properties`
   (already gitignored) and fill in the real `storePassword`/
   `keyPassword`/`keyAlias`/`storeFile` values.
3. Rebuild: `flutter build appbundle --release --flavor prod -t lib/main_prod.dart`.
   The build automatically detects `android/key.properties` and signs
   with it instead of the debug key — no other command changes.
4. Confirm real signing before uploading:
   ```text
   jarsigner -verify -verbose -certs build/app/outputs/bundle/prodRelease/app-prod-release.aab
   ```
   (should show your own certificate, not the well-known Android debug
   one).

## Current Focus

Phase 11 (final visual polish) is underway — the empty-state icon
consistency increment (`DECISIONS.md` D-007) is done. Remaining Phase 11
scope (per `PROMPTS.md` PROMPT-002's list — typography, spacing, button
hierarchy, animations, onboarding, trust messaging, first-use experience)
has not been assessed item-by-item yet; treat it as open until reviewed.
Then Phase 12 (an online-readiness *report* only — no online code until
the user explicitly approves it).

## Important Constraints

- Windows 11, PowerShell primary shell, Bash tool available via Git Bash.
- **Offline-first is a hard constraint, not a preference** — the user
  explicitly declined starting backend/SaaS work when asked directly (see
  `PROMPTS.md` PROMPT-002, and the earlier AskUserQuestion exchange this
  session where the user chose "Stay offline-first for now").
- All 9 supported languages must be kept in exact key-count lockstep — no
  partial translations, no English leakage. Verify with
  `grep -cE '^\s*"[a-zA-Z]' lib/l10n/app_*.arb` after any l10n change.
- `flutter test -j 1` — this project has a known concurrency bug where the
  default test runner concurrency silently drops files; always run with
  `-j 1`.
- `claude-in-chrome` browser tooling has been available in some sessions
  (confirmed working 2026-08-07, D-010) but not others — do not assume
  it's available; check at session start, and if unavailable, state that
  UI verification fell back to `flutter analyze`/`flutter test`/code
  review rather than live rendering. The `.claude/launch.json`
  `flutter-web` config (port 8765) is the way to launch a preview when it
  is available. If port 8765 is already bound but returns errors (e.g.
  HTTP 503) rather than serving the app, it's a stale process from an
  earlier session — kill it and start a fresh `flutter run` rather than
  assuming the app is already up.

## User Preferences

- Wants autonomous continuation through the phase plan without being
  asked what to do next on ordinary decisions — explicit instruction this
  session ("continue with all phases without confirmation from me").
- Wants real, verified work only — no fabricated completion claims; when
  a test reveals a real bug (not a test artifact), fix the actual bug, not
  just the test (see `DECISIONS.md` D-004, the SnackBar queueing fix).
- Prefers minimal, tightly-scoped increments per phase over attempting
  everything at once (see `DECISIONS.md` D-001).
- Corrects course directly and expects the correction followed precisely
  — e.g. flagged that the toolkit path in a supplied prompt was wrong
  (`C:\Claude-Global-Toolkit` vs the actual app at
  `C:\salary-currency-pro`), and that correction was applied immediately.
- Wants this repository's own memory/context system kept up to date
  across session restarts, not just the toolkit repository's — the direct
  motivation for this file existing.

## Known Risks

- AdMob/Play Console are still wired to Google's official *test* IDs —
  real product IDs must be created by the user in their own accounts
  before release; this is not something a coding session can complete.
- No end-to-end validation on a real device/emulator this session (no
  browser/visual tooling available) — `flutter analyze` + `flutter test`
  clean is not the same as confirmed-working UI on a real screen size.
- The Samooporezivanje (Serbia freelancer self-taxation) calculator
  intentionally excludes social security contributions because that
  formula wasn't sourced to the same standard as the rest of the app —
  see `OPEN_QUESTIONS.md`.
- **Release size — real progress, one ABI still over budget.**
  `mobile_scanner`'s dependency originally pushed two of three release
  ABIs over the 30MB-per-ABI budget from D-012 (arm64-v8a 31.5MB, x86_64
  33.8MB; armeabi-v7a 28.1MB stayed under — accepted per D-032). Removing
  the dormant Google Mobile Ads/UMP SDK and its transitive WebView chain
  (D-035) measurably shrank the app: **armeabi-v7a 26.1MB, arm64-v8a
  29.4MB (now under budget), x86_64 31.8MB (still over, by ~6% instead of
  ~13%)**. See `DECISIONS.md` D-035 checkpoint 2 for the full before/after
  table. x86_64 remaining over budget is still real and still not
  described as resolved.
- **UMP/GDPR consent flow and the real app icon are both implemented
  (D-014, D-015) but NOT verified on a real device/emulator** — no
  device/emulator was available in this environment. Before trusting
  either in production: run on a real Android device, confirm the EEA
  consent form actually renders and behaves correctly, and confirm the
  new icon actually looks right on a real launcher (regular/round/themed
  variants).
- **Device-unverified checklist (build/test-verified only, no real
  Android device or emulator available in this environment for any of
  these):**
  - UMP/GDPR consent dialog (D-014) — does the EEA consent form actually
    render and behave correctly.
  - App icon launcher variants (D-015/D-016) — regular/round/themed
    icons on a real launcher.
  - Local notifications (D-026, Stage B item 7) — the four reminder
    types actually fire and display correctly; permission-denied path
    degrades gracefully.
  - Both Android home-screen widgets (D-027, Stage B item 8) —
    spend-vs-budget and pinned-currency-pair RemoteViews widgets actually
    render, refresh on data change, and survive the hourly WorkManager
    backstop on a real launcher.
  - Invoice PDF generation/share/print and the embedded NBS IPS QR code
    (D-030, Stage C item 12) — automated tests prove PDF generation
    succeeds for every locale's characters and that the bundled font
    fixes the known Cyrillic/Latin-Extended glyph gap, but not that the
    rendered PDF/QR actually looks right or scans correctly on a real
    device/printer/banking app.
  - The Cross-Border Pack comparison table and per-row detail sheet
    (D-031, Stage C item 13) — widget-tested at a few fixed viewport
    sizes (800×2400, 360×1800) with no overflow, but real narrow-phone
    `DataTable` horizontal-scroll ergonomics and the bottom-sheet detail
    view haven't been confirmed on an actual device.
  - The fiscal-receipt QR scanner (D-032, Stage C item 10) — automated
    tests cover every camera-controller state via a fake platform double
    and the queue/handoff flow end-to-end, but real-device camera
    behavior (actual QR detection accuracy/speed, real permission-prompt
    UX, real-world lighting/receipt conditions) hasn't been confirmed on
    an actual device.
  - The user will test everything on a real device once the app is
    feature-complete (per `_userprompts/PROMPT-003D Stage C Go-Ahead.md`).

## Known Uncertainties

- Whether/when the user wants real backend infrastructure for the
  deferred business-SaaS features (team workspaces, invoice sync,
  accountant portals) — explicitly gated behind finishing the offline
  plan; see `OPEN_QUESTIONS.md`.
- Exact scope the user wants for Phase 11 (visual polish) — not yet
  discussed in detail.

## Current Priorities

1. **PROMPT-003D (Stage C go-ahead) is Active.** Working order per the
   prompt: **11 → 12 → 13 → 10** — items 11, 12, and 13 are all now done
   (see the top three `Last Updated` entries and `DECISIONS.md`
   D-029/D-030/D-031). **Only item 10 (fiscal-receipt QR scanner, offline
   shell only) remains, and it has not been started — it needs its own
   approved prompt, per PROMPT-003G's explicit instruction not to begin
   it autonomously.**
2. **This prompt's own stop condition:** after item 10's offline shell is
   done and reported, STOP — Stage D (monetization/paywall wiring) needs
   a separate explicit go-ahead. Nothing in Stage C should be gated
   behind a paywall yet, but each feature stays behind a clean service
   boundary so gating is a one-line change later (item 13's
   `CrossBorderComparisonService` follows the same convention).
3. **On-device verification remains open** for consent dialog, app icon,
   both widgets, notifications, invoice PDF/NBS IPS QR rendering, and the
   Cross-Border Pack's table/detail-sheet layout (see the Known Risks
   checklist above) whenever a real Android device/emulator becomes
   available — Stage C will add the QR scanner to this list too. Not
   blocking; the user will test everything on a real device once the app
   is feature-complete.
4. Phase 11's remaining broader scope (typography, spacing, button
   hierarchy, animations — `PROMPT-002`) remains paused, not abandoned.
5. **Phase 12: produce the online-readiness report** and **stop** —
   explicit user instruction not to implement online functionality until
   that report is reviewed and approved. Item 10's network fetch point is
   explicitly NOT approved in this stage for the same reason — offline
   shell only, single documented TODO at the fetch boundary.

## Completed Milestones

- Balkan expansion: 9 countries, 9 languages, config-driven tax engine,
  financial toolkit, monetization scaffolding, local history + saved
  scenarios (prior sessions, before this memory bundle existed).
- This session — Phases 1–9 of the offline-completion plan: transaction
  edit/undo, search/filter/sort, dashboard insights, category budgets,
  savings goals, CSV export, settings data management, minimal offline
  invoice tracking. All localized to 9 languages, all covered by new
  automated tests, `flutter analyze` clean throughout.
- Adopted the toolkit's optional memory-system bundle into this
  repository (`DECISIONS.md` D-005).
- **Phase 10 (quality/reliability pass), completed 2026-08-07:** removed
  an unused dependency (`cupertino_icons`, never referenced anywhere in
  `lib/`); added an explicit restart-persistence test (expense data +
  theme preference survive a simulated app relaunch); added missing
  `IconButton` tooltips (month navigation, clear-search ×2) for
  accessibility; **found and fixed a real production-build blocker** —
  `google_mobile_ads 5.3.1`'s Gradle script was incompatible with this
  project's Gradle 9.1.0/AGP 9.0.1 toolchain, upgraded to `9.0.0` (no
  breaking API changes in this app's usage), then verified with an actual
  `flutter build apk --debug` producing a real 158MB APK — see
  `DECISIONS.md` D-006. 121/121 tests passing, `flutter analyze` clean
  throughout.
- **Phase 11 (visual polish), first increment, completed 2026-08-07:**
  added an icon to the expense tracker, budgets/goals, and invoices
  screens' empty states, matching the icon+text convention already
  established in `my_scenarios_screen.dart` — see `DECISIONS.md` D-007.
  No new l10n strings (existing empty-state messages were already correct
  and unchanged); extended the three existing widget tests that already
  asserted the empty-state message to also assert the new icon renders,
  rather than writing new duplicate tests. 121/121 tests passing,
  `flutter analyze` clean (same 3 pre-existing cosmetic notes as before,
  unrelated to this change).
- **Phase 11, second increment, same day (Claude Desktop, real browser
  available for the first time):** confirmed toolkit already at v2.2.0
  (no pull needed). Ran the app in a real browser preview and visually
  confirmed the D-007 empty-state icon. Found and fixed a real visual bug
  via that verification: the "Add expense"/"Add income" sheet's Amount
  field focus color didn't match the sheet's red/green type theming — see
  `DECISIONS.md` D-008. **The fix itself is not yet visually
  re-confirmed** — a client-side Browser-pane display issue blocked
  screenshots after a preview restart; fell back to `flutter analyze`
  (clean) + `flutter test -j 1` (121/121 passing). Still needs an actual
  look before being trusted.
- **PROMPT-003 registered as Active** (`PROMPTS.md`) — a new large
  standing instruction, supplied as
  `C:\Users\Administrator\Downloads\PROMPT-003_Market_Domination_Addition.md`,
  extending PROMPT-002 with a commercial-readiness layer and a
  prioritized differentiator roadmap. Does not override PROMPT-002's
  offline-first gate.
- **PROMPT-003 Stage A item 1 (onboarding), implemented 2026-08-07:** new
  3-screen flow (country/language with device-locale auto-detection +
  manual override → privacy promise → primary-goal picker that sets a
  persistent default home tab) — see `DECISIONS.md` D-009 for full design
  detail. Audited first: no onboarding existed; reused existing country/
  language picker patterns rather than rebuilding; discovered Stage D
  (monetization) already has real `ProProvider`/`PurchaseService`/
  `PaywallScreen` scaffolding from earlier sessions, not yet a gap. 16
  new l10n keys × 9 languages (352/352 lockstep verified), 2 new tests,
  **123/123 passing**, `flutter analyze` clean.
- **PROMPT-003 Stage A item 1 (onboarding), visually confirmed
  2026-08-07:** real browser screenshots (`claude-in-chrome`) of all 3
  onboarding screens, plus confirmation that picking a goal lands the app
  on the mapped tab. Also re-confirmed D-008's Amount-field fix (red
  label/cursor in the "Add expense" sheet). See `DECISIONS.md` D-010.
- **PROMPT-003 Stage A item 2 (trust surface), completed 2026-08-07:**
  new "Why trust this app?" Settings section; VAT calculator now shows
  "Standard rate as of {date}" from `vat_rates.json`'s real
  `lastUpdated`; Samooporezivanje calculator now shows "{year} quarterly
  thresholds". Salary calculator, currency converter, and freelancer
  payout already had equivalent freshness disclosure — audited, not
  rebuilt. Loan/Savings/Budget Planner deliberately excluded (no
  app-provided rate to disclose). 4 new l10n keys × 9 languages
  (356/356 lockstep verified). Visually confirmed in a real browser. See
  `DECISIONS.md` D-011.
- **PROMPT-003 Stage A item 3 (performance & size budget), completed
  2026-08-07:** R8/resource shrinking enabled in
  `android/app/build.gradle.kts`. A manual `splits.abi` block was tried
  first and failed a real build (conflicts with the Flutter Gradle
  plugin's own NDK filter management) — corrected to rely on
  `flutter build apk --split-per-abi` / Play's own AAB dynamic delivery
  instead, with an explanatory comment left in the gradle file. Measured
  via real release builds: split APKs 19.3MB/21.6MB/22.9MB (all under
  the 30MB target), AAB 58.2MB (whole-bundle size, not per-device).
  Cold-start timing and list virtualization (Expense Tracker, Invoices)
  audited and deliberately left open — no device/emulator available to
  verify safely. See `DECISIONS.md` D-012, `OPEN_QUESTIONS.md`
  QUESTION-004.
- **PROMPT-003 Stage A item 4 (Play Store readiness), completed
  2026-08-07:** store listing text written for all 9 languages
  (`store_listing/`), data-safety-form answers derived from a real audit
  of `lib/services/` and the two third-party SDKs present. Two real gaps
  found and deliberately left unimplemented pending user decision (see
  D-013) — both closed later the same session by PROMPT-003A, below.
  Also fixed two small, clearly-wrong placeholders found while auditing:
  Android's `android:label` was the raw package name, and
  `pubspec.yaml`'s description was still Flutter's template default. See
  `DECISIONS.md` D-013, `store_listing/README.md`.
- **PROMPT-003A (Stage A closure): UMP/GDPR consent flow implemented,
  2026-08-07** — `lib/services/consent_service.dart` wraps
  `google_mobile_ads`' bundled UMP APIs, gates `MobileAds` init and every
  ad request on the consent result, degrades safely offline (3s timeout,
  fails open to "no ads"), adds a "Privacy & ad preferences" Settings
  entry. 4 new l10n keys × 9 languages (360/360 lockstep). **Not verified
  on a real device/emulator — none available.** See `DECISIONS.md`
  D-014.
- **PROMPT-003A (Stage A closure): real app icon designed and generated,
  2026-08-07** — original vector glyph (two exchange arrows forming a
  broken circle, navy/gold) built parametrically
  (`branding/generate_icon.py`, SVG + PNG sources in `branding/`),
  generated via `flutter_launcher_icons` to Android (legacy + adaptive +
  monochrome), iOS, web, Windows, and macOS, plus a 512×512 Play Store
  PNG. Also fixed two more placeholder-metadata bugs found while
  touching this area (`web/manifest.json`, `web/index.html` still had
  Flutter's template name/description). Two real release builds
  succeeded with the new icon compiled in. **Not verified on a real
  device home screen — none available.** See `DECISIONS.md` D-015.
  **This closes PROMPT-003 Stage A completely — PROMPT-003A's own stop
  condition applies: do not start Stage B until the user says so.**
- **D-016 icon-swap verification completed, 2026-08-08:** `flutter
  analyze` clean, `flutter test -j 1` 123/123, and a real
  `flutter build apk --release --split-per-abi` all confirmed the D-016
  externally-supplied icon integration is sound (same size range as
  before the swap) — the one gap explicitly left open at the end of the
  prior session.
- **PROMPT-004 (Per-Country Freelancer Calculator + Store Listing
  De-Serbianisation), complete 2026-08-08 — see `DECISIONS.md` D-017/
  D-018/D-019:**
  - Part 1: replaced the Serbia-specific store-listing bullet with the
    supplied country-neutral text in all 9 `store_listing/*.md` files;
    swept the rest of `store_listing/` for the same leak class, found
    none.
  - Part 2: `assets/config/tax_rules.json` (schema-enforced, every value
    carrying `effectiveFrom`+`source`, `n.a.` gaps as `null`, 10
    regimes) + `lib/services/tax_rules_service.dart` (bundled-first,
    ≤24h/5s-timeout background refresh, silently discards every failure
    mode). Remote URL is a disclosed placeholder — no public repo exists
    yet to host it (`OPEN_QUESTIONS.md` QUESTION-005).
  - Part 3: one strategy class per regime
    (`lib/logic/freelance/*_strategy.dart` — rs, bg, hr, ba_fbih, ba_rs,
    me, mk, si [normirani+popoldanski], al, ro) behind a common
    `FreelanceTaxStrategy` interface, several formulas cross-checked
    internally against a second independent sourced figure (not just
    transcribed), cliff-warning flags always shown when a regime defines
    one. New `FreelanceTaxScreen`, added to the Tools hub and scenario-
    reopen routing, additively alongside (not replacing) the existing
    Serbia-only tool — see `OPEN_QUESTIONS.md` QUESTION-006 for the
    future consolidation call.
  - Part 4: 29 calculator tests + 25 schema tests + 8 fetch-policy tests
    + 1 end-to-end widget test, all passing (186/186 full suite); 39 new
    l10n keys × 9 languages, 399/399 lockstep verified; existing
    estimates-only disclaimer confirmed rendering on the new screen by
    an actual test, not just code inspection.
  - Found and disclosed, not fixed (out of stated scope): Bulgaria's
    salary/VAT/currency code still assumes BGN while PROMPT-004's own
    data says EUR since 1 Jan 2026 — `OPEN_QUESTIONS.md` QUESTION-007.
  - **PROMPT-004's own explicit stop condition applies: Parts 1–4 are
    complete and verified; do not start further scope (QUESTION-005/006/
    007, or PROMPT-003 Stage B) until the user says so.**
- **PROMPT-005 (Version Control, Bulgaria Euro Migration, Serbia Tool
  Consolidation), complete 2026-08-08 — see `DECISIONS.md` D-020/D-021/
  D-022:** git repo stood up (Part 1); `tax_rules.json` publishing
  tooling added (Part 2); Bulgaria BGN→EUR fixed plus two independent
  stale-figure bugs caught in the same audit (Part 3, closes
  QUESTION-007); the two overlapping Serbia freelancer tools consolidated
  into one, with an idempotent migration for old saved scenarios (Part 4,
  closes QUESTION-006). 218/218 tests, clean analyze, 390/390 l10n. Then
  pushed to GitHub (private) and stood up the public
  `salary-currency-pro-rules` repo, closing QUESTION-005 for real (not
  just a placeholder fix) — see `session_logs/2026-08-08-session-02.md`
  and commit `e9a3aa2`.
- **PROMPT-003 Stage B (retention mechanics, items 5–9), complete
  2026-08-08 — see `DECISIONS.md` D-023 through D-028:** recurring
  transactions with idempotent due-date resolution and a review queue
  (item 5); Fixed-Cost Radar, a read-only per-currency overview of active
  recurring expenses (item 6); four offline local notification types, all
  off by default (item 7); two Android home-screen widgets (spend-vs-
  budget, pinned currency pair) via RemoteViews + WorkManager, plus a new
  cross-session `PinnedPairService` (item 8); the Expense Tracker's
  financial-mirror insights reworked to show one at a time with a
  tap-to-reveal calculation (item 9). 276/276 tests, clean analyze,
  444/444 l10n across 9 locales. **Closes Stage B; Stage C (items 10–13)
  was not started in the same session — needed its own explicit
  go-ahead, same discipline as before Stage B.**
- **PROMPT-003D (Stage C go-ahead + housekeeping), 2026-08-08:** user
  supplied `_userprompts/PROMPT-003D Stage C Go-Ahead.md`, satisfying
  Stage B's stop condition; registered in `PROMPTS.md`. Housekeeping
  done before any Stage C code: real `flutter build apk --release
  --split-per-abi` (Stage B's D-027 had only run a fat 60.8MB universal
  APK) — 20.7MB/22.9MB/24.3MB per-ABI, comfortably under the 30MB budget;
  device-unverified checklist in this file confirmed current, widgets
  and notifications added to it. Stage C item 11 is next.
- **PROMPT-003E (Stage C item 11 — Serbia paušal/freelancer compliance
  pack), 2026-08-08 — see `DECISIONS.md` D-029:** paušal turnover tracker
  (dual-window, sourced 6M/8M RSD limits, honest exclusion of invoices
  with no capturable FX rate), monthly reminder lead-time + assessed-
  amount extension, Model A vs Model B comparator. Fixed a real
  pre-existing bug found during the required audit: health contribution
  was charged unconditionally in `RsFreelanceStrategy`, though the
  sourced formula waives it when insured elsewhere. Four figures excluded
  and documented rather than approximated — `OPEN_QUESTIONS.md`
  QUESTION-008. `flutter test -j 1` 304/304, l10n 32 new keys × 9
  languages in lockstep. **PROMPT-003E's own stop condition applies:
  stopped here, awaiting approval before item 12.**

- **PROMPT-003F (Stage C item 12 — Invoice PDF + NBS IPS QR, Enhanced),
  complete 2026-08-08 — see `DECISIONS.md` D-030:** `BusinessProfile`
  model/service/Settings section, invoice itemization, a content/layout-
  split PDF pipeline with bundled Noto Sans fonts, and an
  `NbsIpsPayloadBuilder` for eligible Serbian RSD invoices' embedded
  payment QR, validated against the sourced NBS spec's own worked
  examples. `flutter test -j 1` 402/402, l10n in lockstep, new automated
  l10n-parity test. Three sourcing gaps disclosed rather than guessed —
  `OPEN_QUESTIONS.md` QUESTION-009.
- **PROMPT-003G (Stage C item 13 — Cross-Border Pack), complete
  2026-08-08 — see `DECISIONS.md` D-031:** offline, local-first
  cross-border salary/employer-cost comparison across all 9 countries
  from one "same gross" EUR figure, run through each country's real,
  unmodified `SalaryCalculator`. New cache-only
  `ExchangeRateService.getCachedRateOnly` (additive, never a live
  fetch). 42 new tests, `flutter test -j 1` 434/434, 20 new l10n keys
  × 9 languages (518/518 lockstep), split-APK release build
  23.3/25.0/26.5MB. Per-diem/mileage excluded for all 9 countries —
  not sourceable to the project's evidence standard this session —
  `OPEN_QUESTIONS.md` QUESTION-010. **This closes PROMPT-003D's item
  11→12→13 sequence; only item 10 remains, and it needs its own
  approved prompt.**
- **PROMPT-003H (Stage C item 10 — Offline Fiscal-Receipt QR Scanner
  Shell), complete 2026-08-09 — see `DECISIONS.md` D-032:** local-only
  scan → classify → queue → manual-expense-handoff pipeline across four
  checkpoints (data model/Serbia adapter/future-fetch boundary; scanner UI
  + permissions + manual entry; queue screen + handoff; final
  regression/release evidence). Hard network boundary verified across the
  full item diff — no call to `suf.purs.gov.rs` or any network client
  anywhere. `flutter test -j 1` 490/490, 36 new l10n keys × 9 languages
  (554/554 lockstep). **Real release-size overage found and disclosed,
  not hidden:** arm64-v8a 31.5MB and x86_64 33.8MB now exceed the 30MB
  per-ABI budget (armeabi-v7a 28.1MB stays under) — accepted as the cost
  of `mobile_scanner`'s on-device ML Kit barcode dependency, not fixed
  this pass. **This closes PROMPT-003D's full item 11→12→13→10 sequence
  and Stage C. Per PROMPT-003D's own stop condition: Stage D
  (monetization) needs a separate explicit go-ahead.**

## Next Recommended Action

0. **NEWEST, READ FIRST:** PROMPT-003D (Stage C go-ahead) is Active;
   items 11, 12, 13, and now 10 are all **done** — Stage C is complete.
   See the `Last Updated` entries and `DECISIONS.md` D-029/D-030/D-031/
   D-032. **Per PROMPT-003D's own instruction, this stage stops here:
   Stage D (monetization/paywall wiring) needs its own separate approved
   prompt, not autonomous continuation.** Note the accepted, disclosed
   release-size overage (arm64-v8a/x86_64 over the 30MB budget, see
   `DECISIONS.md` D-032 checkpoint 4) if Stage D scoping ever adds its own
   size cost on top.
1. `OPEN_QUESTIONS.md` QUESTION-008 (four figures excluded from item 11 —
   paušal deemed-base coefficients, supplementary annual PIT, an
   ungazetted contribution-base growth cap, other countries' paušal
   equivalents) is open but non-blocking, same "exclude and document"
   pattern as QUESTION-001. QUESTION-005 is resolved (`kFreelanceTaxRulesRemoteUrl`
   points at the real public `salary-currency-pro-rules` repo,
   live-verified) — no action needed. QUESTION-004 (cold-start timing/list
   virtualization) remains open, deliberately, pending a real device/
   emulator or browser tooling — not blocking Stage C.
2. **Item 10 is done and reported — STOPPED per PROMPT-003D's own stop
   condition.** Stage D (monetization/paywall wiring) needs a separate
   explicit go-ahead, same pattern as every prior stage.
3. On-device verification (consent dialog, icon, both widgets,
   notifications, and eventually the QR scanner) remains the single most
   valuable check whenever a real Android device/emulator or working
   browser tooling becomes available — not blocking Stage C work.
4. Phase 11's remaining broader visual-polish scope and Phase 12
   (online-readiness report) resume once Stage C is substantially done.
