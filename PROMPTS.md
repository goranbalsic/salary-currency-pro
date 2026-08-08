# Prompt Library

Project-specific log of large prompts that shaped this project — distinct
from a generic reusable prompt library (this repo has no such directory).
Each prompt is labeled: Active, Reference, Experimental, Superseded,
Archived.

## Prompt Index

| ID | Name | Type | Status | Purpose |
|---|---|---|---|---|
| PROMPT-001 | Autonomous Product Development Prompt | Large standing instruction | Narrowed by PROMPT-002 | Turn the app into a full Balkan fintech SaaS (personal + business finance, invoicing, research, commercial polish) |
| PROMPT-002 | 12-Phase Offline Completion Plan | Large standing instruction | Active | Finish the offline app completely before any online/backend work; explicit phase-by-phase plan with a definition of "finished" |
| PROMPT-003 | Market-Ready Commercial Excellence Addition | Large standing instruction | Active | Extends PROMPT-002 with a commercial-readiness layer (trust, onboarding, performance/size, store listing) and a prioritized differentiator roadmap (retention mechanics, Balkan-specific killer features, monetization) |
| PROMPT-003A | Stage A Closure — Consent Flow + App Icon | Large standing instruction | Item 1 done; Item 2 superseded by PROMPT-003C | UMP/GDPR consent flow (D-014) accepted. In-house icon (D-015) rejected on design review |
| PROMPT-003C | Checkpoint + Icon Handoff | Large standing instruction | Icon integrated (D-016), verified | Externally-approved icon artwork integrated into branding/; flutter analyze/test/release build re-run and confirmed clean 2026-08-07 |
| PROMPT-004 | Per-Country Freelancer Calculator + Store Listing De-Serbianisation | Large standing instruction | Parts 1–4 complete, own STOP condition reached — awaiting approval | Extends PROMPT-003 Stage A trust surface: fix Serbia-only store listing bullet in all 9 locales, sweep for similar leaks, then build a remote-updatable (bundled-fallback) tax_rules.json data layer and a real per-country freelancer self-assessment calculator covering all 9 countries (BiH split FBiH/RS) |
| PROMPT-005 | Version Control, Bulgaria Euro Migration, Serbia Tool Consolidation | Large standing instruction | Parts 0–5 complete, own STOP condition reached — awaiting approval | Closes the three gaps PROMPT-004 disclosed (git repo missing, Bulgaria still BGN, two overlapping Serbia freelancer tools) plus verifies two PROMPT-004 claims (cliff test coverage, all 10 regimes actually wired in) before building on them |

## Active Prompts

### PROMPT-002: 12-Phase Offline Completion Plan

Status: Active — currently executing Phase 10.

Purpose: Narrow PROMPT-001's scope to "finish the offline product
completely, then produce an online-readiness report and stop" rather than
building online/backend features immediately.

When to use: Governs all work on this app until Phase 12's report is
delivered and the user explicitly approves moving to online features.

Full prompt (as supplied, condensed to its structure — see this session's
own conversation for the verbatim text if ever needed):

> Priority: (1) finish the offline app completely, (2) make the offline
> experience polished/reliable/commercially presentable, (3) add useful
> offline-first features in a logical order, (4) test and stabilize the
> whole app, (5) only after the offline version is genuinely complete,
> begin *planning* online functionality, (6) do not start online
> integrations prematurely.
>
> Definition of "finished" (offline): a user can install, open, use every
> main feature without internet, close and reopen it, and trust their
> data remains accurate and understandable — covering functionality,
> persistence, validation, navigation, empty/loading/error states, undo/
> recovery, edit/delete flows, search/filtering, accessibility,
> responsive layout, visual consistency, tests, documentation, and a
> production build.
>
> Phases: 1 Audit current tracker → 2 Complete the transaction system → 3
> Offline dashboard → 4 Budgeting and goals → 5 Insights and reports → 6
> Search/filters/usability → 7 Settings and personalization → 8 Balkan
> readiness without online dependencies → 9 Business mode, still offline →
> 10 Quality and reliability pass → 11 Final product polish → 12 Online
> functionality comes last: **stop and produce an online-readiness report
> covering data-model sync-readiness, stable IDs, source of truth,
> conflict resolution, offline queue, auth, workspace/permission model,
> privacy/security risks, DB/API requirements, migration strategy, backup/
> restore strategy, cost/complexity per feature — then wait for approval.**
>
> Working rules: work step by step, complete one phase before the next
> unless a dependency requires otherwise, don't skip testing, don't fake
> integrations, don't claim completion without verification, don't
> replace working code unnecessarily, don't add features only because
> they look impressive, report at the end of each phase (inspected /
> implemented / tested / remains / phase complete? / next phase).

