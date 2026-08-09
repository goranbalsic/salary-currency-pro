# Google Play Console Checklist (Owner-Executed)

This is a guidance document, not something the coding environment can
execute — it has no Google Play Console access, and the owner's account
identity/credentials must never be pasted into this repo, a commit, a
prompt, or a log. The owner performs every click/upload below; paste back
screenshots or exact error text if something doesn't match what's
described here.

Real values, derived from the repo as of the NEXT_ACTION prompt's
checkpoint 2 (`DECISIONS.md` D-035) — not guessed:

| Field | Value |
|---|---|
| Production application ID | `rs.salarycurrencypro.salary_currency_pro` |
| Dev application ID (never upload this one) | `rs.salarycurrencypro.salary_currency_pro.dev` |
| Version name | `1.0.0` |
| Version code | `1` (`pubspec.yaml`'s `version: 1.0.0+1`) |
| Release AAB | `build/app/outputs/bundle/prodRelease/app-prod-release.aab` (~74.6MB) |
| Build command | `flutter build appbundle --release --flavor prod -t lib/main_prod.dart` |
| Upload-key certificate SHA-256 (for Play Console App Signing enrollment) | `73fbcd79ff63af74d2aba647dff99d514267a3b058ffda5556fcdf2680079568` |

## Signing — done and verified, not just built

**Real signing is confirmed.** Once you created `android/key.properties`
locally, `flutter build appbundle --release --flavor prod` and
`flutter build apk --release --flavor prod --split-per-abi` were both
verified — `jarsigner -verify` on the AAB and `apksigner verify
--print-certs` on the APK (the correct tool for the APK Signature Scheme
v2 this build actually uses) — to report your real certificate, not the
Android debug certificate. Neither this environment nor this file ever
read the keystore password or `key.properties` contents — only the
build's own signature-verification output, which contains no secret.
**The AAB above is ready to upload** — you don't need to rebuild it
before section B.

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

### Data Safety — known facts (no open items remaining)

Source-derived, current as of D-035 (supersedes whatever
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
- **No ad SDK, resolved by removal, not just disabled:** the Google
  Mobile Ads/UMP SDK (`google_mobile_ads`) — previously flagged here as a
  compiled-but-dormant dependency that Play's automated SDK scanning
  might still detect — was removed completely (D-035): the dependency,
  `AdsService`, `ConsentService`, `BannerAdSlot`, the AdMob manifest
  meta-data, and the "Privacy & ad preferences" Settings row are all
  gone. Confirmed by extracting the release APK and grepping its entire
  file listing for `ads`/`gms`/`admob`/`webview` — zero matches. **Data
  Safety can honestly declare no ad SDK and no advertising ID usage at
  all** — there's nothing left to detect or declare.

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

*Last updated: 2026-08-09, NEXT_ACTION checkpoint 2 (`DECISIONS.md`
D-035). Pair with `DEVICE_TEST_CHECKLIST.md` for the device/Firebase Test
Lab side of what's still pending.*
