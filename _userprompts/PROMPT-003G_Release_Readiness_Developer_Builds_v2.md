# PROMPT-003G: Finished App QA + Deferred Google Play Activation

Status: Active. This is the final app-side release-readiness pass before
Google Play Console exists. Its purpose is to leave Salary & Currency Pro
as a **finished, phone-testable app**: installable from Android Studio,
all current product functionality complete, Free and Pro states fully
testable, and monetization infrastructure ready to activate later without
rewriting the app.

**Important distinction:** "finished app" means every currently-approved
product feature and every Free/Pro gate works locally and can be tested
on a device now. It does **not** mean real Google Play purchases are
claimed to work before the owner has a verified Play Console account,
products, and test track. Build the framework now; activate and
end-to-end verify real billing only when the owner provides those details.

Read the normal session-start files first. Existing rules remain binding:
9-language l10n lockstep, offline-first, real tests (`flutter test -j 1`),
`flutter analyze` clean, honest reports, minimal dependencies,
checkpoint discipline, and no fabricated completion claims.

---

## Non-negotiable outcome

When this prompt is complete, the owner must be able to open the project
in Android Studio, select a documented dev build variant, press Run, and
install a polished, usable app on their Android phone. It must be useful
for everyday testing — not a mock, a collection of half-finished screens,
or a billing demo.

The app must have these two safe modes:

| Variant | Who uses it | Entitlement behavior | Release safety |
|---|---|---|---|
| `devDebug` (and optional `devRelease`) | Owner/local QA | Defaults to fully unlocked Pro; explicit simulation can switch to Free, Trial, Lifetime, or Expired | Unique dev application ID + visible DEV label/icon; never upload or distribute |
| `prodDebug` / `prodRelease` | Production-equivalent QA and later Play release | Starts Free unless restored/verified real entitlement exists | No developer override, selector, hidden route, gesture, query parameter, or mutable preference bypass |

---

## What “framework ready” means

Implement the complete app-side monetization framework now, behind stable
interfaces, while the actual Play configuration is unavailable.

### Entitlement framework

- Keep **one** `EntitlementService` as the only source consulted by all
  gates. Remove or migrate any legacy provider/service so there are never
  two entitlement truths.
- Entitlement states must support `free`, `trialing`, `pro`, `lifetime`,
  and `expired`, including a cached/offline last-known-valid entitlement.
  Never hard-lock an already-entitled user in the middle of a session
  merely because a network call fails.
- Keep a narrow billing adapter interface separate from UI and feature
  gates. The adapter must tolerate an unconfigured Play environment
  gracefully: it returns a localized, recoverable “purchases are not yet
  available” state rather than hanging, crashing, or pretending a charge
  was attempted.
- Product IDs must be constants/configuration in one clearly documented
  location, with placeholders matching the four intended products. Do not
  scatter strings through widgets. Do not invent Play Console IDs or mark
  placeholders as live.

### Planned products — UI and logic ready, console activation deferred

| Product | Type | Planned price | State before Play Console |
|---|---|---:|---|
| Pro Monthly | Subscription | $3.99 / EUR 3.99 base | Displayable; purchase unavailable with honest state |
| Pro Annual | Subscription, 7-day trial | $19.99 / EUR 19.99 base | Displayable; purchase unavailable with honest state |
| Pro Lifetime | One-time purchase | $49.99 / EUR 49.99 base | Displayable; purchase unavailable with honest state |
| Support the developer | One-time, no feature gate | $2.99 / EUR 2.99 base | Displayable; purchase unavailable with honest state |

The paywall must never represent placeholder prices/products as an active
transaction. If no Play catalog is available, retain transparent price
copy as the planned offer and disable/handle purchase actions with a
localized availability explanation. Restore Purchases must also fail
cleanly and honestly before Play setup.

### Feature-gate rules — final

- Salary Calculator: live calculation is free; Free users may use their
  home country only. Other country rows show a lock and open the paywall.
- Cross-Border: live comparisons, including employer cost, are always
  free. Saving is new: one saved comparison at a time for Free, unlimited
  saved comparisons for Pro.
- Invoice PDF generation + NBS IPS QR: Pro.
- Entire paušal/VAT compliance pack: Pro at the Tools-hub entry, visible
  `PRO` badge, contextual paywall.
- Freelance Tax Screen and all of its country/regime choices: fully free.
- QR scanner shell and manual expense handoff: free.
- No ads at launch. Do not add an ad SDK, ad placeholders, or ad code.

---

## Checkpoint 1 — Android Studio build matrix