Key requirements: real tests for every phase; honest phase-end reports;
never claim completion without verification; Phase 12 is a stop-and-report
gate, not a green light to start online work.

Known limitations: this is a condensed structural summary, not necessarily
the user's exact original wording — treat the user's own message in this
session's history as authoritative if a discrepancy ever matters.

### PROMPT-003: Market-Ready Commercial Excellence Addition

Status: Active — applies after Phase 11/PROMPT-002, alongside/after the
Phase 12 report. Does NOT override PROMPT-002's offline-first gate: it
extends it with a commercial layer. Where the two conflict, PROMPT-002
wins until the user explicitly approves online features. Supplied as a
file: `C:\Users\Administrator\Downloads\PROMPT-003_Market_Domination_Addition.md`
(full verbatim text preserved there; condensed structure below).

Purpose: take the app from "complete offline product" to a best-in-class,
commercially credible Balkan finance app — trust/first-impression polish,
retention mechanics, Balkan-specific differentiators no competitor
combines, and an honest three-tier monetization model.

Structure — five staged sections, in priority order:

- **Stage A (highest priority) — Commercial trust & first impression:**
  (1) onboarding, max 3 screens, skippable, locale-detected country/
  language with override, privacy-promise screen, primary-goal picker
  that sets the default home tab; (2) a "Why trust this app?" Settings
  section (formula sources, effective dates, last-updated, offline/
  privacy explanation) plus a "rates valid for YYYY" label on every
  calculator result; (3) performance/size budget — `--split-per-abi`,
  R8/resource shrinking, <2s cold start on a low-end profile, virtualized
  lists, actual release APK/AAB size report (target <30MB per-ABI AAB,
  investigate if exceeded — the 158MB *debug* figure from D-006 is not
  release size); (4) Play Store readiness — data-safety-form answers
  derived from actual code behavior, AdMob/UMP consent documented,
  adaptive icon, localized store listing text for all 9 languages saved
  to `/store_listing/`, screenshot shot-list.
- **Stage B — Retention mechanics:** (5) recurring transactions
  (define-once, auto-post, review-before-post option); (6) subscription/
  fixed-cost radar screen; (7) offline local notifications (expense-log
  nudge, budget-threshold 80/100%, invoice due/overdue, Serbian paušal
  15th-of-month reminder — all off by default); (8) Android home-screen
  widgets (spend-vs-budget, pinned currency pair, WorkManager refresh, no
  polling); (9) "financial mirror" plain-language insights, one at a time,
  always tappable to show the calculation (existing rule).
- **Stage C — Balkan differentiators:** (10) fiscal receipt QR import
  (Serbia `suf.purs.gov.rs`, Croatia/Montenegro analogues) — per-country
  adapter architecture; network fetch part is DESIGN+UI+queued-offline
  only until Phase 12 approval, but scan-and-store-raw ships offline day
  one; (11) paušal & freelancer compliance pack — Serbia first (turnover
  vs 6M/8M RSD limits with 70/85/95% warnings, monthly 15th reminder,
  Model A vs B comparison, same sourced-formula standard as
  Samooporezivanje, unsourceable → exclude and document); (12) invoice PDF
  generation + NBS IPS QR embed for RSD invoices (fully offline, local
  encoding only); (13) cross-border pack — net-salary comparison across
  all 9 countries, employer cost-of-employment view, per-diem/mileage
  official rates where sourceable.
