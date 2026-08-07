# PROMPT-003: Market-Ready Commercial Excellence Addition

Status: Active — applies AFTER Phase 11 completes and alongside/after the
Phase 12 report. Does NOT override PROMPT-002's offline-first gate; it
extends it with a commercial-readiness layer and a prioritized
differentiator roadmap. Where anything below conflicts with PROMPT-002,
PROMPT-002 wins until I explicitly approve online features.

---

## The prompt (paste into Claude Code)

You are continuing work on Salary & Currency Pro (C:\salary-currency-pro).
Read CLAUDE.md, PROJECT_RULES.md, PROJECT_CONTEXT.md, DECISIONS.md,
PROMPTS.md, and the latest session log first, as always. This prompt is
PROMPT-003 — record it in PROMPTS.md as Active, scoped as an extension of
PROMPT-002 (not a replacement). All existing rules still apply: 9-language
l10n lockstep, real tests (`flutter test -j 1`), `flutter analyze` clean,
no fabricated completion claims, offline-first as a hard constraint,
minimal tightly-scoped increments, honest phase-end reports.

### Mission

Take the app from "complete offline product" to "the best-in-class Balkan
finance app a paying customer would choose over every alternative." Work
in the numbered stages below, in order, one increment at a time. Before
building anything, audit whether it already exists in the codebase —
never rebuild working features.

### Stage A — Commercial trust & first impression (highest priority)

The app will live or die on its first 60 seconds and its Play Store page.

1. **Onboarding (max 3 screens):** country + language auto-detected from
   device locale with manual override; one screen stating the privacy
   promise ("Your data never leaves your phone. No account. No cloud.");
   one screen letting the user pick their primary goal (salary math /
   expense tracking / freelancer-business) which sets the default home
   tab. Skippable at every step.
2. **Trust surface:** a "Why trust this app?" section in Settings —
   where each country's tax formulas come from (official sources, with
   effective-date labels), when rates were last updated in the app, and
   the offline/privacy explanation that already exists. Every calculator
   result screen shows a small "rates valid for YYYY" label.
3. **Performance & size budget:** release build with `--split-per-abi`,
   R8/resource shrinking; cold start under 2s on a low-end device
   profile; every list virtualized; no jank on a 60Hz budget phone.
   Report actual release APK/AAB sizes per ABI — the 158MB debug figure
   must never be confused with release size. Target < 30MB per-ABI AAB
   download size; investigate and report if exceeded.
4. **Play Store readiness checklist** (produce as a report + fix what is
   in-code): data-safety-form answers derived from actual code behavior
   (no data collected — verify no SDK contradicts this except AdMob, and
   document exactly what AdMob collects and the consent flow required in
   EEA — UMP consent SDK); adaptive icon; localized store listing text
   drafted for all 9 languages saved to /store_listing/; screenshot
   shot-list description (which screens, which locale, light+dark).

### Stage B — Retention mechanics (what makes people open it weekly)

5. **Recurring transactions:** rent, salary, subscriptions — define once,
   auto-post on schedule fully offline, with a review-before-post option.
   This is the single highest-retention feature a tracker can have.
6. **Subscription/fixed-cost radar:** a screen aggregating recurring
   costs, monthly total, and "price of everything you're subscribed to
   per year" — a known conversion moment for finance apps.
7. **Local notifications (offline, no backend):** optional reminders —
   log-your-expenses nudge (user-set schedule), budget threshold crossed
   (80%/100%), invoice due/overdue, and Serbian paušal monthly payment
   reminder (15th of month, see Stage C). All off by default, one switch
   each, fully localized.
8. **Home-screen widget (Android):** this-month spend vs budget at a
   glance; a second small widget for a pinned currency pair. Keep both
   battery-cheap (WorkManager refresh, no polling).
