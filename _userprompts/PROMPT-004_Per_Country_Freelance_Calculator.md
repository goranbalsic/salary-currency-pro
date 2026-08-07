# PROMPT-004: Per-Country Freelancer Calculator + Store Listing De-Serbianisation

Status: Active. Record in PROMPTS.md. Extends PROMPT-003 (Stage A trust
surface); does NOT override PROMPT-002's offline-first gate — the design
below is offline-first by construction. All existing rules apply:
9-language l10n lockstep, real tests (`flutter test -j 1`),
`flutter analyze` clean, no fabricated completion claims, minimal
tightly-scoped increments, honest phase-end reports.

---

## The prompt (paste into Claude Code)

You are continuing work on Salary & Currency Pro (C:\salary-currency-pro).
Read CLAUDE.md, PROJECT_RULES.md, PROJECT_CONTEXT.md, DECISIONS.md,
PROMPTS.md and the latest session log first, as always. This is
PROMPT-004. Work the parts in order. Do not start Part 3 until Part 2 is
green.

### The defect

Every localized store listing in `/store_listing/` carries this bullet,
translated but not localized:

> „Kalkulator samooporezivanja za srpske frilensere koji prijavljuju
> strani prihod (PP OPO-K)."
> bg.md line 35–36: „Калкулатор за самооблагане за сръбски фрийлансъри,
> декларирали чуждестранен доход (PP OPO-K)."

`PP OPO-K` is a Serbian Tax Administration form. To a Bulgarian,
Romanian, Albanian or Slovenian reader this sentence is noise that says
"this app is not for you" — in a listing whose entire pitch is "9
countries, your language." It is also a product gap, not just copy: the
app ships one Serbia-only freelancer calculator while claiming
nine-country coverage.

Fix both. Copy first (cheap, ships immediately), then the feature.

---

### Part 1 — Store listing fix (all 9 locales)

Replace the offending bullet in every file in `/store_listing/` with the
country-neutral version below. Use the exact strings — they are already
translated and reviewed. Do not re-translate, do not paraphrase.

- **en** — Self-assessment tax calculator for freelancers in your country
  — income tax and social contributions on self-employed income, using
  local rules and the local filing form.
- **bg** — Калкулатор за самооблагане на фрийлансъри във вашата държава —
  данък върху дохода и осигуровки върху доходите от свободна професия, по
  местните правила и с местната декларация.
- **sr** — Kalkulator samooporezivanja za frilensere u vašoj zemlji —
  porez na dohodak i doprinosi na prihod od samostalnog rada, po lokalnim
  pravilima i sa lokalnom prijavom.
- **hr** — Kalkulator samooporezivanja za freelancere u vašoj zemlji —
  porez na dohodak i doprinosi na prihod od samostalnog rada, prema
  lokalnim pravilima i s lokalnom prijavom.
- **bs** — Kalkulator samooporezivanja za frilensere u vašoj zemlji —
  porez na dohodak i doprinosi na prihod od samostalne djelatnosti, prema
  lokalnim pravilima i sa lokalnom prijavom.
- **mk** — Калкулатор за самооданочување за фриленсери во вашата земја —
  данок на доход и придонеси на приходот од самостојна дејност, според
  локалните правила и со локалната пријава.
- **sl** — Kalkulator samoobdavčitve za samozaposlene in freelancerje v
  vaši državi — dohodnina in prispevki od dohodka iz samostojne
  dejavnosti, po lokalnih pravilih in z lokalnim obrazcem.
- **sq** — Llogaritës i vetëtatimit për të vetëpunësuarit në vendin tuaj —
  tatimi mbi të ardhurat dhe kontributet për të ardhurat nga puna e
  pavarur, sipas rregullave dhe formularit vendas.
- **ro** — Calculator de autoimpunere pentru freelanceri din țara ta —
  impozitul pe venit și contribuțiile sociale pentru veniturile din
  activități independente, conform regulilor locale și cu declarația
  locală.

