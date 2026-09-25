# Bilans — finance calculator

Gross and net pay for 9 Balkan tax systems, loans with APR, official NBS and
ECB exchange rates, and invoices with the NBS IPS payment QR code. No
account, no ads, no tracking: everything stays on the phone.

Android · Flutter · package `rs.bilans.app` · 9 languages (English, Serbian
Latin and Cyrillic, Croatian, Bosnian, Slovenian, Macedonian, Bulgarian,
Romanian).

- **Pay** — gross → net, net → gross, employer budget; Serbia, Croatia,
  Slovenia, FBiH, Republika Srpska, Montenegro, North Macedonia, Bulgaria,
  Romania (rules in `lib/features/payroll/domain/payroll_rules.dart`, with
  sources). Team cost and country comparison.
- **Loans and savings** — annuity or equal principal, APR by the EU
  formula, schedule, early repayment, offer comparison, term deposits.
- **Rates** — NBS (kurs.resenje.org) and ECB (Frankfurter), offline cache,
  history.
- **Business** — invoices (PDF, NBS IPS QR, IBAN/SWIFT, NBS counter-value),
  paušal limits, VAT, margin, break-even, investment (NPV, IRR, payback).
- **Bilans Pro** — Google Play Billing: `pro_monthly`, `pro_yearly` (7-day
  trial), `pro_lifetime`. Free tier: home country, 3 invoices, 5 saved
  calculations.

## Run and build

```
flutter pub get
flutter run -t lib/main_dev.dart --flavor dev     # dev build: Pro simulator in Settings
flutter run --flavor prod                          # production configuration
flutter build appbundle --release --flavor prod    # Play upload (needs android/key.properties)
```

## Checks

```
flutter analyze
dart format --set-exit-if-changed lib test
flutter test -j 1          # one test file at a time (see CLAUDE.md)
```

The suite covers the engines, stores, billing states, every PDF report in
every language, and the main flows in all 9 languages at normal and large
text, on phone, foldable and tablet sizes.

## Translations

Strings live in `tool/l10n/<language>/*.json` (English is the template).
After editing:

```
python3 tool/l10n/transliterate.py   # Serbian Cyrillic from Serbian Latin
python3 tool/l10n/check.py           # keys, placeholders, plurals, % spacing
python3 tool/l10n/merge.py           # writes lib/l10n/app_*.arb
flutter gen-l10n
```

`test/l10n/l10n_test.dart` fails if the ARB files and fragments drift apart.

## Store launch

`docs/launch/` has the Play Console guide (`PLAY_CONSOLE.md`), pricing and
growth plan (`GROWTH.md`), listing texts for 8 languages, screenshots and
feature graphics. The privacy policy, terms and landing page are in `docs/`
for GitHub Pages. To regenerate the store graphics:

```
SHOT_LANGS=en,srLatn,hr,bs,sl,mk,bg,ro flutter test --update-goldens --run-skipped --tags screenshots test/screenshots
python3 tool/launch/make_store_graphics.py
python3 tool/launch/check_listing.py
```

## Layout

```
lib/app/          app setup, config (product IDs, URLs, limits)
lib/core/         design tokens and theme, formatting, money, storage, widgets
lib/features/     payroll, credit, fx, business, history, home, onboarding,
                  pro (billing + paywall), reports (PDF), settings, shell
lib/l10n/         ARB files and generated localizations
tool/             l10n scripts, brand asset generator, launch scripts
docs/             website pages, launch kit, archived v1 notes
```
