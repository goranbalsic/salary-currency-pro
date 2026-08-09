# DECISIONS.md

## D-032 — PROMPT-003H Stage C item 10: Offline Fiscal-Receipt QR Scanner Shell (in progress)

- **Date:** started 2026-08-08. Implements
  `_userprompts/PROMPT-003H_StageC_Item10_Offline_Fiscal_Receipt_QR_Scanner.md`.
  One entry, appended per checkpoint, matching the D-029/D-030/D-031
  precedent. This is Stage C's final item, run last per PROMPT-003D's own
  working order (11 → 12 → 13 → 10).
- **Hard network boundary (the point of this item):** no code in this
  feature performs network I/O. The scanner classifies a QR payload
  locally (string/URL shape only), stores it locally, and lets the user
  create a manual expense from it. It never calls `suf.purs.gov.rs` or any
  other endpoint, never resolves a receipt URL, and never claims fiscal
  verification. See the single future-fetch boundary below.
- **Checkpoint 1 — audit, data model, offline boundary:**
  - Audited `ExpenseEntry`/`ExpenseService` (`lib/models/expense_entry.dart`,
    `lib/services/expense_service.dart`) as the persistence/model pattern
    to mirror: `SharedPreferences` JSON blob under one key, a
    `ValueNotifier<int> changes` counter for live refresh, try/catch
    degrade-to-empty on corrupt data, a `maxEntries` cap, tolerant
    `fromJson` defaults for forward migration safety. `FiscalReceiptScan`
    (`lib/models/fiscal_receipt_scan.dart`) and
    `FiscalReceiptScanService` (`lib/services/fiscal_receipt_scan_service.dart`)
    follow this exactly (key `fiscal_receipt_scans_v1`, cap 500).
  - Audited `ToolsHubScreen` (`lib/screens/tools/tools_hub_screen.dart`)
    and `HistoryToolIds` (`lib/models/history_entry.dart`) as the
    established pattern for a new discoverable tool entry point +
    recent-activity id; the scanner entry point will follow this in
    checkpoint 2.
  - Audited the destructive-action confirmation pattern
    (`ExpenseTrackerScreen._confirmDelete`: `AlertDialog` with
    cancel/delete actions, then a snackbar with an undo action) to reuse
    for scan deletion in checkpoint 3.
  - Audited `android/app/src/main/AndroidManifest.xml` (only
    `POST_NOTIFICATIONS`/`RECEIVE_BOOT_COMPLETED` today, no camera
    permission yet) and confirmed `minSdk = flutter.minSdkVersion`.
  - **Adapter architecture:** `ReceiptCountryAdapter`
    (`lib/logic/receipt_scan/receipt_country_adapter.dart`) is a one-method
    interface (`classify(payload) -> ReceiptScanOutcome?`, null = "not
    this country's format, try the next adapter"). `SerbiaReceiptAdapter`
    (`lib/logic/receipt_scan/serbia_receipt_adapter.dart`) recognizes the
    documented `https://suf.purs.gov.rs/v/?vl=<payload>` shape by parsing
    the URL and checking scheme/host/path/non-empty `vl` param — pure
    string/URL inspection, no network call, not fiscal verification.
    `ReceiptAdapterRegistry` (`lib/logic/receipt_scan/receipt_adapter_registry.dart`)
    holds a single ordered `List<ReceiptCountryAdapter>`; adding a country
    later is implement-and-append, nothing else. A lookalike host (e.g.
    `suf.purs.gov.rs.evil.example`) is deliberately treated as
    not-applicable (null), not a Serbia near-match, so a phishing-style
    domain can never be misclassified as a broken Serbian receipt.
  - **Queue state machine:** `ScanQueueStatus` has exactly two values —
    `awaitingFetch` (the permanent default; this app never transitions a
    scan to a "fetched"/"verified" state, because it never fetches) and
    `expenseCreated` (set only by `FiscalReceiptScanService.linkExpense`
    after the user manually creates an expense from the scan). No status
    value exists that could imply automatic or completed retrieval.
  - **Future-fetch boundary (exact location):**
    `FiscalReceiptFetchService` (abstract) and its only implementation,
    `UnavailableFiscalReceiptFetchService`, both in
    `lib/services/fiscal_receipt_fetch_service.dart`. The implementation
    always returns `FiscalReceiptFetchStatus.unavailable` and performs no
    network I/O; the file carries exactly one `TODO(Phase 12 online
    review)` comment directly above the class, stating that real network
    retrieval requires separate, explicit Phase 12 online-review approval.
  - **Manual-expense handoff:** reuses `ExpenseEntry`/`ExpenseService`
    unchanged (per PROMPT-003H's "no parallel expense system" rule). The
    link back to the originating scan is one-directional and
    non-authoritative: `FiscalReceiptScan.linkedExpenseId` (additive field
    on the scan record only) is set by
    `FiscalReceiptScanService.linkExpense` after
    `ExpenseService.add(...)` succeeds in the checkpoint-3 UI flow.
    `ExpenseEntry` itself gains no new field — its existing semantics are
    untouched.
  - Unit tests added: `test/receipt_adapter_registry_test.dart` (Serbia
    format recognition, malformed near-matches, lookalike-host rejection,
    deterministic registry selection), `test/fiscal_receipt_scan_model_test.dart`
    (serialization round-trip, tolerant-migration defaults, `copyWith`),
    `test/fiscal_receipt_scan_service_test.dart` (record/load/delete/
    link-expense, newest-first ordering, corrupt-data degrade, `changes`
    notifier), `test/fiscal_receipt_fetch_service_test.dart` (always
    unavailable, completes well within a short timeout — proving no
    pending network call — and the status enum has exactly one value).
    33/33 new tests pass; `flutter analyze` clean on all new files.
  - **Dependency chosen for checkpoint 2 (recorded now since the audit
    happened in checkpoint 1):** `mobile_scanner` 7.4.0 (BSD-3-Clause,
    actively maintained, `github.com/juliansteenbakker/mobile_scanner`).
    Uses `com.google.mlkit:barcode-scanning:17.3.0` on Android — Google
    ML Kit's *bundled* on-device barcode API (`BarcodeScanning.getClient()`
    in the plugin's `MobileScanner.kt`), which ships its model in the app
    and does not perform a network model download at scan time — and
    AVFoundation/Apple Vision on iOS, ZXing on web. Requires
    `android.permission.CAMERA` (auto-merged into the manifest by the
    plugin) and iOS `NSCameraUsageDescription`; min Android SDK 21, this
    project's `minSdk` already resolves to that floor or higher. No
    required cloud account, no analytics, no network operation for the
    scanning function itself. Chosen over alternatives because it's the
    most-starred, most-actively-maintained pure-QR/barcode Flutter plugin
    with local-only processing and no forced Play Services network
    dependency for the on-device API path used here.
- **Checkpoint 2 — scanner UI, permissions, manual entry:**
  - `FiscalReceiptScannerScreen` (`lib/screens/tools/fiscal_receipt_scanner_screen.dart`),
    reachable from the Tools hub's Track & Plan category (new
    `toolsReceiptScannerTitle`/`Subtitle` entry,
    `lib/screens/tools/tools_hub_screen.dart`, id `fiscal_receipt_scanner`,
    not registered in `HistoryToolIds` — same as Expense
    Tracker/Budgets/Recurring/Subscription Radar, which also aren't
    tracked in the calculator-only "recently used" history).
  - Camera permission is requested only when this screen starts its
    `MobileScannerController` (`autoStart: false`, started explicitly in
    `initState`) — i.e. only once the user has already navigated here to
    scan, matching `NotificationService`'s existing "never proactively"
    permission-timing policy elsewhere in this app.
  - **mobile_scanner usage pattern:** `MobileScanner` (the plugin's
    preview widget) is kept permanently mounted once this screen builds,
    with its own `errorBuilder`/`placeholderBuilder` suppressed
    (`SizedBox.shrink()`) — the screen's own `_CameraBody` renders every
    state (starting/running/permission-denied/unavailable) instead, laid
    over the (invisible) preview. This isn't cosmetic: `MobileScannerController.start()`
    internally waits (with a timeout) for the `MobileScanner` widget's own
    `initState` to call `controller.attach()`; starting the controller
    before that widget exists in the tree at all — the naive
    "conditionally render `MobileScanner` only once running" structure —
    always fails with `controllerNotAttached`. Confirmed by reading
    mobile_scanner 7.4.0's own source
    (`mobile_scanner_controller.dart`/`mobile_scanner.dart`), not
    guessed.
  - **Robustness fix found by testing, not by inspection:** `MobileScannerController.start()`
    only resets its own `isStarting`/`error` state inside an `on
    MobileScannerException catch` block. Any other thrown object (e.g. no
    platform implementation registered at all, which is exactly what
    happens for every widget test in this suite, and would also happen on
    a real device with a broken/missing plugin registration) is left
    uncaught by the controller, leaving `isStarting: true` forever — an
    indeterminate `CircularProgressIndicator` that never resolves. Fixed
    in `_FiscalReceiptScannerScreenState._startCamera()` by catching that
    case and explicitly writing a definite errored `MobileScannerState`
    back onto the controller, so the camera-unavailable message is always
    reachable rather than an infinite spinner. This is a real offline/
    reliability fix (satisfies "no crash when camera startup fails"), not
    just a test workaround — it was caught by `pumpAndSettle` timing out
    in the widget tests below, and would have shipped as a genuine
    stuck-spinner bug on any device without the plugin properly linked.
  - **Manual-entry fallback:** always visible below the camera area
    (`OutlinedButton.icon`, `receiptScannerManualEntryButton`), regardless
    of camera state, opening a bottom sheet (`_ManualEntrySheet`) whose
    `TextEditingController` is created and disposed by that sheet's own
    `State` — not by the caller. An earlier version disposed the
    controller in the parent immediately after the sheet's route popped,
    which crashed ("used after being disposed") because the sheet's exit
    animation was still holding a live `TextField` attached to it;
    letting the sheet own its own controller lifecycle fixed this.
  - **Duplicate-scan suppression:** a `_processingDetection` guard plus an
    immediate `controller.stop()` on first detection — verified by a test
    that fires the same barcode twice in a row and asserts exactly one
    scan is persisted.
  - **Lifecycle:** `dispose()` calls `_controller.dispose()`
    (deliberately not awaited, since `State.dispose()` must stay
    synchronous) so no camera session outlives this screen.
  - **Widget tests** (`test/fiscal_receipt_scanner_screen_test.dart`, 10
    tests): built a `FakeMobileScannerPlatform extends MobileScannerPlatform`
    test double (mobile_scanner's own `PlatformInterface`-based
    testability seam — the same pattern `shared_preferences` and other
    federated plugins use) so every state is exercised with zero real
    camera/platform-channel dependency: initial/running, permission
    denied, unsupported, unexpected-platform-failure (camera
    unavailable), manual entry × (recognized/malformed/unknown/empty-
    validation), live-detection duplicate suppression, and screen-leave
    disposal. No hardware, mocked platform channel, or device required.
  - **Localization:** 23 new keys (`toolsReceiptScanner*`,
    `receiptScanner*`, `receiptScanStatusAwaitingFetch`) added to all 9
    locale `.arb` files and regenerated via `flutter gen-l10n`; both
    `test/l10n_parity_test.dart` checks pass (541 keys × 9 locales in
    lockstep).
  - **Permissions declared:** Android `android.permission.CAMERA` +
    `<uses-feature android:name="android.hardware.camera"
    android:required="false"/>` (explicit in the app's own manifest,
    documented with a comment, even though mobile_scanner's own manifest
    would merge the same entries — `required="false"` keeps the app
    installable on camera-less devices). iOS `NSCameraUsageDescription`
    added to `Info.plist` with a privacy-honest description ("stays on
    your device — nothing is uploaded").
  - `flutter analyze` clean on all new/changed files (3 pre-existing
    unrelated `unintended_html_in_doc_comment` info-level issues only).
    Full suite 477/477 (was 467 after checkpoint 1).
- **Checkpoint 3 — queue screen, manual expense handoff:**
  - **Audit first, per the checkpoint's own instruction:** re-read
    `FiscalReceiptScan`/`FiscalReceiptScanService` (checkpoint 1) and
    `FiscalReceiptScannerScreen` (checkpoint 2) before adding anything.
    Found no existing queue UI or parallel queue data structure to
    duplicate — `loadAll()` already returns newest-first, `delete`/
    `linkExpense` already exist — so this checkpoint is UI-only over the
    existing model/service, plus one small service addition (below).
  - **Queue-vs-linked-removal decision:** an item stays in the queue after
    linking, shown as "Linked to expense" rather than being removed. This
    was already the design checkpoint 1 built (`ScanQueueStatus.expenseCreated`
    is a terminal display state, not a deletion trigger) — checkpoint 3
    confirms and keeps it rather than introducing removal-on-link, matching
    how `ExpenseTrackerScreen` also never auto-removes a source record on
    linking elsewhere in the app. A linked item has no further forward
    action, so `_QueueTile` makes it non-tappable (`onTap: null`) once
    `status == expenseCreated` — the handoff sheet only opens for
    `awaitingFetch` items, preventing an accidental second expense from the
    same scan.
  - **New service method:** `FiscalReceiptScanService.restore()`, added
    only now because checkpoint 1's audit note flagged the delete-then-undo
    pattern (`ExpenseTrackerScreen._confirmDelete`) for reuse here; mirrors
    `ExpenseService.restore()` exactly (re-insert by id, no-op if the id
    already exists).
  - **`FiscalReceiptQueueScreen`** (`lib/screens/tools/fiscal_receipt_queue_screen.dart`):
    listens to `FiscalReceiptScanService.changes`, empty state, one
    `_QueueTile` per scan (status label + `receiptQueueScannedAt` timestamp
    + a 48-char-truncated raw-payload preview, never itself localized since
    it's opaque scanned text, not app copy), delete via the confirm-dialog +
    undo-snackbar pattern. Status label priority: `expenseCreated` →
    "Linked to expense"; else `outcome == unknownFormat` → "Unrecognized
    format"; else the existing `receiptScanStatusAwaitingFetch` string —
    never a "verified"/"fetched" state, matching the model's own
    boundary.
  - **`_ScanExpenseHandoffSheet`** (private, same file): creates the
    expense through the **existing** `ExpenseService.add(...)` — no
    parallel expense model — then calls
    `FiscalReceiptScanService.linkExpense`. Only the scan's own
    `scannedAt` is pre-filled (as the default expense date): the Serbia
    adapter doesn't parse a merchant/amount out of the payload today (see
    checkpoint 1's classifier — it only returns outcome + country id), so
    that timestamp is the one field "already deterministically provided"
    that the prompt's 3.2 asks to reuse. The amount field is always empty
    and required (`parseAmountInput(..., allowZero: false)`, same
    validator/error copy as `ExpenseTrackerScreen`'s own add sheet) — never
    inferred. Category/currency defaults and the currency dropdown mirror
    `_AddTransactionSheet` exactly, including the same
    `salary_selected_country_id` shared-prefs lookup for a default
    currency. Cancel/back writes nothing (the sheet has no side effect
    before `_save` runs), so a dismissed sheet leaves the scan record
    byte-for-byte unchanged — verified by a widget test that dismisses via
    the modal barrier and asserts zero expenses and an unchanged status.
  - **Navigation:** a new Tools hub entry (`toolsReceiptQueueTitle`/
    `Subtitle`, id `fiscal_receipt_queue`, Track & Plan category, not in
    `HistoryToolIds` — same non-tracked precedent as the scanner entry) so
    the queue is reachable without opening the camera, plus a small AppBar
    shortcut (`Icons.inbox_outlined`, `receiptScannerViewQueueTooltip`) on
    `FiscalReceiptScannerScreen` for the immediate after-scan path — both
    reuse `appPageRoute`, the app's standard push transition.
  - **Copy/disclosure discipline:** no string in this checkpoint uses
    "verified," "fetched," or implies tax-authority confirmation; the raw
    payload preview is labeled only by its scan timestamp, never presented
    as validated content.
  - **Tests:** `test/fiscal_receipt_scan_service_test.dart` gained 2 cases
    for `restore`. New `test/fiscal_receipt_queue_screen_test.dart` (10
    widget tests): empty state, populated/awaiting-fetch label,
    unrecognized-format label, delete-cancel keeps the scan, delete-confirm
    + undo, handoff pre-fill from `scannedAt`, required-amount validation,
    successful save creates a linked expense via the real `ExpenseService`,
    barrier-dismiss leaves the scan and expense list untouched, and a
    linked item stays non-tappable. New
    `test/fiscal_receipt_queue_no_network_test.dart`: a static source-scan
    regression guard asserting the queue module's source text never
    contains `suf.purs.gov.rs`, `dart:io`, `package:http`, `HttpClient`, or
    even a reference to `FiscalReceiptFetchService` — the future-fetch
    boundary stays a checkpoint-1-only concept this checkpoint doesn't
    touch. 13/13 new tests pass; full suite 490/490 (was 477).
  - **Localization:** 13 new keys (`toolsReceiptQueue*`, `receiptQueue*`,
    `receiptHandoff*`, `receiptScannerViewQueueTooltip`) added to all 9
    locale `.arb` files (554 keys × 9 locales) and regenerated via
    `flutter gen-l10n`; `test/l10n_parity_test.dart` passes.
  - `flutter analyze` clean (same 3 pre-existing unrelated
    `unintended_html_in_doc_comment` info-level issues as checkpoint 2,
    none in this checkpoint's files).
  - Per PROMPT-003H Checkpoint 3's own instruction, next and last is
    checkpoint 4 (final regression + release evidence + push), which
    closes item 10 — then this prompt's stop condition applies: STOP, no
    Stage D without a separate explicit go-ahead.
- **Reversibility:** Fully reversible — this is a new, additive feature
  behind its own models/services/screens; nothing existing is modified
  except `pubspec.yaml`/`pubspec.lock` (new dependency),
  `AndroidManifest.xml`/iOS `Info.plist` (camera permission), and the
  Tools hub's entry list.
- **Confidence:** High for checkpoints 1–3 (pure local logic, camera/
  permission/manual-entry UI states, and the queue/handoff flow are all
  covered by real, hardware-free automated tests). Real-device camera/
  permission behavior is build-verified only, not device-verified — see
  `PROJECT_CONTEXT.md`.

## D-031 — PROMPT-003G Stage C item 13: Cross-Border Pack — comparison semantics (done)

- **Date:** started 2026-08-08. Implements
  `_userprompts/PROMPT-003G_StageC_Item13_Cross_Border_Pack.md`. One
  entry, appended per checkpoint, matching the D-029/D-030 precedent.
- **Audit findings that shaped the design:**
  - `SalaryCalculator`/`CountryTaxConfig` (`lib/logic/salary_calculator.dart`,
    `lib/models/tax_config.dart`) is monthly-only — every bracket `upTo`
    and contribution `minBase`/`maxBase` is a monthly local-currency
    figure. There is no annual-bracket variant anywhere in the codebase.
  - `kCountries` (`lib/models/country.dart`) has exactly 9 entries; Bosnia
    is one country row with two legally separate entities (FBiH,
    Republika Srpska) requiring their own tax config, same as every other
    screen that touches Bosnia (`SalaryCalculatorProvider`,
    `FreelanceTaxScreen`).
  - Of the 9 countries' native currencies (RSD, EUR×4 [HR/ME/SI/BG],
    BAM, MKD, ALL, RON), `supportedCurrencies`
    (`lib/models/currency.dart`) — the *existing* currency converter's
    picker list — only covers RSD and EUR directly. BAM, MKD, ALL, RON
    have never been fetched or cached by any existing code path.
  - `ExchangeRateService.getRate` (`lib/services/exchange_rate_service.dart`)
    always attempts a live fetch first and only falls back to
    `RateCacheService` on failure — unusable as-is under this item's
    "no network call" constraint. `RateCacheService.load(provider, base)`
    keys strictly by (provider id, the `from` currency last queried), and
    the `open_er_api` provider (open.er-api.com) returns a *full* rates
    table for its base currency, not just the one pair requested — so a
    cache entry from any ordinary RSD-involving conversion the user has
    already run (the currency converter's own default is EUR→RSD, which
    routes to `open_er_api` with base `EUR`) already contains rates for
    every other world currency that provider covers, incidentally
    including BAM/MKD/ALL/RON if that provider quotes them — without this
    feature ever fetching anything itself.
- **"Same gross" semantics:** the user enters one gross figure **denominated
  in EUR** (no input-currency picker — avoids a second unresolved-currency
  axis on top of the comparison-currency one). For each country, that EUR
  figure is converted to the country's own local currency using a
  **cache-only** rate lookup, then run through that country's real,
  unmodified `SalaryCalculator`. Comparing the literal number (e.g. "1000")
  across countries without FX conversion was rejected — it would compare
  wildly different purchasing power as if equivalent, which the prompt
  explicitly forbids.
- **Comparison currency: EUR**, fixed (not user-selectable this item) —
  4 of 9 countries already use EUR natively, RSD↔EUR is always resolvable
  from the app's own default converter usage, and it avoids a second
  currency-picker. Every result is shown in local currency plus an EUR
  equivalent computed by re-using the *same* single rate looked up for the
  input conversion (`localAmount / rate`), rather than a second cache
  read — guarantees the input and output conversions never use
  inconsistently-aged snapshots.
- **Rate lookup — new `ExchangeRateService.getCachedRateOnly(from, to)`:**
  additive method, never calls a provider's `fetchLatest`. Same-currency
  pairs return an identity rate instantly (no cache needed — covers HR,
  ME, SI, BG directly). Other pairs try each read-only provider cache
  bucket keyed at `EUR` base (`frankfurter` then `open_er_api` — RSD-only
  pairs skip straight to `open_er_api` since Frankfurter never quotes
  RSD, matching `_providerFor`'s existing rule) and return the first
  cached snapshot that actually contains the target code. No existing
  method or the shared `_providerFor` routing was changed — this is a
  pure addition, zero risk to the currency converter's existing, already
  live-tested behavior. If nothing is cached, returns `null` — the UI
  must show this as an explicit "no cached rate yet" state per country,
  never a guessed number. In practice this means: RSD and all-EUR
  countries are reliably available from a first app run's own default
  converter screen; BAM/MKD/ALL/RON are available only if the user has
  separately triggered a live conversion (on the ordinary currency
  converter screen, outside this feature) that happened to cache them —
  disclosed honestly per-row, not hidden.
- **Pay period:** Monthly (native to the engine) or Annual. Annual mode
  divides the entered annual EUR gross by 12, computes the ordinary
  monthly breakdown, then multiplies every resulting figure by 12 for
  display — explicitly labelled as such in the UI. A true annual-bracket
  calculation was rejected: no modeled country's config expresses annual
  bracket thresholds, and inventing one would be a payroll-engine change,
  which this item's constraints forbid.
- **Employer total cost:** every modeled country's `SalaryCalculator`
  already produces `bruto2`/`employerContributionsTotal` uniformly from
  its own sourced config — no "not available" employer-cost case exists
  for any of the 9 countries under this design (unlike per-diem/mileage,
  below). Shown as its own column, clearly separate from gross and net.
- **Per-diem/mileage: excluded this item, all 9 countries, both rate
  types** — see `OPEN_QUESTIONS.md` QUESTION-010. Rigorously sourcing
  effective-dated official per-diem and mileage figures for 9 separate
  jurisdictions (10 regimes counting Bosnia's two entities) to this
  project's established evidence standard is not achievable to a
  trustworthy standard within one session; per the prompt's own
  instruction this must not block the core comparison/employer-cost
  feature, so it's excluded and logged rather than approximated.
- **Rounding:** every displayed amount (local and EUR-equivalent) is
  rounded through the existing `lib/utils/money.dart` `roundToMinorUnits`
  helper (introduced in D-030) — no new rounding logic.
- **Checkpoint 1 (design + pure models/service + tests) — done:**
  `lib/models/cross_border_comparison.dart` (`CrossBorderRegimeResult`,
  `CrossBorderRegimeError`, `CrossBorderRateInfo`,
  `CrossBorderComparisonResult`, `scaleBreakdownForPeriod`),
  `lib/services/cross_border_comparison_service.dart`
  (`CrossBorderComparisonService.compare`), and
  `ExchangeRateService.getCachedRateOnly` (additive, doesn't touch
  `getRate`/`_providerFor`, zero risk to the live currency converter).
  33 new tests (`test/cross_border_comparison_test.dart`,
  `test/cross_border_comparison_service_test.dart`, plus 9 added to
  `test/exchange_rate_service_test.dart`) covering: cache-only lookup
  never reaching a live provider, all-nine-country inclusion/ordering,
  explicit unavailable rows (never a guessed rate), same-gross FX
  semantics, propagation parity against `SalaryCalculator` invoked
  directly, employer-cost decomposition, Bosnia entity selection
  isolation, and annual-period scaling without float artifacts.
  `flutter analyze`: clean (same 3 pre-existing cosmetic notes as before,
  none new). `flutter test -j 1`: **425/425** (was 402).
- **Checkpoint 2 (comparison UI) — done:** `lib/screens/tools/
  cross_border_screen.dart` (`CrossBorderScreen`), added to the Tools hub
  (budget/tax category, alongside VAT and Budget — no dedicated
  "cross-border" category exists, and the tool isn't freelance-specific)
  and to `HistoryToolIds`/recently-used tracking, same pattern as every
  other tool. Gross input (EUR) + Monthly/Annual `SegmentedButton` + a
  Bosnia entity `DropdownButtonFormField` (reusing `localizedEntityName`)
  + Calculate button, matching `FreelanceTaxScreen`'s existing input-card
  shape. Results: a real `DataTable` (table is mandatory per the prompt)
  inside a horizontally-scrolling `SingleChildScrollView` so it never
  overflows a narrow phone width, one row per `kCountries` entry in that
  list's fixed order; unavailable rows show every numeric cell as a
  `Tooltip`+`Semantics`-labelled "—" carrying the real reason (no cached
  rate for `<CODE>`, or tax data unavailable) rather than a bare dash.
  Tapping an available row opens a `DraggableScrollableSheet` reusing
  `LabeledRow` and the *existing* `salaryBruto`/`salaryNeto`/etc. l10n
  keys from the Salary Calculator screen — no duplicate breakdown-label
  keys were added. 20 new l10n keys × 9 languages (**518/518 keys per
  locale, verified via `grep -cE '^\s*"[a-zA-Z]'`**) — country/entity
  names and the full breakdown detail reuse `l10n_lookups.dart` and the
  Salary Calculator's own keys rather than duplicating them.
  6 new widget tests (`test/cross_border_screen_test.dart`): initial
  empty state, populated + unavailable-data (Croatia resolves from an
  empty cache via EUR identity, Serbia shows an explicit "no cached
  rate" — never a guessed RSD figure), accessible tooltip/semantics
  label text, narrow-phone-width horizontal scroll with no overflow
  exception, row-tap detail sheet, and amount-validation error state.
  `flutter analyze`: clean. `flutter test -j 1`: **431/431** (was 425).
- **Checkpoint 3 (employer cost + optional rates) — done, mostly
  verification of what checkpoints 1–2 already built correctly:** every
  modeled country's employer total cost was already sourced (each
  country's own `assets/config/tax/<id>.json` employer contribution
  rates, same audited source as the Salary Calculator) and uniformly
  available — there is no country where the engine can't produce a
  defensible `bruto2`, so no employer-cost-specific "not available" case
  exists (unlike the rate-lookup unavailable case, which removes the
  *entire* row, employer cost included — confirmed by a new test rather
  than assumed). Added 5 targeted tests: comparison-currency rounding
  lands on a clean cent value for a repeating-decimal rate (100/3),
  an unavailable row never leaks a partial employer-cost figure, and
  each EUR-native country's employer cost is independently
  sourced/differs (never collapsed to one estimated figure). Per-diem/
  mileage: confirmed still correctly unimplemented and logged —
  `OPEN_QUESTIONS.md` QUESTION-010 — the core comparison/employer-cost
  feature is unaffected either way. `flutter analyze`: clean.
  `flutter test -j 1`: **434/434** (was 431).
- **Checkpoint 4 (final regression + release evidence) — done:** full
  `flutter analyze` clean (same 3 pre-existing, unrelated infos), full
  `flutter test -j 1` **434/434**, l10n **518/518 keys per locale** in
  lockstep across all 9 `.arb` files (verified via
  `grep -cE '^\s*"[a-zA-Z]' lib/l10n/app_*.arb`). Real
  `flutter build apk --release --split-per-abi`:
  **23.3MB / 25.0MB / 26.5MB** (armeabi-v7a/arm64-v8a/x86_64), up from
  item 12's 20.7/22.9/24.3MB (new feature, no new native dependency),
  comfortably under the 30MB per-ABI budget. `PROJECT_CONTEXT.md`'s
  device-unverified checklist extended for the Cross-Border Pack's
  table/detail layout, plus a missing item-12 entry backfilled (see
  `session_logs/2026-08-08-session-05.md`). **Item 13 is complete. Per
  PROMPT-003G's own instruction: item 10 was not started this session —
  it needs its own approved prompt.**

## D-030 — PROMPT-003 Stage C item 12: Invoice PDF + NBS IPS QR (in progress)

- **Date:** started 2026-08-08. Implements
  `_userprompts/PROMPT-003F_StageC_Item12_Invoice_PDF_NBS_IPS_QR_Enhanced.md`.
  Large item, built across several checkpoints per an approved plan; this
  entry is appended to as each checkpoint lands rather than split into
  separate decision records, matching the one-entry-per-item precedent
  (D-029).
- **Audit-first finding that shaped the whole plan:** the existing
  `Invoice`/`InvoiceService`/`InvoicesScreen` only tracked
  client/description/amount/currency/dates/paid-status — no line items, no
  invoice-number identity, and critically **no issuer/business identity
  anywhere in the app**. The app's only prior "export" feature (expense
  CSV) was `Clipboard.setData`, not a real file/share flow, and no
  PDF/QR/share/font dependency existed at all. This is a from-scratch
  build, not a small enhancement — see the full plan for the checkpoint
  breakdown.
- **Deliberately not adding VAT/tax fields this item.** The prompt only
  requires VAT display "if represented by the existing model" — it isn't,
  and adding it would mean inventing tax-calculation semantics the prompt
  doesn't ask for and risks the "don't alter the financial calculation/
  tax-rules path" rule. Generated PDFs show subtotal = total, no tax line.
- **Checkpoint 1 (Foundation) — done:**
  - `BusinessProfile` (`lib/models/business_profile.dart`) — new, single
    global record (one issuer per install, matching `Invoice`'s own
    single-user-tool philosophy): business name, address lines, optional
    RS bank account (NBS "R" tag) and default payment code (NBS "SF" tag).
    Persisted via `BusinessProfileService`
    (`lib/services/business_profile_service.dart`), same
    SharedPreferences + `ValueNotifier<int> changes` pattern as every
    other service in the app. Editable from a new "Business profile"
    section in Settings (`_BusinessProfileSection` in
    `lib/screens/settings/settings_screen.dart`).
  - `Invoice` gained four optional/defaulted fields (no schema-version
    migration needed, per the codebase's existing convention):
    `invoiceNumber` (plain editable text, no auto-numbering scheme —
    deliberately minimal), `items` (`List<InvoiceLineItem>`, new model at
    `lib/models/invoice_line_item.dart` — empty list falls back to
    rendering the existing single `description`/`amount` as one line, so
    today's simple-invoice flow is unaffected), `purpose` (NBS "S" tag
    source), `paymentReference` (NBS "RO" tag source).
  - **Deterministic money-rounding rule** (user-mandated guard added at
    plan approval): `lib/utils/money.dart`. All money summation happens in
    integer minor units (cents), never raw `double` accumulation. Each
    line item is rounded to the nearest cent exactly once
    (`roundToMinorUnits`, with a 1e-9 epsilon to counteract binary
    floating-point representation error — e.g. the double closest to
    1.005 is actually ~1.00499999999999989, which would otherwise round
    down to 100 minor units instead of the intended 101); integer cents
    are then summed exactly (`sumMinorUnits`), and only converted back to
    a `double`/formatted string at the storage/display boundary
    (`minorUnitsToAmount`, `formatMinorUnits`). `formatMinorUnits` takes a
    `decimalSeparator` so the same function serves both normal display
    (`.`) and the NBS "I" tag's required decimal comma (`,`) once the QR
    builder lands. `Invoice.totalFromItems` is the one place that must be
    used to compute a multi-item invoice's stored `amount`, so every
    screen reading `amount` directly (e.g. `InvoicesScreen`'s
    outstanding/overdue totals) stays correct. Covered by
    `test/money_test.dart`, including the specific representation-error
    case above and a repeating-decimal line-item case.
  - Fixed a real, pre-existing test fragility exposed (not caused by a
    bug, but by the new fields): two `widget_test.dart` cases used
    `find.descendant(of: find.byType(SettingsScreen), matching:
    find.byType(Scrollable))` expecting exactly one match; adding
    `TextField`s to Settings means more than one `Scrollable` now exists
    there (every `TextField`/`EditableText` has its own internal one).
    Fixed by taking `.first` (the outer `SingleChildScrollView`'s
    `Scrollable` is still first in tree order), not by weakening the test.
  - `flutter analyze` clean (3 pre-existing unrelated info-level
    `unintended_html_in_doc_comment` hints only), `flutter test -j 1`
    322/322 passing.
- **Checkpoint 2 (Journey, 12.1) — done:**
  - New `InvoiceDetailScreen` (`lib/screens/business/invoice_detail_screen.dart`):
    scannable header (client, invoice number if set, total, status,
    issue/due dates, itemized lines or description), then the action
    hierarchy the prompt asks for — Generate PDF (primary, `ElevatedButton`),
    mark paid/unpaid (`OutlinedButton`), delete last and visually separated
    (a plain `TextButton` in `alertRed`, not styled like the actions above
    it). `InvoicesScreen`'s tile `onTap` now pushes this screen instead of
    opening the edit sheet directly; the edit sheet (renamed from private
    `_InvoiceFormSheet` to public `InvoiceFormSheet` so the new file can
    reuse it) is reached from the detail screen's app-bar edit action.
    Quick mark-paid/delete icon buttons on the list tile itself were left
    untouched, per "preserve existing behavior unless a change is required."
  - **Generate PDF is a real, wired action with real in-flight feedback,
    but its actual PDF work is a placeholder until checkpoint 3** (`pdf`/
    `printing` aren't dependencies yet) — tapping disables the button,
    shows a spinner, and reports "PDF export is coming in a future
    update." rather than a dead/fake-looking control, and a rapid second
    tap while in-flight is a no-op (covered by
    `test/invoice_detail_screen_test.dart`). Never touches the stored
    invoice either way.
  - **NBS IPS QR eligibility text is deliberately deferred to checkpoint 4**,
    not built here — the plan originally scoped it into this checkpoint,
    but with no `NbsIpsEligibility` evaluator yet there was nothing honest
    to show; adding it once the real evaluator lands in 12.3 avoids a
    placeholder eligibility message that could read as a real answer.
  - **Itemization added to the add/edit sheet**, additive only: an empty
    item list leaves the original single amount field exactly as it was;
    adding one or more items switches that same field to read-only,
    showing `Invoice.totalFromItems` (via `lib/utils/money.dart`, so the
    same rounding guarantee applies here as everywhere else), with an
    "Add item"/remove-row UI beneath it. `InvoiceService.add` gained
    optional `invoiceNumber`/`items`/`purpose`/`paymentReference`
    parameters to carry this through. Covered by
    `test/invoice_itemization_test.dart`, including the specific
    floating-point case (3 × 0.1 → the field shows `0.3`, not a raw-double
    artifact).
  - `flutter analyze` clean, `flutter test -j 1` 328/328, l10n 10 new keys
    × 9 languages in lockstep.
- **Checkpoint 3 (PDF rendering, 12.2) — done:**
  - Added `pdf: ^3.11.3` (resolved 3.13.0) and `printing: ^5.13.4`
    (resolved 5.15.0) — both by David PhilBrick (DavBfr), MIT-licensed,
    offline/no-network, actively maintained. `barcode` and `qr` were
    pulled in transitively via `pdf`, confirming the plan's assumption
    that a separate `barcode` dependency won't be needed for checkpoint 4.
  - **Content/layout split**, as planned: `lib/pdf/invoice_pdf_content.dart`
    (`InvoicePdfContent`/`buildInvoicePdfContent` — a pure Dart content
    model with no `pdf` package dependency at all) versus
    `lib/services/invoice_pdf_service.dart` (`InvoicePdfService` — owns
    the actual `pw.Document`/`pw.MultiPage` layout and
    `Printing.layoutPdf` share/print call). This resolves
    `OPEN_QUESTIONS.md` QUESTION-009's item 3: the `pdf` package doesn't
    expose a text-content introspection API, so
    `test/invoice_pdf_content_test.dart` asserts real content rules
    (itemization, pagination-worthy line counts, status-label selection,
    issuer/recipient data, the money-rounding guarantee end-to-end)
    against the content model with zero `pdf` dependency, while
    `test/invoice_pdf_service_test.dart` is an honest smoke suite only
    (valid-PDF-bytes magic-number check across one-item/multi-item/
    pagination/long-text/every currency/paid-unpaid/missing-profile
    cases) — it does not and cannot claim to verify rendered visual
    content.
  - **Dropped the planned `InvoicePdfContent.note` field before it
    shipped**: it would have duplicated the single-line fallback's own
    description text (which already carries the invoice's `description`
    when there are no itemized lines), so keeping it would have meant
    either dead code or the description rendering twice. Caught during
    this checkpoint's own test-writing, not left in.
  - `InvoiceDetailScreen._generatePdf` now does the real thing: loads the
    business profile, builds the content model with localized status/
    table-header labels resolved from `AppLocalizations`, calls
    `InvoicePdfService.generate()` then `.shareOrPrint()`, all inside the
    existing in-flight guard/try-catch — a failure shows `invoicePdfError`
    and never touches the stored invoice. The checkpoint-2 stub
    ("PDF export is coming...") and its `invoicePdfComingSoon` l10n key
    are gone, replaced by `invoicePdfError` + `invoiceItemSubtotal`.
  - **Known, expected, and already-planned gap**: no custom font is
    bundled yet (that's checkpoint 5/12.4), so Cyrillic and Latin-Extended
    characters (Č, Ć, Š, Đ, Ž, mk/bg Cyrillic, Romanian ș/ț, etc.) don't
    render in the generated PDF yet — `pdf`'s base font logs "Unable to
    find a font to draw..." for these, visible in this checkpoint's own
    test output. Every language's *ASCII-range* content renders
    correctly now; full glyph coverage lands with the bundled font.
  - **Verification limits, stated explicitly per the prompt's own
    requirement**: `InvoicePdfService.generate()` (bytes) is
    automated-tested; `InvoicePdfService.shareOrPrint()` (the OS-native
    save/share/print dialog via `Printing.layoutPdf`) has no host-side
    implementation in the widget-test sandbox (`net.nfet.printing`
    channel), so `test/invoice_detail_screen_test.dart` mocks that
    channel to fail deterministically and asserts the app's own error
    handling — it does **not** verify the real share/print dialog, which
    needs device/emulator verification, not yet done.
  - `flutter analyze` clean, `flutter test -j 1` 345/345, l10n net +1 key
    (added `invoiceItemSubtotal`/`invoicePdfError`, removed
    `invoicePdfComingSoon`) × 9 languages in lockstep.
- **Checkpoint 4 (NBS IPS QR, 12.3) — done:**
  - `lib/logic/nbs_ips_payload_builder.dart` (`NbsIpsPayloadBuilder`) —
    pure, stateless, no I/O, modeled structurally on
    `FreelancerPayoutCalculator` but synchronous. Built and validated
    directly against the sourced field rules (cited at the top of
    checkpoint 1's entry above): `K:PR|V:01|C:1|R:...|N:...|I:...`
    mandatory, `P:`/`S:`/`RO:` optional and only ever emitted when
    non-empty. Returns a typed `NbsIpsPayloadResult` (success + payload,
    or failure + a full list of every field error found, not just the
    first) — never throws, never guesses a field.
  - **Account-number normalization is a direct transcription of the
    source document's own three worked examples**, not an invented rule:
    `840-955845-10 → 840000000095584510`,
    `165-55-74 → 165000000000005574`,
    `310-1234567891211-86 → 310123456789121186` — i.e. bank code (3
    digits) + account number zero-padded left to 13 digits + control
    number (2 digits). `test/nbs_ips_payload_builder_test.dart` asserts
    all three verbatim, plus a full exact-payload-string assertion
    (`K:PR|V:01|C:1|R:840000000095584510|N:Čigra doo|I:RSD1025,12|SF:289`)
    to catch any field-ordering or delimiter regression, 36 tests total.
  - **The amount field reuses the same `lib/utils/money.dart` rounding
    guarantee end to end** — `formatMinorUnits(minorUnits,
    decimalSeparator: ',')` — so the QR "I" tag can never carry a
    floating-point artifact any more than the PDF/UI can (explicitly
    tested with a 3×0.1 case, per the user's original rounding-rule
    guard).
  - **"N"/"P"/"S" character-set validation is deliberately narrower than
    the source document's own table**, which PDF text-extraction garbled
    beyond reliable reconstruction (documented in the file's own doc
    comment and `OPEN_QUESTIONS.md` QUESTION-009) — enforces length/line
    limits and rejects the reserved `|` delimiter (which would otherwise
    corrupt the payload's own field structure), not an exact charset
    whitelist. Honest simplification, not a silent gap.
  - `lib/logic/nbs_ips_eligibility.dart` (`NbsIpsEligibility`) — the
    detail-screen-facing evaluator. Operationally defines "Serbian RSD
    invoice" as `currencyCode == 'RSD'`, since `Invoice` has no separate
    country field and RSD is specifically Serbia's currency (the honest
    reading of what the model actually tracks, not an invented proxy).
    Three states: `notRsd` (no QR messaging shown at all, per the
    product standard's "no suggestion a non-Serbian invoice is
    deficient"), `missingOrInvalidData` (RSD but the business profile/
    amount doesn't validate), `eligible` (real payload attached).
  - **Wired end to end**: `InvoiceDetailScreen` now loads the business
    profile alongside the invoice, shows a `_QrEligibilityBanner` (plain
    text + icon, never color/icon alone, never shown for non-RSD) between
    the header and the action buttons, and `_generatePdf` passes
    `eligibility.payload` into the content model only when
    `eligibility.isEligible`. `InvoicePdfService` draws it via `pdf`'s own
    `Barcode.qrCode()`/`pw.BarcodeWidget` (from `package:barcode`, already
    a transitive dependency of `pdf` — confirms the plan's assumption
    that no separate `barcode` dependency would be needed) directly into
    the page as vector, fully offline, only ever from an
    already-validated payload.
  - `flutter analyze` clean, `flutter test -j 1` 391/391 (36 payload-
    builder + 5 eligibility + 3 QR-embedding smoke + 3 eligibility-banner
    UI tests added this checkpoint), l10n net +2 keys × 9 languages.
- **Checkpoint 5 (fonts/i18n/accessibility, 12.4) — done:**
  - **Font: Noto Sans, version 2.015, OFL-1.1 license** (bundled at
    `assets/fonts/NotoSans-OFL.txt`). Source: the official Google Fonts
    repository, `https://github.com/google/fonts`, path
    `ofl/notosans/NotoSans[wdth,wght].ttf` (main branch, fetched
    2026-08-08) — a variable font. Google Fonts no longer publishes
    static-weight Noto Sans files directly, so Regular (wght=400) and
    Bold (wght=700) static instances were produced locally with
    `fonttools varLib.instancer` (a standard, license-preserving
    technique — instancing a variable font doesn't alter its OFL terms),
    then subset with `fonttools subset` to the Unicode ranges the app's 9
    languages' free-text invoice fields actually need: `U+0020-007E,
    U+00A0-00FF, U+0100-017F, U+0180-024F, U+2000-206F, U+20A0-20CF,
    U+2122, U+0400-04FF, U+0500-052F` (Basic Latin, Latin-1 Supplement,
    Latin Extended-A/B — covering Croatian/Bosnian/Serbian-Latin
    č/ć/š/đ/ž and Romanian ș/ț — General Punctuation, Currency Symbols,
    Cyrillic + Cyrillic Supplement for mk/bg). This reduced each weight
    from ~646 KB to ~140 KB (976 glyphs each) — **`assets/fonts/
    NotoSans-Regular.ttf` (140,604 bytes) + `NotoSans-Bold.ttf`
    (140,760 bytes), ~275 KB total added to the app bundle**, measured
    directly, not estimated. Coverage spot-checked programmatically
    (Č/Đ/ș/ț/€/Cyrillic А/Ш/en-dash/left-quote all present) before
    bundling.
  - `pubspec.yaml`'s previously-commented placeholder `fonts:` block
    (flagged as a ready-made insertion point back in the Phase-0 audit)
    is now filled in with a `Noto Sans` family (regular + weight-700
    bold), and `assets/fonts/` added to `assets:`.
    `InvoicePdfService` loads both TTFs once via `rootBundle` and applies
    them as the `pw.Document`'s theme (`pw.ThemeData.withFont`) — this is
    what actually fixes checkpoint 3's known Cyrillic/Latin-Extended
    glyph gap (the `pdf` package's built-in base font previously logged
    "Unable to find a font to draw 'Č'"; that warning is gone as of this
    checkpoint's own test runs).
  - **Locale coverage tested explicitly**: new
    `test/invoice_pdf_locale_coverage_test.dart` runs one representative,
    real-script string per locale (Cyrillic for mk/bg, Latin diacritics
    for hr/bs/sr/sl/sq, Romanian ș/ț) through actual PDF generation with
    the bundled font — proves generation succeeds for every locale's
    characters. Explicitly does **not** claim to verify visual rendering;
    that needs real device/print verification, not yet done.
  - **New automated l10n parity check**: `test/l10n_parity_test.dart` —
    the project had no automated key-parity test before this (parity was
    manually verified per process). Asserts identical non-`@` key sets
    across all 9 `.arb` files and that exactly 9 exist. Passed cleanly
    against every key added across all 5 checkpoints of this item.
  - **Accessibility**: the NBS QR eligibility banner (checkpoint 4) was
    already plain text + icon, never color/icon alone. Added this
    checkpoint: the Generate PDF button is wrapped in `Semantics(button:
    true, label: ...)` with a distinct "Generating PDF…" label
    (`invoiceGeneratingPdf`, new key) while in flight, so a screen reader
    announces the loading state instead of just re-reading "Generate
    PDF" over a now-disabled control.
  - `flutter analyze` clean, `flutter test -j 1` 402/402, l10n net +1 key
    (`invoiceGeneratingPdf`) × 9 languages, parity now automated.
- **Checkpoint 6 (final regression + quality gate) — done, 2026-08-08.**
  Full `flutter analyze` clean (only the 3 pre-existing, unrelated
  `unintended_html_in_doc_comment` infos), full `flutter test -j 1`
  402/402 including every pre-existing invoice CRUD/status/notification
  test, unaffected by this item's additive model changes. Item 12 is
  **done** for this prompt's scope. Per PROMPT-003F's own instruction:
  stopped here, awaiting approval before Stage C item 13.

## D-029 — PROMPT-003 Stage C item 11: Serbia paušal & freelancer compliance pack

- **Date:** 2026-08-08. Implements PROMPT-003E (the sourced-figure narrowing
  of Stage C item 11 per `_userprompts/PROMPT-003E_StageC_Item11_Serbia_Compliance_Pack.md`),
  supersedes the general item-11 description in PROMPT-003D.
- **Audit-first, per the prompt's own instruction:** read the existing
  invoice tracker (`Invoice`/`InvoiceService`), the stored FX-rate layer
  (`ExchangeRateService`/`RateCacheService`/`rate_providers.dart`), the
  local notification system (`NotificationService`), and the existing RS
  freelance-tax engine (`rs_strategy.dart` + `tax_rules.json`'s `rs`
  regime) before writing anything. Found: (a) every sourced figure the
  prompt supplied (110,647/66,733/51,297/732,820/8,000,000/6,000,000, all
  dated) **already exactly matched** what PROMPT-004 had sourced into
  `tax_rules.json` — no conflict to report; (b) a real, pre-existing bug:
  `RsFreelanceStrategy.compute` charged the health contribution
  unconditionally, but the sourced formula waives it when the freelancer
  is insured elsewhere — fixed by adding an `insuredElsewhere` option
  (default `false`, preserving every existing test's behavior) rather than
  silently changing the default; (c) item 11.2's monthly reminder already
  existed from Stage B item 7 (`NotificationService.setPausalReminderEnabled`,
  day 15) — only the lead-time option and the assessed-amount body text
  were genuinely missing, so only those were added, not a new reminder
  type; (d) this app has **no historical-by-date FX archive** — see the
  rate-history design note below, the one real infrastructure gap the
  prompt's own wording didn't anticipate.
- **11.1 — Paušal turnover tracker** (`lib/models/pausal_turnover.dart`,
  `lib/services/pausal_tracker_service.dart`,
  `lib/screens/tools/pausal_tracker_screen.dart`): fed entirely by the
  existing `InvoiceService`, no new turnover data-entry surface. Tracks
  both limits simultaneously with their correct, different windows
  (calendar-year for the 6M paušal ceiling, rolling-365-days for the 8M
  VAT threshold) — both threshold values read from `tax_rules.json`'s `rs`
  regime (`pausalCeilingAnnual`/`vatThresholdRolling12m`), never a literal
  in Dart, so the tracker and the freelance-tax calculator can never
  silently disagree if the figures are ever updated. Early-warning states
  at 70/85/95%/exceeded, always paired with a text label (never color
  alone). Foreign-currency invoices with no captured rate are excluded
  and counted, never priced at a guessed/substituted rate.
  - **Rate-history design decision (the one real judgment call in this
    item):** the prompt asks to convert "at the invoice-date rate from
    the stored rate history," but this app has no such history —
    `ExchangeRateService` only ever fetches the *latest* rate, and
    `RateCacheService` caches only the most recent snapshot per provider.
    Building a full date-indexed historical FX archive was judged out of
    this item's scope (a genuinely new subsystem, not a gap-fill).
    Instead: the first time `PausalTrackerService` sees a foreign-currency
    invoice with no stored conversion, it captures a live (or
    cache-fallback) rate once and persists it permanently against that
    invoice id — immutable afterward, so totals stay stable across
    repeat views rather than drifting every time the screen reopens. This
    is honestly labeled in the UI as "rate: {source}" (the tap-through
    breakdown), never claimed as an NBS historical rate for the invoice's
    own issue date. An invoice whose rate could never be captured (no
    connectivity the first time, and every time since) stays excluded and
    counted — self-healing the next time a live rate succeeds. This is a
    disclosed approximation of "invoice-date rate," not a silent one —
    see the class doc comment on `PausalTrackerService` itself.
  - Projection: a simple current-pace linear projection
    (`calendarYearTotal / daysElapsedThisYear`) for the paušal ceiling
    only, shown only with ≥14 days of data, a positive pace, and a
    projected date within 10 years — never fabricated from too little
    data.
- **11.2 — Monthly obligation reminder extension**
  (`lib/services/notification_service.dart`,
  `lib/screens/settings/settings_screen.dart`): added an optional second,
  additive reminder 3 days before the 15th (`pausalLeadReminderId`, day
  12) — the existing day-15 reminder is never replaced, only supplemented,
  per the prompt's explicit wording. The notification body now includes
  the user's stored assessed monthly amount (`PausalTrackerService.
  getAssessedMonthlyAmount`) when set, via a new parameterized l10n string
  rather than string concatenation. Reuses the existing DST/reschedule-on-
  boot handling in `NotificationScheduler` — no second scheduling path.
- **11.3 — Model A vs Model B quarterly comparator**
  (`lib/screens/tools/freelance_tax_screen.dart`'s new
  `_RsComparatorSection`): deliberately independent of the existing
  single-model selector/result above it — always shows both models side
  by side for whatever income is typed, so opening it never changes the
  primary result. Shows the Model B minimum-PIO-base note whenever it
  actually binds (`FreelanceTaxResult.extra['minPioBaseBinds']`, new),
  the recommended model with the net-income delta, and a quarter selector
  with a filing deadline computed from the sourced
  `filingDeadlineDaysAfterQuarterEnd` field (30 days) rather than a
  hardcoded date. "Formula breakdown on tap" is satisfied by the existing
  row-by-row breakdown this calculator has always shown (deduction →
  taxable base → tax → contributions → net) — a deliberate scope choice
  to reuse the established pattern rather than build a second, parallel
  algebraic-string mechanism just for this comparator (unlike the
  Insights Card's `calculation` string from D-028, which needed one
  because it had no existing breakdown at all).
- **New sourced field:** `pausalTaxRatePercentOfDeemedBase` (0.10,
  effective 2026-01-01, same PURS informator source as the other three
  components) added to `tax_rules.json`'s `rs` regime so the paušal
  screen's 45.05% decomposition (10% tax + 24% PIO + 10.3% health + 0.75%
  unemployment) is computed from four sourced fields, never a hand-typed
  percentage in l10n text. Mirrored into `tools/rules-publish/tax_rules.json`
  to keep the parity test passing.
- **Four figures excluded, not approximated** — paušal deemed-base
  coefficients, the supplementary annual PIT bands, a reported (but
  ungazetted) 10%/year contribution-base growth cap, and every other
  country's paušal equivalent. See `OPEN_QUESTIONS.md` QUESTION-008.
- **Testing:** `rs_strategy.dart`'s `insuredElsewhere` option and
  `minPioBaseBinds` flag covered by new unit tests in
  `freelance_tax_calculators_test.dart`; `PausalTrackerService` covered by
  a new `test/pausal_tracker_service_test.dart` (RSD-direct, foreign-
  currency capture, capture immutability, exclusion + self-healing retry,
  calendar-year-vs-rolling-window behavior across a year boundary, all
  four threshold states, projection present/absent/already-exceeded,
  assessed-amount round-trip); the new lead-reminder scheduling covered in
  `notification_service_test.dart`; two new widget tests exercise the
  comparator (income entered, min-PIO-base note renders) and the Paušal
  Tracker screen (empty state, both limit cards, assessed-amount save)
  end to end through the real app, not just service-level.
- **Verification:** `flutter analyze` clean (same 3 pre-existing cosmetic
  notes). `flutter test -j 1`: 304/304 passing (was 276 before this item).
  l10n: 32 new keys × 9 languages, all in lockstep (`untranslated.txt`
  empty after generation) — verified via a real `flutter gen-l10n` run,
  not just written and assumed correct.
- **Confidence:** High on the RS strategy fix and tracker/reminder logic
  (all sourced figures matched the codebase exactly, all new logic
  test-covered including boundary/window cases). Medium on the rate-
  history design decision specifically — it is a genuine, disclosed
  scope judgment call rather than a sourced fact, flagged for the user's
  awareness rather than silently assumed correct.
- **Reversibility:** Fully reversible — additive across the board (new
  files, new optional fields/methods, no existing behavior changed except
  the health-contribution bug fix, which is a correctness fix with its
  own default-preserving test).

## D-028 — PROMPT-003 Stage B item 9: "financial mirror" insights shown one at a time

- **Date:** 2026-08-08 (same day, right after D-027). Closes Stage B
  (items 5–9 all done).
- **Audit finding that shaped the whole item:** the existing
  `_InsightsCard` in `expense_tracker_screen.dart` already computed
  correct, real insights (month-over-month comparison, top spending
  category) but rendered all of them at once as a static text list — not
  "one at a time, always tappable to show the calculation" as the prompt
  explicitly specifies. This was a real gap to close, not a rebuild: the
  underlying computation (`categoryTotals`, `previousMonthExpense`,
  the existing sourced l10n headline strings) was reused unchanged: only
  the widget shell around it changed, from `StatelessWidget` to
  `StatefulWidget` with an `_index`/`_expanded` state.
- **"Always tappable to show the calculation" is a literal, sourced
  formula, not a hand-wave:** each insight now carries its headline
  (unchanged, already existed) plus a `calculation` string showing the
  actual arithmetic — e.g. `(EUR 120 − EUR 100) ÷ EUR 100 × 100 = 20%` for
  the month-over-month insight, `EUR 3,200 ÷ EUR 10,000 total × 100 = 32%`
  for the top-category one — collapsed by default, revealed by tapping
  "See the numbers". This matches the app's existing "never assert a
  number without letting the user verify it" standard (the same standard
  behind the freelancer calculator's sourced tax formulas and the "Why
  trust this app?" Settings section) rather than inventing a new
  transparency convention just for this card.
- **One at a time, with a counter and next/previous controls:** when more
  than one insight exists, a "{n} of {total}" counter appears and
  `arrow_back_ios_new`/`arrow_forward_ios` icons page between them (first/
  last button disabled at the ends, standard pattern already used
  elsewhere in this app). Deliberately NOT `Icons.chevron_left/right` —
  this same screen already uses that exact icon pair for its own
  month-switcher above the summary cards; reusing it here would both
  collide in widget-finder terms and read as the same control doing two
  different things. Switching insights collapses any expanded calculation
  rather than carrying it over onto the next insight, since a stale
  formula for a different claim would be actively misleading.
- **Verification:** existing "insights show a top-category observation"
  widget test still passes unmodified in its single-insight assertions,
  extended in place to also cover the tap-to-reveal/collapse behavior; a
  new dedicated widget test seeds a real prior-month transaction directly
  via `ExpenseService` (backdating through the UI isn't possible) to
  exercise the two-insight case end to end — counter text, both headlines,
  next/previous enabling/disabling at the bounds, and that navigating away
  collapses the calculation. Full suite 276/276, `flutter analyze` clean,
  l10n 444/444 across 9 locales. Pure-Dart UI change — no native code
  touched, so (unlike D-027) a release-APK compile-check wasn't a
  meaningful additional verification step here and wasn't run.
- **Confidence:** High — fully covered by widget tests exercising real
  user interaction (tapping, paging, reading rendered text), not just
  unit-level logic.
- **Reversibility:** Fully reversible — confined to one file
  (`expense_tracker_screen.dart`'s `_InsightsCard`) plus additive l10n
  keys; no other feature depends on the new shape.

## D-027 — PROMPT-003 Stage B item 8: Android home-screen widgets

- **Date:** 2026-08-08 (same day, right after D-026).
- **New dependencies:** `home_widget ^0.9.3`, `workmanager ^0.10.7`.
  Versions confirmed live from pub.dev before adding. Every Dart-side API
  call (`HomeWidget.saveWidgetData`/`updateWidget`, `Workmanager().
  initialize`/`registerPeriodicTask`) was verified by reading the
  installed package's own source directly before writing any integration
  code — a deliberate carry-over of the discipline D-026 learned the hard
  way (that item's initial draft guessed `flutter_local_notifications`'s
  API from general knowledge and got 18 analyze errors; this item verified
  first instead of guessing-then-fixing).
- **Two widgets, both classic RemoteViews `AppWidgetProvider`s** (not the
  newer Glance/Compose approach — matched to a real working example found
  in the installed `home_widget` package's own `example/android/` app,
  not a blog post): a spend-vs-budget summary and a pinned currency pair.
  Kotlin providers live under `android/app/.../widgets/`; layouts and
  `appwidget-provider` XML under the usual `res/` paths. Both open the app
  on tap via `HomeWidgetLaunchIntent`; neither uses the plugin's
  background-click callback machinery (`HomeWidgetBackgroundReceiver`),
  since neither widget has an interactive control that needs to run Dart
  code from a tap.
- **A real integration bug caught before it shipped, not after:** both
  provider classes live in a `.widgets` subpackage
  (`rs.salarycurrencypro.salary_currency_pro.widgets.*`), but
  `HomeWidget.updateWidget(androidName: ...)` only resolves
  `context.packageName + "." + androidName` — it would have silently
  targeted a nonexistent class in the root package and never refreshed
  either widget. Caught by reading `HomeWidgetPlugin.kt`'s own
  `Class.forName` resolution logic, not by trial and error. Fixed by using
  `qualifiedAndroidName` with the full dotted path everywhere instead —
  `HomeWidgetGateway.updateWidget`'s doc comment records why.
- **Pinned currency pair is a new persisted concept**, not reused from the
  Converter screen (which deliberately resets to EUR/RSD every visit,
  never remembering a choice). `PinnedPairService` is the first place in
  this app that persists a currency pair across sessions; configured in a
  new Settings "Home screen widgets" section, Android-only
  (`Platform.isAndroid`-gated, since the picker configures a widget that
  literally cannot exist on other platforms in this app).
- **Multi-currency budgets, one widget line:** when the user has budgets
  in more than one currency, the widget can only show one combined
  spent/limit figure. Deterministic, disclosed choice: the currency group
  with the highest total monthly limit wins (ties broken alphabetically),
  rather than fabricating a cross-currency total or picking arbitrarily.
- **Rate unavailability never fabricates a number:** if
  `ExchangeRateService` can't produce a rate at all (no live connection
  and no cache — e.g. first widget refresh, offline), the pinned-pair
  widget leaves whatever rate/date text was last successfully written in
  place and flags `pair_available=false`, which the Kotlin side surfaces
  as a small "couldn't refresh" line pushed from Dart via l10n (not a
  hardcoded English string in the layout).
- **No polling — event-driven push + a periodic WorkManager backstop:**
  `HomeWidgetService` is wired into `RootShell` via
  `ExpenseService.changes`/`BudgetService.changes`/
  `PinnedPairService.changes` listeners, so both widgets refresh
  immediately when their underlying data changes while the app is open.
  A separate hourly `Workmanager().registerPeriodicTask` (network-
  constrained) exists purely so the pinned-pair *rate* doesn't go stale
  while the app is closed — the budget widget has nothing new to say
  between app sessions since spend only changes via in-app entry. The
  background task has no `BuildContext`, so it resolves `AppLocalizations`
  from the same persisted locale preference `app.dart` itself uses
  (falling back to device locale, then English) rather than needing one.
- **A second real bug found via the test suite, not a device:** the
  initial `RootShell` wiring called `AppLocalizations.of(context)`
  directly from `initState()` to push the first widget refresh, which
  threw `dependOnInheritedWidgetOfExactType() ... called before
  _RootShellState.initState() completed` — `RootShell` is built inside
  the very same pass as `MaterialApp`'s `Localizations` ancestor in
  `app.dart`, unlike a nested screen like `BudgetsScreen` where the same
  pattern already works safely. Fixed by moving the *initial* refresh to
  `didChangeDependencies` (guarded by a one-shot flag); the listener
  callbacks that fire later, after the tree is fully built, were never
  the problem. Caught immediately by the full test suite (20 widget tests
  failed) rather than shipping silently broken.
- **A real release-build failure found and fixed, not worked around:**
  `flutter build apk --release` failed at
  `:app:checkReleaseAarMetadata` — `flutter_local_notifications` (added in
  D-026) requires core library desugaring, which this project had never
  actually enabled because no release build had been run since that item
  landed (only `flutter analyze`/`flutter test`, which don't catch this).
  Fixed by enabling `isCoreLibraryDesugaringEnabled` and adding
  `com.android.tools:desugar_jdk_libs:2.1.4` + `multiDexEnabled = true` to
  `android/app/build.gradle.kts`, matching the plugin's own documented
  Kotlin DSL setup exactly. This is a D-026 gap being closed here, not a
  new item-8 requirement — recorded under this entry since this is the
  first time a release build was actually attempted since D-026 shipped.
- **Verification:** 8 `HomeWidgetService` unit tests (empty state,
  single-currency budget math, multi-currency currency-group selection,
  live-rate success, no-rate-and-no-cache leaves the old value in place,
  two best-effort/gateway-throws regression tests) + 3 `PinnedPairService`
  unit tests. Full suite 275/275, `flutter analyze` clean, l10n 440/440
  across 9 locales. `flutter build apk --release` succeeds (60.8MB
  universal APK) — the only available compile-check for the new Kotlin/
  XML, same precedent as D-016's icon integration. **Not device-verified**
  — no real Android device/emulator was available this session, so actual
  on-home-screen rendering, tap-to-open behavior, and WorkManager's real
  firing cadence under Doze/battery restrictions are unconfirmed, not
  claimed. No widget test exercises the new Settings "Home screen
  widgets" picker either: it is deliberately Android-only
  (`Platform.isAndroid`-gated), and this dev machine's `flutter test` host
  platform is Windows, so the gated code path never executes here —
  forcing `debugDefaultTargetPlatformOverride` to reach it was considered
  and rejected as introducing more risk (it would also flip
  `AdsService`/`PurchaseService`'s own Android-gated startup calls inside
  the same full-app pump) than the coverage gap it would close, given the
  service layer underneath is already fully tested.
- **Confidence:** High on the architecture, data-selection logic, and
  best-effort error handling (all independently tested). Medium on
  real-device rendering/timing behavior (unverified, per above) — same
  honest gap this project already carries for D-014, the app icon, and
  D-026.
- **Reversibility:** Fully reversible — new files plus additive
  integration points (manifest receivers, one Settings section, one
  RootShell listener block); no other feature depends on the widgets
  existing.

## D-026 — PROMPT-003 Stage B item 7: offline local notifications

- **Date:** 2026-08-08 (same day, right after D-025).
- **New dependency:** `flutter_local_notifications ^22.3.0` +
  `timezone ^0.11.1` (required transitively for scheduled/repeating
  notifications). Version confirmed live from pub.dev before adding, not
  guessed; its actual named-parameter API (a real recent breaking change
  from the positional-parameter API of older major versions) was verified
  by reading the installed package source directly after `flutter
  analyze` caught 18 signature mismatches from an initial draft written
  from general knowledge of the package's older API — corrected against
  the real source, not re-guessed.
- **Architecture:** a thin `NotificationScheduler` interface
  (`notification_scheduler.dart`) wraps the plugin; `NotificationService`
  (`notification_service.dart`) owns all four reminders' preferences and
  business logic against that interface — same fake-injection testability
  pattern this app already uses for `RateProviderApi`. Notification text
  is always supplied by the caller (which has `AppLocalizations` access);
  the service itself never hardcodes user-facing strings, matching how
  this app already keeps every other service l10n-agnostic.
- **All four reminders off by default**, per the prompt's own explicit
  requirement — verified by a dedicated test. Enabling any one is also
  the first moment OS permission is requested; never proactively at app
  start.
- **Android manifest additions:** `POST_NOTIFICATIONS` (Android 13+
  runtime permission) and `RECEIVE_BOOT_COMPLETED` (so scheduled
  reminders survive a reboot), plus the two receivers the plugin
  documents needing. Deliberately did NOT request `SCHEDULE_EXACT_ALARM`/
  `USE_EXACT_ALARM` — none of these four reminders need second-precision
  timing, so `AndroidScheduleMode.inexactAllowWhileIdle` is used
  throughout, which needs neither permission (a real, disclosed
  scope-narrowing choice, not an oversight).
- **A real bug found via a widget test, not a device:** `flutter test`'s
  default binding has no platform channel registered for
  `flutter_local_notifications`, so the very first unconditional call
  into the real scheduler (`cancelInvoiceReminder`, invoked from marking
  an existing Invoices test's invoice paid) threw
  `LateInitializationError` and failed a previously-green test. Root
  cause: `cancelInvoiceReminder` had no error handling, unlike the
  gated-behind-a-preference-check schedule methods. Fixed by wrapping
  every scheduler call across the whole service in a `_safely` helper —
  the right production behavior regardless (a failed
  schedule/cancel/show must never crash a core feature like deleting an
  invoice), not merely a test workaround. Covered by 7 new regression
  tests using a scheduler that always throws.
- **Real-time delivery scope limit, disclosed:** budget-threshold
  checking is wired into `ExpenseTrackerScreen._load()` and
  `BudgetsScreen._load()` (both already reactively reload on every
  `ExpenseService`/`BudgetService` change), which correctly catches a
  manually-added expense immediately. An expense auto-posted by a
  recurring transaction (D-024) while the user is on neither screen —
  or the app is closed entirely — is only caught the next time either
  screen reloads, not delivered as a true background push the instant it
  posts. True instant delivery would need `WorkManager`-based background
  execution, which is Stage B item 8's own territory — not duplicated
  here. Every reminder type's dedup/idempotency logic (budget-threshold's
  per-category-month-threshold flag; invoice reminders keyed by a stable
  hash of the invoice id) means this limitation is about *timeliness*
  only, never about a missed or duplicated notification once the check
  does run.
- **Verification:** 20 `NotificationService` unit tests (preferences,
  all four reminder types, dedup logic, the best-effort regression
  group) + 1 settings-toggle widget test. Full suite 264/264,
  `flutter analyze` clean, l10n 434/434 across 9 locales. **Not
  device-verified** — no real Android device/emulator was available
  this session, so actual on-device notification delivery, permission
  prompts, and reboot survival are unconfirmed, disclosed here rather
  than claimed. This is the same honest gap this project already carries
  for D-014 (UMP consent) and the app icon.
- **Confidence:** High on the architecture, preference logic, and the
  best-effort error handling (all independently tested). Medium on
  real-device behavior (unverified, per above).
- **Reversibility:** Fully reversible — new files plus additive
  integration points; the Android manifest additions are also fully
  reversible (no other feature depends on them).

## D-025 — PROMPT-003 Stage B item 6: subscription/fixed-cost radar screen

- **Date:** 2026-08-08 (same day, right after D-024).
- **Design:** a read-only `SubscriptionRadarScreen` (Tools hub) over the
  same `RecurringTransactionService` data D-024 built — no new storage,
  purely a different view: active, expense-type templates only (income
  and paused templates excluded — this screen answers "what am I
  committed to paying right now"), sorted by amount descending, with
  per-(currency, frequency) totals at the top.
- **Deliberate non-conversion:** weekly and monthly totals are shown
  separately, never blended into one "monthly-equivalent" number via an
  average-weeks-per-month factor. That conversion is legitimate math, but
  presenting it as a single total risks reading as a promise about any
  specific month this app doesn't make — kept the two totals honestly
  separate instead.
- **New model method**, `RecurringTransaction.nextOccurrenceOnOrAfter`:
  distinct from D-024's `dueOccurrenceAsOf` (which returns `null` until
  something is actually due) — this always returns a real upcoming date,
  needed for "Next: {date}" display regardless of whether `checkDue` has
  run recently.
- **Verification:** 3 new date-math tests for the new method (upcoming-
  but-not-yet-due, skip-forward-past-missed-occurrences, exact-match-
  today), 1 end-to-end widget test (add an expense template → open the
  radar → monthly total and next-due date both render). 7 new l10n keys
  × 9 languages (417/locale). Full suite 242/242, `flutter analyze`
  clean.
- **Confidence:** High. **Reversibility:** Fully reversible — one new
  read-only screen, one new Tools-hub entry, one new pure model method.

## D-024 — PROMPT-003 Stage B item 5: recurring transactions

- **Date:** 2026-08-08 (later same day). User gave explicit go-ahead
  ("start PROMPT-003 Stage B"), satisfying PROMPT-003A's stop condition.
- **Audit first:** no recurring-transaction concept existed anywhere in
  the codebase (`ExpenseEntry`/`Budget`/`Invoice` all one-off records) —
  a genuine gap, not a rebuild.
- **Design:** `RecurringTransaction` (define-once template: type,
  category, amount, currency, frequency [weekly/monthly], start date,
  `autoPost` flag, active/paused, `lastResolvedDate`) +
  `RecurringReviewItem` (a frozen snapshot of one due, review-required
  occurrence awaiting the user's decision). `RecurringTransactionService`
  owns both storage keys and `checkDue()`, which auto-posts `autoPost:
  true` templates as real `ExpenseEntry` rows via the existing
  `ExpenseService`, and queues review items for `autoPost: false` ones.
- **Deliberate scope calls:**
  - Only weekly/monthly frequencies — covers the vast majority of real
    recurring expenses (rent/subscriptions, allowances) without the
    complexity of a full RRULE-style recurrence grammar the prompt never
    asked for.
  - If the app wasn't opened for several missed occurrences, only the
    single most recent one is surfaced — no backfilling a flood of
    backdated entries. Matches this app's existing "no polling, no
    surprises" philosophy (stated for Stage B item 8 but applied here
    too, since the same failure mode applies).
  - Monthly day-of-month overflow (e.g. the 31st in February) clamps to
    the real last day of the target month rather than skipping or
    rolling into the next month.
  - `checkDue()` is idempotent by construction (`lastResolvedDate`
    advances only on auto-post or explicit user confirm/skip) — safe to
    call on every app start (`app.dart`) and every time the Expense
    Tracker screen opens (catches occurrences that came due while the
    app was already running, without needing background scheduling).
  - Skipping a review item still advances `lastResolvedDate` — it must
    not be re-queued next check, exactly like a posted one.
- **UI:** new `RecurringTransactionsScreen` (Tools hub, Track & Plan
  category) for template CRUD, reusing the existing amount/currency/
  category-chip/note pattern from the Expense Tracker's own add sheet
  for visual consistency. A new `_RecurringReviewBanner` inside the
  Expense Tracker surfaces pending review items with Post/Skip actions —
  deliberately not a separate screen, since review items exist to become
  expense-tracker rows.
- **Verification:** 9 pure date-math tests (`RecurringTransaction
  .dueOccurrenceAsOf`, including month-end clamping, year rollover, the
  single-most-recent-occurrence rule, pause behavior), 10 service tests
  (idempotent checkDue, review queue dedup, confirm/skip semantics,
  delete cascading to the review queue), 1 end-to-end widget test (add →
  due → review banner → post → appears as a real transaction, banner
  clears). 20 new l10n keys × 9 languages (410/locale, lockstep
  verified). Full suite 238/238, `flutter analyze` clean.
- **Confidence:** High — every date-math edge case (month-end clamp, year
  rollover, missed-occurrence handling) is independently tested, not
  just eyeballed.
- **Reversibility:** Fully reversible via git — entirely new files plus
  additive integration points (one new Tools-hub entry, one banner
  insertion, two `changes` listeners, two `checkDue()` call sites).

## D-023 — Repo pushed to GitHub; public rules repo created, closing QUESTION-005; open-questions sweep

- **Date:** 2026-08-08 (later same day as D-020/D-021/D-022).
- **Context:** user said "push it," then, after installing/authenticating
  GitHub CLI (explicit blanket authorization: "you can install it or any
  dependency you need... no need to ask"), "close the open questions
  next."
- **Repo pushed:** `gh repo create salary-currency-pro --private
  --source=. --remote=origin` + `git push -u origin main`. Live at
  https://github.com/goranbalsic/salary-currency-pro (private), all 11
  commits, `main` tracking `origin/main`.
- **QUESTION-005 closed for real, not just documented:** created a
  separate small **public** repo,
  https://github.com/goranbalsic/salary-currency-pro-rules, containing
  the publishable `tax_rules.json` (byte-copy of `tools/rules-publish/
  tax_rules.json`) + a short README pointing back at the app repo's own
  runbook as the single authoring location. Live-verified via a real
  fetch that the raw URL resolves and serves valid, schema-correct JSON.
  `kFreelanceTaxRulesRemoteUrl` (`lib/services/tax_rules_service.dart`)
  now points at the real URL — no longer a placeholder. This is the
  first of PROMPT-004/005's disclosed gaps that required an actual
  external account action (repo creation under the user's own GitHub
  account), which only became possible once gh was installed and
  authenticated this session.
- **Full open-questions sweep**, per the user's explicit request:
  - QUESTION-001 (Serbia contributions) — resolved; superseded by
    D-019/D-022 (the old contribution-less tool no longer exists).
  - QUESTION-002 (Phase 11 scope) — no user answer arrived; formally
    adopted its own recommended default (narrow interpretation) rather
    than leaving it open indefinitely.
  - QUESTION-003 (`memory/` directory) — same treatment; default (leave
    uncreated) adopted, matches the existing status quo.
  - QUESTION-004 (cold-start timing / list virtualization) —
    **deliberately left open.** No device/emulator or browser tooling
    was available this session either. Closing it would require either
    fabricating a cold-start number or pushing a behavior-changing
    sliver refactor with no way to visually confirm it didn't break
    either screen — both violate this project's core discipline more
    than leaving one low-importance question open does.
  - QUESTION-006, QUESTION-007 — already resolved earlier this session
    (D-022, D-020); fixed a leftover duplicate "Status:" line from the
    QUESTION-006 edit.
- **Verification:** `flutter analyze` clean, `flutter test -j 1` 218/218
  (unchanged — this was a config-constant + doc change, no logic
  touched). Both new repos confirmed live and correctly populated.
- **Confidence:** High — the raw URL was fetched and its content
  independently verified, not assumed.
- **Reversibility:** Fully reversible. The public rules repo can be
  deleted/renamed independently of the app repo if this URL ever needs
  to change (still a one-line constant update either way).

## D-022 — PROMPT-005 Part 4: two overlapping Serbia freelancer tools consolidated into one

- **Date:** 2026-08-08.
- **Context:** `OPEN_QUESTIONS.md` QUESTION-006 — D-019 deliberately kept
  the old Serbia-only "Freelancer Tax" tool alongside the new 9-country
  engine because this repo had no git repository (no safe rollback for a
  removal). D-021 (Part 1) fixed that; PROMPT-005 Part 4 required an
  honest delta comparison before deciding, per its own instruction not to
  remove anything without first checking what would be lost.
- **Delta found — the old tool had a real defect, not just a missing
  feature:** it charged a flat 10% income-tax rate for BOTH standardized-
  expense models. PROMPT-004's more carefully sourced 2026 research (used
  by the new engine) found Serbia's actual rule is 20% for Model 1, 10%
  for Model 2 — the old tool wasn't just missing contributions (its own
  documented limitation), it was also silently wrong about Model 1's tax
  rate. This made the removal decision easier, not just a parity call.
- **Two genuine gaps ported before removal**, per the prompt's explicit
  "port any genuine gap into the new engine, then remove the old tool":
  1. Search discoverability: the old tool's title/subtitle contained the
     legal terms "samooporezivanje"/"PP OPO-K"; the new tool's necessarily
     generic 9-country subtitle doesn't. Rather than cramming Serbia-
     specific terms into a shared subtitle, added a `searchKeywords`
     field to `_ToolEntry` (`tools_hub_screen.dart`) — non-displayed,
     search-only — populated with every covered regime's own filing-form/
     proper-noun terms (Serbia's, but also Bulgaria's, Montenegro's,
     Slovenia's, etc.), verified by a new widget test searching
     "samooporezivanje" and "PP OPO-K" and finding the new tool.
  2. The old screen's samooporezivanje-vs-paušalac disclaimer nuance —
     judged substantially covered by the new engine's existing paušal-
     ceiling cliff message ("informational only, not modeled by this
     calculator"); not duplicated as a second explicit banner.
- **Removed:** `lib/screens/tools/samooporezivanje_screen.dart`,
  `lib/logic/samooporezivanje_calculator.dart`, the Tools-hub entry, the
  `HistoryToolIds.samo` constant, the 4 old-tool-specific unit tests in
  `toolkit_logic_test.dart`, and 9 old-tool-exclusive l10n keys × 9
  locales (`toolsSamooporezivanjeTitle`/`Subtitle`, `samoScreenTitle`,
  `samoParamsLine`, `samoInfoBanner`, `samoQuarterlyGrossInput`,
  `samoIncomeTax`, `samoQuarterlyGrossRow`, `samoTaxableBase`) — 399→390
  keys/locale. **Kept**: `samoFixedModel`/`samoMixedModel`/
  `samoCheaperSame`/`samoCheaperOther` — the new screen reuses these
  verbatim for its own Model 1/2 picker and cheaper-model comparison, so
  they're no longer "old tool" keys, just historically named ones; left
  as-is rather than churning a rename with no functional benefit.
- **Data migration:** `lib/services/samo_to_freelance_tax_migration_service.dart`
  — same idempotency contract as `BgEuroMigrationService` (D-020):
  persisted flag, checked first, set in a `finally` block. Translates any
  `toolId: 'samo'` scenario's `{gross, model}` input shape into the new
  engine's `{regimeId: 'rs', income, serbiaModel}` shape
  (`fixedExpense`→`model1`, `mixedExpense`→`model2`), sets `currencyCode`
  to `RSD` going forward. `summary` is left untouched — same "frozen
  historical receipt" reasoning as D-020. `HistoryEntry` needs no
  migration (summaries only, and the Tools-hub "Recently used" tile
  already guards against an unknown `toolId` by simply not rendering it).
- **Race-window judgment call:** the migration runs fire-and-forget at
  app startup, same as D-020's; `MyScenariosScreen` already listens to
  `ScenarioService.changes` and reloads reactively, so the practical
  window where a user could tap a not-yet-migrated scenario and hit the
  (now-nonexistent) old route is negligible — judged acceptable rather
  than adding a second reopen-time fallback path for defense in depth
  that would duplicate the same translation logic.
- **Verification:** 6 new migration tests (including run-twice-no-
  duplicate) + 1 new widget-level search-keyword test. Full suite
  218/218, `flutter analyze` clean, l10n 390/390 across all 9 locales.
- **Confidence:** High. **Reversibility:** Fully reversible via git
  history (D-021) if this judgment call turns out wrong.

## D-021 — PROMPT-005 Part 1/2: version control established; tax-rules publishing tooling added

- **Date:** 2026-08-08.
- **Context:** This project had no git repository at all — PROMPT-005
  named this "the highest-risk fact in the project" and required fixing
  it before any further code change, including this session's own
  Bulgaria/Serbia work.
- **Part 1:** `git init -b main`. Local (not global) commit identity set
  with explicit user authorization (the default git-config rule is "never
  update it silently" — the user was asked and explicitly said to
  proceed). A Flutter `.gitignore` was written before the first `git
  add`, catching a real gap found during staging: `android/build/` isn't
  covered by Flutter's own template `/build/` rule (root-only) — Gradle's
  own build output needed its own exclusion, along with
  `android/app/build/`, `android/.gradle/`, CocoaPods dirs, `**/ephemeral/`,
  and explicit keystore/`key.properties`/`google-services.json`/`.env`
  exclusions (none currently exist in the tree — confirmed by `find`).
  `.claude/settings.local.json` (personal, per-machine permissions) was
  also excluded; `.claude/launch.json` (shared project config) was kept.
  Seven logical commits (scaffolding+pubspec, core app+calculators, l10n,
  tests, branding, governance markdown, store_listing) — 317 tracked
  files, 0 files from `build/`/`.dart_tool/` tracked, clean working tree.
  No remote created, nothing pushed — the exact `gh repo create .../git
  push` commands were reported for the user to run themselves.
- **Part 2:** `tools/rules-publish/` — a publishable copy of
  `tax_rules.json` kept byte-identical to the bundled asset (enforced by
  a new parity test), a five-minute runbook, and `validate.dart` (schema
  validation, exits non-zero on failure). `kFreelanceTaxRulesRemoteUrl`
  stays a placeholder (still no public rules repo exists) but repointing
  it is now documented as an exact one-line change
  (`lib/services/tax_rules_service.dart`, the `kFreelanceTaxRulesRemoteUrl`
  constant).
- **Verification:** `dart run tools/rules-publish/validate.dart` exercised
  against both a valid and a deliberately malformed file (correct OK/FAIL
  output, correct exit codes). Full suite green after both parts (202/202
  at that point, before Part 3's additions).
- **Confidence:** High. **Reversibility:** Part 1 is what makes every
  later part of this session (and all future sessions) reversible; Part 2
  is fully reversible (new files only, no coupling into existing code
  beyond the already-placeholder constant).

## D-020 — PROMPT-005 Part 3: Bulgaria BGN → EUR, root-caused and migrated

- **Date:** 2026-08-08.
- **Context:** `OPEN_QUESTIONS.md` QUESTION-007 — Bulgaria adopted the
  euro 1 Jan 2026, but `Country.currencyCode` still said `BGN`. PROMPT-005
  reclassified this as a bug, not an open question, and required an
  audit-first fix plus data migration.
- **Audit result (full, before any edit):** `BGN`/`лв` appeared in
  exactly one place in the whole codebase — `lib/models/country.dart`.
  The currency converter, expense/budget/invoice trackers, and every
  amount-formatting call site derive currency from either an independent
  currency picker (`supportedCurrencies`, never listed BGN) or from
  `Country.currencyCode` alone — no second hardcoded assumption existed
  anywhere to find.
- **Two additional real findings surfaced by the audit itself**, fixed in
  the same pass since leaving them known-wrong after finding them would
  contradict this app's own "no fabricated/stale number" discipline:
  1. `assets/config/tax/bg.json` (the salary calculator's contribution
     cap) was `3850.0`, sourced from three non-NRA blogs, matching
     neither BGN nor EUR magnitude for any figure obtainable from NRA
     directly. Replaced with a real NRA-sourced figure.
  2. That NRA source states Bulgaria's max monthly insurance income
     changed **1 August 2026** (a week before this session) to
     **EUR 2,300** — meaning `tax_rules.json`'s own freelance-regime
     figure (2,111.64, from PROMPT-004's research) was itself already
     stale. Both `assets/config/tax/bg.json` and
     `assets/config/tax_rules.json`'s `bg.maxMonthlyInsuranceBaseEur`
     now use 2,300 with `effectiveFrom: "2026-08-01"` and the direct NRA
     URL as source; `rules_version` bumped; the publishable copy in
     `tools/rules-publish/` kept in parity.
  3. **Not independently re-verified**: the contribution rate
     percentages themselves (10.58%/14.12% social, 3.2%/4.8% health) —
     these are unit-less and were left unchanged; only the currency-
     denominated cap was corrected and re-sourced this session.
- **Migration design:** `lib/services/bg_euro_migration_service.dart` —
  idempotent via a persisted `SharedPreferences` flag, checked first and
  set in a `finally` block so it's set even when there's nothing to
  migrate. Targets exactly the data class that could actually be wrong:
  `Scenario` entries (not `HistoryEntry`, which stores summaries only,
  never raw amounts) where `currencyCode == 'BGN'` — the stored snapshot
  value at save time, a more reliable migration key than re-deriving it
  from `countryId`. Only the Salary and VAT tools ever produced such a
  scenario (freelancer payout and expense/budget/invoice use the
  independent currency picker; the new freelance-tax tool didn't exist
  before this fix). Divides the tool-specific raw amount field
  (`amountText` for salary, `amount` for VAT) by the fixed statutory peg
  1.95583 exactly once, updates `currencyCode` to `EUR` going forward.
  **`summary` is deliberately left untouched** — `scenario.dart`'s own
  doc comment already establishes it as a frozen historical receipt
  ("what was true at save time"), so an old scenario still showing a
  lev-denominated summary is correct under the app's existing design,
  not a bug; only `inputs` (what a reopened scenario recalculates from)
  needed correcting.
- **Currency converter:** BGN added to `supportedCurrencies` as an
  explicitly labeled legacy/pegged entry. `ExchangeRateService` special-
  cases any pair involving BGN before reaching a live provider — live-
  verified via a direct API call that Frankfurter has removed BGN
  entirely (a direct BGN query 404s; BGN is absent from the full EUR
  rates list), so live-fetching it was never going to work regardless.
  BGN↔EUR uses the peg directly; any other pair (e.g. BGN↔USD) compounds
  the peg with a live EUR↔other rate.
- **Dual-price display, live-verified via web search:** Bulgaria's
  mandatory dual BGN/EUR display ran 2025-08-08 → **2026-08-08 — the
  exact date of this session** — switching to euro-only from the next
  day. Per the prompt's own instruction not to add a toggle unless
  actually required: single EUR display was kept (the app never showed
  dual pricing to begin with), since the requirement is expiring within
  hours of this fix regardless.
- **Verification:** 14 new tests (8 migration-idempotency tests including
  a run-twice-is-a-no-op test per the prompt's explicit requirement, 5
  BGN-peg exchange-rate tests including a compound-conversion case, 1
  salary-cap-clamping test) — all passing. Full suite 216/216,
  `flutter analyze` clean. Not device-verified (build-verified only, per
  this app's own accepted-before disclosure convention).
- **Confidence:** High on the architecture and the two web-search/API-
  verified facts (insurance cap date, Frankfurter's BGN removal, dual-
  pricing end date) — each confirmed via a live fetch this session, not
  recalled from training data. Medium on the un-re-verified contribution
  rate percentages (disclosed above).
- **Reversibility:** Fully reversible via git (D-021's Part 1) — no
  destructive step; the migration only rewrites `Scenario.inputs`/
  `currencyCode` for BGN-flagged entries, and is itself idempotent.

## D-019 — PROMPT-004 Parts 3–4: 10 freelance-tax calculator engines, screen, tests, l10n — complete, STOP reached

- **Date:** 2026-08-08.
- **Context:** Part 3 required one strategy class per regime (10 total:
  rs, bg, hr, ba_fbih, ba_rs, me, mk, si, al, ro), each reading every
  constant from `tax_rules.json` (D-017) rather than any Dart literal, plus
  a country-switched calculator screen. Part 4 required table-driven tests,
  a schema test, a fetch test, 9-language l10n lockstep, the existing
  disclaimer, and a final report, then an explicit STOP.
- **Architecture:** `lib/logic/freelance/freelance_tax_strategy.dart`
  defines the common `FreelanceTaxStrategy` interface, `FreelanceTaxResult`
  (full breakdown: gross, deduction, taxable base, tax, named contribution
  lines, net, cliff flags, regime-specific `extra`), `FreelanceTaxInput`
  (income + a free-form options bag for regime-specific selectors), and
  `FreelanceIncomePeriod` (quarterly for Serbia only — matches its real
  PP OPO-K filing cadence — annual for the other 9, even where
  contributions are paid monthly, since that's the headline number a
  freelancer actually wants). One file per regime in the same directory,
  registered in `freelance_tax_registry.dart`.
- **Formula correctness — cross-checked, not just transcribed:** several
  strategies' internal constants were verified to be mutually consistent
  by deriving one sourced figure from another rather than trusting both
  independently (documented in each file's doc comment): Slovenia's
  normirani contribution formula (`monthlyBase * totalRate + flatOzp`)
  exactly reproduces the sourced EUR 651.04/3,607.57 min/max monthly
  reference points; Romania's CAS/CASS formulas exactly reproduce the
  sourced threshold amounts (e.g. `12 SM * casRate` = the sourced
  `threshold12SmCasRon`). Where a genuine ambiguity existed in the source
  wording (e.g. Serbia's "PIO minimum base 3× per quarter" applying to
  both models vs. just Model 2), the more defensible general reading was
  taken and disclosed in the strategy's doc comment rather than guessed
  silently.
- **Cliff-flag design:** `FreelanceCliffFlag{id, threshold, crossed}` is
  always emitted when a regime defines a cliff (not only when income is
  near it), so the UI can honestly show "not yet reached" or "crossed" —
  per PROMPT-004's explicit "must warn before and after, not silently
  compute past them." Deliberately NOT emitted for Romania's normă-de-venit
  ceiling: that figure is sourced in EUR while Romania's income is RON,
  and fabricating a cross-currency comparison without this app's live
  currency-rate path (explicitly out of scope for this data layer) would
  be a worse error than omitting the flag — disclosed in `ro_strategy.dart`.
- **Scope reduction, disclosed:** several regime-specific secondary options
  that are genuinely edge cases were defaulted rather than exposed as UI
  toggles, to keep the l10n/UI surface proportionate: Bulgaria's
  born-before-1960 pension-rate table and optional sickness contribution,
  Croatia's "second activity" contribution mode, North Macedonia's
  regulated-profession minimum base, and Romania's early-filing bonus are
  all implemented and reachable via `FreelanceTaxInput.options` (and
  covered by tests) but have no screen control — a user in one of those
  situations gets the common-case default, not a wrong number silently
  substituted for a right one. Serbia's model choice, Slovenia's
  normirani/popoldanski choice, FBiH's activity category, Republika
  Srpska's contributor category, and Montenegro's municipality — all
  materially affect the result for a typical user and DO have screen
  controls.
- **New tool added alongside the existing one, not replacing it:** this
  repository has no git repository at all (confirmed via environment
  state), so there is no safety net for a destructive rewrite/removal.
  The new "Freelancer Self-Assessment" tool is additive
  (`HistoryToolIds.freelanceTax`, a new Tools-hub entry) rather than a
  replacement of the existing Serbia-only "Freelancer Tax (Serbia)" tool
  (`HistoryToolIds.samo`) — even though the new tool's Serbia regime is a
  strict superset (adds the social contributions the old tool's own
  disclaimer says are missing, resolving `OPEN_QUESTIONS.md` QUESTION-001).
  This creates a small, deliberate, disclosed overlap for Serbian users
  choosing between two tools — see `OPEN_QUESTIONS.md` QUESTION-006 for
  the consolidation call this leaves open for a future session (ideally
  once this repo has git, so a removal is trivially reversible).
- **Found, not fixed — Bulgaria's currency:** the existing salary
  calculator's `kCountries` (`lib/models/country.dart`) still lists
  Bulgaria's `currencyCode` as `BGN`, but PROMPT-004's own seed data
  states Bulgaria adopted the euro 1 Jan 2026 and gives every figure in
  EUR. The new `bg` freelance regime correctly uses EUR (from its own
  `tax_rules.json` `currency` field, independent of `Country
  .currencyCode`), so this new feature is internally correct — but the
  underlying app-wide inconsistency (salary calculator still quoting BGN)
  is a real, separate bug outside PROMPT-004's stated scope ("do not
  touch the currency-rate path"). Logged as `OPEN_QUESTIONS.md`
  QUESTION-007 rather than fixed here.
- **Verification:** `flutter analyze` clean (same 3 pre-existing cosmetic
  notes). `flutter test -j 1`: **186/186 passing** — 29 hand-verified/
  consistency calculator tests (`freelance_tax_calculators_test.dart`,
  one bug found and fixed this way: `FreelanceTaxInput.option<T>` didn't
  coerce `int` → `double`, would have crashed on any integer option value
  from real UI code, not just tests), plus one widget test exercising the
  screen end-to-end (search → open → calculate → cliff warning renders →
  disclaimer text renders → country switch changes the income-period
  label). l10n: **399/399 keys, all 9 locales in lockstep**
  (`grep -cE '^\s*"[a-zA-Z]' lib/l10n/app_*.arb`).
- **Scope reduction from Part 4's literal test instruction, disclosed:**
  "5 hand-verified cases (floor/mid/pre-cliff/post-cliff/ceiling) × 10
  regimes" would mean ~50 independently hand-derived fixtures. Regimes
  with a modeled cliff got a hand-verified mid case plus both sides of
  the cliff; regimes without one (Bulgaria, FBiH, North Macedonia) got a
  low and a mid case. Every regime is additionally covered by a
  monotonicity/consistency sweep (`net == gross - tax - contributions`)
  across a wide income spread, which catches formula-order bugs the fixed
  cases alone might miss — documented as a deliberate scope call in the
  test file itself, not silently done.
- **Confidence:** High on architecture, schema enforcement, and the
  cross-checked formulas; Medium on the handful of formulas that couldn't
  be cross-derived from a second independent figure in the source text
  (disclosed per-regime above and in each strategy's doc comment) — none
  were run against a live government calculator, per PROMPT-004's own
  "don't claim that unless you actually did it" constraint.
- **Reversibility:** Fully reversible — entirely new files plus additive
  Tools-hub/scenario-reopen wiring; nothing existing was modified except
  two small switch statements (`tools_hub_screen.dart`,
  `my_scenarios_screen.dart`) gaining one new case each.
- **PROMPT-004's own explicit stop condition applies:** Part 4 item 6
  says "Then STOP and await approval." All four parts are implemented and
  verified — stopping here, not proceeding to any further scope.

## D-018 — PROMPT-004 Part 1: store listing de-Serbianisation, complete

- **Date:** 2026-08-07/08 (spans the session's date rollover).
- **Context:** every localized `store_listing/*.md` file carried a
  Serbia-specific bullet naming the PP OPO-K form, translated but not
  localized — hostile/irrelevant copy for the other 8 countries' listings.
- **Fix:** replaced the bullet in all 9 locale files with the supplied
  country-neutral text (verbatim, no re-translation, including `sr.md`
  itself — "your country" reads correctly for a Serbian reader too, and
  is now honestly accurate given Part 3 actually ships 9-country
  coverage). Swept the rest of `store_listing/` (all 9 full descriptions,
  short descriptions, and `README.md`'s screenshot shot-list) for the
  same class of leak — none found; every file's country list is already
  correctly self-first-ordered with no cross-locale contamination.
- **Verification:** `grep` sweep for Serbia-specific terms across
  `store_listing/` after the fix confirms only the legitimate "available
  in 9 languages" list mentions Serbian remaining.
- **Confidence:** High. **Reversibility:** Fully reversible, prose-only
  change.

## D-017 — PROMPT-004 Part 2: tax_rules.json data layer design

- **Date:** 2026-08-07.
- **Context:** PROMPT-004 requires a remote-updatable, bundled-fallback
  source of truth for freelancer tax rules, with the explicit constraint
  that "no tax constant may live in Dart code" and "every numeric value
  carries `effective_from` and a `source` URL."
- **Schema decision:** every field in a regime's `values` map is an object
  `{"value": ..., "effectiveFrom": "...", "source": "..."}`, never a bare
  number — including structured fields (bracket tables, banded scales),
  where the single effectiveFrom/source applies to the whole table as one
  sourced unit rather than per-row. A `null` `value` is how the seed data's
  `n.a.` gaps (e.g. Albania's sub-10M-turnover deemed-expense percentages)
  are represented — schema-valid, distinct from zero, and the UI must
  render it as "not available." This is enforced in code, not just by
  convention: `RuleValue.fromJson` throws `TaxRulesSchemaException` for any
  field missing `effectiveFrom`/`source`, whether the value itself is
  present or null.
- **Rejected alternative:** per-scalar provenance inside structured fields
  (e.g. a separate effectiveFrom/source on every row of Croatia's 7-band
  receipt table) — rejected as disproportionate: those rows are always
  cited together from the same single source document, so field-level
  granularity captures the real provenance without ~5x the JSON for no
  added truth.
- **Precedence/fetch policy implemented exactly as specified:**
  `lib/services/tax_rules_service.dart` mirrors the app's existing
  remote-with-fallback shape (`ExchangeRateService`/`RateCacheService` for
  currency, `VatRateService` for VAT rates) — `load()` never touches the
  network (bundled asset, or a previously-validated downloaded copy if
  newer, precedence always downloaded → bundled, never reversed);
  `refreshInBackground()` is fire-and-forget, respects a 24h cadence via a
  `SharedPreferences` timestamp, uses a 5s timeout, and silently discards
  every failure mode (offline, timeout, non-200, malformed JSON, any
  schema violation, "not newer") — the previous good copy is always left
  in place.
- **Real, disclosed gap: the remote URL is a placeholder.**
  `kFreelanceTaxRulesRemoteUrl` in `tax_rules_service.dart` points at
  `raw.githubusercontent.com/REPLACE_ME/...` — no public repo was created
  to host this file, because this project itself has no git remote (no
  git repo at all, confirmed via environment state) and standing one up
  is an external action outside what a coding session can do
  unilaterally. Until the user creates a public repo (or GitHub Pages
  site) and this constant is repointed at it, `refreshInBackground()`
  will simply fail to resolve the host every time and be silently
  ignored — functionally identical to being permanently offline. The app
  is fully correct and functional on the bundled copy in the meantime;
  it just never receives an over-the-air rules update yet. See
  `OPEN_QUESTIONS.md`.
- **Verification:** `assets/config/tax_rules.json` validated as syntactic
  JSON and schema-parsed for all 10 required regime ids
  (`test/freelance_tax_rules_schema_test.dart`, 25 tests). Fetch policy
  covered by `test/tax_rules_service_test.dart` (8 tests: newer applied,
  older/malformed/schema-invalid/timeout/HTTP-error all ignored with
  bundled copy retained, 24h cadence respected). Full suite 156/156
  passing, `flutter analyze` clean. Per PROMPT-004's own instruction ("do
  not start Part 3 until Part 2 is green"), Part 3 begins only after this
  was confirmed.
- **Confidence:** High on the architecture and schema enforcement;
  Medium on the transcribed seed figures themselves — they were copied
  faithfully from PROMPT-004's own text (not independently re-verified
  against a live government calculator, per the prompt's own "do not
  claim verified against a live calculator unless you actually ran one"
  constraint) and several are date-sensitive (see the "values to
  re-verify" list carried into a maintenance note below).
- **Reversibility:** Fully reversible — one JSON file plus two small,
  independent Dart files with no coupling into existing salary/VAT logic.

### Maintenance note — values with known future change dates

Per PROMPT-004's own seed data: North Macedonia's contribution rates
(28.0%) are valid **July–December 2026 only**; Slovenia's flat
normirani/popoldanski amounts changed **1 April 2026** (and OZP flat
amount from 1 March 2026); Serbia's normative expense deductions changed
**1 February 2026**; Romania's CASS cap rises to 72 minimum salaries
**for 2026 income**. Whoever maintains `tax_rules.json` after this session
should re-check these four values first when the next `rules_version` is
cut.

## D-016 — D-015 icon SUPERSEDED; approved external artwork integrated (PROMPT-003C)

- **Date:** 2026-08-07. The in-house icon from D-015 was **rejected on
  design review** (jagged/inconsistent arrowheads, read as a broken
  refresh icon, not professional). Per `_userprompts/
  PROMPT-003C_Checkpoint_Icon_Handoff.md`, externally-designed approved
  artwork (gold coin-ring + growth arrow launching through a gap, navy
  `#0F2A43`/gold `#E8B54D`) was supplied as `salary_currency_pro_icon_
  pack.zip` + a preview PNG in the project root.
- **Integrated as-is, not modified**: extracted into `branding/`
  (`icon_full.svg/.png`, `icon_playstore_512.png` → `playstore_512.png`,
  `adaptive_foreground/background/monochrome.svg/.png`), replacing the
  old rejected `app_icon*.svg` set (deleted). `branding/generate_icon.py`
  kept for history — **no longer the icon source of truth**.
  `pubspec.yaml`'s `flutter_launcher_icons` config repointed at the new
  filenames; `dart run flutter_launcher_icons` regenerated all platform
  icons successfully (no warnings). The two root handoff files were
  deleted after integration per user instruction.
- **Verification: NOT run this pass** — user was at ~98% token budget
  and explicitly said do it later. No `flutter analyze`/`test`/build was
  run after this icon swap. **Next session must run all three before
  trusting this integration** (same device-verification gap as D-015
  also still applies — no Android device/emulator available yet).
- **Verification completed 2026-08-07 (next session):** `flutter analyze`
  clean (same 3 pre-existing cosmetic notes, unrelated); `flutter test -j
  1` 123/123 passing; a real `flutter build apk --release --split-per-abi`
  succeeded (armeabi-v7a 19.4MB, arm64-v8a 21.6MB, x86_64 23.0MB — same
  range as before the icon swap, still comfortably under the 30MB
  target). The D-016 icon integration is now build-verified. **Real
  on-device launcher appearance is still unconfirmed** — no Android
  device/emulator available in this environment; this remains the one
  open gap alongside D-014's on-device consent-dialog verification.

## D-015 — Implement PROMPT-003A item 2: real app icon (design + generation)

- **Date:** 2026-08-07
- **Context:** `PROMPT-003A_StageA_Closure.md` gave an explicit design
  spec closing D-013's "no real icon exists" gap: one glyph (no text/
  gradients-with->2-stops/clipart/dollar signs), "two smooth semicircular
  exchange arrows forming a broken circle, with the upper arrow's head
  rising slightly above the circle," deep navy background (~#0F2A43),
  warm metallic gold glyph (~#E8B54D), glyph confined to the adaptive-icon
  safe zone, SVG source committed, generated via `flutter_launcher_icons`
  to all densities + Android adaptive icon (separate foreground/
  background) + Android 13+ monochrome themed-icon layer, plus a 512×512
  Play Store PNG.
- **Tooling:** no SVG rasterizer (cairosvg/rsvg-convert/Inkscape) was
  available or reliably installable in this Windows environment; `pip
  install pillow` succeeded cleanly (pure-Python wheel, no native Cairo
  dependency), so the icon is constructed as parametric geometry — arcs,
  radial/tangent vector math, and simple polygons for the arrowheads —
  computed identically for both the rasterized PNG sources (via Pillow)
  and the hand-generated SVG paths (via the same trig, emitted as SVG arc
  commands), rather than drawing one and approximating the other.
  `branding/generate_icon.py` is the single source of truth for both;
  re-running it regenerates all `branding/*.svg` and `branding/source/
  *.png` identically (verified: hashed the output of a second run against
  the committed files).
- **Design iteration (real, not first-try):** the first few geometry
  attempts had genuine defects, caught by rendering and visually
  inspecting each iteration (via screenshots, not assumed correct):
  1. Naive arrowhead triangles left a visible notch where they met the
     ring stroke, because the triangle's back edge was perpendicular to
     the *tip* direction rather than the ring's own radial cross-section.
     Fixed by deriving the back edge from the radial direction at the
     ring's true endpoint (matching the stroke's own inner/outer edge
     exactly) while still letting the tip point wherever intended —
     this fully eliminated the seam.
  2. Several angle-scheme attempts (three iterations) either didn't
     actually form a broken circle (arcs stayed on one side) or put the
     "rising" arrowhead in a spot where an upward tip read as diagonal/
     flag-like rather than a clean vertical accent. Settled on two ~130°
     arcs at 205–335° and 25–155° (180°-rotationally symmetric, screen
     convention 0°=east/clockwise) — this was the *first* angle attempt,
     which turned out to already have the best balance; only the
     arrowhead join and tip direction needed fixing, not the arc
     placement.
  3. Verified the safe-zone fit empirically — the full-bleed glyph's
     extremal point (the rising arrowhead's tip) measured ~77% of the
     canvas half-width, over the ~66% adaptive-icon safe-zone target — so
     the adaptive foreground/monochrome layers use a separate 0.72×
     scale-down of the same geometry (not the full-bleed version merely
     cropped), confirmed visually with a safe-zone circle overlay before
     committing to it.
- **Generation pipeline:** added `flutter_launcher_icons: ^0.14.4` as a
  dev dependency; configured in `pubspec.yaml` pointing at
  `branding/source/*.png` (`adaptive_icon_background` set directly to the
  hex color `#0F2A43` rather than a PNG, since the background is flat —
  simpler and avoids an extra asset); `adaptive_icon_foreground_inset: 0`
  since the safe-zone margin is already baked into the 0.72×-scaled
  source image, not left to the tool's own default 16% inset (which
  would have shrunk the glyph twice). Ran `dart run flutter_launcher_icons`
  — surfaced and fixed one real warning (`remove_alpha_ios: true`,
  since Apple rejects an alpha channel on the primary iOS icon) before
  the final run.
- **Fixed two more placeholder-metadata bugs found while touching this
  area** (same category as D-013's Android label / pubspec description
  fixes): `web/manifest.json`'s `name`/`short_name`/`description` and
  `web/index.html`'s `<title>`/meta description/apple-mobile-web-app-title
  were all still Flutter's unedited template defaults
  ("salary_currency_pro" / "A new Flutter project.") — corrected to the
  real app name/description, matching Android and iOS.
- **Verification:** `flutter analyze` clean (same 3 baseline notes),
  **123/123 tests passing** (icon generation touches no Dart code). Ran
  **two real release builds** after regenerating icons:
  `flutter build apk --release --split-per-abi` succeeded, sizes
  essentially unchanged (19.4MB/21.6MB/23.0MB — icon assets are a
  negligible size contribution) confirming the new resources compile
  cleanly through R8/aapt2 without error. Directly inspected the
  generated `mipmap-anydpi-v26/ic_launcher.xml` (correct background/
  foreground/monochrome layer references) and the legacy
  `mipmap-xxxhdpi/ic_launcher.png` (opened and visually confirmed the
  glyph renders correctly, not corrupted/misscaled). Also rendered
  `branding/app_icon.svg` in a real browser and confirmed it matches the
  PNG pixel-for-pixel in composition (same geometry, same colors).
  **Not verified: actual on-device rendering** (regular/round/themed
  variants on a real Android launcher, or the iOS home screen) — no
  device/emulator was available this session, same disclosed limitation
  as D-014. The resource files are correctly structured and the build
  compiles them without error, which is strong but not complete evidence
  — a real device check remains the next honest verification step.

## D-014 — Implement PROMPT-003A item 1: GDPR/UK ad consent (UMP)

- **Date:** 2026-08-07
- **Context:** `PROMPT-003A_StageA_Closure.md` (see `PROMPTS.md`)
  explicitly approved and specced closing D-013's consent-flow gap.
  Implemented using `google_mobile_ads: 9.0.0`'s bundled UMP APIs
  (`ConsentInformation`, `ConsentForm`) — confirmed the exact method
  signatures by reading the installed package source directly
  (`.../Pub/Cache/hosted/pub.dev/google_mobile_ads-9.0.0/lib/src/ump/`)
  rather than assuming an API shape from memory, since UMP's Flutter API
  has changed across plugin versions.
- **Architecture — new `lib/services/consent_service.dart`:**
  `resolveConsentAndCheckCanRequestAds()` calls
  `ConsentInformation.instance.requestConsentInfoUpdate(...)`, then (on
  success) `ConsentForm.loadAndShowConsentFormIfRequired(...)` — which
  only actually shows a form when the SDK determines the device is in a
  regulated region and consent isn't already recorded — then resolves
  with `ConsentInformation.instance.canRequestAds()`. Every path
  (success, failure, or an uncaught exception) funnels through a single
  `finish()` that completes a `Completer<bool>` exactly once, and the
  whole thing is wrapped in `.timeout(Duration(seconds: 3), onTimeout: ()
  => false)`.
- **Why a timeout, and why 3 seconds:** the prompt requires startup never
  wait more than "a moment" and to fail open to "no ads" rather than
  delay the user. A cached/non-EEA resolution is near-instant; only a
  first-ever EEA launch needs a real network round-trip (and, if a form
  is shown, however long the user takes to respond — but that's a native
  platform dialog, not something blocking Flutter's own frame rendering).
  3s covers the network case generously without meaningfully feeling like
  a delay; anything not resolved by then falls back to "no ads this
  launch," and resolves normally (fast) on the next launch since the UMP
  SDK caches the outcome itself.
- **Wiring:** `AdsService.initialize()` (already called from `main()`
  before `runApp()`, Android/iOS-only) now calls
  `ConsentService.resolveConsentAndCheckCanRequestAds()` first and only
  calls `MobileAds.instance.initialize()` if it returns true, setting a
  new `_adsAllowed` static flag. `AdsService.createBanner()` returns
  `null` immediately if `!_adsAllowed` — `BannerAdSlot` already treated a
  null banner as "show nothing" (`SizedBox.shrink()`), so no change was
  needed there. This means declined/unresolved consent silently results
  in zero ad requests for the session, matching "never nag, never block
  features."
- **Personalized vs non-personalized ads:** intentionally not
  hand-coded. The modern `google_mobile_ads` SDK reads the IAB TCF
  consent string the UMP SDK already recorded and automatically serves
  personalized or non-personalized ads accordingly on every
  `AdRequest()` — the old manual "npa=1" extra is obsolete. Writing that
  logic by hand here would be redundant, dead code.
- **"Privacy & ad preferences" Settings entry:** new `ListTile` in the
  existing "Privacy & Data" section (grouped with "Clear history" since
  both are privacy-actions, avoiding a one-row section card). On tap:
  web/desktop → a SnackBar explaining ad privacy options aren't
  available on this platform (matches `BannerAdSlot`'s existing
  platform gate); else checks
  `ConsentInformation.instance.getPrivacyOptionsRequirementStatus()` —
  if `required`, calls `ConsentForm.showPrivacyOptionsForm()` (the
  modern "reopen" API, distinct from the initial
  `loadAndShowConsentFormIfRequired`); if not required, a SnackBar
  explains no choice is needed for that region, rather than a dead
  button with no feedback.
- **Debug-only test geography:** `ConsentService._debugSettings` returns
  a `ConsentDebugSettings(debugGeography: DebugGeography.debugGeographyEea)`
  only when `kDebugMode` is true — never active in a release build. A
  real developer with a physical/emulated device can add their test
  device ID to `_testDeviceIds` and see the actual EEA consent form.
- **l10n:** 4 new keys (`settingsAdPrivacyTitle/Subtitle/Unavailable/
  NotRequired`) translated into all 9 languages — the Google consent
  form's own text is Google-localized already, so nothing beyond the
  Settings entry itself needed translation. 360/360 key-count lockstep
  verified.
- **Verification — and its real limits, stated honestly per the
  prompt's own requirement not to claim untested behavior works:**
  `flutter analyze` clean (same 3 pre-existing notes), **123/123 tests
  passing** (no test changes needed — the flow is platform-gated to
  Android/iOS and off in the `flutter test` widget-test environment).
  **The actual native UMP consent dialog was NOT visually verified on a
  device or emulator this session — none was available.** This is a
  disclosed gap, not a claimed success: the code was written to the
  documented API contract (verified against the installed package's own
  source, not guessed), compiles and type-checks correctly, and the
  debug-geography scaffolding is in place for a developer to actually
  exercise it — but end-to-end on-device behavior (does the form
  actually render, does declining actually suppress personalized ads,
  does the "Privacy & ad preferences" entry actually reopen it) remains
  unverified pending a real device/emulator test pass.
- **Data safety notes updated:** `store_listing/README.md` §2/§3 revised
  to describe the consent flow as implemented rather than as a gap.

## D-013 — Implement PROMPT-003 Stage A item 4 (Play Store readiness checklist)

- **Date:** 2026-08-07
- **Context:** Item 4 per `PROMPTS.md`: data-safety-form answers derived
  from actual code behavior, AdMob/UMP consent documented, adaptive
  icon, localized store listing text for all 9 languages saved to
  `/store_listing/`, screenshot shot-list. Full detail and content lives
  in `store_listing/README.md` (the checklist hub) and
  `store_listing/{en,sr,hr,bs,mk,sl,bg,sq,ro}.md` (listing text) — this
  entry records the decisions, not the content itself.
- **Store listing text:** written for all 9 languages, content
  cross-checked against the app's actual real feature set (not
  aspirational) and against `settingsAboutBody`'s existing accurate
  copy. No new l10n keys — this is Play Console content, not in-app UI,
  so it doesn't go through `.arb` files.
- **Data safety form:** answers derived by directly auditing
  `lib/services/*_service.dart` (confirmed: no outbound requests except
  two public no-auth currency-rate APIs) and the two third-party SDKs
  actually present (`google_mobile_ads`, `in_app_purchase`) rather than
  assumed. Full answer set in `store_listing/README.md` §2.
- **AdMob/UMP consent: audited and documented, deliberately NOT
  implemented.** Confirmed via an empty codebase search that no Google
  UMP consent flow exists at all, despite the app targeting 4 EU member
  states (HR, BG, RO, SI) where GDPR applies to ad personalization
  consent. **Decision: this is a real compliance gap, but implementing
  the UMP SDK changes ad-request behavior and carries real legal
  consequences if done wrong — `CLAUDE.md` rule 8 ("ask before risk")
  applies to legal/compliance-sensitive changes, so this was documented
  as a release blocker rather than silently implemented.** Flagged as
  the clear next increment, pending explicit go-ahead.
- **App icon: real gap found, deliberately NOT auto-generated.**
  Discovered by directly opening
  `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` that this app
  still ships Flutter's default template icon (the blue Flutter logo) —
  never replaced with real branding, and consequently no adaptive icon
  exists either (bigger gap than "wrong format," there's no real icon at
  all). **Decision: did not invent icon artwork** — a commercial app's
  icon is a brand-identity decision needing the user's input (symbol,
  colors), and getting it wrong is effectively irreversible once
  published; this matches the same "ask before risk on commercial/
  materially uncertain decisions" reasoning as the UMP item. Documented
  with a concrete recommendation (`flutter_launcher_icons` from one
  supplied source image) rather than left as a bare TODO.
- **Two small, safe metadata fixes made while auditing (in scope, low
  risk, clearly-wrong placeholders, not a judgment call):**
  1. `android/app/src/main/AndroidManifest.xml`'s `android:label` was
     still the raw package identifier `salary_currency_pro` — changed
     to the real display name `Salary & Currency Pro` (matching the
     name used everywhere in-app, e.g. `paywallHeadline`).
  2. `pubspec.yaml`'s `description` was still Flutter's unedited
     template default ("A new Flutter project.") — replaced with a real
     one-line description.
  3. Bonus consistency fix: iOS `Info.plist`'s `CFBundleDisplayName` was
     "Salary Currency Pro" (missing the "&") — aligned to match Android
     and in-app branding exactly.
- **Screenshot shot-list:** written as a prioritized list of 7 screens
  in `store_listing/README.md` §5, explicitly scoped down from "all 9
  languages" to a realistic starting point (English + Serbian first) —
  capturing all 9 languages × 7 screens needs a device/emulator farm
  this environment doesn't have.
- **Verification:** `flutter analyze` clean (same 3 pre-existing
  baseline notes) after the manifest/pubspec metadata edits; these are
  non-Dart or non-functional changes so the existing 123/123 test suite
  is unaffected and wasn't expected to change.

## D-012 — Implement PROMPT-003 Stage A item 3 (performance & size budget)

- **Date:** 2026-08-07
- **Context:** Item 3 per `PROMPTS.md`: `--split-per-abi`, R8/resource
  shrinking, <2s cold start on a low-end profile, virtualized lists,
  actual release APK/AAB size report (target <30MB per-ABI AAB — the
  158MB figure from D-006 was a *debug* build, not comparable). Audited
  `android/app/build.gradle.kts` first (per session-03's own earlier
  finding): confirmed no R8/shrinking and no ABI splitting were
  configured — both real gaps.
- **R8/resource shrinking:** added `isMinifyEnabled = true`,
  `isShrinkResources = true`, and `proguardFiles(...)` to the release
  `buildType`, plus a new (currently empty, commented) `proguard-rules.pro`
  — Flutter's own R8 rules and the bundled AAR consumer-rules from
  `google_mobile_ads`/`in_app_purchase` were sufficient; a real
  `bundleRelease`/`assembleRelease` build succeeded with no R8 errors, so
  no extra manual keep-rules were needed (verified empirically rather than
  pre-guessed).
- **Per-ABI splitting — real mistake, caught and corrected:** first
  attempt added a manual `splits { abi { ... } }` block to
  `build.gradle.kts`. A real `flutter build apk --release` run failed:
  *"Conflicting configuration ... ndk abiFilters cannot be present when
  splits abi filters are set"* — the Flutter Gradle plugin manages
  `ndk.abiFilters` itself and conflicts with a manually-added `splits`
  block. **Corrected approach:** removed the `splits` block entirely;
  Flutter's supported mechanism is the `flutter build apk
  --split-per-abi` CLI flag (for raw APK distribution) — and for the
  actual Play Store artifact (`flutter build appbundle`), Play's own App
  Bundle dynamic delivery already serves each device only the ABI/density
  slices it needs, with no gradle-level splits config required at all.
  Left an explanatory comment in `build.gradle.kts` so a future session
  doesn't repeat the same mistake.
- **Measured, real build sizes (not estimated):**
  - `flutter build appbundle --release`: `app-release.aab` = **58.2MB**
    (this is the *whole* bundle containing all ABIs' native code — not
    directly comparable to a per-device download; Play Store's dynamic
    delivery serves a much smaller slice per device).
  - `flutter build apk --release --split-per-abi`: `armeabi-v7a` =
    **19.3MB**, `arm64-v8a` = **21.6MB**, `x86_64` = **22.9MB** — all
    three comfortably under the <30MB per-ABI target, and each is the
    closest available proxy for a real per-device Play Store download
    size. Confidence: High (measured, not estimated).
- **Cold start <2s on a low-end profile: not verified this session.** No
  physical low-end device or emulator was available in this environment
  to actually launch the release build and time it — stating a number
  without measuring it would violate this project's own "never invent a
  number" pattern. Left open in `OPEN_QUESTIONS.md`.
- **Virtualized lists: audited, deliberately deferred, not fixed.**
  Surveyed every screen with a `for (final x in ...)` loop inside a
  widget tree. Country/language/currency/tool pickers are all bounded to
  small fixed sets (≤20 items) — not a real concern. Two screens build an
  eager `ListView(children: [... for loop ...])` over genuinely
  user-grown data: the Expense Tracker's transaction list (already
  month-scoped, so realistically bounded to a few dozen items at a time)
  and the Invoices list (unbounded over the life of the app, more likely
  to matter at scale). Converting either to a lazily-built
  `ListView.builder`/`CustomScrollView` + slivers is a real, behavior-
  changing UI refactor — both screens currently mix a summary-card header
  with the loop inside a single non-sliver `ListView`, so it's not a
  drop-in change. **Decision: defer rather than rush.** No profiling
  evidence of actual jank exists (no device/emulator available to
  measure), and a sliver refactor done without the ability to visually
  re-verify it (this session's browser tab was already closed) carries
  real regression risk for a benefit that's currently speculative.
  Recorded as an open item rather than silently dropped — see
  `OPEN_QUESTIONS.md` QUESTION-004.
- **Verification:** `flutter analyze` clean (same 3 pre-existing notes),
  no Dart code changed by this item so the existing 123/123 test suite is
  unaffected. Both release build types (`appbundle` and split `apk`)
  actually built successfully end-to-end with the new R8/shrinking config
  — this is real evidence the config works, not just that it compiles.

## D-011 — Implement PROMPT-003 Stage A item 2 (trust surface): design choices

- **Date:** 2026-08-07
- **Context:** Per user instruction, continuing straight through PROMPT-003
  Stage A items without a check-in between each (see auto-memory
  `feedback_continue_without_asking`). Item 2 per `PROMPTS.md`: a "Why
  trust this app?" Settings section (formula sources, effective dates,
  last-updated, offline/privacy explanation) plus a "rates valid for
  YYYY" label on every calculator result.
- **Audit first (per PROMPT-003's own rule):** surveyed every calculator
  screen before adding anything:
  - Salary calculator already shows `{year} parameters · effective
    {date}` from `TaxConfig.effectiveFrom` — satisfies the ask already,
    no change needed.
  - Currency converter and Freelancer payout already use the existing
    `RateStatusBanner` widget (live/cached + "as of" timestamp + source)
    — already satisfies the ask, no change needed.
  - VAT calculator: real gap. `assets/config/vat_rates.json` already
    carries a real `lastUpdated` date and a `sources` list, but
    `VatRateService.loadRates()` discarded `lastUpdated` and the UI never
    showed it.
  - Samooporezivanje (Serbia self-taxation) calculator: real gap. The
    2026 quarterly thresholds are real, sourced constants (per the
    calculator's own doc comment), but no year/effective-date was ever
    surfaced to the user.
  - Loan, Savings, and Budget Planner: **deliberately excluded** — every
    rate/percentage in these three is user-typed, not app-provided, so
    there is no app-sourced "rate" to disclose freshness for. Adding a
    "valid as of" label here would fabricate a claim the app can't back
    up — rejected as a violation of this project's own "never invent a
    number" pattern (see `OPEN_QUESTIONS.md` QUESTION-001).
- **Changes made:**
  1. `VatRateService` gained a `lastUpdated` field, set as a side effect
     of `loadRates()` (avoids a second asset read). `vat_screen.dart`
     shows "Standard rate as of {date}" under the country/rate dropdown
     when available.
  2. `SamooporezivanjeCalculator` gained a `year = 2026` constant
     (already asserted in its doc comment, just not exposed). The screen
     now shows "{year} quarterly thresholds" above the existing
     disclaimer banner. **Deliberately did not fabricate a `sources` list
     for this calculator** — unlike the payroll `TaxConfig`s and
     `vat_rates.json`, this regime's specific deduction constants aren't
     yet backed by the same citation standard (this is the same
     already-documented gap as `OPEN_QUESTIONS.md` QUESTION-001), so only
     the year is claimed, not sourcing.
  3. New Settings section "Why trust this app?", placed after the Pro
     card and before "Privacy & Data" — explains that payroll/VAT/
     self-taxation figures are sourced and dated, and cross-references
     the existing "Privacy & Data" and "Works fully offline" sections by
     their real (translated) titles rather than duplicating their copy.
- **l10n:** 4 new keys (`vatRatesAsOf`, `samoParamsLine`,
  `settingsTrustTitle`, `settingsTrustBody`) hand-translated into all 9
  languages, cross-referencing each language's own translated section
  titles (not the English ones) so the in-app pointer text is accurate
  per-locale. 356/356 key-count lockstep verified. Ran `flutter gen-l10n`
  (triggered via `l10n.yaml`, not the raw `flutter gen-l10n` CLI args) to
  regenerate `AppLocalizations` after editing the `.arb` files directly.
- **Testing:** no new tests added — these are additive, non-interactive
  display-only changes (a caption, a label, a settings section) to
  screens already covered by existing tests; existing tests continue to
  pass unchanged. **123/123 passing**, `flutter analyze` clean (same 3
  pre-existing baseline notes).
- **Verification:** Real browser screenshots (`claude-in-chrome`) of all
  three additions — the Settings section, the VAT "as of" caption, and
  the Samooporezivanje params line — confirmed rendering correctly on a
  fresh dev-server restart.

## D-010 — Visual verification: onboarding flow (D-009) and D-008 Amount-field fix both confirmed

- **Date:** 2026-08-07
- **Context:** Resumed session per `PROJECT_CONTEXT.md`'s Next Recommended
  Action. `claude-in-chrome` browser tooling was available this session
  (unlike the two prior sessions that lacked it). Killed a stale/broken
  `flutter run` process already bound to port 8765 (returning HTTP 503,
  not a live dev server — confirmed via `read_network_requests` before
  killing it), then launched a fresh `flutter run -d web-server --web-port
  8765` per `.claude/launch.json`'s `flutter-web` config.
- **Onboarding (D-009) — confirmed working end-to-end on first launch:**
  1. Country/language screen: all 9 countries render with flag icons,
     Serbia pre-selected (device-locale auto-detection working), Language
     dropdown shows "System default", Skip link and progress dots present.
  2. Privacy screen: lock icon, "Your data stays on your phone" heading,
     body copy matches D-009's honestly-scoped wording (names salaries/
     expenses/invoices staying on-device, calls out currency conversion as
     the one internet-dependent feature) — not the prompt's unscoped
     example line, as designed.
  3. Goal-picker screen: all three goals render with icons; "Get started"
     is correctly disabled until a goal is picked. Selected "Salary &
     payroll math" → app opened directly on the **Salary tab** (bottom nav
     index 2, Serbia salary calculator visible) — confirms the goal→tab
     mapping and the persistent `home_default_tab_index` write both work.
  4. Bonus confirmation while navigating to re-check D-008: the Expense
     Tracker's empty state (D-007) also renders its icon correctly on a
     real screen, not just in the widget test.
- **D-008 (Amount field focus color) — confirmed fixed:** opened the
  Expense Tracker's "Add expense" sheet; the Amount field's label and
  cursor render red (matching `AppColors.alertRed`, the sheet's expense
  theme color), not the Material-default green seen before the fix.
  Zoomed screenshot confirms the exact color. This closes out D-008's
  previously-open "not yet visually re-confirmed" caveat.
- **Verification:** Real browser screenshots at each step (not just
  `flutter analyze`/`flutter test`, which were also re-run this session
  and remain clean: 3 pre-existing info-level notes, 123/123 tests
  passing). No new code changes were needed — both D-009 and D-008 were
  already correct; this decision closes out the "not yet visually
  confirmed" status both carried.

## D-009 — Implement PROMPT-003 Stage A item 1 (onboarding): design choices

- **Date:** 2026-08-07
- **Context:** User supplied a new large standing instruction, PROMPT-003
  (`C:\Users\Administrator\Downloads\PROMPT-003_Market_Domination_Addition.md`,
  registered in `PROMPTS.md`), extending PROMPT-002 with a commercial-
  readiness layer. Stage A ("Commercial trust & first impression") is
  marked highest priority; item 1 is a max-3-screen, skippable onboarding
  flow: country+language auto-detected from device locale with manual
  override, a privacy-promise screen, and a primary-goal picker that sets
  the default home tab. Audited first per the prompt's own rule ("audit
  whether it already exists — never rebuild working features"): no
  onboarding code existed; country/language pickers already existed
  separately (Settings' language `RadioGroup`, the salary calculator's
  country bottom-sheet) and were reused rather than rebuilt.
- **Key design choices:**
  1. **Auto-detection:** `detectCountryFromDeviceLocale` matches the
     device's `Locale.countryCode` directly against `Country.id` (they're
     the same two letters for all 9 supported countries — rs/hr/ba/me/mk/
     si/bg/al/ro), falls back to a language match via `Country.localeCode`,
     then to Serbia (matching `SalaryCalculatorProvider`'s own existing
     default). Language itself needed no new detection code — the app
     already resolves the device locale automatically whenever `_locale`
     is null (Flutter's own `MaterialApp` locale resolution); onboarding's
     language control just reuses that same `locale`/`onSetLocale`
     plumbing already threaded through `app.dart` → `RootShell` →
     `SettingsScreen`.
  2. **Shared state promoted, not duplicated:** `SalaryCalculatorProvider`'s
     private `_prefsCountryKey`/`_prefsEntityKey` became public
     `prefsCountryKey`/`prefsEntityKey` so onboarding writes the exact same
     SharedPreferences keys the salary calculator already reads on
     startup — no new country-persistence mechanism. `settings_screen.dart`'s
     private `_languageNames` map moved to `l10n_lookups.dart` as public
     `kLanguageNames` so onboarding's language dropdown and Settings' list
     can't drift apart.
  3. **"Sets the default home tab" interpreted as persistent, not one-time:**
     `RootShell` gained an `initialIndex` parameter (default 0); `app.dart`
     persists the chosen goal's tab index (`home_default_tab_index`) and
     passes it through on every launch, not just immediately after
     onboarding. Rationale: the prompt's own wording ("sets the default
     home tab") reads as an ongoing default, not a single redirect, and a
     persistent default is more useful to, e.g., a freelancer who always
     wants to land on Tools.
  4. **Goal → tab mapping:** salary → Salary tab (2), business → Tools tab
     (3, where invoices/business tools live), expenses → Home (0), since
     expense tracking has no dedicated tab — it's Home's "This month"
     card. Skipping onboarding also lands on Home (0).
  5. **Privacy-screen copy scoped honestly:** adapted from the existing,
     already-accurate `settingsOfflineStatusBody`/`settingsPrivacyNote`
     copy (no account/cloud/server, currency conversion is the one
     internet-dependent feature) rather than the prompt's example line
     ("Your data never leaves your phone") verbatim — that phrasing would
     be inaccurate given AdMob's ad SDK, which is a separate, correctly-
     scoped disclosure item (Stage A item 4, not yet done). Kept this
     screen's claim scoped to *user-entered financial data* specifically,
     matching this app's existing "don't overclaim privacy" pattern.
  6. **Loading-state gap avoided:** `app.dart` now tracks
     `_onboardingComplete` as nullable (`null` = prefs still loading) and
     renders a blank `Scaffold` in that brief window, rather than showing
     `RootShell` and then swapping to `OnboardingScreen` a frame later for
     a first-time user (or the reverse flash for a returning one).
- **l10n:** 16 new keys (`onboarding*`), translated into all 9 languages
  by hand, calibrated against each language's existing register/formality
  in nearby strings (e.g. Romanian's existing informal "tu" register,
  Slavic languages' existing formal/impersonal "unesete"-style register)
  rather than a uniform mechanical translation. Verified 352/352 key-count
  lockstep across all 9 `.arb` files before and after.
- **Testing:** two new tests in `test/widget_test.dart` — first-launch
  shows onboarding + skip completes it and never shows again after a
  simulated relaunch; picking the salary goal lands on the Salary tab
  (`NavigationBar.selectedIndex == 2`). Every onboarding interactive
  control got a stable `Key` (not text-based finders) because `PageView`
  can keep multiple pages' widgets built simultaneously, which would make
  text finders like `find.text('Continue')` ambiguous across pages.
  Existing tests that build the full app (`widget_test.dart`,
  `salary_calculator_screen_test.dart`) now seed
  `{'onboarding_complete': true}` in their `setUp()` so they continue
  testing past-onboarding behavior unchanged. **121 pre-existing + 2 new
  = 123/123 passing**, `flutter analyze` clean (same 3 pre-existing
  baseline notes).
- **Not yet done:** visual/browser verification of the onboarding flow's
  actual rendering was in progress (browser preview loading) when this
  session was asked to checkpoint for a fresh-session handoff — see
  `PROJECT_CONTEXT.md`'s Next Recommended Action. Code-level verification
  (analyze + tests) is real and complete; visual confirmation is not.

## D-008 — Fix focus-color mismatch in the expense/income "Add transaction" sheet's Amount field

- **Date:** 2026-08-07
- **Context:** Continuing Phase 11 with real browser verification for the
  first time this project (Claude Desktop preview, per
  `PROJECT_CONTEXT.md`'s "Next Recommended Action"). Ran the app via the
  existing `flutter-web` launch config, opened the Expense Tracker, and
  visually confirmed the D-007 empty-state icon renders correctly. Then
  opened the "Add expense" sheet (`_AddTransactionSheet` in
  `lib/screens/expenses/expense_tracker_screen.dart`) and found a real,
  screenshot-confirmed inconsistency: the sheet's title and Save button
  are colored per transaction type (`AppColors.alertRed` for expense,
  `AppColors.moneyGreen` for income — an existing, intentional pattern),
  but the Amount `TextField`'s focused label and cursor used Flutter's
  Material 3 default (`colorScheme.primary`, which is `moneyGreenLight`
  in this app's dark theme per `lib/theme/app_theme.dart`) — so an "Add
  expense" sheet showed a green-focused Amount field inside an otherwise
  red-themed sheet.
- **Options considered:**
  1. Set `cursorColor: color` and `floatingLabelStyle: TextStyle(color:
     color)` explicitly on the Amount field, matching the sheet's
     existing `color` variable.
  2. Wrap the field in a local `Theme` override changing
     `colorScheme.primary` for the subtree.
  3. Leave it — it's cosmetic, not a functional bug.
- **Decision:** Option 1. Smaller diff than a `Theme` override, and only
  touches the two properties that actually showed the wrong color.
  Guarded the label-color override with `_issue == null ? ... : null` so
  a validation error still falls through to Flutter's own default
  error-red label styling instead of being masked by the type color —
  verified this matters by reading `InputDecorator`'s `_getActiveColor`
  logic (an explicit `TextStyle.color` in `floatingLabelStyle` overrides
  the framework's automatic error-color switch, so leaving it unguarded
  would have kept the label green/red-by-type even while showing a
  validation error).
- **Rejected alternatives:** Option 2 rejected as more change than needed
  for a two-property fix. Option 3 rejected — this is exactly the kind of
  item Phase 11 (button hierarchy / visual consistency, `PROMPTS.md`
  PROMPT-002) exists to catch, and it was directly observed, not
  speculative.
- **Verification:** Visually confirmed via screenshot **before** the fix
  (green label on red sheet, reproducible). After the fix, browser
  verification could not be re-run in this session — a client-side
  Browser-pane display issue ("pane is not displayed, so the page is not
  compositing frames") blocked screenshots on the next two preview
  restarts, unrelated to this code change (all page resources loaded 200
  OK each time; console showed a DWDS debug-websocket handshake race, not
  an app error). Fell back to `flutter analyze` (clean, same 3
  pre-existing baseline notes) and `flutter test -j 1` (121/121 passing)
  as the available verification instead. **Not claiming visual
  confirmation of the fix itself** — only of the bug it fixes. Next
  session should re-open the Expense Tracker's "Add expense" sheet and
  confirm the Amount field's label/cursor now render red before trusting
  this fix visually.

## D-007 — Phase 11 empty-state polish: reuse the existing icon+text pattern rather than invent a new one

- **Date:** 2026-08-07
- **Context:** `OPEN_QUESTIONS.md` QUESTION-002 scoped Phase 11 to a focused
  visual-consistency pass over what was added this session (expense
  tracker, budgets/goals, invoices), not a redesign. Re-checking those
  three screens before touching anything found they already had
  functioning empty states (`expenseEmptyState`, `invoicesEmptyState`,
  `budgetsNoGoalsYet` — all already present and correct in all 9
  `lib/l10n/app_*.arb` files from prior sessions), but all three were
  text-only, while `lib/screens/scenarios/my_scenarios_screen.dart`
  (an already-shipped screen) established an icon+message empty-state
  convention (centered `Column` — `Icon` sized 40, `colorScheme.outline`
  color, 12px gap, `bodyMedium` text) that these three never picked up.
  So the actual Phase 11 gap here was a visual-consistency one (missing
  icon), not a missing message.
- **Options considered:**
  1. Add a leading `Icon` to each of the three existing empty-state
     widgets, reusing `my_scenarios_screen.dart`'s exact icon+text layout,
     with no new l10n strings (the existing messages are already correct).
  2. Write new, more elaborate empty-state copy/layout (e.g. an
     illustration, a call-to-action button) for each screen.
  3. Leave them as-is since they're technically not "missing" empty
     states, just missing an icon.
- **Decision:** Option 1, applied to `expense_tracker_screen.dart` (icon:
  `Icons.account_balance_wallet_outlined`), `invoices_screen.dart` (icon:
  `Icons.receipt_long_outlined`), and `budgets_screen.dart`'s "no savings
  goals yet" card (icon: `Icons.savings_outlined`, sized 32 not 40 since
  it sits inside a `Card` within a longer scrollable list rather than
  filling the whole screen like the other two). The category-budgets
  section of `budgets_screen.dart` was deliberately left untouched — it
  always renders the full fixed category list with a "Set limit" action
  regardless of whether any budget is set (an existing, intentional
  design from Phase 4, not a list of user-entered items that can be
  "empty" in the same sense), so adding a separate empty-state icon there
  would misrepresent it as missing data rather than an always-available
  action list.
- **Rejected alternatives:** Option 2 rejected — out of Phase 11's scoped
  interpretation (QUESTION-002) and this repo's minimal-increment
  convention (D-001); a call-to-action button would also duplicate the
  screens' existing FAB/"Add" affordance. Option 3 rejected — the task
  driving this session explicitly asked for icon+message empty states in
  this app's existing visual style, and an established icon+text
  convention already existed one screen over that these three didn't
  match; that is a real, if small, visual inconsistency worth fixing in a
  visual-polish phase.
- **Confidence:** High — the icon+text pattern was copied directly from
  an already-shipped screen rather than invented, and all three existing
  l10n messages were re-verified unchanged (no new keys needed; key count
  stayed at 336/locale across all 9 `lib/l10n/app_*.arb` files, re-checked
  via `grep -cE '^\s*"[a-zA-Z]' lib/l10n/app_*.arb` after the change,
  matching the count before it).
- **Reversibility:** Fully reversible; each change is a small, local
  widget-tree edit adding one `Icon` + `SizedBox` per screen, no schema,
  service, or l10n key changes.

## D-006 — Upgrade google_mobile_ads 5.3.1 → 9.0.0 to fix a real production-build failure

- **Date:** 2026-08-07
- **Context:** Phase 10's quality pass attempted an actual `flutter build apk
  --debug` (this repo's Android toolchain: Gradle 9.1.0, AGP 9.0.1, per
  `android/gradle/wrapper/gradle-wrapper.properties` and
  `android/settings.gradle.kts`). The build failed with a real, reproducible
  Gradle configuration error inside `google_mobile_ads-5.3.1`'s own
  `build.gradle` (`Could not get unknown property 'all' for configuration
  container`) — that package version predates Gradle 9's Configuration
  Container API changes. This is not a code bug in this app; it's a
  third-party plugin/toolchain version mismatch, but it fully blocks
  producing an installable APK, which is a real Phase 10 blocker.
- **Options considered:**
  1. Upgrade `google_mobile_ads` to `^9.0.0` (available on pub.dev,
     version-number-aligned with this project's AGP 9.0.1 generation).
  2. Downgrade the project's Gradle/AGP versions to match what
     `google_mobile_ads 5.3.1` expects.
  3. Leave it broken and just report the finding without fixing it.
- **Decision:** Option 1. Checked `lib/services/ads_service.dart` and
  `lib/widgets/banner_ad_slot.dart` first — both use only the stable core
  API (`MobileAds.instance.initialize()`, `BannerAd`, `AdSize.banner`,
  `AdRequest`, `BannerAdListener`, `AdWidget`), unchanged across this
  version range. Upgraded, ran `flutter analyze` (clean, no breaking API
  usage found), ran the full test suite (121/121 passing), then re-ran
  `flutter build apk --debug` — succeeded, produced a real 158MB
  `app-debug.apk` (verified via `ls`, not assumed from a "BUILD
  SUCCESSFUL" log line alone).
- **Rejected alternatives:** Option 2 rejected — the Gradle/AGP versions
  are the project template's own baseline (not something this session
  introduced), and downgrading a whole toolchain to accommodate one old
  plugin is higher blast-radius and less future-proof than upgrading the
  one plugin that's actually behind. Option 3 rejected — "production build
  succeeds" is an explicit, testable Phase 10 requirement
  (`PROMPTS.md` PROMPT-002); reporting a known-fixable blocker without
  fixing it would leave the app in a worse state than necessary for no
  reason, and the fix was low-risk once the API surface was checked first.
- **Confidence:** Confirmed — the build failure, the fix, and the
  successful rebuild were all directly observed via actual command
  execution, not inferred.
- **Reversibility:** Fully reversible (a `pubspec.yaml` version constraint
  change); if `9.0.0` ever caused a real runtime regression, reverting is a
  one-line change plus `flutter pub get`.



Log of significant choices for this repository. Newest first. Each entry:
context, options considered, decision, rejected alternatives, confidence,
reversibility. Not part of the Claude Global Toolkit's optional memory-
system bundle itself (`PROJECT_CONTEXT.md`, `PROJECT_RULES.md`, etc.) — this
file already existed as a standalone convention (see
`C:\Claude-Global-Toolkit\HOW_TO_USE.md` §3) and the bundle deliberately
does not duplicate it.

## D-005 — Adopt the toolkit's optional memory-system bundle into this repo

- **Date:** 2026-08-07
- **Context:** `C:\Claude-Global-Toolkit` implemented SRC-002 (a general
  project-memory/decision system) and packaged it as six opt-in templates
  (`PROJECT_CONTEXT.md`, `PROJECT_RULES.md`, `PROMPTS.md`, `IDEAS.md`,
  `OPEN_QUESTIONS.md`, `session_logs/`) any adopting repository can copy in
  independently of the full SRC-001 governance structure. The user asked
  for this repo to be updated so a future session restart actually picks up
  the new context/decision continuity, not just the toolkit repo itself.
- **Options considered:**
  1. Adopt the full six-file bundle now, filled with this project's real
     content (not toolkit boilerplate).
  2. Wait until the offline-completion phase plan finishes before adding
     more repository scaffolding.
  3. Adopt only `PROJECT_CONTEXT.md`, skipping the rest as lower-value.
- **Decision:** Option 1 — the user explicitly asked for this now, and the
  whole point of the bundle is to survive a session restart, so deferring it
  would defeat the purpose for exactly the restart the user is anticipating.
- **Rejected alternatives:** Option 2 rejected — the request was explicit
  and time-sensitive (before a restart). Option 3 rejected — a partial
  adopt would leave `PROJECT_RULES.md`'s "Source of Truth" section
  (assumed present) unbacked, and `PROMPTS.md`/`IDEAS.md`/
  `OPEN_QUESTIONS.md` each hold real, distinct content already accumulated
  this session (the two large supplied prompts, the deferred-feature
  backlog, and genuinely open questions) that would otherwise have no home.
- **Confidence:** High — directly requested, and the toolkit's own
  `HOW_TO_USE.md` §3 gives an exact, already-verified adoption procedure.
- **Reversibility:** Fully reversible; all additions are new files, no
  existing file's meaning changed except `CLAUDE.md`'s addition of a
  "Start or resume" pointer section.

## D-004 — SnackBar queueing fix: hide the current one before showing a new one

- **Date:** 2026-08-07
- **Context:** A widget test revealed a real bug while testing Settings'
  "Delete all local data" flow: triggering two `ScaffoldMessenger`
  snackbar-showing actions in quick succession (e.g. "Export all data" then
  "Delete all local data") silently queued the second snackbar behind the
  first's multi-second default duration, so it wasn't visible until the
  first fully timed out — not a test artifact, a real UX bug any user
  triggering two Settings actions back-to-back would hit.
- **Options considered:**
  1. Call `ScaffoldMessenger.of(context).hideCurrentSnackBar()` immediately
     before every `showSnackBar()` call in these flows.
  2. Leave it — the queueing is default Flutter `ScaffoldMessenger`
     behavior, not a crash.
  3. Increase pump/wait time in tests to work around it without fixing the
     underlying behavior.
- **Decision:** Option 1 — applied to `_confirmClearHistory`,
  `_exportAllData`, and `_confirmDeleteAllData` in `settings_screen.dart`.
- **Rejected alternatives:** Option 2 rejected — a confirmation the user
  can't see because it's silently queued behind an unrelated one is a real
  trust problem for a "did my delete actually work" action. Option 3
  rejected — that would hide the bug from tests without fixing the actual
  behavior users experience.
- **Confidence:** Confirmed — reproduced via test, fixed, re-verified
  passing.
- **Reversibility:** Fully reversible, three-line change per call site.

## D-003 — No cross-currency conversion anywhere in the offline finance features

- **Date:** 2026-08-07
- **Context:** Expense tracker summaries, category budgets, savings goals,
  and invoices can all involve more than one currency (e.g. a freelancer
  paid in USD with EUR expenses). Converting everything to one currency for
  a single combined total would require a live/cached exchange rate and
  introduce a number that silently drifts from what the user actually
  entered.
- **Options considered:**
  1. Convert everything to one "home" currency for unified totals.
  2. Keep every total (monthly summary, category breakdown, budget
     progress, invoice outstanding total) strictly per-currency — one
     section/card per currency present, never blended.
  3. Only support a single currency per household/business, forcing a
     choice at setup.
- **Decision:** Option 2, applied consistently across `ExpenseService`,
  `BudgetService`, and `InvoiceService`.
- **Rejected alternatives:** Option 1 rejected — this app has no live
  backend rate source wired into these features (the currency *converter*
  tool is separate and explicit-action-only), so a blended total would
  either need a stale/cached rate presented as current or a fabricated one;
  both risk misrepresenting the user's actual money, which every other
  offline-data feature in this app explicitly avoids. Option 3 rejected —
  real Balkan freelancers commonly deal in multiple currencies (EUR
  expenses, USD/GBP foreign income) per the app's own Freelancer Payout
  tool; forcing single-currency would contradict that.
- **Confidence:** High — consistent with this app's existing "never
  fabricate a number" pattern (see `ExchangeRateService`'s own
  never-fabricate-a-rate design).
- **Reversibility:** Reversible but with real cost — retrofitting
  conversion later means redesigning every summary widget's data shape.

## D-002 — Invoice status: two real states + a derived flag, not four stored states

- **Date:** 2026-08-07
- **Context:** The requested feature set asked for "paid, unpaid, and
  overdue" invoice status. The obvious literal implementation is a
  draft/sent/paid/overdue enum.
- **Options considered:**
  1. Store a four-value status enum (draft/sent/paid/overdue) set
     explicitly by the user.
  2. Store only `isPaid` (bool) + `paidDate`; compute `isOverdueAsOf(now)`
     live from `!isPaid && dueDate.isBefore(now)` — never stored, so it
     can't go stale relative to today's date.
- **Decision:** Option 2 (`lib/models/invoice.dart`).
- **Rejected alternatives:** Option 1 rejected — "draft" and "sent" don't
  correspond to any real distinction in a single-user, no-sending-mechanism
  tool (there's no email/delivery step this app performs), so tracking them
  would be state the user has to maintain by hand for no operational
  benefit; a *stored* "overdue" status would also silently go wrong the
  moment the app isn't opened on the exact day it should flip, which a
  derived value can't do.
- **Confidence:** High — matches this app's existing product-judgment
  pattern of preferring fewer, honestly-computed states over more stored
  ones (e.g. `HistoryEntry` vs `Scenario`'s deliberately different
  persistence models).
- **Reversibility:** Reversible; would require a schema migration
  (`Invoice.schemaVersion` already exists for this) if draft/sent tracking
  is ever genuinely requested.

## D-001 — Scope offline expense/budget/business features as staged MVPs, not the full mega-prompt at once

- **Date:** 2026-08-07
- **Context:** The user supplied a large 18-section "Autonomous Product
  Development Prompt" (logged in `PROMPTS.md` PROMPT-001) describing a full
  Balkan fintech SaaS — personal finance, business finance, invoicing,
  team workspaces, accountant reports, research/trends, commercial
  onboarding — then redirected explicitly to "finish the offline app
  completely" first via a 12-phase plan (`PROMPTS.md` PROMPT-002) before
  any online/backend work.
- **Options considered:**
  1. Build every feature the original mega-prompt listed, immediately,
     across all phases in one pass.
  2. Build one real, tested, minimal-but-honest increment per phase in
     order (edit/undo → search/filter → dashboard → budgets/goals →
     insights/export → settings data management → offline business MVP),
     explicitly logging deferred scope rather than silently dropping or
     silently fully building it.
  3. Stop after each phase and ask for confirmation before continuing.
- **Decision:** Option 2 — matches both the mega-prompt's own stated
  discipline ("prefer fewer excellent workflows over many unfinished
  features," "do not maximize the number of features") and the toolkit's
  no-silent-scope-expansion rule.
- **Rejected alternatives:** Option 1 rejected — attempting Phase 9's full
  scope (multi-workspace, team roles, accountant PDF reports) in one pass
  alongside every other phase would produce untested, half-built surface
  area, the exact failure mode both the mega-prompt and this toolkit's
  daily-operating-loop chapter warn against. Option 3 rejected — the user
  explicitly said "continue with all phases without confirmation from me."
- **Confidence:** High — directly instructed, twice (offline-first
  redirect, then explicit no-confirmation continuation).
- **Reversibility:** Fully reversible; every deferred item is recorded in
  `IDEAS.md`, not lost.
