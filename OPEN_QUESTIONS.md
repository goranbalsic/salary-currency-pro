# Open Questions

Unresolved questions with a safe default recorded, so they don't block
progress and don't get re-asked every session.

## High Importance

### QUESTION-011: Cross-Border Comparison shows "—" for 5 of 9 countries (Serbia, Bosnia-FBiH, North Macedonia, Albania, Romania)

Date added: 2026-08-11

Why it matters: discovered live while capturing Checkpoint 3 (redesign)
screenshots for the Cross-Border Comparison screen — no code change was
made to this screen beyond one text color (the megaprompt's redesign
pass does not touch calculation logic). With a 3000 EUR gross salary
entered: Croatia (EUR), Montenegro (EUR), Slovenia (EUR), and Bulgaria
(BGN) return real computed Gross/Employee deductions/Net/Employer cost
figures. Serbia (RSD), Bosnia and Herzegovina — Federation of BiH
(BAM), North Macedonia (MKD), Albania (ALL), and Romania (RON) render
"—" in every numeric column instead. Serbia is the app's default/home
country and its own Salary Calculator works fine standalone, so this is
specific to the Cross-Border comparator, not a broken tax config.
Root cause is unknown but the working/broken split lines up exactly
with currency: every broken country's currency is neither EUR nor BGN,
suggesting a currency-conversion/exchange-rate lookup failure (missing
cached rate, wrong currency-code lookup key, or similar) rather than a
payroll-calculation bug — but this is an observation, not a verified
diagnosis.

Current assumptions: none — not investigated further, since the
redesign pass explicitly defers logic/data suspicions to Checkpoint 5's
full codebase review rather than fixing them ad hoc mid-redesign.

Possible answers: (a) Checkpoint 5's full review traces the currency-
conversion path in `lib/screens/tools/cross_border_screen.dart` (and
whatever exchange-rate service/cache it calls) for RSD/BAM/MKD/ALL/RON
specifically, compares it against why EUR/BGN succeed, and fixes the
root cause with a regression test (recommended); (b) if Checkpoint 5
finds this is a pre-existing, already-known limitation with a reason
not documented here, downgrade this entry accordingly.

Does it block current work? No — the redesign pass continues per its
own rule (restyle only, log data/logic suspicions). It should block
Checkpoint 6/7's "ready for Play" sign-off if still unresolved, since it
affects the free-tier's most-used calculator's own country.

Recommended default if no answer is received: treat as a confirmed bug
and fix in Checkpoint 5, not skip it.

Status: Open.

## Medium Importance

### QUESTION-001: Should the Samooporezivanje (Serbia freelancer self-taxation) calculator include social security contributions?

Date added: prior session (carried forward from `lib/screens/tools/samooporezivanje_screen.dart`'s
own in-app disclaimer, formalized here 2026-08-07).

Why it matters: the calculator currently shows only the 10% income tax for
foreign-income self-taxation (PP OPO-K); social security contributions for
this regime were left out because the formula wasn't sourced to the same
verification standard as the rest of the app's tax configs. A user relying
on this for a real quarterly filing could underestimate their obligation.

Current assumptions: the in-app disclaimer already tells users this is
income-tax-only and to verify contributions separately — treated as
sufficient disclosure for now, not a silent gap.

Possible answers: (a) research and add a sourced contributions formula;
(b) keep the explicit disclaimer indefinitely, since this is a narrow
regime (foreign-income freelancers specifically, not registered
"paušalac" entrepreneurs); (c) remove the tool entirely if it can't be
made complete.

Does it block current work? No — Phase 10's quality pass is about the
offline expense/budget/invoice features added this session, not this
pre-existing calculator.

Recommended default if no answer is received: keep the existing
disclaimer-based approach (option b) — a clearly-labeled partial estimate
is more honest than a fabricated complete one, and matches this app's own
"never invent a number" pattern.

**Resolved 2026-08-08 (superseded by PROMPT-004/PROMPT-005, option (a)):**
the new "Freelancer Self-Assessment" tool's Serbia regime computes real,
sourced social contributions (PIO/health/unemployment) alongside income
tax — see `DECISIONS.md` D-019. The old contribution-less tool this
question was about no longer exists (removed in D-022, PROMPT-005 Part
4). Nothing left to decide.

Status: Resolved.

## Low Importance

### QUESTION-002: Exact scope for Phase 11 (final visual polish)

