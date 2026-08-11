# Megaprompt: Full Redesign → Full Interaction Test → Full Code Review → Play-Ready

## Read this whole prompt before doing anything

This is one long-running, mostly autonomous pass. Work through the
checkpoints below **in order**, without waiting for the owner between
checkpoints, except where a checkpoint explicitly says to stop. Report
after every checkpoint in the standard format at the end of this prompt,
then continue automatically to the next checkpoint unless a stop
condition or an unresolved product-policy conflict applies.

Read first, in this order: session-start files per existing project
rules, `UI_REDESIGN_HANDOFF.md`, `PROJECT_CONTEXT.md`, `DECISIONS.md`,
`DEVICE_TEST_CHECKLIST.md`, `PLAY_CONSOLE_CHECKLIST.md`, and the latest
session log. Reconcile against actual Git state; the repository is the
source of truth over any stale prose.

### Non-negotiable boundaries (from this project's full history)

- This is a **presentation/usability redesign**, not a license to change
  tax formulas, sourced figures, data models, storage schemas,
  entitlement rules, product pricing, or approved feature scope.
- Preserve: offline-first behavior, no ads (Google Mobile Ads/UMP stay
  removed), no WebView, no fiscal-receipt network fetch, the single
  documented TODO fetch boundary in the QR scanner, and all existing
  Free/Pro gates (Salary Calculator home-country lock, Cross-Border
  1-free/unlimited-Pro saves with free live comparisons, Invoice PDF Pro,
  paušal/VAT pack Pro, Freelancer Tax fully free, QR scanner shell free).
- Never touch, read, print, or commit `android/key.properties`, any
  `*.jks`/`*.keystore`, or passwords.
- Never stage, alter, or commit the pre-existing, unrelated CTK
  toolkit-sync files unless explicitly asked.
- 9-language l10n lockstep stays mandatory for every new/changed string.
- Real tests only (`flutter test -j 1`), `flutter analyze` clean, no
  fabricated pass claims for anything not actually run.
- If any redesign decision would require changing logic, pricing,
  entitlement behavior, or sourced data — stop, document the conflict in
  `OPEN_QUESTIONS.md`, and do not decide it unilaterally. Everything else
  in this prompt is pre-approved to proceed without further check-ins.

### What this pass can and cannot finish

This pass can take the app from "functionally complete, basic UI" to
"redesigned, internally tested, code-reviewed, and release-artifact
ready." It **cannot** complete real Android-device testing, Firebase
Test Lab, Google Play upload, Billing purchases, or closed-test
recruitment — those require the owner's phone, Firebase console, and
Play Console access, none of which exist in this environment. Checkpoint
7 defines the honest stop point and exact owner handoff for those.

---

## Checkpoint 1 — Baseline capture (Chrome, before any redesign)

1. Run the app in Chrome using the browser extension.
2. Systematically capture screenshots of every major screen and
   reachable state: onboarding steps, dashboard/home, Salary Calculator
   input and result (home country and a locked country), Expenses/Budget,
   Recurring transactions, Invoice tracker and PDF preview, Cross-Border
   comparison (free 1-save and Pro unlimited states via the dev
   Entitlement Preview), Freelancer Tax (at least 3 regimes), Paušal/VAT
   Tools-hub entry and detail, QR scanner shell (camera-unavailable/
   manual-entry path, since Chrome has no real camera), queue screen,
   manual expense handoff, Paywall (all four products), Settings
   (including Entitlement Preview), and light/dark theme for at least the
   5 highest-traffic screens.
3. Save these as the "before" baseline set with clear filenames per
   screen/state. This is for your own before/after comparison in later
   reports — do not ask the owner to review it mid-pass.
4. Do not change any code in this checkpoint.

---

## Checkpoint 2 — Design system

1. From the baseline screenshots, write a short internal audit: what
   looks basic, inconsistent, crowded, low-contrast, or dated, screen by
   screen, ranked by visibility/frequency of use.
2. Define one cohesive design system: light + dark color palettes,
   typography scale, spacing/radius/elevation tokens, button/card/input/
   chip/bottom-sheet/list-row styles, icon style, navigation styling, and
   restrained motion rules (short, purposeful — number count-ups,
   skeleton/loading states, sheet/dialog entrances; no constant/decorative
   motion). Base it on Material 3 as the app already does, refined rather
   than replaced.
