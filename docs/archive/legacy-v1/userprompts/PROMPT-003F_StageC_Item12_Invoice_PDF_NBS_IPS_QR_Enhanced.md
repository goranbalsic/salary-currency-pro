# PROMPT-003F: Stage C Item 12 — Excellent Invoice PDF + NBS IPS QR

**Status:** Approved. Proceed with PROMPT-003 Stage C item 12 only. This revision raises the quality bar for the existing invoice experience; it does **not** authorize unrelated tools, a broad redesign, paid services, or Stage C item 13 work.

Register this prompt in `PROMPTS.md`. Retain every existing project rule: session-start read order; 9-language l10n lockstep; real tests (`flutter test -j 1`); clean `flutter analyze`; honest reporting; minimal, reviewable increments; offline-first behavior; and checkpoint discipline.

Item 11 is accepted and complete. Do not revisit it unless an item-12 dependency reveals a genuine blocking defect. If a proposed change affects a screen or system outside the invoice journey, report it as a recommendation rather than implementing it.

---

## Product standard

The invoice feature must feel like part of one calm, trustworthy financial app—not a technical export utility bolted onto a tracker. A first-time user must be able to:

1. create or open an invoice,
2. understand its amount, currency, due date, payment status, and available actions immediately,
3. generate a professional document with one obvious action,
4. understand whether an NBS IPS QR payment code is available and why, and
5. save, share, or revisit the same invoice without losing context.

Prioritize clarity, restrained layout, readable money formatting, and useful text over decorative UI. Do not add feature count for its own sake. Every user-visible action must have a clear purpose.

---

## Objective

Build a fully offline, professional invoice-PDF feature from the existing invoice tracker. Embed a validated NBS IPS QR code only for eligible Serbian RSD invoices.

The feature must improve the existing invoice journey through clear information hierarchy, predictable actions, transparent eligibility, and durable local data—not through a parallel invoice model or a separate workflow.

---

## Phase 0 — Audit before editing

Before changing code, inspect and report:

- The existing invoice model, persistence, CRUD flow, status/paid flow, itemization, VAT representation, currency handling, due-date logic, and any existing export/share code.
- Current invoice list, detail, add, and edit screens; identify the exact user journey for creating, viewing, generating, sharing, marking paid, and revisiting an invoice.
- Existing app design system: colors, typography, spacing, money/date formatting, empty states, feedback/error components, accessibility semantics, and localization approach.
- Android and iOS storage/share/file behavior and all relevant current dependencies.
- Whether the current model contains every legally necessary NBS IPS field. Do not infer, synthesize, or silently reuse a semantically incorrect field.

Report a concise **before-state UX map** and implementation plan. Then implement only the scoped improvements below.

---

## 12.1 — Cohesive invoice journey

Improve existing invoice screens only where necessary to support excellent PDF and QR behavior.

### Information hierarchy

- On the invoice detail screen, make the invoice identity, recipient, total, currency, payment status, due date, and principal action easy to scan without scrolling through secondary information.
- Use the app’s established money and date formatting consistently. Never present mixed-currency totals as though they are directly comparable.
- Keep primary actions limited and clear. The intended hierarchy is: **Generate/Share PDF** as the document action, then edit, mark paid/unpaid where supported, and delete as a clearly separated destructive action.
- Preserve all existing invoice data and behavior unless a change is required for correctness or usability.

### PDF action and feedback

- Provide one clearly named, accessible action such as `Generate PDF` or the localized equivalent. Do not make users choose technical formats or destinations before a document exists.
- Generate locally, then present the established save/share/export path. Reuse existing platform abstractions where available.
- Give concise, non-technical progress and failure feedback. A failed export must not lose or modify the invoice.
- Prevent accidental duplicate work: repeated taps must not create a confusing competing export state or modify the stored invoice.
- The invoice remains the source of truth. A generated PDF is an export artifact, not a second editable invoice record.

### Eligibility transparency

