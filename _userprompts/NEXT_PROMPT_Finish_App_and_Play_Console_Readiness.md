# Next Prompt: Finish the App + Prepare Google Play Console Upload

## Starting point — do not redo completed work

Continue from this verified state:

- Dev/prod Android build flavors are implemented and committed locally at
  `2923fba` (currently ahead of origin).
- Dev uses a distinct application ID, real DEV-ribbon icon, and distinct
  app label; actual builds and `aapt dump badging` verified this. A
  flavor-less broken-label regression was fixed.
- Dev-only Entitlement Preview exists in Settings and simulates Free,
  Trialing, Pro, Lifetime, and Expired through the same
  `EntitlementService` used by all real gates. It is compile-time absent
  from production builds. A widget test proves it drives a real Salary
  Calculator country gate.
- Current evidence: 525/525 tests, 586 production l10n keys plus 2
  dev-only keys, `flutter analyze` clean.
- Open work only: checkpoint 3 (complete all QA verifiable in this
  environment and prepare device QA) and checkpoint 4 (production safety
  + release evidence).

The owner has a **verified Personal Google Play Console account**. The
account identity/ID was supplied privately in conversation; do not copy
personal email addresses, account IDs, payment information, government
ID, passwords, recovery codes, or Console credentials into source files,
commits, logs, or prompts. A verified account does not grant this coding
environment Console access. The owner performs Console clicks/uploads and
can provide non-sensitive screenshots or exact error text for guidance.

## Goal

Finish the app-side release candidate so the owner can:

1. Run the finished DEV build from Android Studio on their phone, fully
   unlocked by default and able to simulate a real Free user.
2. Build a safe production AAB ready for Google Play upload, with no DEV
   branding or entitlement bypass.
3. Complete the Google Play Console setup through a precise owner
   checklist, then upload to Internal Testing when the signed AAB is
   ready.

Do not claim physical-device behavior, Firebase Test Lab results, or real
Google Play Billing purchases were verified unless the owner supplies that
actual evidence.

All existing project rules remain binding: read session-start files,
9-language l10n lockstep, `flutter test -j 1`, `flutter analyze` clean,
honest reporting, offline-first behavior, minimal scope, and checkpoint
discipline. No ads and no new Firebase runtime SDKs/services.

---

## Checkpoint 3 — Complete app-side QA honestly

There is no Android device or emulator in this environment. Therefore,
complete every QA activity that is genuinely possible, and record the
rest as pending rather than fabricating a pass.

### Do now

1. Audit every approved Free/Pro rule in widgets/services/tests:
   - Salary Calculator: Free user can calculate live but can use only the
     home country; other country choices lock/paywall.
   - Cross-Border: live results and employer-cost view are free; one saved
     comparison is allowed for Free; a second save opens the paywall;
     Pro has unlimited saves.
   - Invoice PDF/NBS IPS QR: Pro.
   - Paušal/VAT compliance pack: visible Pro badge at Tools hub and
     paywall in Free.
   - Freelancer Tax Screen: all regimes remain fully free.
   - QR scanner/manual expense handoff: free; still no receipt-content
     fetch, WebView, or fiscal-verification claim.
2. Add/fix widget or unit coverage for any concrete gap found. Do not add
   speculative features or alter pricing/tier policy.
3. Run a full static scope audit for accidental production leakage:
   Entitlement Preview, DEV labels/assets, `.dev` package values,
   hard-coded unlock paths, test-only product IDs, debug logging of
   personal/billing data, or a runtime Firebase dependency.
4. Create/update `DEVICE_TEST_CHECKLIST.md` with three plain sections:
   - **Verified here:** tests/build/static checks only.
   - **Pending owner phone or Firebase Test Lab:** onboarding touch flow,
     camera granted/denied/permanently-denied behavior, actual QR scan,
     permissions, notifications, widgets, visual layout, keyboard/input,
     and performance.
   - **Pending Google Play Internal Testing:** real product catalog,
     annual trial, subscription, lifetime/support purchases,
     cancellation/expiry, restore, failed/pending purchases, and cached
     entitlement offline behavior.
5. Create a short owner-facing Android Studio guide in
   `PROJECT_CONTEXT.md` (or the project’s established documentation
   location): open the root folder containing `pubspec.yaml`, choose
   `devDebug`, connect a USB-debugging-enabled phone, and run. Include
   the exact project-tested commands/run configurations — do not guess.

### Do not do now

- Do not claim real camera, notifications, widgets, permission dialogs,
  UX, or physical-phone testing has passed.