Then sweep the rest of `/store_listing/` for the same class of leak: any
single-country reference, form name, currency or institution appearing in
a file for a different country. Check the short description, the
"what the app offers" list, the differentiator paragraph, and the
screenshot shot-list captions. Report every instance you find and fix,
even if you judge it harmless.

---

### Part 2 — Rules data layer: remote-first, free, offline-safe

Read this section fully before writing code. The architecture matters
more than the arithmetic.

**Be clear about what "realtime" can honestly mean here.** Tax law is not
a live feed. There is no free API that returns Bulgaria's 2026
contribution ceiling. An app that tried to read tax-authority websites at
runtime would be slow, fragile, legally uncomfortable, and would break
offline-first. Do not attempt it, and do not add any paid data service.

What you build instead — remote-updatable rules with a bundled fallback:

1. **Single source of truth: `tax_rules.json`**, a versioned file with a
   `schema_version`, a `rules_version` (ISO date), and one entry per
   country. Every numeric value carries `effective_from` and a `source`
   URL. No tax constant may live in Dart code — if a rate is hardcoded in
   a widget or a service, that is a bug.
2. **Bundled copy** at `assets/tax_rules.json`, shipped in the APK. This
   is what a fresh install with no network uses. The app is fully
   functional with only this file.
3. **Remote copy** hosted free and statically. Use **GitHub Pages or the
   raw URL of a public repo** (`raw.githubusercontent.com/<user>/<repo>/main/tax_rules.json`)
   — zero cost, no server, no account, no backend to maintain, CDN-backed.
   Do not stand up an API, a Firebase project, or anything with a bill.
   Put the URL in a single constant so it can be changed in one place.
4. **Fetch policy:** on app start, at most once every 24h, fire a
   background fetch with a short timeout (≤5s). Never block startup,
   never show a spinner for it, never fail loudly. If the fetched
   `rules_version` is newer and the payload validates against the schema,
   write it to app storage and use it from the next calculation onward.
   Any error — offline, 404, malformed JSON, schema mismatch — is
   silently ignored and the previous good copy stays in use.
5. **Precedence:** downloaded copy → bundled copy. Never the reverse, and
   never a partial merge.