1. Audit the current Gradle/Flutter setup before changing it.
2. Add `dev` and `prod` flavors, each with documented entrypoints and
   Android Studio run configurations. Use a distinct dev application ID
   suffix (for example `.dev`), a DEV app label, and unmistakable dev
   branding so it cannot be mistaken for production on the phone.
3. Verify and document the exact commands for this repository, following
   its current entrypoint conventions. At minimum provide equivalents of:

   ```text
   flutter run --flavor dev -t lib/main_dev.dart
   flutter run --flavor prod -t lib/main_prod.dart
   flutter build apk --debug --flavor dev -t lib/main_dev.dart
   flutter build apk --release --flavor prod -t lib/main_prod.dart
   ```

4. Add a compile-time flavor configuration object. Do not decide flavor
   from an editable runtime preference.
5. Confirm `devDebug` installs and runs from Android Studio on a physical
   Android phone.

## Checkpoint 2 — Developer entitlement simulator

1. In **dev composition only**, provide an accessible Settings section
   named `Entitlement Preview` with Pro (default), Free, Trialing,
   Lifetime, and Expired options. Clearly label every state as simulated;
   state that no money is charged.
2. The preview change must update every gate/paywall state immediately
   without requiring an app reinstall (restart only if unavoidable, and
   document why).
3. In `prod` builds, route solely to the real `EntitlementService` /
   billing adapter. The preview UI and implementation must be absent or
   compile-time unreachable in `prodRelease`.
4. Test every preview state against every defined gate, including
   offline/restart persistence for the dev package only.

## Checkpoint 3 — Finished-app phone QA

Treat this as product QA, not a UI screenshot pass. Test on a physical
phone using `devDebug`; fix concrete defects within current approved scope.
Do not add speculative product features.

- Onboarding, language/country selection, skip and restart persistence.
- Every main tab, navigation/back behavior, light/dark theme, and core
  manual expense/budget/invoice flows.
- Salary Calculator country locks in Free and full switching in Pro.
- Cross-Border live results in Free, first save in Free, second-save
  paywall, and unlimited saves in Pro.
- Freelancer Tax every regime in Free.
- Invoice PDF paywall in Free and working generation under Pro preview.
- Paušal/VAT Tools-hub gate + full Pro flow.
- QR scanner: granted/denied/permanently-denied camera flows, manual
  fallback, queue, and expense handoff. Reconfirm no fiscal-receipt
  network fetch/verification claim exists.
- Notifications and recurring flows where implemented; denied-permission
  behavior must remain graceful.
- Paywall: four product cards, annual visual emphasis, planned 7-day
  trial copy, lifetime/support options, Restore Purchases, unavailable
  Play-catalog behavior, offline/error state, and no indefinite spinner.

Record findings. Fix real defects. If a finding demands a new product
policy rather than a defect fix, document it and stop for approval.

## Checkpoint 4 — Production safety + release evidence

1. Run full `flutter test -j 1` and `flutter analyze`.
2. Verify all 9 locales are in lockstep for production-visible text.
3. Build/install `devDebug`; verify dev label/icon, default Pro preview,
   and Free simulation on a physical phone.
4. Build `prodRelease` if signing credentials are available; otherwise
   build the closest valid production artifact and state the limitation.
   Inspect it: no dev package ID, DEV branding, Entitlement Preview, or
   entitlement bypass may be present.
5. Build `prodRelease` with `--split-per-abi`, report all three ABI sizes
   honestly, and update the existing size disclosure if they change.
6. Update `PROJECT_CONTEXT.md` with the exact Android Studio variant
   selection/run/build instructions. Update `DECISIONS.md` with the
   dev/prod security boundary, final gate map, no-ads-at-launch decision,
   planned prices, and explicit statement that Play products are pending.
7. Commit and push.

---

## Deferred activation — only after owner supplies Play Console details

Do not attempt this work now. When the owner has a verified Play Console
account and provides the needed product IDs/configuration, use a separate
prompt to:

1. Upload a signed `prodRelease` AAB to Internal Testing.
2. Create/activate the two subscriptions and two one-time products with
   the planned pricing, annual 7-day trial, and regional pricing.
3. Replace placeholders in the one configuration location only.
4. Add license testers and execute real sandbox purchases, cancellation,
   trial, restore, pending/failure, and offline-cache tests.
5. Only then report real Play Billing as end-to-end verified.

## Report format (after each checkpoint)

Implemented / tests (`flutter test -j 1` count) / l10n parity /
`flutter analyze` / physical-phone results / exact Android Studio
variant + commands verified / known limitations caused solely by absent
Play Console / prod-artifact no-bypass verification / per-ABI sizes /
files updated / commit + push / what is next. Stop after checkpoint 4.
