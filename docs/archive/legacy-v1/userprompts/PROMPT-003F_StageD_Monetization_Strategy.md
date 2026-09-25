# PROMPT-003F: Stage D Go-Ahead — Monetization Strategy (Production-Ready)

Status: Active go-ahead. Register in PROMPTS.md. Stage C (items
11→12→13→10) is fully closed. This prompt makes the two previously-open
calls (ads at launch, exact pricing) so implementation can start without
further product decisions blocking it. All existing rules stay in
force: session-start read order, 9-language l10n lockstep, real tests,
`flutter analyze` clean, honest reporting, one increment at a time,
checkpoint discipline, clean service boundaries.

---

## Decision 1 — No ads at launch (final)

**Launch ad-free.** Do not integrate an ad SDK in this pass.

Rationale, from current data on indie app monetization: ad-based apps
average roughly **$0.01–$0.10 revenue per install**, while freemium/
subscription apps in professional-utility and fintech-adjacent
categories average **$1.50–$10+ per install** — a 20–100x gap driven by
category and audience, not effort. Ads are consistently reported as "the
worst choice" for indie developers relative to subscriptions, because ad
fill rates and eCPMs in smaller/lower-income markets (this app's entire
footprint) are weak, while the compliance/cross-border tools this app
offers are exactly the kind of "ongoing professional value" that
converts on subscription instead. On top of the economics, ads sitting
near tax thresholds or compliance figures would directly undermine the
sourcing-trust standard already built into every other feature.

This is not permanent — it's sequencing. Revisit only if, after real
usage data (30+ days post-launch), free-tier retention and Pro
conversion both suggest the free tier needs a soft monetization layer;
if so, the fallback is a single static banner on list-type screens only,
never interstitial, never on a calculator/compliance screen, removable
by any paid plan. Do not build ad infrastructure speculatively now.

---

## Decision 2 — Pricing (final, ready to configure in Play Console)

| Plan | Base price (USD/EUR reference) | Notes |
|---|---|---|
| Monthly | $3.99 / EUR 3.99 | Entry point; visually anchors annual as the better deal |
| Annual | $19.99 / EUR 19.99 (≈ $1.67/mo) | Primary target plan — default-selected on the paywall |
| Lifetime | $49.99 / EUR 49.99 (one-time) | ~2.5x annual; counters subscription fatigue, targets high-intent price-sensitive users |
| Support the developer | $2.99 / EUR 2.99 (one-time, no feature gate) | Matches your existing sponsor/donation preference; optional, non-blocking add |

**Set these as the base price and let Google Play's regional pricing
template auto-convert per country** rather than hand-setting each of
the 9 markets — Play's PPP-based templates already map a ~$19.99 tier
to roughly EUR 8.49–11.99 in Balkan markets (Serbia, Bosnia,
Bulgaria, Croatia), which matches what comparable regional apps already
charge and avoids both overpricing and undervaluing the work. Do not
manually discount below Play's auto-generated regional price — that
template already accounts for local purchasing power.

Free trial: 7-day free trial on the annual plan only (not monthly, not
lifetime) — long enough to reach the "aha moment" (a real threshold
warning or a real cross-border comparison result), short enough to
avoid trial-abuse churn.

---

## Tier structure (unchanged from prior draft, now final)

**Free — must stay genuinely useful:**
- Full salary/net-pay calculator, home country only.
- Full manual budget/expense tracking and basic invoice tracker.
- QR scanner shell (item 10) and manual expense handoff — stays free,
  it was built as a core feature.
- One saved cross-border comparison at a time.

**Pro — the specialized, high-effort differentiators:**
- All 9 countries' full calculator/adapter set.
- Unlimited cross-border comparisons + employer-cost view (item 13).
- Invoice PDF generation + NBS IPS QR embedding (item 12).
- Full paušal/PDV compliance pack: dual-threshold turnover tracker,
  monthly obligation reminders, Model A/B comparator (item 11).

---

## Implementation checkpoints

1. **Checkpoint 1 — entitlement plumbing.** Single `EntitlementService`
   boundary wired to Play Billing (products: monthly, annual w/ 7-day
   trial, lifetime, support-IAP). No paywall UI yet. Tests: entitlement
   state transitions (free/trialing/pro/lifetime/expired), offline grace
   handling (cached entitlement must hold through no-connectivity
   periods — this is an offline-first app, never hard-lock mid-session
   on a network check).
2. **Checkpoint 2 — gate Pro features + paywall.** Wire the Pro feature
   list above behind the entitlement service. Build the paywall screen,
   localized across all 9 languages, annual plan visually favored
   (larger card, "best value" label, per-month equivalent shown), 7-day
   trial called out clearly, lifetime and support-IAP as secondary
   options below the fold. Trigger the paywall contextually (e.g., when
   a free user taps a second country or the invoice-PDF button), not on
   cold start.
3. **Checkpoint 3 — regional pricing + release evidence.** Configure the
   four products in Play Console at the base prices above with regional
   auto-pricing enabled for all distributed countries. Full regression:
   test suite, `flutter analyze`, l10n parity (new paywall strings ×9),
   per-ABI size check (billing library adds some weight — report
   honestly per the D-032 precedent). Push.
4. **STOP after checkpoint 3.** Report conversion-relevant setup
   (product IDs, trial config, paywall trigger points) so real usage
   data can be reviewed before any decision to revisit ads.

## Report format (each checkpoint)

Implemented / tested / l10n key count / `flutter analyze` status /
per-ABI size / entitlement states covered / Play Console product config
confirmed / DECISIONS.md entries (final pricing, ads-at-launch: no,
sponsor-IAP: yes) / what's next.