- When the invoice is Serbian and denominated in RSD, show a short, accessible explanation that the PDF can include an NBS IPS QR payment code if the required payment details are valid.
- When it is not eligible, do not show a disabled mysterious control. Explain the relevant reason in plain localized language—for example, QR payment is available only for qualifying Serbian RSD invoices, or required payment data is incomplete.
- Avoid country-specific jargon outside the Serbian/RSD context. Non-Serbian users should still receive a polished invoice PDF, with no suggestion that their invoice is deficient.
- Communicate QR availability, validation errors, and export errors with text and semantics—not color, iconography, or QR imagery alone.

### Data entry and validation

- Validate required invoice and NBS-only fields as close to entry as possible, with actionable field-level explanations.
- Do not block creating/saving a normal invoice because optional NBS QR information is absent. Block only QR generation when the relevant mandatory data is invalid or missing.
- Preserve drafts and user-entered content when validation fails. Never discard information because a payment payload cannot be built.

---

## 12.2 — Localized professional PDF

- Generate a professional PDF from the existing invoice model; do not create a parallel invoice data model.
- Render in the invoice’s selected language, using the project’s existing localization approach and locale-appropriate number/date formatting.
- Establish a calm, legible document hierarchy: issuer and recipient details; invoice number/identity; issue and due dates; itemized lines; quantities; unit prices; discounts/VAT only if represented by the existing model; subtotal; tax; total; payment/status details; and QR payment information where eligible.
- Use a layout that remains readable for long issuer/recipient names, multi-line descriptions, many invoice lines, zero/one/multiple VAT configurations supported by the model, and page breaks. Do not truncate legal/business content silently.
- Add a modest product identity only if it does not obscure the issuer’s identity or make the invoice appear to be issued by the app. The app is the document generator, not the seller.
- Make totals visually prominent but never more prominent than the invoice’s actual issuer/recipient identity.
- Keep PDF generation entirely offline. Do not contact an external PDF, QR, font, payment, analytics, or image service.
- Use stable, deterministic generation wherever feasible so the same stored invoice produces materially equivalent content on repeated exports.

---

## 12.3 — NBS IPS QR for eligible Serbian RSD invoices

- For Serbian RSD invoices only, embed an NBS IPS QR code in the generated PDF.
- Build and encode the payment payload entirely locally. No network interaction is permitted.
- Obtain and cite the applicable official NBS IPS specification before implementation. Record the exact specification/version/source in `DECISIONS.md`; do not rely on memory, blog posts, or invented field behavior.
- Validate the payload against the official specification’s mandatory fields before generating a QR code.
- Implement a dedicated, small payload-builder/validator service behind a clear interface. Keep invoice UI, PDF rendering, QR encoding, and NBS payload rules separated so each can be tested independently.
- Unit-test account-format validation, amount formatting, payment-code validation, supported character set, required-field behavior, line/payload construction, invalid-input rejection, and any checksum/length constraints required by the official specification.
- Do not show or create an NBS IPS QR for invoices that are not eligible Serbian RSD invoices. A normal invoice PDF must still generate successfully.
- If a necessary specification detail is unclear, unavailable, or incompatible with the existing invoice model, stop that subpart, record the question in `OPEN_QUESTIONS.md`, and continue only with behavior that can be correct. Never invent a payment payload.

---

## 12.4 — Fonts, language quality, and accessibility

- Bundle one suitable, legally distributable font family with coverage for Cyrillic and every glyph needed by all nine supported app languages. Prefer a well-maintained, mainstream open font; document its license, version/source, expected asset impact, and selection rationale in `DECISIONS.md`.
- Do not assume coverage from a font family name. Explicitly test representative invoice text for en, sr, hr, bs, mk, sl, bg, sq, and ro, including Latin diacritics, Cyrillic, currencies, punctuation, and long text.
- Preserve readable font sizes, contrast, line height, and table spacing in generated PDFs. Do not shrink content to an unusable size merely to avoid page breaks.
- Use semantic labels and accessible text for all QR/export states in-app. PDF generation must be understandable without relying on visual QR recognition.
- Ensure error messages tell the user what to fix, not merely that an operation failed.

