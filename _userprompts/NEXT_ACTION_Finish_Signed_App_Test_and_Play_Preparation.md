# Next Action: Finish Signed App, Test It, and Prepare Google Play

## Use this as the single current continuation prompt

Do not consult or restart older monetization/release prompts unless this
prompt explicitly says to. Continue from the repository and local-machine
state below. The goal is a finished, signed, phone-testable app followed
by an honest, staged path into Firebase Test Lab and Google Play Internal
Testing.

---

## Verified starting state

### Repository/app state

- Stage C is complete; fiscal QR scanner remains an **offline-only shell**.
  No `suf.purs.gov.rs` receipt-content fetch, WebView, or fiscal
  verification claim is approved.
- Stage D monetization framework is implemented. Free/Pro rules are final:
  - Salary Calculator: live calculation is Free; Free is limited to home
    country; other countries are Pro.
  - Cross-Border: live comparison and employer-cost view are Free; Free
    can save one comparison; Pro can save unlimited comparisons.
  - Invoice PDF + NBS IPS QR: Pro.
  - Paušal/VAT compliance pack: Pro at the Tools-hub entry.
  - Freelancer Tax Screen: fully Free across all regimes.
  - Fiscal QR scanner/manual expense handoff: Free.
  - No ads at launch.
- DEV/PROD Android flavors are complete and pushed at `d020bae`:
  distinct `.dev` package/label/DEV-ribbon icon; DEV Entitlement Preview
  simulates Free/Trialing/Pro/Lifetime/Expired; production has no visible
  preview/bypass. Actual build/aapt/binary evidence already exists.
- Latest verified evidence before this continuation: 525/525 tests,
  588 l10n keys × 9 locales, `flutter analyze` clean except three known,
  unrelated info notices. Production package ID:
  `rs.salarycurrencypro.salary_currency_pro`, version `1.0.0`, version
  code `1`.
- Previous production size evidence: armeabi-v7a 28.1MB, arm64-v8a
  31.5MB, x86_64 33.8MB. The latter two exceed the 30MB target because of
  the scanner ML Kit dependency. This is accepted/disclosed (D-032), but
  must never be described as under budget.
- Working tree may contain pre-existing unrelated CTK toolkit-sync files.
  Do not stage, alter, or commit them.

### Owner/local machine state

- The owner has a verified **Personal** Google Play Console account.
- The owner created the local upload keystore successfully and created
  local `android/key.properties`. These are private signing secrets.
- Never read, print, commit, copy, upload, or request the contents of
  `android/key.properties`, the `.jks` keystore, or any passwords.
- The owner will perform all Google Play Console clicks/uploads. This
  coding environment has no Play Console credentials/access.

### Truthfulness boundary

There is no Android device/emulator in this coding environment. You may
perform code/build/static verification now, but you must not claim camera,
permissions, notification/widget behavior, visual/touch UX, Firebase Test
Lab, or real Google Play Billing has been tested without owner-provided
results.

All normal project rules continue: read session-start files, 9-language
l10n lockstep, real `flutter test -j 1`, `flutter analyze`, offline-first,
honest reporting, one bounded checkpoint at a time, and no scope creep.

---

## Checkpoint 1 — Remove dormant Google Mobile Ads completely

The product decision is final: **no ads at launch**. The Google Mobile Ads
SDK currently remains compiled but dormant; remove it completely before
any Play upload.

1. Audit dependencies/lockfiles, Android Gradle files/manifests,
   Dart/Kotlin/Java code, assets, UMP/consent code, ProGuard/R8 rules,
   resources, tests, and docs for Google Mobile Ads/AdMob/ad units/ad
   metadata/ad-oriented Data Safety statements.
2. Remove every ads/AdMob/UMP dependency and dead supporting code. Do not
   leave it disabled, commented out, feature-flagged, or as a TODO.
3. Preserve the no-ads-at-launch decision in `DECISIONS.md`: future ads
   would require a fresh, explicit product/privacy implementation.
4. Update privacy/Data Safety preparation based only on the actual
   post-removal code/dependencies. Never claim no collection unless the
   audit supports it.
5. Run `flutter pub get`, `flutter test -j 1`, and `flutter analyze`.
6. Build/inspect a production artifact and prove the Mobile Ads SDK is no
   longer packaged. State the exact inspection method/result.
7. Commit only these scoped source/documentation changes and push. Do not
   include CTK artifacts or signing secrets.

