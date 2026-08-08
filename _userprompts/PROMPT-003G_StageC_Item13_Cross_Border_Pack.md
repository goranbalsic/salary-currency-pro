# PROMPT-003G — Stage C Item 13: Cross-Border Pack

## Authorization and scope

You are explicitly authorized to begin and complete PROMPT-003 Stage C, item 13 — **Cross-border pack**.

- **Repository:** `goranbalsic/salary-currency-pro`
- **Branch:** `main`
- **Starting baseline:** `origin/main` at `b16cf524ad231d62af6dc6e5c28802d670ea88d2`

Stage C item 12 is complete and pushed. Do not revisit or expand the invoice PDF / NBS IPS QR feature except for a narrowly necessary regression fix discovered by the item-13 test suite. Preserve all existing item-12 decisions, especially `QUESTION-009` and `D-030`.

This is one increment only. Complete item 13, report it honestly, commit all work, push `main`, then **STOP**. Do not start Stage C item 10. Stage D requires separate explicit approval.

## Mandatory session-start procedure

Before editing anything:

1. Pull and inspect `origin/main`; confirm the HEAD commit and working-tree status.
2. Read, in the repository’s required order:
   - `CLAUDE.md`
   - `PROJECT_RULES.md`
   - `PROJECT_CONTEXT.md`
   - `PROMPTS.md`
   - `DECISIONS.md`
   - `OPEN_QUESTIONS.md`
   - The governing Stage C prompt and relevant existing calculator, currency, l10n, navigation, provider, test, and accessibility code.
3. Record `PROMPT-003G` in `PROMPTS.md` with status **in progress**.
4. Audit the existing salary calculators for all nine supported countries. Do not assume all inputs, currencies, pay frequencies, tax-year effective dates, employer-cost fields, or edge-case semantics are identical.
5. Audit existing exchange-rate and currency-conversion behavior before deciding how a “same gross” comparison is represented. No live rate fetching, network call, analytics, or new online dependency is allowed.

## Deliverable

Build an offline, local-first **Cross-border pack** that lets a user compare the same gross-salary scenario across all nine supported countries.

### 1. Cross-border salary comparison UI

- Provide one clearly labelled gross input and an explicit pay-period choice that maps safely onto the existing salary engines.
- Use a transparent comparison-currency/conversion approach consistent with the app’s existing local or stored-rate architecture.
- Never silently compare unequal currency amounts as though they were equivalent.
- Show a clear effective-date or rates-data explanation wherever existing engine metadata supports it.
- Provide a responsive results table/card layout usable on narrow mobile screens, with all nine countries represented.
- A visual comparison is optional only if it adds real value and remains fully accessible. A table is mandatory.
- For each country, show at minimum: gross, employee deductions where available, net salary, and comparison-currency equivalent when a supported conversion is available.
- Make empty, unavailable, unsupported, and insufficient-data states explicit and useful. Never substitute a guessed calculation.

### 2. Employer total-cost view

- Show country-by-country employer total cost of employment using only existing source-backed calculator logic or properly sourced additions.
- Clearly distinguish employer contributions/costs from employee deductions and gross salary.
- If an engine cannot produce a defensible employer total cost, show a truthful **not available** state rather than estimating it.
- Do not alter existing payroll rules merely to make the comparison table appear uniform.

### 3. Per-diem and mileage support

- First audit whether official, effective-dated rates can be sourced to the project’s established evidence standard for each specific country and rate type.
- Implement only rates that meet that standard, with source and effective-date visibility in the UI where appropriate.
- If a country or rate cannot be sourced, exclude it from calculation and record it precisely in `OPEN_QUESTIONS.md`. Do not use blogs, aggregators, approximations, stale figures, or invented defaults.
- Do not block the core cross-border salary and employer-cost feature on optional rate data.

## Design and engineering constraints

