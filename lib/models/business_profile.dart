/// The invoice issuer's identity, used on generated PDFs and, for
/// eligible Serbian RSD invoices, the NBS IPS QR payload. This app is a
/// single-user offline tool, so there is exactly one business profile
/// per install rather than a per-invoice record (same philosophy as
/// [Invoice] itself — see that model's own doc comment).
class BusinessProfile {
  final String businessName;
  final String addressLine1;
  final String addressLine2;

  /// NBS IPS "R" tag source. Serbia-only in meaning; harmless to leave
  /// blank for users who never generate a QR-eligible invoice.
  final String bankAccountNumber;

  /// NBS IPS "SF" tag source (3-digit payment code). A freelancer
  /// typically uses the same code for every invoice, so this is
  /// issuer-level data, not per-invoice.
  final String defaultPaymentCode;

  const BusinessProfile({
    this.businessName = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.bankAccountNumber = '',
    this.defaultPaymentCode = '',
  });

  bool get isEmpty =>
      businessName.isEmpty &&
      addressLine1.isEmpty &&
      addressLine2.isEmpty &&
      bankAccountNumber.isEmpty &&
      defaultPaymentCode.isEmpty;

  BusinessProfile copyWith({
    String? businessName,
    String? addressLine1,
    String? addressLine2,
    String? bankAccountNumber,
    String? defaultPaymentCode,
  }) =>
      BusinessProfile(
        businessName: businessName ?? this.businessName,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
        defaultPaymentCode: defaultPaymentCode ?? this.defaultPaymentCode,
      );

  Map<String, dynamic> toJson() => {
        'businessName': businessName,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'bankAccountNumber': bankAccountNumber,
        'defaultPaymentCode': defaultPaymentCode,
      };

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => BusinessProfile(
        businessName: json['businessName'] as String? ?? '',
        addressLine1: json['addressLine1'] as String? ?? '',
        addressLine2: json['addressLine2'] as String? ?? '',
        bankAccountNumber: json['bankAccountNumber'] as String? ?? '',
        defaultPaymentCode: json['defaultPaymentCode'] as String? ?? '',
      );
}
