# Device Test Checklist

Tracks what has actually been verified for Salary & Currency Pro's Stage D
release candidate (PROMPT-003I/003J — see `DECISIONS.md` D-033/D-034) versus
what still needs a real device, Firebase Test Lab, or Google Play Internal
Testing. Kept in three honest sections rather than one pass/fail list, per
this project's "never fabricate a completion claim" rule (see
`PROJECT_CONTEXT.md`'s "Known Risks" for the same discipline applied
elsewhere).

**No Android device or emulator exists in the coding environment this
checklist was written in.** Everything in the first section is real —
either a passing automated test or a real `flutter build`/`aapt`
inspection — never a guess dressed up as a result.

**2026-08-11 update:** the UI/UX redesign pass (`DECISIONS.md` D-036)
rebuilt and re-verified the signed production artifact (version bumped to
`1.0.1+2`; AAB + split APKs re-signed with the same real owner
certificate, re-checked via `apksigner`/`jarsigner`; 526/526 tests;
`aapt2 dump badging` re-confirmed package ID/label/permissions unchanged).
That refreshes the "Build/version evidence" entry below but does not
change anything in either "Pending" section — still nothing here has
touched real hardware, Firebase Test Lab, or Play Internal Testing.

## Verified here (tests, real builds, or static inspection)

### Free/Pro gate rules (source-audited against every gate + covered by a
real widget test — see `test/` for the exact file per rule)
- Salary Calculator: live calculation is free; a Free user's country
  picker locks every country except their current one, with a lock icon
  per locked row; tapping a locked one opens the upgrade prompt instead of
  switching. `test/salary_calculator_screen_test.dart`.
- Cross-Border: running a live comparison, including the employer-cost
  column, is unrestricted for everyone. Saving is capped — Free keeps one
  saved comparison at a time (a second save opens the upgrade prompt), Pro
  is unlimited. `test/cross_border_screen_test.dart`.
- Invoice PDF + NBS IPS QR: gated behind Pro at the single generation
  trigger; a Free tap shows the upgrade prompt, the invoice itself is
  untouched. `test/invoice_detail_screen_test.dart`.
- Paušal/VAT compliance pack: gated entirely at the Tools-hub entry point,
  with a visible gold "PRO" badge on the tile before tapping — not a
  surprise gate. `test/widget_test.dart`.
- Freelance Tax Screen: no entitlement coupling exists anywhere in that
  screen (confirmed by source grep, zero hits for
  `EntitlementService`/`hasFullAccess`/`proOnly`) — every regime stays
  free regardless of tier, matching the explicit product decision that
  this screen is out of scope for Stage D gating.
- QR scanner + manual expense handoff: free, no entitlement coupling.
  Re-confirmed this checkpoint that the hard network boundary still
  holds — a source grep across the whole app for `suf.purs.gov.rs` and
  `WebView`/`webview` finds only the Serbia adapter's local URL-shape
  string match and the single documented, unimplemented
  `FiscalReceiptFetchService` TODO; nothing else references either.

### Production-leakage static audit (checkpoint 3, item 3)
- `EntitlementPreviewSection` has exactly one call site
  (`settings_screen.dart`), gated by `if (AppConfig.isDev)` — never
  constructed at all when `AppConfig.flavor == AppFlavor.prod`, not merely
  hidden.
- `EntitlementService.setDevSimulatedStatus` is a no-op whenever
  `devSimulationEnabled` is false (defense in depth beyond the UI gate).
