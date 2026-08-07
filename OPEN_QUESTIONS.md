# Open Questions

Unresolved questions with a safe default recorded, so they don't block
progress and don't get re-asked every session.

## High Importance

_None currently — nothing open is blocking the current Phase 10 work._

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

Status: Open, non-blocking.

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

Status: Open, non-blocking — will be revisited when Phase 11 actually
starts.

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

Status: Open, non-blocking.

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

Status: Open, non-blocking.

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

Status: Open, non-blocking.

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

Status: Open, non-blocking.

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

## Question Template

### QUESTION-NNN: Title

Date added:
Why it matters:
Current assumptions:
Possible answers:
Does it block current work?
Recommended default if no answer is received:
Status:
