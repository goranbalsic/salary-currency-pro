import '../data/business_store.dart';
import 'identifiers.dart';
import 'invoice.dart';

/// The payment block an invoice prints: a domestic account for dinar
/// invoices, an IBAN and SWIFT code for foreign-currency ones.
class PaymentDetails {
  const PaymentDetails({this.account, this.iban, this.swift, this.bank, this.reference});

  final String? account;
  final String? iban;
  final String? swift;
  final String? bank;
  final String? reference;

  bool get isEmpty => account == null && iban == null;

  static String? _nonEmpty(String s) => s.trim().isEmpty ? null : s.trim();

  static bool _looksLikeIban(String s) => RegExp(r'^[A-Za-z]{2}\d{2}').hasMatch(s.trim());

  factory PaymentDetails.of(BusinessProfile p, Invoice invoice) {
    final raw = p.bankAccount.trim();
    final rawIsIban = raw.isNotEmpty && _looksLikeIban(raw);
    final serbian18 = rawIsIban ? null : Identifiers.normalizeSerbianAccount(raw);
    final serbianValid = serbian18 != null && Identifiers.isValidSerbianAccount(serbian18);
    final reference = _nonEmpty(invoice.reference);
    final bank = _nonEmpty(p.bankName);
    final swift = _nonEmpty(p.swift.toUpperCase());

    if (invoice.currency == 'RSD') {
      return PaymentDetails(
        account: rawIsIban ? null : _nonEmpty(raw),
        iban: rawIsIban ? Identifiers.formatIban(raw) : null,
        bank: bank,
        reference: reference,
      );
    }
    // Foreign currency: the dedicated IBAN, else the main account when it
    // is already an IBAN, else the IBAN form of a Serbian account.
    String? iban = _nonEmpty(p.iban);
    if (iban == null && rawIsIban) iban = raw;
    if (iban == null && serbianValid) iban = Identifiers.ibanFrom('RS', serbian18);
    return PaymentDetails(
      account: iban == null ? _nonEmpty(raw) : null,
      iban: iban == null ? null : Identifiers.formatIban(iban),
      swift: swift,
      bank: bank,
      reference: reference,
    );
  }
}