3. Implement the design system as shared theme/widgets only — do not
   touch individual screens yet.
4. Run `flutter test -j 1` and `flutter analyze`. Fix regressions from
   theme changes only.
5. Capture Chrome screenshots of 2–3 representative screens under the new
   theme as an early sanity check before rolling it out everywhere.

---

## Checkpoint 3 — Screen-by-screen redesign

Work through this order, committing in small scoped increments, one
group at a time:

1. Onboarding + dashboard/navigation shell.
2. Salary Calculator (input + result + locked-country state).
3. Expenses/Budget/Recurring transactions.
4. Invoice tracker + PDF preview.
5. Cross-Border comparison (both free and Pro save states).
6. Freelancer Tax Screen (all regimes remain visually consistent).
7. Paušal/VAT Tools-hub entry + detail screens.
8. QR scanner shell, queue screen, manual expense handoff.
9. Paywall (all four products, annual still visually favored) and
   Settings (including Entitlement Preview, still dev-only).
10. Splash screen using the existing app icon/branding assets — native
    splash, no heavy animation, fast to skip past.
11. Empty states, error states, and loading states app-wide, since these
    are usually the most neglected and most visible during real use.

For each numbered group: implement, run `flutter test -j 1` and
`flutter analyze`, confirm l10n parity for any changed/new strings across
all 9 locales, capture Chrome "after" screenshots of every state touched,
and commit with a clear scoped message before moving to the next group.

Do not change: calculation logic, tax constants, data models, storage,
entitlement rules, product IDs/prices, or gating behavior. If a screen's
current data/logic seems wrong while redesigning it, do not silently fix
it here — log it for checkpoint 5's full code review instead, unless it
is trivially a copy/label bug.

---

## Checkpoint 4 — Full interactive click-through test (Chrome, dev build)

This is systematic UI testing, not a demo pass.

1. Run the **dev** build in Chrome (or the closest achievable dev-flavor
   equivalent in this environment; state clearly if Chrome cannot exactly
   mirror the dev flavor, and note the limitation).
2. For every single screen, tap/click **every interactive element**:
   every button, tab, chip, list item, menu, icon button, form field,
   dropdown, switch, slider, dialog action, and bottom-sheet control.
   Include back-navigation and system-back-equivalent behavior in the
   browser.
3. Repeat this pass under each Entitlement Preview state (Free, Trialing,
   Pro, Lifetime, Expired) for every screen affected by entitlement,
   since paywall triggers and locked/unlocked states change behavior.
4. Test edge-case inputs on every form: empty submission, zero, negative,
   extremely large numbers, decimal edge cases, non-numeric text where a
   number is expected, and very long text in name/description fields.
5. Test every navigation path between screens, not just the "happy path"
   — dead ends, back-loops, and screens that fail to update after a
   change (stale state) are real bugs.
6. Record every finding precisely: screen, exact action, expected result,
   actual result, and an "after" screenshot if visual. Classify each as:
   confirmed bug, redesign follow-up (cosmetic only), Chrome-only
   limitation (e.g., camera), or expected behavior.
7. Fix every confirmed bug in this checkpoint. Add a regression test
   (widget/unit) for each one so it cannot silently return. Do not defer
   fixes to "later" — this checkpoint's whole purpose is to close them
   now.
8. Rerun the full suite, `flutter analyze`, and l10n parity after fixes.
   Commit fixes in sensible groups with clear messages, not one giant
   commit.

---

## Checkpoint 5 — Full codebase review (logic, not just visuals)

Audit the entire codebase methodically, not spot checks:

1. **Logic correctness:** re-verify every calculator/engine against its
   already-sourced formulas and existing test tables (Salary Calculator,
   Freelancer Tax regimes, Cross-Border comparator, paušal/VAT thresholds,
   invoice/PDF totals and VAT handling). Flag any mismatch against the
   sourced standard — do not "fix" a number without a source; document
   any suspected discrepancy in `OPEN_QUESTIONS.md` instead of guessing.
