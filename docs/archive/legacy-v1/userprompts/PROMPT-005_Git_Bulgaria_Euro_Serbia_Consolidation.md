# PROMPT-005: Version Control, Bulgaria Euro Migration, Serbia Tool Consolidation

Status: Active. Record in PROMPTS.md. Closes the three items disclosed at
the end of PROMPT-004 (remote-URL gap, QUESTION-007, QUESTION-006) and
verifies two PROMPT-004 claims before building on them. All existing
rules apply: 9-language l10n lockstep, real tests (`flutter test -j 1`),
`flutter analyze` clean, no fabricated completion claims, offline-first,
minimal tightly-scoped increments, honest phase-end reports.

Work the parts strictly in order. Part 1 protects everything that
follows — do not start Part 2 until Part 1 is committed.

---

## The prompt (paste into Claude Code)

You are continuing work on Salary & Currency Pro (C:\salary-currency-pro).
Read CLAUDE.md, PROJECT_RULES.md, PROJECT_CONTEXT.md, DECISIONS.md,
PROMPTS.md, OPEN_QUESTIONS.md and the latest session log first, as always.
This is PROMPT-005.

---

### Part 0 — Verify two PROMPT-004 claims (cheap, do first)

No new code. Report only.

1. **Cliff test coverage.** PROMPT-004 required a test case immediately
   below and immediately above every regime cliff. Print the actual test
   names covering each of these five boundaries, with the input value
   used and the expected output asserted:
   - Albania, ALL 14,000,000 turnover (0% → 15%/23%)
   - Slovenia, EUR 60,000 revenue (80% deemed expenses → 0%)
   - Serbia, RSD 6,000,000 paušal ceiling
   - Montenegro, EUR 30,000 paušal ceiling
   - Romania, EUR 25,000 normă de venit ceiling
   Plus each country's VAT registration threshold. If any boundary has no
   test either side of it, say so plainly and add the missing cases now.
   These five are where a wrong number causes a real filing error.
2. **Regime completeness.** Confirm all ten regimes actually shipped by
   listing the strategy class names and their file paths: Serbia,
   Bulgaria, Croatia, FBiH, Republika Srpska, Montenegro, North
   Macedonia, Slovenia, Albania, Romania. Your PROMPT-004 report
   truncated after the eighth — confirm Albania and Romania exist and are
   wired into the screen's country selector, not just present as files.

---

### Part 1 — Put this project under version control

There is no git repository. That is the highest-risk fact in the project:
no history, no rollback, no diff of what any session changed, no recovery
from a bad edit. Every prior session's work — the UMP consent flow, the
icon integration, 186 tests, ten tax engines — is unprotected. Fix this
before anything else.

1. **`git init`** at the repo root. Set `main` as the default branch.
2. **Write a proper Flutter `.gitignore`** before the first `git add`.
   Exclude at minimum: `build/`, `.dart_tool/`, `.packages`,
   `.flutter-plugins`, `.flutter-plugins-dependencies`, `*.iml`, `.idea/`,
   `.vscode/` (except any shared config you deliberately keep),
   `android/.gradle/`, `android/local.properties`, `ios/Pods/`,
   `ios/.symlinks/`, `*.lock` files that Flutter regenerates (keep
   `pubspec.lock` — commit it, this is an app not a library).
3. **Never commit secrets.** Explicitly exclude and verify absent from
   the index: any `*.keystore` / `*.jks`, `android/key.properties`,
   `google-services.json`, any real AdMob unit IDs if they ever replace
   the test IDs, and any `.env`. If any such file already exists in the
   working tree, add it to `.gitignore` and tell me — do not commit it
   and then remove it, since that leaves it in history.
4. **Commit in logical chunks, not one giant commit.** A reasonable split:
   scaffolding + pubspec; core app and calculators; l10n and ARBs; tests;
   branding assets; governance markdown (CLAUDE.md, PROJECT_RULES.md,
   DECISIONS.md, PROMPTS.md, OPEN_QUESTIONS.md, session logs);
   store_listing. Write real commit messages describing what each chunk
   is.
5. **Verify** with `git status` clean, `git log --oneline`, and a check
   that `build/` and `.dart_tool/` are genuinely untracked. Report the
   commit count and the total tracked file count.
6. **Report the exact commands I need to run** to push this to a new
   GitHub repository, and recommend private. Do not attempt to create a
   remote or push — you have no credentials and I will do it.

---

### Part 2 — Host the tax rules and close the remote-URL gap

`kFreelanceTaxRulesRemoteUrl` is a placeholder because there was nowhere
to host. Part 1 unblocks it.

1. **Recommend a separate small PUBLIC repository** for the rules file,
   distinct from the app repo (which should be private). The app repo
   contains your commercial source; the rules file must be fetchable by
   anonymous clients. Do not make the app repo public just to serve one
   JSON file.
2. **Create the publishable artifact** in the app repo at a clear path
   (e.g. `tools/rules-publish/tax_rules.json`) as an exact copy of the
   bundled `assets/config/tax_rules.json`, so there is one authoring
   location and a defined copy step.
3. **Write `tools/rules-publish/README.md`** — a runbook I can follow in
   five minutes with no Flutter knowledge: how to bump `rules_version`,
   what must change when a rate changes (the value, its `effectiveFrom`,
   and its `source`), how to validate before publishing, how to publish,
   and how to confirm a device picked it up. Include the raw-URL format
   `https://raw.githubusercontent.com/<user>/<repo>/main/tax_rules.json`
   and note that raw.githubusercontent.com is CDN-cached for about five
   minutes, so an update is not instant.