- Reuse existing salary engines, country configuration, money formatting, stored currency-rate logic, themes, providers, navigation patterns, and accessibility conventions. Item 13 is primarily a comparison presentation/orchestration feature, not a payroll-engine rewrite.
- Keep calculations deterministic and offline. No API calls, telemetry, remote configuration, or runtime legal/tax lookup.
- Preserve user data and existing calculator flows. Additive changes only.
- Put comparison orchestration behind a clean service/model boundary so future paywall wiring can be a one-line gate. Do not add paywall, entitlement, subscription, advertising, analytics, or account code now.
- Keep all user-facing text in lockstep across exactly nine locales: `en`, `sr`, `hr`, `bs`, `mk`, `sl`, `bg`, `sq`, `ro`. Update ARB files and generated localization output correctly; do not hard-code visible strings.
- Maintain locale-safe and screen-reader-accessible labels, semantic structure, focus order, loading states, errors, and table/chart alternatives.
- Do not add a dependency unless it is minimal, mainstream, offline, license-compatible, and genuinely necessary. Record its rationale and license in `DECISIONS.md` before use. Prefer existing Flutter components over a chart dependency.
- Do not change unrelated formatting or refactor unrelated systems.

## Required implementation sequence

### Checkpoint 1 — Audit and design

- Finish the engine, currency, employer-cost, country-data, and source audit.
- Define and document the exact meaning of “same gross,” pay period, comparison currency, rate snapshot/date semantics, unavailable-result behavior, and rounding.
- Add or extend pure models and orchestration services before UI work.
- Update `DECISIONS.md` with comparison semantics and limitations. Update `OPEN_QUESTIONS.md` for every excluded or unresolved per-diem/mileage rate.
- Add focused unit tests before UI work.
- Run `flutter analyze` and `flutter test -j 1`.
- Commit checkpoint 1.

### Checkpoint 2 — Comparison UI

- Add the discoverable cross-border entry point and responsive, accessible comparison-results UI.
- Wire all nine countries to the audited orchestration layer.
- Add widget tests for initial, populated, narrow-layout, unavailable-data, and accessible-label states.
- Verify localization parity across all nine locales.
- Run `flutter analyze` and `flutter test -j 1`.
- Commit checkpoint 2.

### Checkpoint 3 — Employer cost and optional rates

- Complete employer total-cost presentation and only the rate features that passed the official-source standard.
- Test country-specific cost behavior, missing-data behavior, money rounding, and no-rate exclusions.
- Run `flutter analyze` and `flutter test -j 1`.
- Commit checkpoint 3.

### Checkpoint 4 — Final regression and release evidence

- Run the full test suite serially: `flutter test -j 1`.
- Run `flutter analyze`.
- Run a release build and report split-per-ABI APK sizes, not a fat APK, following the Stage C APK-size rule. If a build cannot run, state the exact blocker and do not claim it passed.
- Inspect generated localization parity and confirm all nine locales.
- Update `PROJECT_CONTEXT.md`’s device-unverified checklist for any new comparison UI, chart, or rate-view behavior requiring device validation.
- Add a concise session log and final `DECISIONS.md` / `PROMPTS.md` updates.
- Commit the final checkpoint and push all item-13 commits to `origin/main`.
- **STOP. Do not start Stage C item 10.**

## Test requirements

At minimum, add or extend automated tests for:

- All nine-country comparison inclusion and deterministic ordering.
- Same-gross conversion semantics, including absent, stale, or unsupported stored-rate behavior where applicable.
- Correct propagation of each existing engine’s net result without rewriting or rounding it incorrectly.
- Employer total-cost decomposition and unavailable states.
- Money-rounding and currency-formatting boundaries.
- Every implemented, officially sourced per-diem/mileage rule and each documented excluded or unsupported rate category.
- Full l10n-key parity across all nine ARB locales.
- Widget accessibility/semantics, loading/error/empty states, and narrow-screen layout.
- Regression coverage for existing salary calculators and item-12 invoice tests.

## Completion report format

After the final commit and push, report only facts actually verified in this session:

1. **Implemented:** User-facing flows, country coverage, employer-cost behavior, rate features included/excluded, and key architectural choices.
2. **Sources and effective dates:** Official sources used for every newly introduced rate or figure; list exclusions separately.
3. **Tested:** Exact commands, counts, and what the tests prove.
4. **Localization:** Key count and confirmation of parity across all nine locales.
5. **Static analysis:** Exact result, separating pre-existing issues from new ones.
6. **Build:** Exact command, success/failure, and split-per-ABI sizes if run.
7. **Device verification still needed:** Specific flows, not generic wording.
8. **Decisions and open questions:** Exact IDs added or updated.
9. **Commit hashes and push status.**
10. **Explicit stop statement:** “Stage C item 13 is complete; item 10 has not been started and requires its own approved prompt.”

Be concise, do not overclaim, and do not report a pass for anything not actually executed.
