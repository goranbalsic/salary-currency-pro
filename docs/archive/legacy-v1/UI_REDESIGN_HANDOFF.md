# UI/UX Redesign Handoff

Written at the close of the pre-redesign closeout pass
(`_userprompts/NEXT_PROMPT_Pre_Redesign_Closeout_and_Safe_Workspace_Cleanup.md`),
2026-08-09. This is the single document a later, separate UI/UX redesign
prompt should read first. It does not replace `PROJECT_CONTEXT.md`,
`DECISIONS.md`, `DEVICE_TEST_CHECKLIST.md`, or `PLAY_CONSOLE_CHECKLIST.md`
— it is a compact pointer into them for redesign purposes only.

**Status: redesign complete as of 2026-08-11** — see `DECISIONS.md` D-036
for the full per-checkpoint record and `_redesign_evidence/` for before/
after screenshots and build/signing evidence. Every boundary this
document set (below) was honored: no tax formula, data model, storage
schema, entitlement rule, or pricing changed; offline-first, no-ads,
no-WebView held throughout; 9-language l10n stayed in lockstep (584
keys × 9 locales, unchanged — no strings were touched by this pass).
This document's own content below is left intact as the historical
record of what the redesign was scoped against, not rewritten after
the fact.

## What is functionally complete and must be preserved

- **9-country payroll engine**: Salary Calculator (`SalaryCalculator` +
  `CountryTaxConfig`), 9 countries, monthly-native (annual = monthly × 12,
  no separate annual-bracket logic exists).
- **9-country freelancer self-assessment calculators**
  (`lib/logic/freelance/*_strategy.dart`) behind `FreelanceTaxStrategy`.
- **Currency conversion + Cross-Border Pack** (live convert, cached-rate
  cross-border comparison across all 9 countries from one EUR figure,
  employer-cost column).
- **Expense/income tracker, category budgets, savings goals, recurring
  transactions, Fixed-Cost Radar, local notifications, two Android
  home-screen widgets, financial-mirror insights.**
- **Serbia paušal/freelancer compliance pack** (turnover tracker, monthly
  reminder, Model A/B comparator).
- **Invoice PDF + NBS IPS QR** (Serbia RSD invoices).
- **Offline fiscal-receipt QR scanner** — scan → classify → queue →
  manual expense handoff. Local-only, no receipt-content network fetch.
- **Onboarding** (country/language → privacy promise → primary-goal
  picker), Settings trust surface, data export/delete.
- **Monetization**: `EntitlementService`, `PaywallScreen`, DEV/PROD Gradle
  flavors, DEV-only Entitlement Preview simulator (compile-time absent
  from prod).
- 9-language l10n in exact key-count lockstep (verify with
  `grep -cE '^\s*"[a-zA-Z]' lib/l10n/app_*.arb` after any change).
- All of the above is source-audited, unit/widget-tested, and reflected in
  `PROJECT_CONTEXT.md`'s "Current State" / "Last Updated" log and
  `DECISIONS.md` D-001 through D-035. Redesign should restyle these
  screens, not reimplement their logic.

## Final Free/Pro boundaries (do not change without a separate product decision)

- **Salary Calculator**: live calculation free; Free locks every country
  picker row except the user's current country (lock icon, tap opens
  upgrade prompt).
- **Cross-Border**: running a live comparison (incl. employer cost) is
  unrestricted for everyone; saving is capped — Free keeps one saved
  comparison, Pro unlimited.
- **Invoice PDF + NBS IPS QR**: Pro-gated at the generation trigger.
- **Paušal/VAT compliance pack**: Pro-gated at the Tools-hub entry point
  (visible gold "PRO" badge before tapping).
- **Freelance Tax Screen**: free for every regime, no entitlement coupling
  anywhere — explicit product decision, out of Stage D gating scope.
- **QR scanner + manual expense handoff**: free, no entitlement coupling.
- No ads at launch (Google Mobile Ads/UMP SDK removed completely, D-035
  — do not reintroduce it or any WebView dependency).

## Non-negotiable offline/privacy/network boundaries

- App is offline-first by design: no backend, no accounts, no server.
- The **only** network calls in the entire app: two public no-auth
  currency-rate APIs (`ExchangeRateService`), the freelance tax-rules
  remote-update endpoint (`TaxRulesService`, points at the project's own
  public `salary-currency-pro-rules` repo), and Google Play Billing
  (`in_app_purchase`) once wired to real products. Everything else stays
  local (`SharedPreferences`).
- **Fiscal-receipt QR scanner stays offline-only**: no receipt-content
  network fetch, no WebView, no claim of fiscal verification. The one
  future-fetch interface (`FiscalReceiptFetchService`) stays unimplemented
  behind its documented Phase-12-approval TODO — do not implement it as
  part of a visual redesign.
- Camera is requested only when the user opens the scanner and taps to
  scan; no frame or image is ever stored or transmitted.
- A redesign must not add any new network call, analytics SDK, ad SDK, or
  WebView dependency as a side effect of restyling.

## Screens/features expected to be visually redesigned later

Everything user-facing is in scope for visual/UX restyling, in particular
the areas Phase 11 (visual polish) never finished: typography, spacing,
button hierarchy, animations, onboarding polish, trust messaging, and
first-use experience (see `PROJECT_CONTEXT.md` "Current Focus"). No screen
is excluded by default; the redesign prompt should state its own scope
explicitly.

## Deliberately deferred until *after* the redesign is complete

- Real phone QA (see `DEVICE_TEST_CHECKLIST.md`'s "Pending owner phone or
  Firebase Test Lab" section — nothing in it has touched real hardware).
- Firebase Test Lab.
- Google Play Internal Testing upload and real Billing verification (see
  `PLAY_CONSOLE_CHECKLIST.md`) — the signed production AAB/APKs already
  built and verified this closeout remain valid evidence; they are not
  invalidated by waiting, but do not upload them to Play before the
  redesign ships (uploading now would ship the pre-redesign UI).
- Recruiting closed testers / the Personal-account 12-tester/14-day
  requirement, if applicable (`PLAY_CONSOLE_CHECKLIST.md` section A).
- Creating Play Console Billing products.

## Required redesign verification, per checkpoint

At every redesign checkpoint (not just the end):

- `flutter test -j 1` full pass (this project's known test-runner
  concurrency bug means the default concurrency silently drops files —
  never trust a bare `flutter test` run).
- `flutter analyze` clean (same 3 pre-existing cosmetic
  `unintended_html_in_doc_comment` notices are expected and unrelated).
- 9-locale l10n parity check (exact key count per `.arb` file).
- Browser screenshots (`claude-in-chrome`, when available this session) or
  another real visual check per changed screen — not just widget-test
  pixel assertions.

**Do not rerun full signed-release builds, `apksigner`/`jarsigner`
verification, real-device work, or Firebase Test Lab checks at every
checkpoint.** That evidence only needs to be regenerated once, at the very
end of the redesign, immediately before the app moves to real phone QA /
Play Internal Testing.

## Scope statement

This is a presentation/usability redesign, not a mandate to change tax
formulas, data models, storage, entitlement rules, product pricing, or
approved feature scope.