Stop and report checkpoint 1 before proceeding.

---

## Checkpoint 2 — Build and prove the signed production release

Proceed only after checkpoint 1 is green.

1. Verify the existing Gradle signing configuration recognizes the owner’s
   **local ignored** `android/key.properties`. Do not print its contents.
2. Confirm `.gitignore` excludes `android/key.properties`, `*.jks`,
   `*.keystore`, and no signing secret appears in `git status`, commit
   diff, logs, or reports.
3. Build:
   - signed production AAB for Google Play;
   - signed production split-per-ABI APKs for artifact inspection.
4. Inspect the artifacts and record only non-secret evidence:
   production package ID, label, version name/code, signed/release status,
   no `.dev` suffix/DEV icon/DEV label, no Entitlement Preview UI/bypass,
   and no Mobile Ads SDK.
5. Rerun full `flutter test -j 1`, `flutter analyze`, and production l10n
   parity. Record actual counts/results.
6. Record final per-ABI sizes and AAB size. Retain/refresh D-032 wording
   honestly if values remain over budget.
7. Update `PROJECT_CONTEXT.md`, `DECISIONS.md`, and
   `PLAY_CONSOLE_CHECKLIST.md` with only truthful, non-secret release
   evidence. Commit/push source/docs only.

Stop and report checkpoint 2 before asking the owner to test.

---

## Owner test gate — do not fake it

After checkpoint 2, give the owner exact project-verified Android Studio
instructions to install/use the app on their phone:

- **DEV build:** default Pro/unlocked; use Entitlement Preview to switch
  to Free and test gates.
- **PROD build:** no developer preview; validates true Free behavior.

The owner should test and return observations/screenshots for:

- onboarding, country/language persistence, navigation/back, theme;
- Salary home-country lock vs Pro switching;
- Cross-Border first Free save vs second-save paywall;
- Freelancer Tax fully Free;
- PDF and Paušal/VAT Pro gates;
- scanner granted/denied/permanently-denied camera states, manual fallback,
  queue, and expense handoff;
- notifications/widgets/keyboard/layout if available.

Maintain `DEVICE_TEST_CHECKLIST.md` with three groups: verified in
code/build, pending/verified on owner phone or Firebase Test Lab, and
pending/verified through Play Internal Testing. Do not mark an item passed
until evidence exists.

---

## Next external-test sequence — prepare, do not claim complete

### Firebase Test Lab

After the signed production artifact is ready, prepare a concise
owner-run Test Lab package: artifact path, package/version, SHA-256 if
available, upload instructions, and a small Robo-test matrix (one
older/low-resource device, one current device, English + Serbian smoke
run). Do not add Firebase SDKs, Analytics, Crashlytics, or runtime keys.
The owner will return screenshots/logs/videos/crashes; triage/fix only
confirmed defects in a later bounded checkpoint.

### Google Play Internal Testing + Billing

After phone/Test Lab smoke testing is satisfactory, the owner will:

1. Create/select the Play app using the exact production package ID.
2. Complete required app-content/Data Safety/store declarations truthfully.
3. Upload the signed production AAB to **Internal Testing** and install
   through the Play opt-in link.
4. Add the phone’s Google account as a license tester.
5. Create/activate products only after checking the exact central product
   IDs expected by the app. Do not invent or create near-matching IDs.

Planned product catalog, subject to central-config audit before Console
creation:

- Pro Monthly subscription: $3.99/EUR 3.99 base.
- Pro Annual subscription: $19.99/EUR 19.99 base, 7-day trial.
- Pro Lifetime non-consumable: $49.99/EUR 49.99 base.
- Support the developer repeatable one-time product: $2.99/EUR 2.99 base,
  no Pro entitlement.

The owner’s Personal account is newly created. Plan a closed test with at
least 12 opted-in testers for 14 continuous days before applying for
Production access. Internal Testing is still appropriate for immediate
owner/Billing QA, but it does not replace the closed-test requirement.

---

## Required report after each checkpoint

Implemented / tests (`flutter test -j 1` actual count) / l10n parity /
`flutter analyze` / production artifact + signing evidence / ad-SDK
absence evidence / DEV/PROD no-bypass evidence / final per-ABI and AAB
sizes / changed files / commit + pushed SHA / Git status excluding known
CTK artifacts / owner action required next / items explicitly not yet
verified. Stop after checkpoint 2 and wait for owner phone results.
