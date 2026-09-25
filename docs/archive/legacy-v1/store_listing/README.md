# Play Store readiness checklist

PROMPT-003 Stage A item 4, closed out by PROMPT-003A. Status as of
2026-08-07 — see `DECISIONS.md` D-013 (original checklist) and D-014
(UMP consent implementation) for the full session records.

## 1. Store listing text — done

One file per supported language, each with an app title, an ≤80-character
short description, and a full description (≤4000 characters):
`en.md`, `sr.md`, `hr.md`, `bs.md`, `mk.md`, `sl.md`, `bg.md`, `sq.md`,
`ro.md`. Content is drawn from what the app actually does (cross-checked
against `settingsAboutBody` and the real feature list) — no invented
claims.

## 2. Data safety form — answers derived from actual code, not guessed

Audited `lib/services/` and `android/app/src/main/AndroidManifest.xml`
directly rather than assuming. What the app actually does:

- **No account, no login, no user-identifying data collected by this
  app's own code.** All user-entered data (expenses, budgets, goals,
  invoices, saved scenarios, calculation history) is stored only in
  local `SharedPreferences` on-device — confirmed by
  `lib/services/*_service.dart`, none of which make an outbound request.
- **Network requests the app makes directly:** two public, no-auth
  currency-rate APIs — `https://api.frankfurter.app` and
  `https://open.er-api.com` (see `lib/services/rate_providers.dart`).
  Only a currency code is sent as a query parameter; no personal or
  device-identifying data.
- **Third-party SDKs present:** `google_mobile_ads` (AdMob, currently
  configured with Google's official *test* App ID
  `ca-app-pub-3940256099942544~3347511713` — **must be replaced with a
  real AdMob App ID before release**, see `PROJECT_CONTEXT.md` Known
  Risks) and `in_app_purchase` (Play Billing, for the Pro subscription).
  Both are Google-operated SDKs that independently collect data per
  their own privacy disclosures (advertising ID, IP-derived
  approximate location for ads; purchase/transaction data for billing)
  — this app does not control or see that data itself, but the Play
  Console data-safety form must still disclose it under "data shared
  with third parties" for both Advertising and Purchase history
  categories.
- **Recommended data-safety form answers**, to be entered directly in
  Play Console (not something this repo can submit on your behalf):
  - Data collected/shared: Advertising ID (via AdMob), Purchase history
    (via Play Billing). Financial info entered in-app (salary/expense
    amounts) is **not** collected or shared — it never leaves the
    device.
  - Data encrypted in transit: Yes (both rate APIs use HTTPS; AdMob and
    Play Billing use HTTPS by SDK default).
  - Data deletion: N/A for anything server-side (nothing is stored
    server-side by this app) — in-app, the existing Settings ➝ "Delete
    all local data" flow covers on-device deletion.
  - Ad personalization consent: covered by the UMP flow described in §3
    — Play Console's data-safety form should reflect that ad
    personalization is conditional on user consent (EEA/UK), not
    unconditional.

## 3. AdMob / UMP consent — implemented (PROMPT-003A, D-014)

**Real gap found in the prior session, now closed:** `google_mobile_ads`
was wired in and serving ads with **no Google User Messaging Platform
(UMP) consent flow at all**. Given explicit approval and a full spec in
`_userprompts/PROMPT-003A_StageA_Closure.md`, this is now implemented:
`lib/services/consent_service.dart` requests consent info and shows the
UMP form (native, EEA/UK-only) before `lib/services/ads_service.dart`
ever calls `MobileAds.instance.initialize()` or requests an ad; a
"Privacy & ad preferences" entry in Settings lets users reopen the form
later, per Google policy. Full architecture, the 3-second startup-safety
timeout rationale, and the debug-geography testing scaffolding are
documented in `DECISIONS.md` D-014.

**Verification status — disclosed honestly, not overclaimed:**
`flutter analyze` clean, 123/123 tests passing, code written against the
installed package's actual API (not guessed). **The real native consent
dialog was NOT visually verified on a device/emulator this session — none
was available.** Before relying on this in production: run the app on a
real Android device or emulator with `ConsentService`'s debug-geography
override active, confirm the EEA consent form actually renders and that
declining actually results in non-personalized ads (or no ads), and
confirm "Privacy & ad preferences" actually reopens the form. This is a
real remaining verification step, not a formality.

## 4. App icon — designed and generated (PROMPT-003A, D-015)

**Real gap found in the prior session, now closed:** the app was still
using Flutter's default template launcher icon. Given an explicit design
spec in `_userprompts/PROMPT-003A_StageA_Closure.md`, a real icon was
designed and generated: two smooth semicircular exchange arrows forming
a broken circle (the upper one's head rising above the circle), navy
background (#0F2A43), gold glyph (#E8B54D). Source: `branding/*.svg` +
`branding/generate_icon.py` (the parametric source of truth — re-run it
to iterate the design, then `dart run flutter_launcher_icons` from the
repo root to regenerate every platform's actual icon files). Full design
rationale and the iteration process in `DECISIONS.md` D-015.

Generated: Android legacy + adaptive icon (separate foreground/
background/Android-13+-monochrome layers), iOS, web (including PWA
manifest icons and favicon), Windows, macOS, and a 512×512 Play Store
listing PNG (`branding/playstore_512.png`).

**Verification status:** a real `flutter build apk --release
--split-per-abi` succeeded with the new icon resources compiled in
(sizes unchanged, confirming negligible size impact and no build
errors). The generated Android resource files were inspected directly
and the glyph PNGs were visually confirmed correct. **Not verified: how
it actually looks on a real device home screen** (regular/round/themed
icon variants) — no device/emulator was available this session. Check
this before treating the icon as final.

## 5. Screenshot shot-list

Recommended screens to capture for the Play Store listing (phone
screenshots, portrait, at least 2 and up to 8 per Play Console). In
priority order:

1. **Salary calculator result** — the strongest, most differentiated
   screen; shows a real gross-to-net breakdown for one country.
2. **Onboarding goal-picker** (screen 3) — communicates the "pick what
   you need" positioning in one glance.
3. **Currency converter** with the `RateStatusBanner` visible — shows
   the live-rate/offline-fallback trust signal.
4. **Expense Tracker** with populated data (income/expense entries,
   monthly summary) — shows the budgeting side of the app, not just
   payroll.
5. **Budgets & Goals** screen with an active savings goal and a category
   budget shown mid-progress.
6. **Tools hub** (grouped calculator categories) — communicates breadth
   without needing 15 separate screenshots.
7. **Settings ➝ "Why trust this app?"** section (D-011) — a
   differentiator worth surfacing given how much of this app's identity
   is "sourced, dated, no hidden costs."

Each screenshot should be captured once per language actually submitted
to Play Console for that locale's listing (at minimum English + Serbian
to start, expanding to all 9 as listings go live) — capturing all 9
languages × 7 screens is a real production task, not something to
attempt from this environment without a device/emulator farm.