- Do not add Firebase SDKs/Analytics/Crashlytics/App Distribution. The
  owner may use Firebase Test Lab later as external infrastructure.
- Do not claim Play Billing works before products exist and an Internal
  Testing build is installed from Google Play.

---

## Checkpoint 4 — Production safety and release evidence

1. Run `flutter test -j 1`; record the actual passing count.
2. Run `flutter analyze`; resolve new findings or report any pre-existing
   exceptions precisely.
3. Verify production l10n parity: all 9 shipped locales must have the
   same production key set. Dev-only strings may remain dev-only, but
   must not create a production fallback/missing-key error.
4. Build and inspect both relevant artifacts:
   - `devDebug` (or the repository’s exact dev build) for local owner
     installation; confirm DEV name/icon and default Pro simulation.
   - signed `prodRelease` AAB if signing credentials are available. If
     signing is unavailable in this environment, produce the closest
     valid release artifact and state exactly what owner action is still
     required — never imply upload readiness without a signed AAB.
5. Inspect `prodRelease` with build tools/artifact analysis. Confirm:
   production application ID, production app label/icon, no DEV ribbon,
   no Entitlement Preview route/string, no dev entitlement override, no
   development package suffix.
6. Run a production `--split-per-abi` release build where feasible and
   record all three ABI sizes. Preserve the existing honest D-032
   disclosure: current scanner-related overage is accepted but must never
   be described as "under budget."
7. Update `DECISIONS.md` with the dev/prod security boundary, final gate
   map, no-ads-at-launch decision, current size evidence, and the fact
   that Play billing is pending Internal Testing.
8. Commit the completed work and push it to `origin/main`. Report the
   resulting commit SHA and clean/unclean working-tree state; do not stage
   unrelated CTK toolkit-sync artifacts unless the owner explicitly asks.

---

## Owner Play Console checklist — do after checkpoint 4

Prepare this checklist with actual values discovered from the repository
(production package name, version code, AAB filename, and source-backed
privacy facts). The owner completes it in Play Console; the coding agent
only guides based on screenshots/errors.

### A. Confirm account readiness

- Dashboard shows identity verification complete and no account-level
  blocking task.
- Complete Payments profile/merchant setup before activating paid
  products, using the owner’s own financial/tax information.
- Determine whether this Personal account was created after 13 November
  2023. If yes, plan for Play’s production-access requirement: a **closed
  test with at least 12 opted-in testers for 14 continuous days** before
  applying for production access. Internal Testing is still useful for
  immediate owner/billing QA but does not substitute for that production
  access requirement.

### B. Create the app and test release

- Create the Play app with the exact `prodRelease` package/application
  ID. Never use the dev package ID.
- Complete only truthful Store Listing, App Content, Data Safety, content
  rating, privacy-policy, target-audience, and policy declarations. Do
  not use generic or fabricated answers; derive answers from source and
  document assumptions/questions.
- Upload the signed production AAB to **Internal Testing**, add the
  owner’s phone Google account as an internal tester, publish the track,
  and use the opt-in link to install the Play-distributed build.
- Add the same account in Console **License testing** before testing
  Billing. Do not use a real payment method as a substitute for test
  purchase setup.

### C. Create products only after the app upload is accepted

Audit the central app configuration first, then give the owner the exact
product IDs it expects. If placeholders have not been finalized, stop and
ask the owner before creating immutable Console product IDs. The intended
catalog is:

- Pro Monthly subscription — $3.99/EUR 3.99 base.
- Pro Annual subscription — $19.99/EUR 19.99 base with 7-day trial.
- Pro Lifetime — one-time non-consumable, $49.99/EUR 49.99 base.
- Support the developer — repeatable/consumable one-time purchase,
  $2.99/EUR 2.99 base, no Pro entitlement.

Use Play regional pricing for the countries in which the app is actually
distributed. Activate products only after all Console requirements are
met. Then a separate, tightly scoped prompt will conduct real Internal
Testing purchase/restore/trial/expiry verification.

---

## Final report format — then STOP

Implemented / tests (`flutter test -j 1` actual count) / l10n parity /
`flutter analyze` / dev artifact evidence / production artifact evidence
and signing status / exact production package ID + version code / per-ABI
sizes / production no-bypass result / Firebase/phone items still pending /
Google Play Console owner checklist and blockers / commit + pushed SHA /
working-tree status. Then STOP and await the owner’s Firebase Test Lab or
physical-phone results, plus Play Console screenshots/errors if needed.