- `devSimulationEnabled` is set to `true` only by `AppConfig.isDev` in
  `app.dart`, which is itself only ever `true` when `main_dev.dart` (the
  `dev` flavor's entrypoint) called `AppConfig.initialize(AppFlavor.dev)`.
  `main.dart` (the bare/default entrypoint) and `main_prod.dart` both
  explicitly initialize `AppFlavor.prod`.
- No Firebase package appears anywhere in `pubspec.yaml` or
  `android/app/build.gradle.kts` (grep confirmed zero matches) — none was
  added this stage, matching the "no new Firebase runtime SDKs" rule.
- No debug logging (`print`/`debugPrint`) of personal or billing data
  exists in `entitlement_service.dart` or `paywall_screen.dart` (grep
  confirmed zero matches).
- The `.dev` application-ID suffix and DEV app label/icon are entirely
  Gradle/Android-resource-level (`build.gradle.kts` `productFlavors`,
  `android/app/src/dev/res/`) — no Dart string anywhere references the
  literal `.dev` suffix, so there's no way for it to leak into
  user-facing text.
- No hidden route, gesture, query parameter, or mutable
  `SharedPreferences`-backed toggle exists anywhere in the app that
  changes entitlement outside of `EntitlementService` itself — the whole
  gate surface was grepped (`hasFullAccess`, `devSimulationEnabled`,
  `AppConfig.isDev`) and every hit is accounted for above.
- Product IDs (`pro_monthly`, `pro_annual`, `pro_lifetime`,
  `support_developer`) are declared once in `lib/config/monetization_config.dart`,
  each still marked with an explicit `// TODO: create ... in Play Console`
  comment — none is treated as a live/created product anywhere in the
  code, and no code path grants entitlement just because one of these
  strings is present without a real `PurchaseStatus.purchased`/`restored`
  event from the store.

### Build/version evidence
- `devDebug` and `prodDebug` both built successfully via
  `flutter build apk --debug --flavor <dev|prod>` this stage;
  `aapt dump badging` confirmed distinct application IDs
  (`rs.salarycurrencypro.salary_currency_pro.dev` vs the unsuffixed prod
  ID), distinct labels ("Salary & Currency Pro (DEV)" vs "Salary &
  Currency Pro"), and distinct version names (`1.0.0-dev` vs `1.0.0`).
- Full test suite and `flutter analyze` status: see `DECISIONS.md`
  D-034's checkpoint 4 entry for the exact counts as of that commit
  (kept there rather than duplicated here, since this file's job is the
  three-way verified/pending split, not a running test tally).

## Pending owner phone or Firebase Test Lab

None of the following has been exercised on real hardware or in Firebase
Test Lab. All of it is either build-verified only or covered solely by a
platform-double-based widget test (no real OS/hardware involved):

- Onboarding's actual touch flow (tap targets, scroll, keyboard
  interaction) on a real screen size/density.
- Camera permission states for the fiscal-receipt QR scanner — granted,
  denied, and permanently-denied — and an actual QR code scan against a
  real printed/displayed Serbian fiscal receipt.
- Local notification permission prompt and the four reminder types
  actually firing and displaying correctly.
- Both home-screen widgets (spend-vs-budget, pinned currency pair)
  actually rendering, refreshing on data change, and surviving the
  hourly WorkManager backstop.
- Visual layout across real screen sizes/densities, light/dark theme
  switching, large-font/TalkBack accessibility passes.
- Keyboard/input behavior (numeric keyboards, IME behavior per locale)
  on a real device.
- Cold-start and general performance/jank — no device/profiling tooling
  available in this environment (this specific gap has been open since
  D-012/Stage A and remains open here, not new to this checkpoint).
- The dev build's default-Pro simulation and Free-simulation switch,
  confirmed only via widget test against a fake platform double — not
  yet confirmed to look/feel right in Settings on an actual phone.

## Pending Google Play Internal Testing

None of Play Billing has been exercised against a real product catalog —
none of the four products exist in Play Console yet:

- Real product catalog load (all four product cards showing real,
  regionally-priced `ProductDetails` instead of the reference-price
  fallback).
- Annual plan's real 7-day free trial behavior.
- A real monthly/annual subscription purchase and its lifecycle.
- A real lifetime one-time purchase.
- A real support-the-developer purchase (confirming it never grants
  entitlement, only as observed against the real store, not just in
  code).
- Cancellation and natural expiry, and `EntitlementService.verify()`'s
  expiry-detection path against a real store response (only tested here
  against a fake platform double that simulates "nothing to restore").
- Restore Purchases against a real prior purchase.
- A failed or pending purchase's real UI/error behavior.
- Cached-entitlement offline behavior with a real device actually taken
  offline mid-session (only tested here via a fake platform's
  `isAvailable`/`restorePurchases` throwing, not real connectivity loss).

---

*Last updated: 2026-08-09, PROMPT-003J checkpoint 3 (see
`_userprompts/PROMPT-003G_Release_Readiness_Developer_Builds_v2.md`,
recorded as PROMPT-003J, and
`_userprompts/NEXT_PROMPT_Finish_App_and_Play_Console_Readiness.md`).*
