# PROMPT-003H — Stage C Item 10: Offline Fiscal-Receipt QR Scanner Shell

## Authorization and hard boundary

You are explicitly authorized to begin and complete PROMPT-003 Stage C item 10: **Fiscal receipt QR scanner — offline shell only**.

- **Repository:** `goranbalsic/salary-currency-pro`
- **Branch:** `main`
- **Starting baseline:** `origin/main` at `947ceb44f72ddf1c1bf5f36c8ed50a81fa30bb86`

Stage C items 11, 12, and 13 are complete. Item 10 is the final Stage C item.

## Absolute non-negotiable network boundary

**Do not implement, call, schedule, stub-call, or test any network request that retrieves fiscal-receipt contents.**

In particular:

- Do not call `suf.purs.gov.rs`, or any Serbian tax authority endpoint.
- Do not add HTTP, browser-webview, scraping, cloud, analytics, telemetry, or remote-configuration behavior for this feature.
- Do not parse a receipt page by resolving a URL.
- Do not imply that a scanned QR code has been fiscally verified.

The scanner may capture a QR payload or URL locally, classify it locally, persist it locally, and place it in a local queue labelled **“Scanned, awaiting fetch”** (localized). It may let the user create a manual expense from that scan, with the user entering the amount and any necessary fields.

Create exactly one clearly named service interface/method representing the future receipt-content fetch boundary. Its implementation must be unavailable/offline and must contain exactly one clearly worded TODO stating that network retrieval requires a separate Phase 12 online-review approval. Document this boundary in `DECISIONS.md`.

After this item is complete, report and **STOP**. Do not start Stage D, online receipt retrieval, monetization, or any other follow-up work.

## Mandatory session start

Before editing:

1. Pull and inspect `origin/main`; confirm HEAD, branch, and clean/dirty working-tree state.
2. Run `/ctk:resume`, then read the current CTK state and all files it identifies as needed.
3. Inspect `PROMPTS.md`, `DECISIONS.md`, `OPEN_QUESTIONS.md`, `PROJECT_CONTEXT.md`, existing expense/invoice models and persistence, current permissions setup, l10n conventions, navigation, accessibility patterns, existing offline service boundaries, and relevant tests.
4. Register this prompt in `PROMPTS.md` as **in progress**.
5. Audit the target platforms and current app configuration before adding a scanner dependency. Confirm Android/iOS permission requirements, minimum platform compatibility, offline behavior, supported barcode formats, maintenance status, license, and whether the dependency has any network/analytics behavior.

## User-facing deliverable

Build an offline-first fiscal-receipt scan flow with the following capabilities.

### 1. Scanner entry and camera handling

- Add a clearly discoverable Fiscal Receipt Scanner entry point in the appropriate existing app area.
- Scan QR codes using the device camera, locally.
- Request camera permission only when the user initiates scanning.
- If permission is denied, permanently denied, unavailable, unsupported, or the camera cannot start, show a clear localized explanation and a safe recovery path. The rest of the app must continue to work normally.
- Provide an accessible manual-entry alternative for raw QR payload/URL so the feature remains usable without a camera and testable without device hardware.
- Avoid adding photo-library scanning, OCR, background scanning, or non-QR barcode support unless already supported at negligible complexity and genuinely needed. QR is the scope.

### 2. Local classification and adapter architecture

- Implement a country-adapter architecture for local receipt-payload recognition.
- Implement Serbia’s adapter first, recognizing the **documented `suf.purs.gov.rs` fiscal receipt URL format locally only**. Validate only what can be safely inferred from the payload format; do not claim validation against a remote system.
- Preserve unknown, unsupported-country, malformed, and non-fiscal QR payloads as explicit local outcomes with useful localized explanations. Do not discard a scanned raw payload silently.
- Make adapter selection deterministic and unit-testable. Do not hard-code Serbia-specific logic into UI widgets or persistence code.
- Keep future country additions additive: one adapter per country, registered through a single registry/factory.

### 3. Local receipt queue

- Persist scans locally using the project’s established storage approach.
- Each local record must have a stable ID, raw payload/URL, detected country/type or unknown state, scan timestamp, local queue status, and optional user-entered notes.
- The primary queue status after capture is **“Scanned, awaiting fetch.”** It must not suggest that an online fetch will occur automatically.
- Build a queue screen with clear empty, loading, malformed/unsupported, and stored-scan states. Users must be able to inspect a stored scan and delete it with the project’s established destructive-action confirmation pattern.
- Do not store camera frames, images, or any receipt content obtained from external services.

### 4. Manual expense creation from a scan

- From a stored scan, offer **Create manual expense**.
- Pre-fill only safe local metadata, such as a note/reference based on the scan; do not infer merchant, amount, tax, date, receipt lines, or fiscal status from the URL.
- The user must enter the amount manually and select or confirm all required expense fields.
- Reuse existing expense models, validation, money formatting, categories, and persistence. Do not create a parallel expense system.
- Make the linkage between a created expense and its originating local scan explicit only if the existing model can support it additively and privately; otherwise retain a local non-authoritative reference without changing established expense semantics.

## Architecture and privacy constraints

- Offline-only means no network I/O from this feature, including error reporting, telemetry, remote settings, URL previews, or automatic browser launch.
- Use the app’s existing local storage and dependency-injection/provider conventions.
- Keep scanner, classification, queue persistence, manual-expense handoff, and future-fetch boundary as separate testable layers.
- Keep a clean service boundary so future monetization gating is one-line work, but do not add any paywall, entitlement, subscription, advertising, account, or analytics code now.
- All user-visible strings must be localized in exactly nine locales: `en`, `sr`, `hr`, `bs`, `mk`, `sl`, `bg`, `sq`, `ro`. Do not hard-code user-facing text.
- Preserve accessibility: semantics labels and hints for scanner controls, labelled permission/error states, keyboard-safe manual entry, logical focus order, screen-reader descriptions for queue status, and non-color-only status cues.
- Do not modify unrelated calculators, tax logic, exchange-rate behavior, invoices, or item-13 comparison semantics.

