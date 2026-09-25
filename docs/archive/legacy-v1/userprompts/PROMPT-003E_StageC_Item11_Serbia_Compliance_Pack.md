# PROMPT-003E: Stage C Item 11 — Serbia Paušal & Freelancer Compliance Pack

Status: Active. Narrows and supplies the sourced figures for PROMPT-003
item 11 / PROMPT-003D "Item 11". Register in PROMPTS.md. All existing
rules stay in force: session-start read order, 9-language l10n lockstep,
real tests (`flutter test -j 1`), `flutter analyze` clean, honest
reporting, one increment at a time, checkpoint discipline, no
monetization gating yet (clean service boundary only).

Stage C housekeeping (per-ABI sizes, device-unverified checklist) is
already closed — do not redo it.

---

## Before you write code

1. **Audit first.** Read the existing invoice tracker model, the stored
   FX-rate layer, the local notification service and the existing tax
   engines. Reuse them. Report anything that already covers part of this
   item and close only the gap.
2. If any figure below conflicts with what is already in the codebase,
   stop and report the conflict rather than silently overwriting.

---

## Sourced figures — Serbia, 2026 (use exactly these, with these labels)

All amounts RSD. Every constant must carry an official-source reference
and an effective-date label in code and in the UI, per the existing
sourcing standard.

### Freelancer self-taxation (samooporezivanje frilensera, PP OPO-K)

Normative expenses (normirani troškovi), **effective 1 February 2026**:

| Item | Value | Effective |
|---|---|---|
| Model A (Model 1) normative expense | 110,647 / quarter | 1 Feb 2026 (was 107,738) |
| Model A tax rate | 20% of base | 2026 |
| Model B (Model 2) fixed normative expense | 66,733 / quarter | 1 Feb 2026 (was 64,979) |
| Model B additional normative expense | 34% of quarterly gross | 2026 |
| Model B tax rate | 10% of base | 2026 |
| PIO (pension) | 24% | 2026 |
| Health | 10.30%, only if not insured elsewhere | 2026 |
| Model B minimum PIO base | 3 × lowest monthly base = 153,891 / quarter | 2026 |
| Lowest monthly contribution base | 51,297 (35% of 146,564 average salary) | 2026 |
| Highest monthly contribution base | 732,820 (annual 8,793,840) | 2026 |

