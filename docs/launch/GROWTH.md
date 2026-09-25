# Bilans — pricing and growth plan

Goal: **500 € a month net** within the first year, then grow from there.

## Why people will pay

The free app is genuinely useful (pay, loans, savings, rates, VAT, margin,
break-even, 3 invoices), which earns installs and reviews. Money comes from
people who use Bilans for work:

1. **Paušalci and freelancers in Serbia** (the core market — around 200,000
   flat-rate entrepreneurs, many of them IT freelancers invoicing abroad in
   EUR). Pro solves recurring pain: unlimited invoices with the NBS IPS QR,
   EUR invoices with the NBS counter-value, and the live 6 / 8 million
   dinar limit tracker. Nothing else on Play does this in one private app.
2. **Small employers and accountants** — team cost, all 9 countries, PDF
   reports for clients.
3. **People comparing loans or job offers** across the region — country
   comparison, loan comparison, early repayment (one-off need, best served
   by the lifetime plan).

## Prices (set in Play Console, see PLAY_CONSOLE.md)

| | Monthly | Yearly (7 days free) | Lifetime |
|---|---|---|---|
| Serbia | 349 RSD | 2,490 RSD | 4,990 RSD |
| Euro markets | 2.99 € | 19.99 € | 39.99 € |

Google keeps **15 %** of subscriptions and of the first $1M of yearly
earnings from one-time purchases (enrol in the 15 % programme in Play
Console for the in-app product).

## The arithmetic

500 € net ≈ **590 € gross** a month. One realistic mix:

| Source | Count | Gross / month |
|---|---|---|
| Yearly subscribers (≈ 21 €/yr) | 200 active | ≈ 350 € |
| Monthly subscribers (≈ 3 €) | 50 active | ≈ 150 € |
| Lifetime purchases (≈ 42 €) | 3 new a month | ≈ 125 € |
| **Total** | | **≈ 625 € gross → ≈ 530 € net** |

At a typical 2–4 % paid conversion for a tool with real work value, that
is **about 7,000–10,000 active users** — roughly 3–5 % of Serbia's
paušalci, before counting the other eight countries.

## Launch plan

**Weeks 1–3 — closed test (required).** 12+ testers for 14 days. Recruit
from people who will really invoice with it: freelancer friends, two or
three accountants. Fix what they report; ask each for an honest review on
launch day.

**Launch week.**
- Post once, personally and without ad-speak, in: Facebook groups for
  paušalci and entrepreneurs in Serbia, IT/freelancer groups, r/serbia and
  r/programiranje, Startit community, LinkedIn. Show the invoice + IPS QR +
  paušal tracker; say it is private and made in Serbia.
- Give accountants **free Pro** with Play *promo codes* (Play Console →
  Promo codes, up to 500 per quarter) — each accountant can recommend
  Bilans to dozens of clients.

**Every month.**
- Reply to every review within a day (in the reviewer's language).
- Keep the rules current: payroll and tax parameters change every January
  (and minimum wages mid-year). Ship the update in the first week of the
  year and announce it — "2027 rules are in" is the strongest reason to
  open the app again.
- Seasonal pushes: January (new rules, new paušal year), October–December
  (paušal limit panic — the tracker is exactly the answer), salary season
  (compare job offers).

## Store optimisation (ASO)

- Titles and short descriptions already lead with the searched words
  (*plata/plaća/заплата*, *kredit*, *faktura/račun*, *kurs*, *EKS*, *PDV*).
- Keywords to repeat naturally in updates' "What's new" and in the full
  descriptions: *kalkulator plate, bruto neto, obračun zarade 2026, kurs
  evra, NBS kurs, faktura, paušal, IPS QR, EKS kredita, prevremena otplata*.
- Run a **store listing experiment** after the first 1,000 installs:
  screenshot order (invoice first vs. pay first) and the feature graphic.
- Run a **price experiment** on the yearly plan after 3 months (e.g.
  2,490 vs. 2,990 RSD).

## What to measure (Play Console)

- Store listing conversion (visitors → installs): aim for 30 %+.
- Trial start rate and trial → paid (Play subscriptions dashboard).
- Monthly churn: under 8 % is healthy for a work tool.
- Android vitals: crash rate under 0.5 %, ANR under 0.2 %.
- Ratings: above 4.5 keeps the listing ranking well.

## What to build next (to raise revenue per user)

1. **SEF (e-Faktura) sending** for VAT payers and public-sector clients —
   the most requested thing Serbian businesses pay for; justifies a higher
   tier.
2. **Several businesses in one app** — for accountants and people with more
   than one company; a natural "Business" tier (e.g. 5.99 €/month).
3. **Recurring invoices and payment reminders** (due date notifications).
4. **Tax calendar** for paušalci (monthly tax and contribution deadlines).
5. **Home-screen widget** with today's NBS rates.