## Dependency rule

A scanner dependency is permitted only if necessary. Before adding one:

1. Prefer a mainstream Flutter package with active maintenance, permissive license, local camera/barcode processing, and no required cloud account or network operation.
2. Verify its package/API behavior from primary package documentation and lock the exact resolved version.
3. Document name, version, license, offline behavior, platform implications, and reason it is preferred in `DECISIONS.md`.
4. Do not add a second scanner package or a dependency solely for a visual scanner overlay.

## Checkpoint sequence

### Checkpoint 1 — Audit, data model, and offline boundary

- Complete the platform/permission, storage, expense-model, and scanner-dependency audit.
- Define scan record schema, queue state machine, Serbia adapter contract, raw-payload retention policy, deletion behavior, manual-expense handoff, and exact future-fetch interface.
- Add pure models, adapter registry, classifier, local persistence service, and the unavailable future-fetch interface before camera UI.
- Add unit tests for Serbia-format recognition, unknown/malformed input, deterministic adapter selection, record serialization/migration, queue transitions, deletion, and proof that the future-fetch implementation performs no network operation.
- Update `DECISIONS.md` and `OPEN_QUESTIONS.md` as warranted.
- Run `flutter analyze` and `flutter test -j 1`.
- Commit checkpoint 1.

### Checkpoint 2 — Scanner and permissions UI

- Add the discoverable entry point, camera scan UI, permission handling, and manual raw-payload entry fallback.
- Ensure scanner lifecycle handling is safe: no duplicate scans, no active camera after leaving the page, and no crash when permission changes or camera startup fails.
- Add widget tests for initial, permission-denied, camera-unavailable, manual-entry, malformed/unknown, and valid Serbia-recognition states. Mock platform/camera APIs; do not require hardware in unit/widget tests.
- Update all nine locales and run the automated parity test.
- Run `flutter analyze` and `flutter test -j 1`.
- Commit checkpoint 2.

### Checkpoint 3 — Queue and manual expense flow

- Implement persisted local scan queue, scan-detail screen, deletion confirmation, and manual-expense creation handoff.
- Add tests for persistence across service recreation, queue/list order, explicit awaiting-fetch wording, deletion, missing required manual expense data, successful expense creation, and preservation of existing expense behavior.
- Verify no screen offers a network-fetch action and no code path can initiate network retrieval.
- Run `flutter analyze` and `flutter test -j 1`.
- Commit checkpoint 3.

### Checkpoint 4 — Final regression and release evidence

- Run `flutter analyze`.
- Run the full suite serially: `flutter test -j 1`.
- Run `flutter build apk --release --split-per-abi`; report exact ABI sizes, compare them with item 13’s 23.3MB / 25.0MB / 26.5MB baseline, and confirm whether each remains below the 30MB per-ABI budget. If unable to build, state the exact blocker.
- Run the project’s l10n parity test and report exact locale/key results.
- Update `PROJECT_CONTEXT.md` with concrete device-verification needs: Android/iOS permission behavior, real camera scanning, scanner lifecycle/backgrounding, and a real Serbian fiscal URL classification sample. State explicitly that this is format recognition only, not remote fiscal verification.
- Update `PROMPTS.md`, `DECISIONS.md`, session log, and CTK checkpoint state.
- Commit the final checkpoint, push all item-10 commits to `origin/main`, then stop.

## Required automated coverage

At minimum, include tests for:

- Serbia URL/payload recognition against documented local-format examples and rejection of malformed near-matches.
- Unknown, unsupported-country, and generic QR payload handling without data loss.
- Adapter registry ordering and isolation from UI/persistence.
- Scan-record serialization, migration/default safety, persistence, deletion, and deterministic queue ordering.
- Explicit awaiting-fetch state and its accessibility labels.
- Future-fetch interface is unavailable/offline and no implementation performs network I/O.
- Permission denied, permanently denied, unavailable camera, camera-start failure, and manual-entry fallback.
- Duplicate-scan suppression and scanner lifecycle behavior where testable.
- Manual expense validation, amount entry, created-expense persistence, and regression protection for existing expense flows.
- All nine locales’ l10n key parity.
- Regression coverage for existing calculators, invoices/PDF/IPS QR, notifications, and cross-border comparison.

## Completion report format

After final commit and push, report only what you actually verified:

1. **Implemented:** Scan entry, supported local recognition, unsupported/unknown behavior, persistence, queue, manual expense flow, and future-fetch boundary.
2. **Privacy and network boundary:** State every mechanism used to ensure no network retrieval exists, and name the single future-fetch interface/TODO location.
3. **Dependency and permissions:** Package/version/license, offline behavior, platform permissions changed, and rationale.
4. **Tested:** Exact commands, counts, and what the automated tests prove.
5. **Localization:** New-key count and proof of nine-locale parity.
6. **Static analysis:** Exact output, separating pre-existing issues from new ones.
7. **Build:** Exact command, result, and split-per-ABI sizes.
8. **Device verification still needed:** Specific Android/iOS camera, permission, lifecycle, and scan scenarios.
9. **Decisions and open questions:** Exact IDs added or updated.
10. **Commit hashes and push status.**
11. **Explicit stop statement:** “Stage C is complete. No network fiscal-receipt retrieval was implemented. Stage D has not been started and requires separate explicit approval.”

Do not overclaim. A local match to a Serbian fiscal-receipt URL format is not fiscal verification, and no real-device scan, permission behavior, or external receipt content may be claimed as verified unless it was actually tested.
