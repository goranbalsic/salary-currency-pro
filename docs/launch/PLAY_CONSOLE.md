# Publishing Bilans on Google Play

Everything Play Console asks for, in the order it asks. Items marked **You**
need your accounts or decisions; everything else is already prepared in
this repository.

App: **Bilans** · package `rs.bilans.app` · version `2.0.0 (20)` ·
min Android 7.0 (API 24) · target Android 16 (API 36).

---

## 1. Before the first upload

1. **You — support email.** Pick the public contact address (a dedicated one,
   e.g. a new Gmail, keeps your personal inbox private). Put it in
   `lib/app/app_config.dart` → `supportEmail` (it shows as Settings → Contact)
   and in Play Console → Store settings → Contact details.
2. **You — upload key.** Create it once and keep two backups outside the repo:
   ```
   keytool -genkey -v -keystore ~/bilans-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   Then create `android/key.properties` (git-ignored):
   ```
   storePassword=…
   keyPassword=…
   keyAlias=upload
   storeFile=/home/you/bilans-upload.jks
   ```
   Without this file the release build is signed with the debug key, which
   Play rejects.
3. **Build the bundle:**
   ```
   flutter build appbundle --release --flavor prod
   ```
   Output: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`.
   The file is ~64 MB because it carries native debug symbols for crash
   reports; phones download about 11 MB.
4. **Website.** The pages (source in `docs/`) are published from the public
   repository `goranbalsic.github.io`, folder `bilans/`, so this code
   repository can be private. These must open before you submit:
   - https://goranbalsic.github.io/bilans/ (landing page)
   - https://goranbalsic.github.io/bilans/privacy.html
   - https://goranbalsic.github.io/bilans/terms.html

   After editing `docs/index.html`, `privacy.html`, `terms.html` or
   `site.css`, copy them to `bilans/` in that repository.

## 2. Create the app

Play Console → *Create app*: name **Bilans**, default language
**English (United States)**, *App*, *Free* (Pro is sold in-app). Accept the
declarations.

## 3. App content (Policy → App content)

| Section | Answer |
|---|---|
| Privacy policy | `https://goranbalsic.github.io/bilans/privacy.html` |
| App access | All functionality is available without special access. (No login; Pro features unlock through an in-app purchase.) |
| Ads | No, the app does not contain ads. |
| Content rating | Category *All other app types*; answer **No** to every question (no violence, sexuality, gambling, user interaction or location sharing). Expected: PEGI 3 / Everyone. |
| Target audience | **18 and over** only. Not designed for children. |
| News app | No. |
| Health apps | None. |
| Government apps | No. |
| Financial features | The app offers calculators and invoicing tools only. It does **not** provide loans, banking, payments, crypto or investment services. If the form lists a calculator/tools option, choose it; otherwise *My app doesn't provide any of these financial features*. |
| Data safety | See section 4. |

## 4. Data safety form

- *Does your app collect or share any of the required user data types?* → **No.**
  Everything the person enters stays on the device; the developer runs no
  servers. Exchange-rate requests name only currencies and dates.
  Purchases are processed by Google Play.
- Because nothing is collected, the encryption and deletion questions do not
  apply. (For the record: all network traffic is HTTPS, and Settings →
  Delete all data erases everything on the device.)
- Privacy policy link: as above.

If Google's form changes to ask about data processed by Google Play
Billing, answer as the form's help text describes for Play Billing; the app
itself stores only the purchase status, on the device.

## 5. Store listing (Grow → Store presence → Main store listing)

- Texts: `docs/launch/store_listing/<language>.md` — title, short and full
  description for English (default), Serbian, Croatian, Bosnian, Slovenian,
  Macedonian, Bulgarian and Romanian. Add each as a translation under
  *Manage translations → Add your own*. All texts are within Play's limits
  (`python3 tool/launch/check_listing.py`).
- App icon (512 × 512): `docs/launch/assets/play_icon_512.png`.
- Feature graphic (1024 × 500): `docs/launch/assets/feature_graphic_<lang>.png`.
- Phone screenshots (1080 × 1920): `docs/launch/assets/screenshots/<lang>/`.
  Use the Serbian set for the Serbian, Croatian, Bosnian, Macedonian,
  Bulgarian and Romanian listings unless you render theirs
  (`tool/launch/make_store_graphics.py`).
- Category: **Finance**. Tags: *Calculators*, *Invoicing*, *Currency converter*
  (whatever of these Play offers).
- Website: `https://goranbalsic.github.io/bilans/`.

## 6. Payments and products (Monetize with Play)

1. **You — payments profile.** Setup → Payments profile: legal name, address,
   bank account (IBAN) for payouts. Complete the **tax information** (for
   individuals outside the US: form W-8BEN in the Play tax center).
2. **Products** — the IDs must match exactly (`AppConfig`):

| Type | Product ID | Base plan / setup | Offer |
|---|---|---|---|
| Subscription | `pro_monthly` | Auto-renewing, 1 month | — |
| Subscription | `pro_yearly` | Auto-renewing, 1 year | Free trial, 7 days, *new customer acquisition* (never had this subscription) |
| One-time product (in-app) | `pro_lifetime` | Managed product | — |

   The app reads the offers from Play, so base-plan and offer IDs can be
   anything (e.g. `monthly`, `yearly`, `trial7`).
3. **Prices** (set the default, then override these markets):

| Market | Monthly | Yearly | Lifetime |
|---|---|---|---|
| Serbia (RSD) | 349 | 2,490 | 4,990 |
| Euro countries (HR, SI, ME, BG, EU) | 2.99 € | 19.99 € | 39.99 € |
| Bosnia and Herzegovina (BAM) | 5.99 KM | 39.99 KM | 79.99 KM |
| North Macedonia (MKD) | 179 ден | 1,190 ден | 2,490 ден |
| Romania (RON) | 14.99 lei | 99.99 lei | 199.99 lei |
| Everyone else (USD base) | $2.99 | $19.99 | $39.99 |

   The yearly plan shows about 40–44 % saving against monthly; the paywall
   computes the percentage from the live prices.
4. **License testing:** Setup → License testing → add your Google account and
   testers. They can buy every product without being charged — test monthly,
   yearly (with trial), lifetime, *Restore* and cancellation before launch.

## 7. Testing tracks and release

1. **Internal testing:** upload the AAB, add yourself, install from the Play
   link, run the device checklist below.
2. **Closed testing (required for new personal developer accounts):** at least
   **12 testers opted in for 14 consecutive days** before you can apply for
   production. Recruit colleagues, friends and a few paušalci/accountants —
   their feedback is the most valuable. Keep them opted in for the full 14
   days.
3. **Production:** apply for access (the form asks about the closed test),
   then roll out to 20 %, watch *Android vitals* and reviews for two days,
   then 100 %.

### Device checklist (internal/closed test)

- First launch in Serbian, English and one Cyrillic language; change
  country and language in Settings.
- Pay: gross → net for Serbia, Croatia, Romania; *Options* sheets; save,
  share, PDF.
- Loans: schedule, early repayment, comparison; Savings with tax.
- Rates: converter offline (flight mode) after one online start; history.
- Invoice: business details → invoice in RSD → issue → QR scanned by a real
  banking app (NBS IPS) shows the right account, amount and reference.
- Invoice in EUR: NBS rate fetched; PDF in the bilingual option.
- Backup: export to Drive or Files, *Delete all data*, restore the backup.
- Purchases with a license tester: each plan, Restore on a second device,
  cancel the subscription in Play and reopen the app after expiry.
- Large text (Android font size maximum) and dark theme on a few screens.