4. **Add a validation script** (`dart run tools/rules-publish/validate.dart`
   or equivalent) that checks the publishable JSON against the same
   schema the app enforces and exits non-zero on failure. The runbook
   must tell me to run it before every publish. A malformed rules file
   pushed to production is the one failure mode that reaches every
   installed app at once — though note the app already discards invalid
   payloads and keeps its last good copy, so this is defence in depth,
   not the only guard.
5. **Add a schema-parity test** asserting the bundled file and the
   publishable file are byte-identical, so they cannot silently drift.
6. Leave the constant as a placeholder with a clear comment, but make it
   a **one-line change** for me. Tell me exactly which file and line.

---

### Part 3 — Bulgaria: BGN → EUR (QUESTION-007 is a bug, not a question)

Bulgaria adopted the euro on **1 January 2026** at the irrevocably fixed
rate **1 EUR = 1.95583 BGN**. The National Revenue Agency publishes 2026
contribution bases in EUR
(https://nra.bg/wps/portal/nra/osiguryavane/osiguritelen-dohod-2), and the
VAT registration threshold is now EUR 51,130
(https://nra.bg/wps/portal/nra/taxes/dds-v-balgariya/registratsiya-po-zdds).

That was eight months ago. The new freelancer calculator correctly shows
EUR while the salary and VAT tools still show BGN — so the app currently
contradicts itself inside one session, and every Bulgarian user sees the
wrong currency on the app's two headline features. Bulgaria is one of
nine markets and this is the kind of defect a Play Store reviewer or a
first-week user finds immediately.

1. **Audit first, then change.** Find every place BGN appears: the
   country/currency model, salary calculator constants, VAT tool,
   expense/income tracking, budget planner, savings and loan calculators,
   invoice tracker, the currency converter's pair list, number formatting
   and symbol rendering, and all 9 ARB files. Report the full list before
   editing so I can see the blast radius.
2. **Move Bulgaria's tax constants into `tax_rules.json`** if any still
   live in Dart, in EUR, with `effectiveFrom: "2026-01-01"` and NRA
   sources — same rule as PROMPT-004: no tax constant in Dart code.
3. **Migrate stored user data.** Any amount a Bulgarian user already
   saved (expenses, income, budgets, savings goals, invoices) is in BGN
   and must be divided by 1.95583 exactly once.
   - Use the fixed statutory rate, never a live FX rate. This is a
     redenomination, not a conversion.
   - Make the migration **idempotent and versioned** — a persisted
     migration flag, so a re-run, a crash mid-migration, or a reinstall
     restoring a backup can never convert twice. Double conversion
     silently halves a user's financial history and is unrecoverable.
   - Round to 2 decimals at the point of display, but store full
     precision.
   - Write a test that runs the migration twice and asserts the second
     run is a no-op.
4. **Keep BGN in the currency converter** as a legacy/pegged entry if
   users may still hold or reference it, but peg it at the fixed
   1.95583 rather than fetching a live rate for it. Confirm what the
   existing rate source returns for BGN and handle it deliberately —
   report what you find.
5. **Dual display.** Bulgaria ran a mandatory dual-pricing period around
   changeover. Check whether it is still in force as of August 2026; if
   it is not, single EUR display is correct and simpler. Report your
   finding and what you implemented. Do not add a dual-display toggle
   unless it is actually required.
6. **l10n**: the Bulgarian ARB must use the euro symbol and Bulgarian
   euro formatting conventions. Verify the other 8 locales render
   Bulgarian amounts in EUR too.
7. Close QUESTION-007 in OPEN_QUESTIONS.md with what changed.

---

### Part 4 — Serbia: one calculator, not two (QUESTION-006)

Part 1 of PROMPT-004 rewrote all nine listings to promise a single
self-assessment calculator "for freelancers in your country." A Serbian
user opens the app and finds two overlapping tools. That makes the copy
fix cosmetic.

1. **Compare the two implementations honestly.** Does the old Serbia-only
   tool do anything the new engine does not — a field, an edge case, a
   saved-history feature, a nicer flow? Report the delta before deciding.
2. **Port any genuine gap into the new engine**, then remove the old
   tool. One calculator, reachable from one place.
3. **Migrate the old tool's saved data**, if it persisted anything, into
   the new engine's storage. Do not orphan user data. Same idempotency
   requirement as Part 3.
4. If you conclude the old tool should stay for a reason I have not
   anticipated, **do not remove it** — stop and make the argument, since
   that decision changes the store listing again.
5. Close QUESTION-006 in OPEN_QUESTIONS.md.

---

### Part 5 — Verification and report

1. `flutter analyze` clean; `flutter test -j 1` green with counts before
   and after; l10n key parity across all 9 ARBs.
2. One **release** build (`--split-per-abi`) succeeds; report actual
   per-ABI sizes against the < 30MB target from PROMPT-003.
3. Manually exercise the Bulgaria path end to end and describe what you
   saw: salary calculator, VAT tool, freelancer calculator and one saved
   expense, all in EUR, all consistent. If you build-verified rather than
   device-verified, say so explicitly — that caveat has been accepted
   before and remains acceptable, fabricating verification does not.
4. Report per the standard format, including: the BGN audit list and what
   changed, the Serbia delta and your decision, the git commit count, the
   exact file and line for the rules URL constant, and anything still
   open. Then STOP and await approval.

### Hard constraints

- No paid service, no backend, no API keys, no Firebase.
- No tax constant in Dart code.
- The app must be fully functional with the network permanently off.
- Never commit a keystore, signing config, or secret.
- BGN→EUR uses the fixed 1.95583 rate, never a live FX rate, exactly once.