Date added: 2026-08-07

Why it matters: PROMPT-002's Phase 11 lists typography, spacing, button
hierarchy, icons, chart presentation, animations, empty states,
onboarding, app name/product language, trust messaging, and "first-use
experience" — a broad list that could mean anything from minor tweaks to
a substantial redesign.

Current assumptions: interpret it as a focused pass over what was *added*
this session (expense tracker, budgets/goals, invoices) for visual
consistency with the app's existing design system — not a redesign of
already-shipped, already-consistent screens (salary calculator, currency
converter, existing toolkit calculators).

Possible answers: (a) the narrow interpretation above; (b) a full app-wide
visual refresh; (c) something specific the user has in mind but hasn't
stated yet.

Does it block current work? No — Phase 10 comes first regardless of how
Phase 11 is eventually scoped.

Recommended default if no answer is received: option (a) — proportionate
to what actually changed, consistent with this app's existing "minimal
reversible changes" convention.

**Default adopted 2026-08-08:** no user scope decision has arrived, and
Phase 11 hasn't resumed since it was paused — adopting option (a) (the
narrow interpretation) as the working assumption for whenever Phase 11
actually starts, rather than leaving it perpetually open. If the user
wants a broader visual refresh, say so when Phase 11 resumes.

Status: Resolved (default adopted; revisit if the user's actual intent
differs when Phase 11 starts).

### QUESTION-003: What does `memory/` (per the toolkit's SRC-002) mean for this repository, if anything?

Date added: 2026-08-07

Why it matters: the toolkit's own `SOURCE_REGISTER.md`/`OPEN_QUESTIONS.md`
flags that SRC-002 requires a `memory/` directory in its file list without
ever defining its contents — the toolkit repository itself left this
undefined (see `C:\Claude-Global-Toolkit\OPEN_QUESTIONS.md` QUESTION-001).
This repository adopted the rest of the memory-system bundle but not
`memory/` for the same reason.

Current assumptions: not created here; `PROJECT_CONTEXT.md`, `DECISIONS.md`,
and `session_logs/` are judged sufficient for this repository's actual
needs so far.

Possible answers: (a) leave it uncreated until a concrete need appears;
(b) create it empty with a README matching the toolkit's own placeholder
approach.

Does it block current work? No.