Sources: the increased 1 Feb 2026 normative amounts and both models'
mechanics are published by [Poreska uprava's freelancer FAQ](https://frilenseri.purs.gov.rs/lat/najcesca-pitanja.html?position=2)
and reported with the before/after amounts by
[Creative Finance](https://creativefinance.rs/od-1-februara-povecani-iznosi-normiranih-troskova-za-frilensere/)
and [Biznis.rs](https://biznis.rs/vesti/srbija/frilenserima-povecani-iznosi-normiranih-troskova-od-1-februara/);
the 2026 minimum base of 51,297 is published by
[Porezi.rs](https://www.porezi.rs/statisticki_podaci/2026/pregled-najnizih-osnovica-za-obracun-doprinosa-2026)
and [IPC](https://www.ipc.rs/vest/najniza-mesecna-osnovica-za-placanje-doprinosa-za-2026-godinu-iznosi-51297-dinara_v2386),
and the maximum base by the [PIO Fund](http://www.pio.rs/sr/vesti/nove-osnovice-u-2026-godini-chlan-15-zakona-o-pio).

Formulas (per quarter; contributions are **not** deducted from the tax
base — tax and contributions are both computed on the same
normative-reduced base):

```
# Model A
base_A   = max(0, gross_quarter - 110_647)
tax_A    = 0.20 * base_A
pio_A    = 0.24 * base_A
health_A = 0.103 * base_A   if not insured elsewhere else 0
net_A    = gross_quarter - tax_A - pio_A - health_A

# Model B
norm_B   = 66_733 + 0.34 * gross_quarter
base_B   = max(0, gross_quarter - norm_B)
tax_B    = 0.10 * base_B
pio_B    = 0.24 * max(base_B, 153_891)      # 3x lowest monthly base
health_B = 0.103 * base_B   if not insured elsewhere else 0
net_B    = gross_quarter - tax_B - pio_B - health_B
```

The model election is made per quarter on PP OPO-K, so the comparator is
a **per-quarter** tool, not an annual one. Filing/payment deadline: within
30 days of quarter end — 30 Apr / 30 Jul / 30 Oct / 30 Jan
([PURS freelancer FAQ](https://frilenseri.purs.gov.rs/lat/najcesca-pitanja.html?position=2)).

### Thresholds — two different limits, two different measurement windows

This distinction is the whole point of the tracker; get it exactly right.

| Limit | Value | Window | Consequence |
|---|---|---|---|
| Paušal ceiling | 6,000,000 | **calendar year** total income | loses paušal status |
| PDV (VAT) registration | 8,000,000 | **rolling previous 12 months** | mandatory VAT registration within 5 days; also disqualifies from paušal |

The 6,000,000 calendar-year paušal ceiling comes from Zakon o porezu na
dohodak građana čl. 40 and the 8,000,000 VAT threshold from Zakon o PDV
čl. 38, as set out by [Cica Pravnica](https://cicapravnica.rs/pravni-saveti/pausalno-oporezivanje-preduzetnika);
the rolling-12-month (not calendar-year) measurement of the VAT threshold
is confirmed by [Platni Listić](https://www.platnilistic.rs/blog/pdv-prag-preduzetnik),
[Fakturko](https://fakturko.io/blog/ulazak-u-pdv-sistem-2026-prag-rokovi-i-sef)
and [Zunic Law](https://zuniclaw.com/pdv-registracija-u-srbiji/), and the
two limits are contrasted directly by [Capitaale](https://capitaale.com/en/blog/pdv-registracija-2026).
Paušal application deadline for the following year is 31 October
([PURS](https://www.purs.gov.rs/lat/odnosi-s-javnoscu/novosti/4608393/rok-za-podnosenje-zahteva-za-pausalno-oporezivanje-za-2026-godinu.html)).

### Paušal charge

Monthly amount is a **tax-ruling figure**, not something the app may
compute: deemed base = average salary × activity coefficient (0.15–0.55)
× zone coefficient (0.6–1.0), with statutory reductions. Total charge on
the deemed base = 10% tax + 24% PIO + 10.3% health + 0.75% unemployment =
**45.05%** ([PURS informator](https://www.purs.gov.rs/upload/media/2025/3/13/759186/Poreski_informator_za_fizicka_lica_koja_obavljaju_samostalnu_delatnost_mart_2025.pdf);
[Otvori Firmu](https://otvorifirmu.rs/pausalno-oporezivanje-vodic/)).
Payment is due **monthly by the 15th of the following month**, and the KPO
turnover book is mandatory ([Cica Pravnica](https://cicapravnica.rs/pravni-saveti/pausalno-oporezivanje-preduzetnika)).

**Therefore:** the user enters their assessed monthly paušal amount from
their tax decision (rešenje) — the app stores and reminds, it does not
derive it. Optionally show the 45.05% decomposition of the amount the
user entered, clearly labelled as an explanation of the ruling, not a
calculation of it.

---

## What to build

### 11.1 — Paušal turnover tracker

- Fed by the **existing invoice tracker**; no new data entry surface for
  turnover beyond what already exists (plus a manual adjustment entry if
  the model needs one — justify it).
- Track **both** limits simultaneously with their correct windows
  (calendar-year 6M, rolling-12-month 8M) and show both.
- Early-warning states at **70 / 85 / 95%** of each limit, plus an
  exceeded state. Colour + text, never colour alone (accessibility rule).
- Foreign-currency invoices convert at the **invoice-date** rate from the
  stored rate history. If no stored rate exists for that date, do **not**
  silently substitute today's rate: mark the invoice as
  "rate unavailable", exclude it from the tracked total, and surface the
  count of excluded invoices prominently. Honest gaps over fake totals.
- Tap-through explanation of how the total was computed (existing rule):
  which invoices, which rates, which dates, which window.
- Projection: at current pace, the date the limit would be reached —
  label it clearly as a projection, and only show it once there is enough
  data to be meaningful.

### 11.2 — Monthly obligation reminder

- Uses the **existing local notification system**. Due the 15th; fire the
  reminder with the user's chosen lead time (default: on the 15th, plus
  an optional 3-days-before). **Off by default**, one switch, fully
  localized, same pattern as every other reminder.
- Include the user's stored assessed amount in the notification body when
  it is set.
- Respect the existing DST/timezone and reschedule-on-boot handling — do
  not invent a second scheduling path.

### 11.3 — Model A vs Model B quarterly comparator

- Input: quarterly gross, "insured elsewhere?" toggle, quarter selector.
- Output: side-by-side tax / PIO / health / total burden / net for both
  models, the recommended model, and the delta. Show the Model B minimum
  PIO base whenever it binds — that is exactly the case users get wrong.
- Effective-date label ("normative expenses valid from 1 Feb 2026") and
  the source link, per the trust-surface standard.
- Show the formula breakdown on tap, like every other engine.
- Deadline hint for the selected quarter (30 Apr / 30 Jul / 30 Oct /
  30 Jan).

### Exclusions — record in OPEN_QUESTIONS.md, do not guess

Apply the Samooporezivanje precedent: exclude and document rather than
approximate.

1. **Paušal deemed-base coefficients** (activity 0.15–0.55, zone
   0.6–1.0, and the statutory reductions) — not published as a complete,
   citable machine-readable table; the app must not compute the assessed
   amount. User enters it from their rešenje.
2. **Supplementary annual PIT** (10% above 3× and 15% above 6× the
   average annual salary, per [PwC](https://taxsummaries.pwc.com/serbia/individual/taxes-on-personal-income))
   — out of scope for this pass; note it as a known future addition.
3. The **10%-per-year cap on paušal contribution-base growth for 2026–2027**
   is reported by practitioners but I have not sourced it to an official
   gazette text — exclude from any calculation, and note it.
4. Other countries' paušal equivalents — deliberately out of scope
   (Croatia paušalni obrt etc. follow later, same pattern).

---

## Testing bar

- Unit tests for both models across the interesting ranges: gross below
  the normative expense (zero tax, contributions still due), the
  crossover point where A beats B and vice versa, the Model B minimum-PIO
  binding region, and zero/negative-guard inputs.
- Tracker tests: calendar-year vs rolling-12-month window behaviour
  across a year boundary, each threshold state (70/85/95/exceeded),
  multi-currency conversion using stored invoice-date rates, and the
  missing-rate exclusion path.
- Reminder tests: scheduled date computation for the 15th including
  month-length edges, and default-off behaviour.
- No test may assert a figure not in the table above.

## Report format (then STOP)

Implemented / tested (`flutter test -j 1` count) / l10n key count across
all 9 languages / `flutter analyze` status / per-ABI size only if a
release build was run / OPEN_QUESTIONS.md additions / DECISIONS.md
entries / what's next.

Then stop and await approval before item 12 (Invoice PDF + NBS IPS QR).