- **Stage D — Monetization:** (14) three tiers — FREE (calculators, basic
  tracking, non-interstitial ads, converter), PRO subscription (removes
  ads, unlocks recurring/widgets/receipt-QR/invoice-PDF/paušal-pack/
  unlimited budgets/all exports), LIFETIME one-time at ~3–4x annual;
  (15) paywall gated on value moments not timers, one honest screen, no
  fake urgency/testimonials, free tier stays genuinely useful forever;
  (16) `in_app_purchase` + local entitlement cache + single
  `EntitlementService`, test fake-store flows, AdMob real IDs stay a
  user-supplied swap.
- **Stage E — Delight beyond Phase 11:** (17) Material You dynamic color
  with existing theme as fallback, full dark-mode audit, large-font/
  TalkBack pass on money-entry flows; (18) purposeful micro-animations
  only (count-ups, budget-bar fills) — nothing that costs jank;
  (19) local encrypted backup/restore to a user-chosen file (Storage
  Access Framework) with a monthly reminder — doubles as the future sync
  migration path.

### PROMPT-003 Stage B: Retention Mechanics — Started

Status: **Done, 2026-08-08** — user gave explicit go-ahead ("start
PROMPT-003 Stage B"), satisfying PROMPT-003A's stop condition. Worked
through items 5–9 in order, one increment at a time, audit-first per
item, same discipline as Stage A. See `DECISIONS.md` D-024–D-028 for
per-item records. Stage C (items 10–13) has not been started — no user
go-ahead yet, same stop-condition discipline as before Stage B started.

### PROMPT-003A: Stage A Closure — Consent Flow + App Icon

Status: Done, per this prompt's own explicit stop condition ("report per
the standard format, then STOP... do not start Stage B until I say so").
Both items implemented 2026-08-07 — see `DECISIONS.md` D-014 (consent)
and D-015 (icon). On-device verification of both remains genuinely open
(no Android device/emulator was available in this environment) — this is
disclosed, not glossed over, in both decision records. Supplied as
`_userprompts/PROMPT-003A_StageA_Closure.md` (full verbatim text
preserved there — this repo's convention going forward for the user's
longer prompts, per this session's instruction). Closes the two items
the prior session (D-013) deliberately left undone pending explicit user
approval/input: AdMob/UMP GDPR consent, and a real app icon.

- **Item 1 — UMP consent, explicitly approved, implement fully:** use
  `google_mobile_ads`' bundled `ConsentInformation`/`ConsentForm` APIs
  (no third-party consent library). Request consent info on app start;
  show the form only when required (EEA/UK); gate `MobileAds` init and
  all ad loads behind the consent result; non-EEA users see no popup and
  no added delay. Respect the result (personalized vs non-personalized
  vs no ads — never nag, never block features). Add a "Privacy & ad
  preferences" Settings entry to reopen the form later (required by
  Google policy). Must degrade gracefully offline (skip silently, retry
  next launch, never block startup). Keep test ad-unit IDs. Document the
  architecture in `DECISIONS.md`; update `store_listing/`'s data-safety
  notes to reflect the real implementation.
- **Item 2 — real app icon, explicit design spec:** original SVG vector
  artwork committed to `/branding/`, exported via `flutter_launcher_icons`
  to all densities + a proper Android adaptive icon (separate foreground/
  background layers) + Android 13+ monochrome themed-icon layer. Concept:
  one glyph, no text/letters/gradients-with->2-stops/clipart/dollar
  signs — two smooth semicircular exchange arrows forming a broken
  circle, upper arrow's head rising slightly above the circle (reads as
  both "currency exchange" and "growth"). Deep navy background
  (~#0F2A43) with warm metallic gold glyph (~#E8B54D range). Glyph
  confined to the adaptive-icon safe circle (66% of canvas). Also a
  512×512 Play Store PNG, and a flat-white-silhouette notification icon
  if one exists.
- **Verification required:** `flutter analyze` clean, all tests passing,
  l10n lockstep preserved; a real release build succeeds with the new
  icon rendering correctly (regular/round/themed variants); consent flow
  verified with UMP debug/test EEA geography settings, documented
  honestly (no claiming untested behavior works).
- **Explicit stop condition:** report per the standard format, then
  STOP — Stage A is complete once this closes; do not start Stage B
  until the user says so.

Working rules (same discipline as PROMPT-002, restated with additions):
one increment at a time, report implemented/tested/l10n-count/analyze-
status/next after each; audit before building — never rebuild something
that already exists, close only the actual gap; any network call beyond
currency rates gets built as an offline shell with the fetch point marked
and STOPS for approval (listed in the Phase 12 report, not implemented);
new feature work must never degrade the Stage-A performance/size budget;
every new tax/compliance number needs the same sourcing standard as
existing engines or gets excluded and logged in `OPEN_QUESTIONS.md`.

### PROMPT-004: Per-Country Freelancer Calculator + Store Listing De-Serbianisation

Status: Parts 1–4 all implemented and verified 2026-08-08 — see
`DECISIONS.md` D-017 (Part 2 data layer), D-018 (Part 1 store listing),
D-019 (Parts 3–4 calculators/tests/l10n). Per this prompt's own Part 4
item 6 ("Then STOP and await approval"), work stopped here — do not
start any further scope (e.g. `OPEN_QUESTIONS.md` QUESTION-006/007,
or setting up the real remote rules URL per QUESTION-005) without
explicit instruction. Extends PROMPT-003 (Stage A trust surface); does
NOT override PROMPT-002's offline-first gate — the design is
offline-first by construction. Supplied as
`_userprompts/PROMPT-004_Per_Country_Freelance_Calculator.md` (full
verbatim text preserved there, including all sourced 2026 seed tax data
per country).

Purpose: two related fixes found via the same defect. Every localized
store listing translates (but doesn't localize) a bullet naming Serbia's
PP OPO-K form — noise-to-hostile copy for the other 8 countries in a
listing whose pitch is "9 countries, your language." It also reflects a
real product gap: the app ships one Serbia-only freelancer self-assessment
calculator while claiming nine-country coverage.

Work the parts in order; do not start Part 3 until Part 2 is green:

- **Part 1 — store listing fix (all 9 locales):** replace the offending
  bullet with the supplied country-neutral, already-translated text
  (verbatim, no re-translation); then sweep all of `store_listing/` for
  the same class of leak (other single-country references, form names,
  currencies, institutions in the wrong locale's file) and report/fix
  every instance found, even ones judged harmless.
- **Part 2 — remote-first, free, offline-safe rules data layer:** a single
  `tax_rules.json` source of truth (`schema_version`, `rules_version`
  ISO date, one entry per country, every numeric value carrying
  `effective_from` + `source`) — no tax constant may live in Dart code.
  Bundled copy ships in `assets/`. Remote copy hosted on free static
  hosting only (GitHub Pages / raw.githubusercontent.com — explicitly no
  paid API, no backend, no Firebase). Fetch at most once per 24h, ≤5s
  timeout, never blocks startup, any failure (offline/404/malformed/
  schema-mismatch) is silently ignored and the previous good copy stays
  in use. Precedence: downloaded → bundled, never reversed, never
  partial-merged. Surfaced in the existing "Why trust this app?" section
  (`rules_version`, bundle-vs-updated, per-country `effective_from` +
  source link) — drives the existing per-calculator "rates valid for
  YYYY" label. Applies to tax rules only; the currency-rate live-fetch
  path is untouched.
- **Part 3 — per-country freelancer calculator:** one country-switched
  screen, 9 countries with Bosnia and Herzegovina split into FBiH and
  Republika Srpska as separate regimes (10 regimes total). Each regime is
  its own strategy class behind a common interface — the prompt is
  explicit that the order of operations genuinely differs by country
  (e.g. Bulgaria deducts the 25% allowance before computing contributions
  then deducts those too; Serbia's contributions are not deductible and
  two competing models must both be computed and compared; Romania's
  contributions are computed on statutory ceilings, not actual income,
  and ARE deductible; several regimes use a fixed statutory base that
  doesn't scale with income at all). Cliff warnings (regime-changing
  thresholds: Albania's all-or-nothing ALL 14M turnover cliff, Slovenia's
  80%-expense EUR 60,000 cutoff, Serbia/Montenegro/Romania paušal
  ceilings, VAT thresholds) must warn before and after, not silently
  compute past them.
- **Part 4 — tests, l10n, reporting:** table-driven unit tests per regime
  (floor/mid/pre-cliff/post-cliff/above-ceiling, full breakdown asserted
  — not just net), a schema-validation test on the bundled JSON, a mocked
  fetch test (newer applied / older ignored / malformed ignored / timeout
  ignored / offline ignored, previous good rules retained in every
  failure case), l10n lockstep across all 9 ARBs in the same commit
  (regime/form proper nouns stay untranslated), the existing
  estimates-only disclaimer on the new screen, then a standard-format
  report and an explicit STOP for approval.

Seed data: the prompt embeds sourced, dated 2026 tax figures for all 9
countries (10 regimes) with explicit `n.a.` gaps that must render as
"not available," never as zero or an invented value — see the full text
in `_userprompts/` for the complete per-country figures and source URLs.
A maintenance note for values with known future change dates (North
Macedonia's July–Dec 2026 rates, Slovenia's 1 April 2026 change, Serbia's
1 February 2026 change, Romania's 2026 CASS cap) belongs in
`DECISIONS.md` once implemented.

Hard constraints: no paid service/backend/API keys/Firebase, free static
hosting only; no tax constant anywhere in Dart code; app fully functional
with network permanently off; do not touch the currency-rate path; never
claim a formula was verified against a live tax calculator unless one was
actually run and can be named.

### PROMPT-005: Version Control, Bulgaria Euro Migration, Serbia Tool Consolidation

Status: Parts 0–5 all implemented and verified 2026-08-08 — see
`DECISIONS.md` D-021 (Parts 1–2: git + rules-publish tooling), D-020
(Part 3: Bulgaria BGN→EUR, closes QUESTION-007), D-022 (Part 4: Serbia
tool consolidation, closes QUESTION-006). Per this prompt's own Part 5
instruction ("Then STOP and await approval"), work stopped here — do
not start QUESTION-005 (still open: real remote-rules URL) or PROMPT-003
Stage B without explicit instruction. Supplied as
`_userprompts/PROMPT-005_Git_Bulgaria_Euro_Serbia_Consolidation.md` (full
verbatim text preserved there). Closes the three items PROMPT-004
disclosed at session end (D-019's remote-URL gap, `OPEN_QUESTIONS.md`
QUESTION-006 and QUESTION-007) and requires verifying two of PROMPT-004's
own claims (cliff test coverage at all five listed boundaries plus VAT
thresholds; that all 10 regime strategy classes actually exist and are
wired into the screen's picker, not just present as files) before
building further on them. Work strictly in order — Part 1 (git) must be
committed before Part 2 starts.

- **Part 0 — verify two PROMPT-004 claims, report only, fix gaps found:**
  cliff test coverage at Albania/Slovenia/Serbia/Montenegro/Romania plus
  every VAT threshold; confirm all 10 strategy classes exist and are
  reachable from the screen's country selector.
- **Part 1 — put the project under version control:** `git init`, a real
  Flutter `.gitignore` before the first `git add`, explicit secret
  exclusion (keystores, `key.properties`, `google-services.json`, `.env`)
  verified absent from the index, logical multi-commit history (not one
  giant commit), verified via `git status`/`git log`, then report the
  exact commands to push to a new private GitHub repo — do not create a
  remote or push.
- **Part 2 — host the tax rules, close the remote-URL gap:** recommend a
  separate small PUBLIC repo (distinct from the private app repo) for
  `tax_rules.json`; add a publishable copy + a five-minute runbook +
  a schema validation script + a schema-parity test (bundled vs.
  publishable must be byte-identical); leave the remote-URL constant a
  placeholder but make repointing it a one-line change, name the exact
  file/line.
- **Part 3 — Bulgaria BGN→EUR (QUESTION-007 reclassified as a bug):**
  audit every BGN reference across the app first and report the full
  blast radius before editing; move any Bulgaria tax constant still in
  Dart into `tax_rules.json` (EUR, sourced); migrate any already-saved
  Bulgarian user data using the fixed 1.95583 rate (never live FX),
  exactly once, via an idempotent versioned migration flag with a test
  that runs it twice and asserts the second run is a no-op; decide
  BGN's fate in the currency converter (pegged legacy entry, not live);
  check whether Bulgaria's mandatory dual-pricing changeover period is
  still in force as of August 2026 and implement accordingly; verify
  Bulgarian and all other locales' formatting.
- **Part 4 — Serbia: one calculator, not two (QUESTION-006):** honestly
  compare the old Serbia-only tool against the new engine's Serbia
  regime, port any genuine gap into the new engine, then remove the old
  tool (git now makes this safely reversible) and migrate any of its
  saved data into the new engine's storage — or, if there's a real reason
  to keep both, stop and make that argument instead of removing anything.
- **Part 5 — verification and report:** analyze/test/l10n-lockstep clean,
  one real release build with sizes reported against the 30MB target,
  the Bulgaria path manually exercised end to end (build-verified vs.
  device-verified stated honestly either way), then the standard report
  — BGN audit list, Serbia delta and decision, commit count, exact
  rules-URL file/line, anything left open — and STOP.

Hard constraints: no paid service/backend/API keys/Firebase; no tax
constant in Dart code; fully functional with network off; never commit a
keystore/signing config/secret; BGN→EUR uses the fixed 1.95583 rate,
never live FX, exactly once.

## Reference Prompts

### PROMPT-001: Autonomous Product Development Prompt

Status: Reference / narrowed — the personal-finance and offline-business
portions were absorbed into PROMPT-002's phase plan (Phases 3–4, 9); the
online/backend/SaaS portions (team workspaces, invoice sync, accountant
portals, commercial landing page, pricing page, bank integrations) are
explicitly deferred, not rejected — see `IDEAS.md` and
`OPEN_QUESTIONS.md`.

Purpose (as originally supplied): transform the app into "Version 1.0 of a
serious Balkan fintech startup" — full personal + business finance
platform, invoicing, team roles, accountant reports, market/economic
research module, commercial SaaS polish (landing page, pricing,
onboarding, trust messaging), Balkan localization, security/reliability
pass, then (last) plan online functionality.

Structure: 18 numbered sections — product vision; autonomous decision-
making rules; short focused audit-then-implement discipline; research
discipline (don't over-research); execution/scope discipline (finish one
thing end-to-end); protect-and-evolve-architecture rules; product-judgment
rules (fewer excellent workflows over many unfinished features); UI/visual
direction; personal finance feature list; business/freelancer feature
list; research/trends feature list; Balkan localization requirements;
commercial SaaS quality bar; security/privacy/reliability checklist;
validation/evidence discipline; prioritization order; a "final quality
review" from 8 different user personas; required session-report format.

Key requirements carried forward into PROMPT-002 and this project's
ongoing work: no fabricated data/testimonials/urgency; every insight must
explain how it was calculated; label demo/simulated data explicitly;
prefer fewer excellent workflows over feature-maximizing; real
verification before claiming done.

Known limitations / why narrowed: the original prompt's first line named
`C:\Claude-Global-Toolkit` as the target repository — a copy-paste error
from a template, corrected in this session before any work started (the
actual app is `C:\salary-currency-pro`). Its business-SaaS sections
(multi-tenant workspaces, invoicing sync, accountant portals, live
economic-trend data feeds) require backend infrastructure this app does
not have and the user explicitly declined to start building yet (see
`DECISIONS.md` and the AskUserQuestion exchange choosing "Stay
offline-first for now").