---

## Engineering and privacy rules

- Audit first; reuse existing invoice, design, localization, file, and share components wherever appropriate.
- Use only minimal mainstream dependencies. Every new dependency must be offline-capable, justified in `DECISIONS.md`, compatible with project platforms, and must not phone home.
- Keep invoice and payment data on-device unless the user explicitly invokes the system save/share/export action.
- Never add analytics, cloud storage, account creation, backend calls, payment initiation, or external font/PDF/QR services.
- Keep the implementation behind clean service boundaries so a later monetization decision could gate PDF export with minimal wiring. Do not add a paywall, price, trial, ad placement, upsell, or entitlement behavior now.
- Do not alter the financial calculation/tax-rules path as part of this work.
- Do not claim on-device, printer, bank-app scan, or payment-app interoperability that has not actually been tested.

---

## Required tests

### Functional and regression

- PDF-generation tests using representative existing invoice fixtures: one item, multiple items, long content, totals, all VAT configurations actually supported by the model, different currencies, paid/unpaid status where represented, and enough lines to exercise pagination.
- Tests proving existing invoice tracker CRUD, status changes, and persistence remain correct after any modified detail/export flow.
- Tests ensuring repeated PDF action attempts do not corrupt, duplicate, or mutate stored invoice data.
- Tests ensuring normal PDF generation works without NBS payment data and for non-Serbian/non-RSD invoices.

### NBS IPS

- Valid Serbian RSD payload fixtures sourced from the official NBS specification or official examples, with provenance documented.
- Invalid account, amount, payment-code, character-set, missing-required-field, and specification-required constraint cases.
- Eligibility tests proving QR generation is restricted to qualifying Serbian RSD invoices and is omitted from every other invoice PDF.
- Tests proving invalid QR data creates a helpful in-app validation state and never silently produces a guessed payload.

### Localization, documents, and accessibility

- Localization/font coverage checks for all nine languages, explicitly including Serbian, Macedonian, and Bulgarian Cyrillic plus relevant Latin diacritics.
- PDF-content/layout assertions appropriate to the chosen PDF library: required invoice data and totals must be present; no test may falsely claim visual/device/printer verification.
- Widget tests for visible action hierarchy, eligibility explanations, field-level validation, loading/error feedback, and semantic text for QR availability.

No test may assert a legal, payment, tax, or NBS-spec figure without a project-standard source.

---

## Quality gate before completion

Before reporting completion, explicitly verify and report:

- Whether the detail-screen action hierarchy is clear and limited.
- Whether normal invoices remain easy to create without Serbian payment data.
- Whether non-eligible users receive a clear explanation rather than a disabled or unexplained QR control.
- Whether the generated document identifies the invoice issuer—not the app—as the business party.
- Whether all nine locales have exact key parity.
- Whether any required official NBS detail remains open.
- Whether device/emulator, bank-app QR scanning, printer, and share-sheet behavior was actually verified; clearly distinguish automated, build, emulator, and physical-device verification.

---

## Completion report — then stop

Report exactly:

- **Implemented** — including the before/after invoice journey and any deliberately deferred UX recommendation outside this prompt’s scope
- **Tested** — `flutter test -j 1` command and actual passing count
- **Localization** — key count for each of the nine locales and parity result
- **Static analysis** — `flutter analyze` status
- **Build** — per-ABI size only if a release build was actually run
- **Dependencies and assets** — each added dependency/font, license/source, offline/privacy justification, and size impact if measured
- **NBS source** — official specification/version/source used and any deliberate constraints
- **Verification limits** — exact difference between automated, build, emulator, and physical-device verification
- **OPEN_QUESTIONS.md** additions
- **DECISIONS.md** entries
- **Commit hash and push status**
- **What’s next** — recommendations only; do not start Stage C item 13 (Cross-border pack) or unrelated cohesion work without approval

Then stop and await approval.
