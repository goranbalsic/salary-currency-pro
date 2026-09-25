# Ideas Backlog

Ideas that have *not* been committed to — distinct from actual planned
work. Each idea here was raised (by the user's supplied prompts or found
during implementation) and deliberately deferred, not silently dropped.

## High-Potential Ideas

### IDEA-001: Recurring transaction support

Date added: 2026-08-07
Source: PROMPT-002 Phase 2 ("recurring transaction support or a clearly
prepared architecture for it").
Problem it may solve: users with regular rent/subscriptions/salary
currently have to re-enter the same transaction every month.
Proposed solution: a `RecurrenceRule` (frequency, next-due date) attached
to an `ExpenseEntry` template; on app open (or on visiting the tracker),
generate any due occurrences.
Expected benefit: real time savings for the most common use case.
Potential risks: "next-due generation" logic needs careful design (what
happens if the app isn't opened for 3 months — backfill 3 entries, or
just the most recent?); editing/skipping a single occurrence vs. the whole
series adds real complexity.
Dependencies: none beyond `ExpenseService`.
Alternatives: leave it manual (current state); a lighter "quick re-add
last transaction" shortcut instead of full recurrence.
Priority: High.
Status: Deferred.
Reason for current status: judged as needing its own dedicated design
pass (the "what happens if you don't open the app" question needs a real
answer, not a rushed one) rather than a rushed half-feature bolted onto
Phase 2.

### IDEA-002: Custom (user-defined) categories

Date added: 2026-08-07
Source: PROMPT-002 Phase 2.
Problem it may solve: the fixed category lists (8 expense, 3 income) don't
cover every household/business's real spending categories.
Proposed solution: allow adding a custom category (name + icon), stored
alongside the built-in `ExpenseCategories` ids.
Expected benefit: better categorization accuracy → better budgets/
insights.
Potential risks: custom categories need their own localized-label
fallback (can't rely on the 9-language `catX` key set); interacts with
category budgets (Phase 4) and the category breakdown card.
Dependencies: `ExpenseCategories`, `l10n_lookups.dart`.
Alternatives: keep the fixed list, add more built-in categories instead.
Priority: Medium.
Status: Deferred.
Reason for current status: the fixed list has covered every scenario
exercised so far; revisit if real usage shows it's genuinely limiting.

## Possible Ideas

### IDEA-003: Merchant/source field and tags on transactions

Date added: 2026-08-07
Source: PROMPT-002 Phase 2 ("optional merchant or source field," "optional
tags").
Problem it may solve: finer-grained search/reporting than category alone.
Proposed solution: add optional `merchant` and `tags: List<String>` fields
to `ExpenseEntry`, surfaced in search.
Expected benefit: modest — the existing note field already covers
free-text search reasonably well.
Potential risks: UI clutter in the already-multi-field add-transaction
sheet if not designed carefully.
Dependencies: `ExpenseEntry` schema (has `schemaVersion` for this).
Alternatives: encourage using the existing `note` field for this.
Priority: Low.
Status: Deferred.

### IDEA-004: Duplicate-transaction detection

Date added: 2026-08-07
Source: PROMPT-002 Phase 2 ("duplicate prevention where relevant").
Problem it may solve: accidentally adding the same transaction twice.
Proposed solution: warn (not block) when a new entry matches an existing
one's amount+category+date closely.
Expected benefit: low-moderate — a real but infrequent annoyance.
Potential risks: false positives (two genuinely separate ~identical
purchases) annoying users if the warning is too aggressive.
Dependencies: `ExpenseService.add()`.
Alternatives: none needed — the undo-after-delete flow already makes
mistakes cheap to fix.
Priority: Low.
Status: Deferred.

## Deferred Ideas

### IDEA-005: Full offline business mode (team workspaces, roles, accountant reports)

Date added: 2026-08-07
Source: PROMPT-001 §9 (Business mode), PROMPT-002 Phase 9.
Problem it may solve: PROMPT-001/002's full business-mode ask beyond what
the invoice-tracker MVP covers — personal/business workspace switching,
business profile, revenue/expense/profit reporting distinct from the
personal expense tracker, monthly business reports formatted for sharing
with an accountant.
Proposed solution: a `Workspace` concept (personal vs. one-or-more
business profiles) that scopes `ExpenseService`/`InvoiceService` data;
a dedicated business P&L report screen.
Expected benefit: real value for freelancers/small businesses who
currently have to mentally separate personal and business transactions
within the same single ledger.
Potential risks: meaningfully larger than the invoice-tracker MVP — new
data-scoping concept touching every existing service; needs its own
design pass, not a quick addition.
Dependencies: `ExpenseService`, `InvoiceService`, `BudgetService` would
all need workspace-scoping.
Alternatives: a manual "business" category/tag on transactions (cheaper,
less structurally sound).
Priority: Medium-High (once the offline-completion phases finish).
Status: Deferred — explicitly out of Phase 9's MVP scope this session
(see `DECISIONS.md` D-001).

### IDEA-006: Full online/backend features (per PROMPT-001 and PROMPT-002 Phase 12)

Date added: 2026-08-06 (first raised), reconfirmed 2026-08-07
Source: PROMPT-001 (throughout), PROMPT-002 Phase 12.
Problem it may solve: multi-device sync, team collaboration, invoice
sending/sync, bank integration, live economic-data feeds.
Proposed solution: see PROMPT-002 Phase 12's explicit report requirements
(sync-readiness, stable IDs, source of truth, conflict resolution, auth,
workspace model, cost/complexity per feature).
Expected benefit: large, but requires ongoing infrastructure cost/
complexity the user hasn't committed to.
Potential risks: real backend infrastructure is a major, costly, largely
irreversible commitment (hosting bills, auth provider, database, ongoing
security surface) — explicitly flagged to the user via AskUserQuestion
this session; the user chose to stay offline-first.
Dependencies: everything — this is the largest item in the backlog.
Alternatives: none; this is the eventual destination, not an alternative.
Priority: Blocked until Phase 12's report is written and approved.
Status: Deferred (explicit user decision, not a default).
Reason for current status: user directly confirmed "stay offline-first
for now" when asked; PROMPT-002 makes this an explicit phased gate.

## Rejected Ideas

_None yet — nothing has been formally rejected outright; everything above
is deferred with a path back, not closed off._

## Idea Template

### IDEA-NNN: Title

Date added:
Source:
Problem it may solve:
Proposed solution:
Expected benefit:
Potential risks:
Dependencies:
Alternatives:
Priority:
Status:
Reason for current status:
