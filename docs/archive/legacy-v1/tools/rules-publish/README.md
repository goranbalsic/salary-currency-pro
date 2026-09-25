# Publishing tax_rules.json — runbook

Five-minute guide, no Flutter knowledge required. Read this fully before
your first publish.

## What this is

Salary & Currency Pro's freelancer self-assessment calculator reads its
tax rates from a JSON file. Every installed app ships with a bundled copy
(`assets/config/tax_rules.json`) so it always works fully offline. On top
of that, the app *optionally* checks once a day for a newer copy at a
public URL and, if one exists and validates, starts using it — without
needing a new Play Store release. That public copy is the file in this
folder: `tools/rules-publish/tax_rules.json`.

**There are two copies of this file on purpose:**

| File | Purpose |
|---|---|
| `assets/config/tax_rules.json` | The bundled copy. Baked into the app at build time. The floor — always works, even on a plane. |
| `tools/rules-publish/tax_rules.json` | The publishable copy. What you edit and push to the public rules repo. |

They must always be **byte-identical** — this repo has an automated test
(`test/rules_publish_parity_test.dart`) that fails the build if they ever
drift apart. Edit one, then copy it over the other (step 3 below) — never
edit them independently.

## Where it's hosted

A **separate, small, PUBLIC** repository — distinct from this app's own
repository, which should stay private. The rules file must be fetchable
by anonymous clients with no login, so it can't live in a private repo.
Recommended: create a new public GitHub repo (e.g.
`salary-currency-pro-rules`) containing nothing but `tax_rules.json` (and
optionally this README, for your own future reference). GitHub Pages also
works if you'd rather serve it from a custom domain — either way, you end
up with one plain URL that returns the JSON file's raw bytes.

Raw-file URL format:

```
https://raw.githubusercontent.com/<your-username>/<rules-repo>/main/tax_rules.json
```

**Important:** `raw.githubusercontent.com` sits behind a CDN and caches
responses for roughly five minutes. If you push an update and immediately
check the URL, you may briefly still see the old content — that's
expected, not a bug. Give it a few minutes.

## How to update a rate

1. **Edit `tools/rules-publish/tax_rules.json` directly** (not the bundled
   copy — that only changes on the next app release). For the value you're
   changing:
   - Update `"value"`.
   - Update `"effectiveFrom"` to the real date the new rate takes effect
     (ISO format, `YYYY-MM-DD`).
   - Update `"source"` to the URL where you found the new figure. Never
     leave a stale source pointing at the old rate.
2. **Bump the top-level `"rules_version"`** to today's date (or the date
   you're publishing). This is what tells every installed app "this copy
   is newer than what you have" — if you forget this step, your change
   will be silently ignored by every app that already has an equal-or-newer
   version.
3. **Validate before publishing** (see below) — every time, no exceptions.
4. **Publish** (push to the public rules repo).
5. **Confirm a device picked it up** (see below).

## Validate before every publish

```
dart run tools/rules-publish/validate.dart
```

This checks the file against the exact same schema the app enforces at
runtime: every regime present, every value carrying both `effectiveFrom`
and `source`, `rules_version` is a real date. It prints `OK` with a
summary, or `FAIL` with the specific problem, and exits non-zero on
failure.

**Why this matters:** a malformed rules file pushed to the public repo is
the one failure mode that could reach every installed app at once if
nothing caught it. In practice the app itself is defence in depth here
too — `TaxRulesService` discards any payload that fails schema validation
and silently keeps using its last good copy, so a bad publish degrades to
"no update happened" rather than a crash. Still: always validate before
publishing. Don't rely on the app's own safety net as your only check.

## Publish

Whatever git workflow you're comfortable with, applied to the **separate
public rules repo**, e.g.:

```
cd path/to/salary-currency-pro-rules
cp path/to/salary-currency-pro/tools/rules-publish/tax_rules.json .
git add tax_rules.json
git commit -m "Update <country> <what changed>, effective <date>"
git push
```

## Confirm a device picked it up

The app checks for updates at most once every 24 hours, with a 5-second
timeout, and never blocks startup on the check. To confirm it worked:

1. Open the app's Freelancer Self-Assessment screen.
2. Look at the small "Rates ... version {date}" line near the bottom.
3. If it says the new `rules_version` and "updated over the air" rather
   than "bundled with the app", the device has the new copy.

If it still shows the old version after a day, check: the raw URL
actually returns your new content (allow for the ~5 minute CDN cache),
and that `kFreelanceTaxRulesRemoteUrl` in
`lib/services/tax_rules_service.dart` actually points at your repo (see
below) — a wrong or still-placeholder URL fails silently by design, so
there's no error message to find; the symptom is simply "never updates".

## One-line change: pointing the app at your real rules repo

This has not been done yet — the constant is still a placeholder. Once
your public rules repo exists, change exactly one line:

**File:** `lib/services/tax_rules_service.dart`
**Constant:** `kFreelanceTaxRulesRemoteUrl`

```dart
const String kFreelanceTaxRulesRemoteUrl =
    'https://raw.githubusercontent.com/REPLACE_ME/salary-currency-pro-rules/main/tax_rules.json';
```

Replace the URL with your real one, matching the format above. Nothing
else in the app needs to change — the fetch/validate/fallback logic
already works, it's just pointed at a host that doesn't exist yet.
