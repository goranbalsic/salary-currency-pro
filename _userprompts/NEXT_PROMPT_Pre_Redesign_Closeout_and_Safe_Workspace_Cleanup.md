# Next Prompt: Pre-Redesign Closeout + Safe Workspace Cleanup

## Purpose and stop condition

This is a **short closeout pass**, not the UI/UX redesign and not a new
feature phase. Finish any remaining bookkeeping, make the local project
workspace smaller without risking code or private signing material, write
one unambiguous handoff for the later full UI/UX redesign, commit/push
only safe project changes, and then STOP.

The owner will close the session after this pass. Later, the owner will
provide a separate comprehensive UI/UX redesign prompt. After that
redesign is implemented and reviewed, the project moves to real phone
QA, Firebase Test Lab, and Google Play Internal Testing.

Do not begin the redesign now. Do not redesign widgets, change themes,
add animations, add a splash screen, add features, alter monetization,
run Firebase, upload to Play Console, create Billing products, recruit
closed testers, or claim device/Billing verification.

---

## Current authoritative state

- `main` includes the signed production-release work and CTK saved state.
- Stage C is complete. The fiscal receipt QR scanner remains offline-only:
  no receipt-content network fetch, no WebView, and no claim of fiscal
  verification.
- Stage D app-side work is complete: Free/Pro gates, DEV/PROD flavors,
  DEV entitlement simulator, signed production artifacts, and no ads at
  launch.
- Google Mobile Ads/UMP and its transitive WebView dependency were removed
  completely. Do not reintroduce them.
- Production package: `rs.salarycurrencypro.salary_currency_pro`, version
  `1.0.0` / code `1`.
- Last verified app evidence: 525/525 tests, 584 l10n keys × 9 locales,
  `flutter analyze` clean except the same three known unrelated info
  notices. Final post-Ads sizes: armeabi-v7a 26.1MB, arm64-v8a 29.4MB,
  x86_64 31.8MB. x86_64 remains modestly over the 30MB target and is
  honestly disclosed; never call it under budget.
- The owner has a verified Personal Google Play Console account and a
  locally created upload keystore/key.properties. **Never read, print,
  copy, commit, move, delete, or request** the contents of
  `android/key.properties`, the `.jks` key file, or passwords.
- Real phone QA, Firebase Test Lab, Play Internal Testing, real Billing,
  and the Personal-account closed-test requirement remain pending.
- Pre-existing CTK toolkit-sync files may be locally uncommitted. They
  are unrelated to app work: do not stage, revert, delete, or include
  them in this pass.

---

## Checkpoint 1 — Reconcile and write the redesign handoff

1. Read the existing CTK state, `PROJECT_CONTEXT.md`, `DECISIONS.md`,
   `DEVICE_TEST_CHECKLIST.md`, `PLAY_CONSOLE_CHECKLIST.md`, and latest
   session log. Reconcile with actual Git `main`; do not trust stale prose
   over the repository.
2. Add a concise `UI_REDESIGN_HANDOFF.md` at the project root (or the
   project’s established docs location if one is clearly more appropriate)
   containing only:
   - What is functionally complete and must be preserved.
   - Final Free/Pro boundaries.
   - Non-negotiable offline/privacy/network boundaries.
   - Screens/features expected to be visually redesigned later.
   - What is deliberately deferred until *after* redesign: phone QA,
     Firebase Test Lab, Play upload/Billing, closed testing.
   - Required redesign verification per checkpoint: tests, analyze, 9-l10n
     parity, browser screenshots; signed artifact/device/Firebase work
     only once at the redesign end.
   - A plain statement: “This is a presentation/usability redesign, not a
     mandate to change tax formulas, data models, storage, entitlement
     rules, product pricing, or approved feature scope.”
3. Update only stale or contradictory state/documentation. Do not rewrite
   historical records merely to make them prettier.
4. Do not rerun expensive release builds, signing checks, APK inspections,
   or full regression solely for this documentation checkpoint. Existing
   evidence is valid until source changes occur.

---

## Checkpoint 2 — Safe, targeted workspace cleanup

The owner wants the project root/workspace smaller. Start with an
**inventory**, not deletion:

1. Report the largest top-level directories/files in the project and
   clearly separate:
   - tracked source/assets/docs;
   - ignored/generated build output;
   - private local signing files;
   - unrelated CTK artifacts;
   - global tools/caches outside the project (Flutter SDK, Android SDK,
     global Gradle cache), which must not be touched in this pass.
2. Check Git status and tracked-file status before deleting anything.

### Authorized cleanup — only after confirming paths are ignored/generated

Delete only clearly regenerable project-local build/cache output such as:

- `build/`
- `android/app/build/`
- `android/.gradle/`
- `.dart_tool/`
- other clearly generated, Git-ignored Flutter/Gradle outputs under the
  project root

Use targeted deletion, never a blanket `git clean -fdx` command.

### Never delete, move, alter, or commit

- `.git/`
- `lib/`, `test/`, `assets/`, `android/app/src/`, `pubspec.yaml`,
  `pubspec.lock`, source-controlled documentation, or store-listing files
- `android/key.properties`, any `*.jks`/`*.keystore`, passwords, or
  signing configuration templates
- `.claude/` CTK toolkit-sync artifacts that were pre-existing/unrelated
- Android Studio project/run configuration files that are tracked
- the Flutter SDK, Android SDK, global Gradle cache, user profile folders,
  or anything outside the project root

### Release artifacts

Before deleting old APK/AAB artifacts, list exact paths, timestamps, and
sizes. The owner authorizes deletion of **old generated artifacts only**
after this list is reported, but preserve the latest signed production
AAB/APK evidence until the owner explicitly confirms it has been copied
or backed up outside the project. Do not move or copy signing keys.

3. After cleanup, report before/after project-root size and exactly which
   paths were removed. A subsequent `flutter pub get`/build may recreate
   generated directories; that is expected.

---

## Checkpoint 3 — Close safely and stop

1. Commit/push only the handoff/documentation and any safe source-controlled
   cleanup changes. Generated output deletions normally should not be
   committed if ignored.
2. Confirm the secret safety boundary: no `key.properties`, keystore,
   password, APK signing secret, or unrelated CTK artifact was staged or
   committed.
3. Save a CTK session checkpoint that says the **next work is a separate,
   owner-supplied full UI/UX redesign prompt**. It must state that external
   testing/Play work is paused until the redesign is complete.
4. Stop. Do not initiate any UI change or test run after the checkpoint.

## Final report format

Documentation reconciled / UI redesign handoff location / workspace
inventory and before-after size / generated paths removed / release
artifacts retained or owner-confirmed deleted / Git status and secret
safety / commit + pushed SHA / exact next step: await full UI/UX redesign
prompt. Then STOP.
