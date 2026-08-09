/// Play Billing product identifiers. Every value here is a placeholder —
/// **before publishing to the Play Store**, create the real products in
/// Play Console with these exact IDs. Shipping the placeholders is safe
/// (no real product exists yet, so no real subscription purchases can
/// occur) but means no real revenue until they're created.
///
/// No ad SDK identifiers live here — the app removed the dormant Google
/// Mobile Ads/UMP dependency entirely (see DECISIONS.md; "no ads at
/// launch" is final, and re-adding ads later needs a fresh, explicit
/// product/privacy implementation, not just re-enabling old code).
class MonetizationConfig {
  MonetizationConfig._();

  /// TODO: create this as a real subscription product in Play Console
  /// before release — this ID must match exactly.
  static const String proMonthlySubscriptionId = 'pro_monthly';

  /// PROMPT-003F Stage D go-ahead's four-product lineup. Every id below is
  /// a placeholder the same way [proMonthlySubscriptionId] is — none of
  /// these has been created in Play Console yet. See DECISIONS.md for the
  /// final pricing table (monthly $3.99, annual $19.99 w/ 7-day trial,
  /// lifetime $49.99, support $2.99) — pricing itself is configured in Play
  /// Console, not in this app.
  ///
  /// TODO: create as a real annual subscription product (with a 7-day free
  /// trial configured on it) in Play Console before release.
  static const String proAnnualSubscriptionId = 'pro_annual';

  /// TODO: create as a real one-time (non-consumable) product in Play
  /// Console before release.
  static const String proLifetimePurchaseId = 'pro_lifetime';

  /// A non-gating, one-time "support the developer" purchase — never checked
  /// by any Pro feature gate. TODO: create as a real one-time (non-
  /// consumable) product in Play Console before release.
  static const String supportDeveloperPurchaseId = 'support_developer';

  /// The full Stage D product lineup, for a single `queryProductDetails`
  /// call. [proMonthlySubscriptionId] is deliberately included — Decision 2
  /// keeps a monthly plan alongside annual/lifetime/support, it's simply
  /// no longer this app's only product.
  static const Set<String> entitlementProductIds = {
    proMonthlySubscriptionId,
    proAnnualSubscriptionId,
    proLifetimePurchaseId,
    supportDeveloperPurchaseId,
  };

  /// Reference USD prices from PROMPT-003I's Decision 2 — the app's own
  /// already-decided pricing, not a guess. [PaywallScreen] shows these as a
  /// fallback whenever a real `ProductDetails.price` isn't available (i.e.
  /// always, until the products above actually exist in Play Console),
  /// clearly labeled as reference/indicative rather than a live confirmed
  /// price — Play's regional PPP auto-pricing template will set the real
  /// per-market price, which these numbers deliberately don't try to
  /// predict. Never used to process an actual purchase; `buy()` always
  /// requires a real `ProductDetails` from the store.
  static const double monthlyReferenceUsd = 3.99;
  static const double annualReferenceUsd = 19.99;
  static const double lifetimeReferenceUsd = 49.99;
  static const double supportReferenceUsd = 2.99;
}