Recommended default if no answer is received: option (a) — matches
`CLAUDE.md` rule 6 ("do not create major new components unless
required").

**Default adopted 2026-08-08:** no concrete need for `memory/` has
appeared since this was raised; option (a) (leave uncreated) is already
the status quo and is being formally adopted rather than left open
indefinitely.

Status: Resolved (default adopted).

### QUESTION-004: Cold-start timing and list virtualization for the Expense Tracker / Invoices screens

Date added: 2026-08-07

Why it matters: `PROMPTS.md` PROMPT-003 Stage A item 3 asks for a <2s
cold start on a low-end device profile and virtualized lists for large
data sets. Neither could be verified or safely implemented this session
— see `DECISIONS.md` D-012.

Current assumptions: cold-start timing needs an actual low-end
device/emulator to measure honestly (none was available this session —
stating an unmeasured number would violate this project's "never invent
a number" pattern). The Expense Tracker's transaction list and the
Invoices list both build every row eagerly (`ListView` + a `for` loop)
rather than lazily (`ListView.builder`/slivers); this is a real gap for
users with a lot of data, but the Expense Tracker is already month-scoped
(bounded), and converting either screen properly requires a sliver-based
restructure (both mix a summary-card header with the loop in one
non-sliver `ListView`) that deserves its own visually-verified pass
rather than being rushed in without the ability to re-check it rendered
correctly.

Possible answers: (a) get access to a low-end emulator profile and
measure cold start for real, then decide if optimization is needed; (b)
convert Expense Tracker/Invoices to `CustomScrollView` + `SliverList`
lazy building proactively, verified visually in a follow-up session; (c)
leave both as-is until a user or tester actually reports jank with a
large dataset.

Does it block current work? No — Stage A items 1–3's other parts are
complete regardless of this.

Recommended default if no answer is received: option (c) for
virtualization (wait for real evidence before a behavior-changing
refactor); option (a) for cold-start whenever a device/emulator becomes
available in a session.

**Checked 2026-08-08, deliberately NOT closed:** still no device/emulator
or browser tooling available this session (confirmed — same gap as every
prior session). Closing this would require either inventing a cold-start
number (violates this app's core "never fabricate a number" rule) or
pushing the sliver-based refactor blind, with no way to visually confirm
it didn't break either screen's layout — also unacceptable. Continuing
option (c): stays as-is until real evidence (a device/emulator session,
or an actual user report) justifies the refactor.

Status: Open, non-blocking — genuinely cannot be closed honestly without
device/emulator or browser access.

### QUESTION-005: No public repo/GitHub Pages exists yet to host `tax_rules.json` for over-the-air updates

Date added: 2026-08-07

Why it matters: PROMPT-004 Part 2 requires tax rules to update over the
air via a free, static-hosted URL (GitHub Pages or
`raw.githubusercontent.com/<user>/<repo>/...`) without a paid backend.
`lib/services/tax_rules_service.dart`'s `kFreelanceTaxRulesRemoteUrl` is
currently a placeholder (`raw.githubusercontent.com/REPLACE_ME/...`)
because this project itself has no git repository or remote at all
(confirmed via environment state) — standing one up, and deciding whether
`tax_rules.json` lives in this same (still-nonexistent) repo or a
separate public one, is an account-level action outside what a coding
session can do unilaterally.

Current assumptions: the app is fully correct and functional without
this — every fetch attempt against the placeholder host simply fails to
resolve and is silently ignored, identical in effect to being
permanently offline, per the fetch policy's own design (D-017). Rules
only ever update via a new app release (a new bundled `assets/config/
tax_rules.json`) until this is set.

Possible answers: (a) the user creates a small public GitHub repo (or
enables GitHub Pages on an existing one) containing just `tax_rules.json`,
then this constant gets a one-line update to the real raw URL — no code
changes beyond that; (b) host it as a public Gist instead (also free,
also no backend) if a full repo feels heavier than needed; (c) skip
remote updates entirely for now and accept "rules update only via app
release" as the permanent policy.

Does it block current work? No — Part 3 (the calculator itself) does not
depend on the remote fetch actually succeeding.

Recommended default if no answer is received: option (a) once the user
is ready — it's the one the prompt itself named first, and matches this
app's existing zero-backend, zero-cost pattern.

**Resolved 2026-08-08 (option (a)):** now that this project has a GitHub
account connection (PROMPT-005 Part 1), created a separate small public
repo, https://github.com/goranbalsic/salary-currency-pro-rules,
containing the publishable `tax_rules.json` + a short README. Live-
verified the raw URL resolves and serves valid, schema-correct JSON
(`schema_version: 1`, `rules_version: "2026-08-08"`, all 10 regimes
present). `kFreelanceTaxRulesRemoteUrl`
(`lib/services/tax_rules_service.dart`) now points at the real URL
instead of the `REPLACE_ME` placeholder. The app's freelancer calculator
will now genuinely receive over-the-air rule updates (≤24h cadence, per
the existing fetch policy) whenever `tools/rules-publish/README.md`'s
runbook is followed to publish a change.

Status: Resolved.

### QUESTION-006: Consolidate the old Serbia-only "Freelancer Tax" tool with the new 9-country "Freelancer Self-Assessment" tool?

Date added: 2026-08-08

Why it matters: PROMPT-004 Part 3 built a new unified freelancer
self-assessment calculator covering all 9 countries, including a Serbia
regime that (unlike the pre-existing `HistoryToolIds.samo` tool) also
computes social security contributions — resolving `OPEN_QUESTIONS.md`
QUESTION-001's long-standing gap. The old tool was left in place rather
than removed or merged (see `DECISIONS.md` D-019): this repository has no
git repository at all, so a destructive removal would have no rollback
path. The result is two Tools-hub entries a Serbian user could reasonably
open for the same task, one of which (the older one) is now the strictly
worse option.

Current assumptions: both tools stay as-is until the user decides;
neither is hidden or deprecated in-app.

Possible answers: (a) remove the old `samo` tool and its screen/
calculator/tests once git exists for this project (making the removal
trivially reversible) or once the user explicitly accepts the risk
without git; (b) keep both permanently — the old one is narrower/simpler
and some users may prefer that; (c) merge them by pointing the old tool's
route at the new screen pre-filtered to Serbia, keeping the old
Tools-hub entry point but retiring the separate implementation.

Does it block current work? No.

Recommended default if no answer is received: option (a) once a git
repository exists for this project — matches this app's general
"delete what's genuinely superseded" convention (see `CLAUDE.md`'s
"avoid backwards-compatibility hacks" rule) once it's safe to do so.

**Resolved 2026-08-08 (PROMPT-005 Part 4, option (a) — git now exists,
D-021):** honest delta comparison found the old tool had no missing
feature the new engine lacked — and one thing the old tool actively got
wrong: it applied a flat 10% income-tax rate to BOTH standardized-expense
models, while the correctly-sourced 2026 rule set uses 20% for Model 1
and 10% for Model 2 (the old tool predates that more careful research).
Two genuine gaps WERE found and ported before removal: (1) search
discoverability — the old tool's title/subtitle contained
"samooporezivanje"/"PP OPO-K", terms the new tool's necessarily-generic
9-country subtitle doesn't; ported as a non-displayed `searchKeywords`
field on the Tools-hub entry (covering every regime's own filing-form/
proper-noun terms, not just Serbia's), verified by a new widget test.
(2) The old screen's samooporezivanje-vs-paušalac disclaimer nuance is
substantially covered by the new engine's paušal-ceiling cliff note
("informational only, not modeled by this calculator") — judged adequate
rather than porting a second explicit banner. Removed:
`samooporezivanje_screen.dart`, `samooporezivanje_calculator.dart`, the
Tools-hub entry, the `HistoryToolIds.samo` constant, and 9 old-tool-
exclusive l10n keys × 9 locales (4 keys — the model-name and cheaper-
model-comparison strings — are reused by the new screen and were kept).
Added an idempotent `SamoToFreelanceTaxMigrationService` (6 tests
including a run-twice-no-duplicate case) so any previously-saved `samo`
scenario translates into the new engine's input shape rather than being
orphaned. See `DECISIONS.md` D-022.

Status: Resolved.

### QUESTION-007: Bulgaria's salary calculator still quotes BGN; PROMPT-004's freelance data says EUR (adopted 1 Jan 2026)

Date added: 2026-08-08

Why it matters: while building the Bulgaria freelance regime for
PROMPT-004 Part 3, `lib/models/country.dart`'s existing `kCountries` entry
for Bulgaria was found to still declare `currencyCode: 'BGN'` — but
PROMPT-004's own sourced seed data states Bulgaria adopted the euro on
1 Jan 2026 and gives every freelance-tax figure in EUR. The new freelance
regime is internally correct (it reads its currency from its own
`tax_rules.json` entry, independent of `Country.currencyCode`), but the
existing salary calculator, VAT calculator, and currency converter
presumably still treat Bulgaria as a BGN country — a real, separate
correctness gap this session did not investigate or fix, since
PROMPT-004 explicitly scopes out touching the currency-rate path.

Current assumptions: not investigated further this session — the actual
blast radius (how many places in the app assume `bg` = BGN, and whether
`vat_rates.json`/`assets/config/tax/bg.json` also need updating) is
unknown.

Possible answers: (a) a dedicated follow-up pass auditing every Bulgaria-
BGN assumption across the app (salary config, VAT rate, currency
converter defaults, onboarding) and migrating to EUR with a real source
citation for the 1.95583 peg-turned-conversion; (b) confirm with the user
whether this matters for the app's actual user base before spending the
effort (may be low-impact if few users pick Bulgaria + BGN specifically).

Does it block current work? No — PROMPT-004 itself is unaffected.

Recommended default if no answer is received: option (a) as a scoped
follow-up prompt, not folded silently into unrelated work.

**Resolved 2026-08-08 (PROMPT-005 Part 3, option (a)):** full audit found
the blast radius was narrower than feared — `grep` confirmed `BGN`/`лв`
appeared in exactly one place in the entire codebase
(`lib/models/country.dart`), since the currency converter, expense/
budget/invoice trackers, and loan/savings/VAT-amount display all use an
independent currency picker that never listed BGN. Fixed:
`Country.currencyCode`/`currencySymbol` for `bg` → `EUR`/`€`;
`assets/config/tax/bg.json`'s contribution-base cap re-sourced from NRA
directly (was 3850 from non-NRA blogs, now EUR 2,300, itself found to be
stale as of 1 Aug 2026 — also fixed in `tax_rules.json`); an idempotent,
versioned `BgEuroMigrationService` redenominates any pre-existing
Bulgaria salary/VAT `Scenario` amount at the fixed 1.95583 peg exactly
once (8 tests, including a run-twice-is-a-no-op test); BGN kept in the
currency converter as a legacy/pegged entry only (`ExchangeRateService`
special-cases it — confirmed live that Frankfurter has removed BGN
entirely, so no live fetch was ever possible for it going forward); dual
mandatory price display was live-verified to run 2025-08-08 through
2026-08-08 (today) — expiring within the day this was fixed, so single
EUR display (already the only mode the app has) was kept rather than
building a toggle for a requirement that's already over. See
`DECISIONS.md` D-020.

Status: Resolved.

### QUESTION-008: PROMPT-003E (Stage C item 11, Serbia paušal/freelancer compliance pack) — four figures deliberately excluded rather than approximated

Date added: 2026-08-08

Why it matters: PROMPT-003E's own instruction is to apply the
Samooporezivanje precedent (QUESTION-001's original resolution) — exclude
and document any figure that can't be sourced to this app's standard
(official source, effective-date label) rather than approximate it. Four
such figures came up while building the paušal turnover tracker and the
Model A/B comparator:

1. **Paušal deemed-base coefficients** (activity coefficient 0.15–0.55,
   zone coefficient 0.6–1.0, and the statutory reductions that combine
   with the average salary to produce a paušalac's actual monthly tax
   assessment) — not published anywhere as a complete, citable,
   machine-readable table. The app does not compute the assessed paušal
   amount; the Paušal Tracker screen has the user enter it directly from
   their own tax ruling (rešenje), and only decomposes the entered figure
   into its sourced 10%/24%/10.3%/0.75% components (all four of which
   *are* sourced — `tax_rules.json`'s `pausalTaxRatePercentOfDeemedBase`/
   `pioContributionRate`/`healthContributionRate`/
   `unemploymentContributionRate`) — it never asserts what the ruling
   itself should say.
2. **Supplementary annual PIT** for the OPO-K self-taxation regime (an
   extra 10% above 3× and 15% above 6× the average annual salary, per
   PwC's Serbia tax summary) — out of scope for this pass. The
   freelance-tax calculator (`rs_strategy.dart`) computes only the base
   quarterly tax/PIO/health/unemployment; a taxpayer who crosses either
   multiple during the year owes more than this app currently shows.
   Noted here as a known future addition, not fixed now.
3. **A reported 10%-per-year cap on paušal contribution-base growth for
   2026–2027** — several practitioner sites mention this, but it was not
   traced to an official gazette/PURS text during this session. Excluded
   from every calculation rather than guessed at.
4. **Other countries' paušal-equivalent regimes** (Croatia's paušalni
   obrt, etc.) — deliberately out of scope for this pass, per the
   prompt's own instruction; Serbia done first and completely.

Current assumptions: the Paušal Tracker and Model A/B comparator are
fully correct and honest without these — items 1 and 3 have no safe
approximation (a wrong deemed-base or growth-cap figure would misstate a
real tax liability), and items 2/4 are additive scope, not correctness
bugs in what's already built.

Possible answers: (a) leave as documented gaps, matching the
Samooporezivanje precedent, until a citable official source appears for
1/3, or until supplementary-PIT/other-country coverage is separately
requested; (b) reach out to a Serbian accountant/PURS directly for the
deemed-base coefficient table if this app's paušal coverage needs to go
beyond "user enters their own ruling."

Does it block current work? No — PROMPT-003E's own scope is satisfied by
excluding and documenting these, exactly as instructed.

Recommended default if no answer is received: option (a).

Status: Open.

### QUESTION-009: PROMPT-003F (Stage C item 12, Invoice PDF + NBS IPS QR) — three implementation gaps flagged during planning

Date added: 2026-08-08

Why it matters: the prompt requires citing the official NBS IPS
specification exactly and never inventing payload/checksum behavior, and
requires being explicit about what automated tests can and can't verify.
Three genuine gaps surfaced while planning the NBS QR and PDF-test
checkpoints (not yet built as of checkpoint 1):

1. **NBS Annex 3 payment-code list is only partially sourced.** The
   official NBS "Preporuke" (Recommendations) PDF
   (`https://ips.nbs.rs/PDF/pdfPreporukeValidacijaLat.pdf`, © 2020 NBS)
   gives the "SF" tag's format (mandatory 3-digit numeric) and a handful
   of example codes (189/289 for private-individual cash/non-cash;
   121/122/221/222 for goods/services), but says the full code list is
   "Prilogom 3" of a separate NBS decision on dinar payment-order forms,
   which hasn't been independently located/read yet.
2. **Model-97 reference-number checksum ("RO" tag) is out of scope.**
   The Preporuke doc explicitly says a payer computing model 97
   themselves is responsible for getting the checksum right — the app
   will validate "RO" for format/length only (≤25 chars, leading 2-digit
   model), not verify or compute a mod-97 check digit.
3. ~~**PDF content-assertion API for automated tests is unconfirmed.**~~
   **Resolved in checkpoint 3 (2026-08-08):** the `pdf` package exposes
   no text-content introspection API at all — only raw bytes. Resolved by
   splitting content from layout: `lib/pdf/invoice_pdf_content.dart`
   builds a plain-Dart content model with zero `pdf` dependency (so
   `test/invoice_pdf_content_test.dart` can assert real content rules —
   itemization, pagination-worthy line counts, status labels, money
   rounding — without touching the `pdf` package at all), while
   `lib/services/invoice_pdf_service.dart`'s own tests
   (`test/invoice_pdf_service_test.dart`) are an honest smoke suite only
   (valid-PDF-bytes magic-number check), never claiming rendered-text
   verification.

Current assumptions (1 and 2 both confirmed still in effect as of
checkpoint 4, which built `lib/logic/nbs_ips_payload_builder.dart`
against them): (1) ship the "SF" field as validated free-text (3 digits,
required) with the sourced example codes shown as in-app help text, not a
hardcoded exhaustive dropdown, until/unless the full Annex 3 is sourced;
(2) implement no model-97 computation/validation, only the documented
format/length rule (confirmed: `NbsIpsPayloadBuilder` rejects a dash in a
model-97 reference per the source doc's own note, but never computes or
verifies the check digit itself).

Possible answers: (a) proceed with the current assumptions (recommended —
none of the three block a correct, honest implementation, they only bound
its scope); (b) source Annex 3's full code list from an official NBS
decision text before implementing "SF" if a complete dropdown is wanted
later.

Does it block current work? No — checkpoints 3/4 (PDF rendering, NBS QR)
can proceed with the current assumptions.

Recommended default if no answer is received: option (a).

Status: Open.

### QUESTION-010: PROMPT-003G (Stage C item 13, Cross-Border Pack) — per-diem and mileage excluded for all 9 countries

Date added: 2026-08-08

Why it matters: the prompt requires per-diem/mileage rates to be sourced
to official, effective-dated documents to the project's established
evidence standard, with no blogs, aggregators, approximations, stale
figures, or invented defaults — and explicitly says any rate that can't
be sourced that way must be excluded and logged rather than block the
core comparison/employer-cost feature. Rigorously locating and citing an
official effective-dated per-diem rate AND a separate official mileage
(per-km) rate for all 9 jurisdictions (10 regimes counting Bosnia's FBiH/
RS split) — 18–20 individual figures — is not achievable to a trustworthy
standard within one session; the risk of citing a stale, unofficial, or
misremembered figure as if verified is exactly what this project's
evidence standard (and QUESTION-008/QUESTION-009's precedent of excluding
rather than approximating) exists to prevent.

Current assumptions: none implemented. The Cross-Border Pack ships with
no per-diem/mileage feature at all this item — the comparison table and
employer-cost view (checkpoint 1/2/3) are unaffected and fully
functional without it, per the prompt's own "do not block the core
feature" instruction.

Possible answers: (a) leave unimplemented indefinitely — the core
comparison/employer-cost feature does not need it (recommended, current
default); (b) a future prompt sources per-diem/mileage rates one country
at a time from each country's own official gazette/ministry-of-finance
publication (the same standard already applied to `tax_rules.json` and
`freelance_tax_rules.json`), and this item's cross-border UI gets a
follow-on increment to display whichever subset clears that bar,
excluding the rest by name (same pattern as QUESTION-008/QUESTION-009);
(c) explicitly abandon per-diem/mileage as a feature.

Does it block current work? No — PROMPT-003G's own instruction is that
optional rate data must never block the core cross-border salary and
employer-cost feature.

Recommended default if no answer is received: option (a).

Status: Open.

## Question Template

### QUESTION-NNN: Title

Date added:
Why it matters:
Current assumptions:
Possible answers:
Does it block current work?
Recommended default if no answer is received:
Status:
