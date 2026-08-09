# Google Play Console Checklist (Owner-Executed)

This is a guidance document, not something the coding environment can
execute — it has no Google Play Console access, and the owner's account
identity/credentials must never be pasted into this repo, a commit, a
prompt, or a log. The owner performs every click/upload below; paste back
screenshots or exact error text if something doesn't match what's
described here.

Real values, derived from the repo as of PROMPT-003J checkpoint 4
(`DECISIONS.md` D-034) — not guessed:

| Field | Value |
|---|---|
| Production application ID | `rs.salarycurrencypro.salary_currency_pro` |
| Dev application ID (never upload this one) | `rs.salarycurrencypro.salary_currency_pro.dev` |
| Version name | `1.0.0` |
| Version code | `1` (`pubspec.yaml`'s `version: 1.0.0+1`) |
| Release AAB (once signed — see below) | `build/app/outputs/bundle/prodRelease/app-prod-release.aab` |
| Build command | `flutter build appbundle --release --flavor prod -t lib/main_prod.dart` |

## Before anything else: real signing

**The AAB this environment can build is signed with the debug keystore —
Play will not accept it.** See `PROJECT_CONTEXT.md`'s "Release signing"
section for the exact `keytool` command and the `android/key.properties`
setup. Do not proceed to section B below until a real signed AAB exists;
verify with `jarsigner -verify` first (also documented there).

## A. Confirm account readiness

- [ ] Play Console dashboard shows identity verification complete, no
      account-level blocking task.
- [ ] Payments profile / merchant setup completed (using your own
      financial/tax information — this coding environment never sees or
      needs this).
- [ ] **Check your account creation date.** If this Personal account was
      created after **13 November 2023**, Play requires a **closed test
      with at least 12 opted-in testers for 14 continuous days** before
      you can apply for production access. Internal Testing (section B)
      is still the right next step for your own billing QA — it just
      doesn't by itself satisfy this separate production-access
      requirement. Plan the 12-tester/14-day window accordingly if it
      applies to you.

## B. Create the app and test release

- [ ] Create the Play app using the **exact production package ID**
      above (`rs.salarycurrencypro.salary_currency_pro`) — never the
      `.dev` one.
- [ ] Store Listing, App Content, Data Safety, content rating,
      privacy-policy, and target-audience declarations: fill these in
      truthfully from what the app actually does — see the Data Safety
      notes below for known source-derived facts and one open question
      that needs your decision. Don't reuse generic template answers.
- [ ] Upload the signed production AAB to **Internal Testing**, add your
      own phone's Google account as an internal tester, publish the
      track, then use the opt-in link to install the *Play-distributed*
      build on your phone (not a sideloaded APK — this is what actually
      exercises Play's real signing/distribution path).
- [ ] Add the same Google account under Console **License Testing**
      *before* testing Billing. Do not substitute a real payment method
      for proper test-purchase setup.

### Data Safety — known facts and one open item

Source-derived, current as of this checkpoint (supersedes whatever
`store_listing/README.md` §2/§3 said before Stage D — that was written
before the no-ads-at-launch decision and needs a fresh pass, not just
reuse):

- **Network calls:** two public, no-auth currency-rate APIs
  (`ExchangeRateService`) and the freelance tax-rules remote-update
  endpoint (`TaxRulesService`, points at the project's own public
  `salary-currency-pro-rules` GitHub repo) — no personal data is sent to
  either. In-app purchases go through Google Play Billing
  (`in_app_purchase`), not a custom backend.
- **Local-only data:** every user-entered financial figure (expenses,
  budgets, invoices, salary calculations, saved scenarios) stays in
  `SharedPreferences` on-device — see `PROJECT_CONTEXT.md`/`settingsAboutBody`'s
  existing accurate in-app copy for the user-facing version of this
  claim.
- **Camera:** requested only when the user opens the fiscal-receipt QR
  scanner and taps to scan; no frame or image is ever stored or
  transmitted (local on-device ML Kit detection only — see `DECISIONS.md`
  D-032).
- **⚠️ Open item — decide before filling this in, don't guess:** the
  Google Mobile Ads SDK (`google_mobile_ads`) is still a compiled
  dependency of the app (Decision 1 disabled its *initialization*, not
  the dependency itself — see D-033/D-034, "paused infrastructure, not
  removed") — the AdMob app ID meta-data is also still present in
  `AndroidManifest.xml`. Play's automated SDK scanning during app review
  frequently detects an SDK's mere *presence* in the binary regardless of
  whether your code ever calls it. **Before filling in Data Safety,
  either:** (a) declare the Google Mobile Ads SDK's standard data
  practices anyway to avoid a mismatch with Play's automated detection,
  even though it's dormant, or (b) actually remove the
  `google_mobile_ads` dependency from `pubspec.yaml` and the AdMob
  manifest meta-data now, before this upload, so there's nothing for Play
  to detect. This is a real product/compliance call — not something to
  guess an answer for.

## C. Create products only after the app upload is accepted

Audited product IDs (`lib/config/monetization_config.dart`) — every one
is still a placeholder marked with its own `// TODO: create ... in Play
Console` comment; none has been created anywhere yet:

| Console product | Type | ID (must match exactly) | Base price |
|---|---|---|---|
| Pro Monthly | Auto-renewing subscription | `pro_monthly` | $3.99 / EUR 3.99 |
| Pro Annual | Auto-renewing subscription, 7-day free trial | `pro_annual` | $19.99 / EUR 19.99 |
| Pro Lifetime | One-time, non-consumable | `pro_lifetime` | $49.99 / EUR 49.99 |
| Support the developer | One-time, repeatable/consumable, no entitlement | `support_developer` | $2.99 / EUR 2.99 |

- [ ] **If any of these four IDs need to change, stop and say so before
      creating them in Console — product IDs are immutable once created.**
- [ ] Create all four with the exact IDs above.
- [ ] Configure the annual subscription's 7-day free trial in its base
      plan/offer.
- [ ] Use Play's regional pricing template (auto-converts the USD/EUR
      base price per country) rather than hand-setting each of the 9
      target markets — this was already the Stage D pricing decision
      (D-033), not new guidance.
- [ ] Activate products only once every Console requirement above is
      met — don't activate against an app still in review/rejected.

Once products are live and an Internal Testing build with License
Testing is installed, a **separate, tightly scoped prompt** should handle
real purchase/restore/trial/expiry verification — that's explicitly out
of scope for this checklist (see `NEXT_PROMPT_Finish_App_and_Play_Console_Readiness.md`'s
own boundary: "a separate prompt will conduct real Internal Testing
purchase/restore/trial/expiry verification").

---

*Last updated: 2026-08-09, PROMPT-003J checkpoint 4. Pair with
`DEVICE_TEST_CHECKLIST.md` for the device/Firebase Test Lab side of
what's still pending.*
