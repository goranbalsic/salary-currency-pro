# Project Context

## Last Updated (newest first)

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
- **UMP/GDPR consent flow and the real app icon are both implemented
  (D-014, D-015) but NOT verified on a real device/emulator** — no
  device/emulator was available in this environment. Before trusting
  either in production: run on a real Android device, confirm the EEA
  consent form actually renders and behaves correctly, and confirm the
  new icon actually looks right on a real launcher (regular/round/themed
  variants).

## Known Uncertainties

- Whether/when the user wants real backend infrastructure for the
  deferred business-SaaS features (team workspaces, invoice sync,
  accountant portals) — explicitly gated behind finishing the offline
  plan; see `OPEN_QUESTIONS.md`.
- Exact scope the user wants for Phase 11 (visual polish) — not yet
  discussed in detail.

## Current Priorities

1. **PROMPT-003A is complete and its own explicit stop condition applies:
   "do not start Stage B until [the user says] so."** Do not
   autonomously begin Stage B — wait for explicit instruction, even
   though the general working style for this project (once a stage/
   prompt IS active) is to proceed through its items without asking.
   This is a documented exception, not a contradiction — see
   `PROMPTS.md` PROMPT-003A and the auto-memory feedback note on it.
2. **On-device verification of D-014 (UMP consent) and D-015 (app icon)
   is the most valuable next action** whenever a real Android device/
   emulator becomes available — both are implemented and build-verified
   but not run on real hardware.
3. Once the user says to proceed, **PROMPT-003 Stage B (retention
   mechanics)** is next per the plan — see `PROMPTS.md` for the full item
   list (recurring transactions, subscription tracking, etc.). Each item
   needs its own audit-first pass like Stage A's items did.
4. Phase 11's remaining broader scope (typography, spacing, button
   hierarchy, animations — `PROMPT-002`) remains paused, not abandoned —
   resume once Stage B is further along.
5. **Phase 12: produce the online-readiness report** and **stop** —
   explicit user instruction not to implement online functionality until
   that report is reviewed and approved. PROMPT-003 does not override
   this gate — any network-dependent item in Stages C/D gets built as an
   offline shell only, per PROMPT-003's own working rules.

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

## Next Recommended Action

0. **NEWEST, READ FIRST:** PROMPT-005 (git + Bulgaria BGN→EUR + Serbia
   tool consolidation) is fully implemented, Parts 0–5, verified
   218/218 tests + clean analyze + 390/390 l10n lockstep + a real release
   build (D-020, D-021, D-022). **This repo now has git** — 10 commits on
   `main`, nothing pushed, no remote created. To push:
   `gh repo create salary-currency-pro --private --source=. --remote=origin`
   then `git push -u origin main` (or create the private repo on
   github.com first and `git remote add origin ...`). **PROMPT-005's own
   explicit stop condition is in force — do not start any further scope
   without the user's go-ahead**, including:
   - `OPEN_QUESTIONS.md` QUESTION-005 (still open: set up a real public
     repo/GitHub Pages URL for `tax_rules.json` over-the-air updates —
     `kFreelanceTaxRulesRemoteUrl` in
     `lib/services/tax_rules_service.dart` is still a placeholder; once a
     real URL exists, repointing it is a one-line change).
   - PROMPT-003 Stage B (still blocked by PROMPT-003A's own separate
     stop condition, item 1 below — unrelated to PROMPT-004/005, still
     open, unchanged from before this session).
   QUESTION-006 (Serbia tool overlap) and QUESTION-007 (Bulgaria BGN)
   are now **resolved** — see `DECISIONS.md` D-022 and D-020.
1. **Do not start PROMPT-003 Stage B** — PROMPT-003A's explicit stop
   condition applies until the user says otherwise. (D-014/D-015's real
   Android icon swap is verified per D-016's addendum; on-device
   consent-dialog/launcher verification is still the one open item under
   this heading, unchanged from before this session — still needs a real
   device/emulator, as does the Bulgaria BGN→EUR fix, which was only
   build-verified this session, not device-verified — no browser/device
   tooling was available.)
2. Once the user gives the go-ahead, start PROMPT-003 Stage B (retention
   mechanics) — see `PROMPTS.md` for the full item list. Each item needs
   its own audit-first pass, same as Stage A.
3. Phase 11's remaining scope and Phase 12 (online-readiness report)
   resume once Stage B is substantially done — see Current Priorities.