9. **Financial mirror moments:** after enough data exists, the dashboard
   surfaces one plain-language insight at a time ("Dining is 23% of your
   spending this month, up from 15%") — computed locally, honest, and
   every insight must show how it was calculated on tap (existing rule).

### Stage C — Balkan differentiators (what no competitor combines)

These are the features that justify "best Balkan app on the market."
Implement offline-capable parts now; anything requiring a network call is
DESIGN + UI + queued-offline behavior now, with the single network fetch
implemented only after I approve it in the Phase 12 review (same
exception model as currency rates — one endpoint, degrade gracefully).

10. **Fiscal receipt QR import (killer feature):** Serbian fiscal
    receipts carry a QR code linking to suf.purs.gov.rs which returns
    full receipt data (merchant, line items, totals, VAT) — an official,
    public verification endpoint. Camera scan → parse URL → (network
    fetch, gated as above) → prefill an expense with merchant, amount,
    date, category suggestion; store the receipt locally for warranty/
    bookkeeping. Croatia (JIR / mPorezna-style verification) and
    Montenegro have analogous systems — architect the scanner around a
    per-country adapter so more countries can be added. Offline behavior:
    scan queues the receipt and imports when back online. Even
    scan-and-store-raw (no fetch) is useful day one and fully offline.
11. **Paušal & freelancer compliance pack (Serbia first, then region):**
    - running paušal turnover tracker vs the 6,000,000 RSD annual limit
      (and 8M PDV limit), fed by the existing invoice tracker, with
      early-warning thresholds (70/85/95%) — foreign-currency invoices
      converted at the invoice-date rate;
    - monthly obligation reminder (due 15th);
    - frilenser Model A vs Model B quarterly comparison calculator using
      the same sourced-formula standard as the rest of the app (label
      effective dates; if a formula can't be sourced to standard, exclude
      it and say so — existing Samooporezivanje precedent).
    Croatia paušalni obrt and other countries' equivalents follow the
    same pattern later — one country done excellently first.
12. **Invoice PDF + IPS QR:** generate a clean, professional PDF invoice
    from the existing invoice tracker (fully offline), and for Serbian
    RSD invoices embed an NBS IPS QR code so the client can pay by
    scanning with any mBanking app — QR generation is a local encoding,
    no network needed. This turns the invoice tracker from a list into a
    tool businesses actually rely on.
13. **Cross-border pack:** net-salary comparison across the 9 countries
    for the same gross/total-cost (already have the engines — build the
    comparison UI); a "cost of employment" employer view; per-diem and
    mileage official rates per country where sourceable.

### Stage D — Monetization architecture (build it honest)

14. **Three tiers:**
    - FREE: all calculators, basic tracking, banner/native ads (never
      interstitials inside data-entry flows), currency converter.
    - PRO subscription (monthly/annual, regional pricing via Play
      pricing templates — Balkan price points, annual heavily favored):
      removes ads, unlocks recurring transactions, widgets, receipt QR
      import, invoice PDF+IPS QR, paušal pack, unlimited budgets/goals,
      all export formats.
    - LIFETIME one-time purchase at ~3–4x annual: Balkan users are
      subscription-averse; a fair lifetime option is a trust signal and
      a real revenue line. Businesses can expense it.
15. **Paywall rules:** gate on value moments, not timers — e.g. the
    third budget, the first PDF invoice, the first receipt scan offer
    Pro contextually with a one-screen, honest paywall (what you get,
    price, restore-purchases, no fake urgency, no fake testimonials —
    existing rule). Free tier must remain genuinely useful forever.
16. **Implementation:** `in_app_purchase` with local entitlement cache so
    Pro works offline after purchase verification; a single
    EntitlementService consulted everywhere; test fake-store flows.
    AdMob: real ad-unit IDs remain a user task — keep test IDs until I
    supply real ones, and keep the swap a one-file change.

### Stage E — Delight & polish beyond Phase 11

17. Material 3 dynamic color (Material You) with the existing theme
    system as fallback; dark mode audited on every screen; larger-font
    and TalkBack pass on the money-entry flows.
18. Micro-animations only where they communicate (number count-ups on
    results, budget bar fills) — nothing decorative that costs jank.
19. Local backup/restore to a single encrypted file the user can save
    anywhere (Storage Access Framework) — the missing piece of the
    privacy story ("your data, your file"). Auto-reminder to back up
    monthly. This is also the migration path for future sync.

### Working rules for this prompt

- One increment at a time; after each, report: implemented / tested /
  l10n key count / analyze status / what's next. Update DECISIONS.md and
  session logs per existing rules.
- Any feature needing a network call beyond currency rates: build the
  offline shell, mark the fetch point clearly, and STOP for my approval —
  list it in the Phase 12 report instead of implementing.
- If a stage item already exists (fully or partly), audit it against this
  bar, close only the gap, and say what was already done.
- Never let feature count degrade speed, size, or clarity — if an
  addition harms the performance budget in Stage A item 3, it doesn't
  ship until it fits.
- Every new tax/compliance number must be sourced to the same standard as
  the existing engines, with effective dates; unsourceable → exclude and
  document in OPEN_QUESTIONS.md.