6. **Surface it in the trust UI** (the PROMPT-003 Stage A "Why trust this
   app?" section): show `rules_version`, whether it came from the bundle
   or an update, and the per-country `effective_from` and source link.
   Every calculator result already shows a "rates valid for YYYY" label —
   drive that label from this data, not from a string constant.
7. This mechanism is for **tax rules only**. Currency rates keep their
   existing live-fetch-with-last-known-fallback path. Do not merge them.

**Why this satisfies the requirement:** rates update over the air without
a Play Store release, cost nothing to run, and the app still works on a
plane. When North Macedonia's contribution rate changes in December or
Slovenia's flat amounts move on 1 April, you edit one JSON file in a
public repo and every installed app picks it up within a day.

---

### Part 3 — Per-country freelancer calculator

One calculator screen, country-switched (default = the user's selected
country, same selector the salary calculators use). Nine countries, with
Bosnia and Herzegovina split into FBiH and Republika Srpska as separate
selectable regimes.

**The formulas are NOT variations on one template.** The order of
operations genuinely differs by country and a shared formula will produce
wrong numbers. Implement each as its own strategy class behind a common
interface, each with its own unit tests. Specifically:

- **Bulgaria** deducts the 25% statutory expense allowance first,
  computes contributions on the reduced amount, then deducts those
  contributions again to reach the tax base.
- **Serbia** applies the normative deduction once and charges both tax
  and contributions on that same base; contributions are NOT deductible.
  Two models exist and the user picks per quarter — compute both and show
  which is better.
- **Romania** computes contributions on statutory ceilings (not on actual
  income) and they ARE deductible from the tax base.
- **Albania, FBiH, Republika Srpska** treat contributions as ordinary
  business expenses.
- **Croatia paušal, Slovenia popoldanski s.p., Albania, both BiH
  entities** charge contributions on a fixed statutory base that does not
  scale with income at all.

**Cliff warnings are a feature, not a nicety.** Where crossing a
threshold changes the regime, the result screen must warn before and
after, not silently compute:

- Albania: 0% income tax up to ALL 14,000,000 turnover, then 15%/23% — an
  all-or-nothing cliff
- Slovenia: 80% deemed expenses up to EUR 60,000, 0% above
- Serbia: RSD 6,000,000 paušal ceiling
- Montenegro: EUR 30,000 paušal ceiling
- Romania: EUR 25,000 normă de venit ceiling
- Plus each country's VAT registration threshold

**Seed data.** The 2026 research below is your starting content for
`tax_rules.json`. It is sourced and dated. Transcribe it faithfully —
including the `n.a.` gaps, which must render as "not available" in the
UI rather than as zero. Do not invent values to fill them.

---

### Seed rules (2026) — transcribe into tax_rules.json

**Serbia** (RSD) — Samooporezivanje frilensera, PP OPO-K, quarterly,
within 30 days of quarter end. Model 1: 20% tax after RSD 110,647/quarter
normative expenses. Model 2: 10% tax after RSD 66,733 + 34% of gross;
PIO minimum base 3 × RSD 51,297 per quarter. Contributions PIO 24%,
health 10.30%, unemployment 0.75%. Min monthly base RSD 51,297, max
monthly RSD 732,820, max annual RSD 8,793,840. VAT threshold RSD
8,000,000 rolling 12m. Paušal ceiling RSD 6,000,000, total burden 45.05%
of the deemed base. Normative expenses changed 1 February 2026.
Sources: https://frilenseri.purs.gov.rs/lat/najcesca-pitanja.html?position=2 ,
https://www.purs.gov.rs/upload/media/2025/3/13/759186/Poreski_informator_za_fizicka_lica_koja_obavljaju_samostalnu_delatnost_mart_2025.pdf ,
http://www.pio.rs/sr/vesti/nove-osnovice-u-2026-godini-chlan-15-zakona-o-pio

**Bulgaria** (EUR — euro adopted 1 Jan 2026 at 1.95583 BGN) — Свободна
професия. 10% flat. Normative expenses 25% (40% lawyers/journalists/
artists, 60% unprocessed agricultural). Pension 19.8% if born before
1960, else 14.8% + 5% UPF; health 8%; sickness 3.5% optional. Min base
EUR 550.66/month, max EUR 2,111.64/month. VAT threshold EUR 51,130. Annual
declaration Art. 50 ZDDFL, Appendix 3 (form 2031), 10 Jan–30 Apr; 5%
discount (max BGN 500) if e-filed and paid by 31 March.
Sources: https://nra.bg/wps/wcm/connect/agency/site/taxes/danak-vurhu-dohodite-na-fizicheski-lica/svobodni-profesii ,
https://nra.bg/wps/portal/nra/osiguryavane/osiguritelen-dohod-2 ,
https://nra.bg/wps/portal/nra/taxes/dds-v-balgariya/registratsiya-po-zdds

**Croatia** (EUR) — Paušalni obrt: deemed income 15% of receipts taxed at
12% ≈ 1.8% of receipts. Statutory brackets (receipts → annual base →
annual tax): 0–11,300 → 1,695 → 203.40; 11,300–15,300 → 2,295 → 275.40;
15,300–19,900 → 2,985 → 358.20; 19,900–30,600 → 4,590 → 550.80;
30,600–40,000 → 6,000 → 720; 40,000–50,000 → 7,500 → 900; 50,000–60,000
→ 9,000 → 1,080. Paid in 4 quarterly instalments. Contributions on a
FIXED base of EUR 797.20/month (MIO I 15% + MIO II 5% + health 16.5%) =
EUR 290.98/month; 17.5% of the annual deemed base if it is a second
activity alongside employment. Min monthly base EUR 757.34, max
EUR 11,958.00, max annual EUR 143,496.00. VAT threshold and paušal
ceiling both EUR 60,000. PO-SD by 15 January, DOH by end of February.
Drugi dohodak: 30% flat expenses, then MIO 10%, then local rate on the
remainder.
Sources: https://porezna-uprava.gov.hr/hr/porezna-osnovica-i-stope/4775 ,
https://www.teb.hr/novosti/2025/osnovice-za-obracun-doprinosa-u-2026-godini/ ,
https://stuasistent.hr/porezni-razredi-i-doprinosi-za-pausalne-obrte-u-2026-godini/

**Bosnia and Herzegovina — FBiH** (BAM) — Samostalna djelatnost, 10%
flat. No normative deduction; personal allowance KM 300/month = KM
3,600/year, dependant coefficients spouse 0.5, first child 0.5, second
0.7, third+ 0.9, disability 0.3. Contributions 36.0% (PIO 19.5% + health
14.5% + unemployment 2.0%) on a statutory base: free professions KM
2,710.00/month → KM 975.60/month; obrt and similar KM 1,602.00;
agriculture/forestry and trgovac pojedinac KM 715.00; lump-sum obrt KM
1,355.00; traditional crafts/taxi KM 616.00. Max base `n.a.`
Contributions ARE deductible. Annual form GIP. VAT KM 100,000
(state-level, raised from 50,000 effective 2 Dec 2023 — many guides still
quote the old figure).
Sources: https://mojobrt.ba/blog/osnovice-za-doprinose-slobodna-zanimanja-2026 ,
https://feb.ba/wp-content/uploads/2026/02/16_02_2026_PRECISCENI-Pravilnik-o-primjeni-Zakona-o-porezu-na-dohodak-12-26.pdf

**Bosnia and Herzegovina — Republika Srpska** (BAM) — Mali preduzetnik:
KM 600/year if revenue ≤ 50,000; KM 1,200/year for 50,000–100,000;
otherwise 10% on real profit. Contributions 31.0% (PIO 18.5% + health
10.2% + unemployment 0.6% + child protection 1.7%). Base = 70% of the
prior-year average gross salary — the planned rise to 80% from 1 Jan 2026
was REPEALED by Sl. glasnik RS 114/25. 2025 average KM 2,349 → base KM
1,644.30/month → KM 509.73/month. Independent professions 100% of average
→ KM 728.19/month. Supplementary activity and pensioners: PIO only on 30%
of average → KM 130.37/month. Minimum total burden KM 6,680.28/year (KM
7,280.28 above 50,000 revenue). Max base and annual form `n.a.` VAT KM
100,000.
Sources: https://ba.bloombergadria.com/ekonomija/bih/92842/samostalni-preduzetnici-u-rs-obaveze-u-2026/news ,
https://www.paragraf.ba/propisi/republika-srpska/zakon-o-doprinosima.html ,
https://zanatskakomorars.com/ukinuto-povecanje-osnovice-za-doprinose-za-preduzetnike-od-1-januara-2026-godine/

**Montenegro** (EUR) — Preduzetnik. Progressive: 0% to EUR 8,400, 9% from
8,400.01 to 12,000, 15% above 12,000. Municipal surtax on the TAX amount:
15% Podgorica/Cetinje, 13% most municipalities, 10% Budva. Contributions
10.5% (PIO 10%, health 0% — abolished January 2022, unemployment 0.5%).
Min/max base `n.a.` Paušal: application on form ZPO by 31 January,
ceiling EUR 30,000 (raised from 18,000 on 1 Jan 2025), recognised costs
by activity group 50/40/35/30%, scale ≤1,250 → 70; ≤2,500 → 260; ≤3,750
→ 450; ≤4,500 → 540 annual tax. Annual return GPP-FL by 30 April. VAT
threshold EUR 30,000.
Sources: https://unija.com/cg/porez-na-dohodak-fizickih-lica/ ,
https://eporezi.me/vodici/porez-na-dohodak , https://eporezi.me/vodici/pdv

**North Macedonia** (MKD) — Самостојна дејност, 10% flat. No normative
deduction; reduction of 30% of qualifying investments capped at 50% of
the base. Contributions from the July 2026 salary through December 2026:
PIO 19.9% + health 7.5% + injury 0.5% + unemployment 0.1% = 28.0%
(previously 18.8/7.5/1.2/0.5). Average gross Jan 2026 MKD 69,141; min
base MKD 34,570.00 (50%); max for self-employed MKD 829,692.00 (12×);
lawyers/notaries/enforcement agents may not go below 100% of average
(MKD 69,141). VAT threshold MKD 2,000,000, form ДДВ-01. Annual: form „Б"
+ ДЛД-ДБ by 15 March, ДЛД-ГДП pre-filled by 30 April, confirm by 31 May.
Monthly advances of 1/12 of prior-year tax by the 15th. Lump-sum payers
exempt from books.
Sources: https://ujp.gov.mk/files/attachment/0000/0730/08-2102-1-Odanocuvanje_na_prihodi_ostvareni_od_vrsenje_na_samostojna_dejnost_09.03.2026.pdf ,
https://www.ujp.gov.mk/-/javnost/soopstenija/pogledni/1266 ,
https://ujp.gov.mk/;133305/javnost/soopstenija/pogledni/1187

**Slovenia** (EUR) — Normirani s.p.: deemed expenses 80% up to EUR 60,000
(cap EUR 48,000), 0% above; tax 20% up to a EUR 72,000 base, 35% above;
effective ≈4% of revenue up to EUR 60,000. Contributions 40.20% (PIZ
24.35% + ZZZS 13.45% + long-term care 2.00% + parental/employment 0.40%)
plus flat OZP EUR 39.36 from 1 March 2026 → EUR 651.04/month at the
minimum base, EUR 3,607.57 at the maximum. Min base EUR 1,521.62/month
(60% of the EUR 2,536.03 average), max EUR 8,876.11 (3.5×). New-s.p.
relief ≈EUR 463.60–465.79/month in year 1, ≈EUR 540.74 in year 2.
Popoldanski s.p.: deemed 80% up to 12,500 then 40% from 12,500 to 30,000,
cap EUR 17,000; tax 20% up to a EUR 33,000 base, 35% above; flat
contributions EUR 110.11/month Jan–Mar 2026, EUR 113.01 from April 2026.
From 1 Jan 2026 (ZPZR): normed-scheme entry ceiling EUR 120,000
conditional on nine continuous months of full-time self-employed
insurance, popoldanski entry EUR 50,000. VAT EUR 60,000 (if exceeded but
under 66,000, VAT status starts 1 January of the following year), form
DDV-P2. Annual return form designation `n.a.`
Sources: https://www.frs.si/spremembe-obdavcitve-za-normirance-v-letu-2026-kaj-prinasa-nova-shema ,
https://mojizracun.si/davcni-vodic-sp ,
https://lider.si/polni-s-p-v-aprilu-2026-placa-651-evrov-prispevkov-popoldanski-113-evrov/ ,
https://www.gov.si/novice/2025-11-24-novosti-pri-ugotavljanju-davcne-osnove-z-upostevanjem-normiranih-odhodkov-v-letu-2026/

**Albania** (ALL) — I vetëpunësuar under Law 29/2023. 0% income tax on
business profit for turnover up to ALL 14,000,000, from 1 Jan 2025 to
31 Dec 2029 (Art. 69) — an all-or-nothing cliff. Above: 15% up to ALL 14
million, 23% above. Contributions are FIXED and income-independent:
social 23% of one minimum wage + health 3.4% of twice the minimum wage;
minimum wage rose to ALL 50,000 on 1 Jan 2026 → ALL 11,500 + ALL 3,400 =
ALL 14,900/month = ALL 178,800/year, due by the 20th. Min base ALL
50,000/month, max ALL 186,416/month, self-employed health base fixed at
ALL 100,000/month. Deemed-expense percentages for turnover ≤ ALL 10M
exist but the percentages are `n.a.` VAT ALL 10,000,000 rolling 12m, but
regulated professions must register regardless of turnover — flag the
deliberate gap where at ALL 12M turnover income tax is 0% yet 20% VAT
applies. Deklarata Vjetore + DIVA by 31 March. A "profesionist i lirë"
earning ≥80% from one client or ≥90% from fewer than three is taxed as an
employee.
Sources: https://sherbimekontabiliteti.al/en/freelancer-tax-guide-albania/ ,
https://sherbimekontabiliteti.al/en/albania-tax-changes-2026/ ,
https://www.karanovicpartners.com/news/albania-implementing-new-income-tax-law/

**Romania** (RON) — PFA în sistem real, or normă de venit (county- and
CAEN-specific fixed norm, only under an EUR 25,000/year ceiling). Tax 10%
on net income AFTER deducting CAS and CASS. Minimum gross salary RON
4,050. CAS 25%, only if net income exceeds 12 minimum salaries, charged
on a ceiling: 12 SM if income is between 12 and 24 SM, 24 SM above.
CASS 10% on net income with a 6-SM floor and a cap. Thresholds: 6 SM =
24,300 (min CASS 2,430); 12 SM = 48,600 (CAS 12,150); 24 SM = 97,200
(CAS 24,300); CASS cap 60 SM = 243,000 for 2025 income, rising to 72 SM =
291,600 for 2026 income under Law 141/2025. Declarația Unică D212 due
25 May 2026 for 2025 income; NEW — 3% bonification on income tax (not on
CAS/CASS) if filed and paid by 15 April 2026 (OUG 8/2026). VAT threshold
RON 395,000 (raised from 300,000 on 1 Sept 2025); from 2026 VAT status
begins on the day of the crossing transaction and that invoice must
already carry VAT, registration on form 700 within 10 days. Standard VAT
21% since 1 Aug 2025.
Sources: https://declaratie-unica.ro/ghiduri/pfa ,
https://eghiseul.ro/calculator/contributii-pfa/ ,
https://static.anaf.ro/static/10/Anaf/AsistentaContribuabili_r/Brosura_Declaratia_Unica_212_2025.pdf ,
https://www.solo.ro/blog/declaratia-unica-2026-pentru-pfa-termene-ce-completezi-si-ce-e-nou-fata-de-2025

**Values to re-verify on a schedule** (put these in DECISIONS.md as a
maintenance note): North Macedonia's rates are valid July–December 2026
only; Slovenia's flat amounts changed 1 April 2026; Serbia's normative
expenses changed 1 February 2026; Romania's CASS cap rises to 72 minimum
salaries for 2026 income.

---

### Part 4 — Tests, l10n, reporting

1. **Unit tests per country**, table-driven, at minimum: a low income
   below every floor, a mid income, an income just below and just above
   each cliff, and an income above every ceiling. Assert the full
   breakdown (gross, deduction, each contribution, tax, net) — not just
   net. Ten regimes × those cases, no exceptions and no "representative
   sample."
2. **A schema test** that validates the bundled `tax_rules.json` against
   the schema and fails the build if any country is missing a required
   field or any value lacks `effective_from` and `source`.
3. **A fetch test** with a mocked client covering: newer version applied,
   older version ignored, malformed JSON ignored, timeout ignored,
   offline ignored — and in every failure case the previous good rules
   are still in use.
4. **l10n lockstep**: every new string in all 9 ARBs in the same commit.
   Regime names stay in the local language (paušalni obrt, normirani s.p.,
   PFA, свободна професия) — they are proper nouns, do not translate
   them. Form names are never translated.
5. **Disclaimer**: the existing "estimates only, not professional tax
   advice" line must appear on this screen. These are the highest-stakes
   numbers in the app.
6. **Report** per the standard format: what was implemented, analyze
   clean, tests passing with counts, the store-listing leaks found and
   fixed, the remote rules URL you used, and an explicit list of anything
   you left as `n.a.` Then STOP and await approval.

### Hard constraints

- No paid service, no backend, no API keys, no Firebase. Free static
  hosting only.
- No tax constant anywhere in Dart code.
- The app must be fully functional with the network permanently off.
- Do not touch the currency-rate path.
- Do not claim a formula is verified against a live tax calculator unless
  you actually ran one and can name it.
