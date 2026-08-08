import '../models/business_profile.dart';
import '../models/invoice.dart';
import 'nbs_ips_payload_builder.dart';

/// Whether/why an invoice can show an NBS IPS QR code on its PDF
/// (PROMPT-003 Stage C item 12.3).
///
/// Operational definition of "Serbian RSD invoice" for this app: the
/// invoice's currency is RSD. [Invoice] has no separate country field,
/// and RSD is specifically Serbia's currency, so this is the honest,
/// non-inventing reading of "Serbian RSD invoice" given what the model
/// actually tracks — see `DECISIONS.md`.
enum NbsIpsEligibilityReason {
  /// Not RSD — most invoices; not an error, just not applicable. Per the
  /// product standard, non-RSD invoices show no QR messaging at all
  /// rather than a "you're missing something" implication.
  notRsd,

  /// RSD, but required payment data (issuer bank account/payment code,
  /// business name, or a valid amount) is missing or invalid.
  missingOrInvalidData,

  /// RSD and every required field validates — a QR code will be embedded.
  eligible,
}

class NbsIpsEligibility {
  final NbsIpsEligibilityReason reason;
  final List<NbsIpsFieldError> fieldErrors;
  final String? payload;

  const NbsIpsEligibility._({
    required this.reason,
    this.fieldErrors = const [],
    this.payload,
  });

  bool get isEligible => reason == NbsIpsEligibilityReason.eligible;

  static NbsIpsEligibility evaluate(Invoice invoice, BusinessProfile profile) {
    if (invoice.currencyCode != 'RSD') {
      return const NbsIpsEligibility._(reason: NbsIpsEligibilityReason.notRsd);
    }

    final result = NbsIpsPayloadBuilder.build(NbsIpsInput(
      accountNumber: profile.bankAccountNumber,
      recipientName: profile.businessName,
      amountRsd: invoice.amount,
      paymentCode: profile.defaultPaymentCode,
      payerName: invoice.clientName,
      purpose: invoice.purpose,
      paymentReference: invoice.paymentReference,
    ));

    if (!result.isValid) {
      return NbsIpsEligibility._(
        reason: NbsIpsEligibilityReason.missingOrInvalidData,
        fieldErrors: result.errors,
      );
    }

    return NbsIpsEligibility._(
      reason: NbsIpsEligibilityReason.eligible,
      payload: result.payload,
    );
  }
}