2. **State management correctness:** look for stale state after
   navigation, values not resetting between sessions when they should,
   race conditions between async loads and user input, and any place a
   loading state could hang indefinitely (the same bug class already
   found once in the paywall's `isAvailable()` call).
3. **Resource/lifecycle correctness:** controllers/streams/listeners
   disposed correctly, no use-after-dispose (the same bug class already
   found once in a save dialog), no leaked subscriptions.
4. **Error handling:** every network-adjacent or platform-channel call
   (currency rates, tax-rules remote fetch, camera/QR, billing adapter,
   notifications) fails gracefully with a clear, localized message —
   never a silent freeze or an uncaught crash.
5. **Entitlement/gating correctness:** re-verify every Free/Pro boundary
   directly against source one more time, now that the UI has changed —
   confirm no redesign accidentally exposed a Pro feature to Free or
   vice versa.
6. **Security/privacy correctness:** confirm no Ads/WebView/Firebase
   dependency has crept back in, no personal or billing data is logged,
   no secret or key material exists in source, and the offline-first
   guarantee holds (app remains fully usable with network permanently
   off, except the already-approved currency-rate and tax-rules fetches
   with fallback).
7. **Dead code and inconsistency:** unused files/widgets/services left
   over from the redesign, duplicated logic that should share one
   implementation, and inconsistent copy/terminology across screens.
8. **Accessibility:** contrast, tap-target sizing, and screen-reader
   labels on the money-entry and result flows, consistent with any
   existing accessibility rules in this project.
9. For every real defect found, fix it and add a regression test. For
   anything ambiguous or requiring a product decision, log it in
   `OPEN_QUESTIONS.md` rather than deciding it silently.
10. Rerun the full suite, `flutter analyze`, and l10n parity again after
    all fixes.

---

## Checkpoint 6 — Final regression and release-candidate rebuild

1. Run the complete test suite (`flutter test -j 1`) and `flutter
   analyze`; record actual counts/results, not estimates.
2. Confirm full 9-locale l10n parity for every string touched across
   checkpoints 2–5.
3. Rebuild `devDebug` and inspect it: confirm DEV label/icon and default
   Pro simulation still work correctly after the redesign.
4. Rebuild the signed `prodRelease` AAB and split-per-ABI APKs using the
   owner's existing local `key.properties` (existence check only, never
   read/printed). Re-verify signature (apksigner/jarsigner) is the
   owner's real certificate, not a debug cert.
5. Re-inspect the production artifact: no DEV branding, no Entitlement
   Preview UI/bypass, no Ads/WebView/Firebase dependency, correct package
   ID/version.
6. Record final per-ABI and AAB sizes honestly against the existing
   disclosure; never describe an over-budget ABI as under budget.
7. Take final Chrome "after" screenshots of the same screens captured in
   checkpoint 1, for a clear before/after record.
8. Update `PROJECT_CONTEXT.md`, `DECISIONS.md`, `UI_REDESIGN_HANDOFF.md`
   (mark redesign complete), `DEVICE_TEST_CHECKLIST.md`, and
   `PLAY_CONSOLE_CHECKLIST.md` with real, current evidence only.
9. Commit and push all remaining scoped changes. Confirm no secret,
   keystore, or unrelated CTK file was staged.

---

## Checkpoint 7 — Honest stop and owner handoff

Do not claim any of the following happened unless the owner supplies
actual evidence: real Android-device testing, Firebase Test Lab results,
Google Play upload, Billing purchase testing, or closed-test progress.

Produce a short, final handoff stating plainly:

1. The redesign, full interaction testing, and full code review are
   complete, with evidence (test/analyze/l10n counts, before/after
   screenshots, defects found and fixed).
2. The exact next owner actions, unchanged in nature from before this
   pass: install the new `devDebug` build on a real phone and use the
   Entitlement Preview to check Free/Pro visually and by touch; run
   Firebase Test Lab against the new production artifact; upload to Play
   Internal Testing; create/verify Billing products; run the required
   12-tester/14-day closed test before applying for production access.
3. Save a CTK checkpoint reflecting this exact stop point.

Then **STOP**. Do not begin device testing, Firebase Test Lab, Play
Console configuration, or closed-test recruitment — those remain owner
actions outside this environment.

---

## Report format (after every checkpoint)

Checkpoint number and name / implemented / Chrome screenshots captured
(before/after, which screens/states) / defects found and fixed with brief
description each / tests (`flutter test -j 1` actual count) / `flutter
analyze` result / l10n parity (key count × 9 locales) / files changed /
commit + pushed SHA / any items logged to `OPEN_QUESTIONS.md` instead of
decided / next checkpoint about to start. Continue automatically to the
next checkpoint after each report unless a boundary above requires
stopping for owner input.
