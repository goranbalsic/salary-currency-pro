/// Builds and validates an NBS IPS QR payload string (PROMPT-003 Stage C
/// item 12.3). Pure, synchronous, offline — no I/O, never invents a field
/// or a payload when required data is missing/invalid.
///
/// Source: NBS "Preporuke" (Recommendations) PDF, © 2020 Narodna banka
/// Srbije, https://ips.nbs.rs/PDF/pdfPreporukeValidacijaLat.pdf — see
/// `DECISIONS.md` for the exact field rules cited from that document.
///
/// Deliberate, documented simplifications (see `OPEN_QUESTIONS.md`
/// QUESTION-009 — none of these block a correct, honest implementation,
/// they only bound its scope):
/// - The full NBS Annex 3 payment-code list isn't independently sourced;
///   "SF" is validated for format only (exactly 3 digits), not against an
///   exhaustive official code list.
/// - The "RO" tag's model-97 reference-number checksum is never computed
///   or verified — only its documented format/length rules are.
/// - The "N"/"P"/"S" tags' official special-character table couldn't be
///   reliably extracted from the source PDF (the extraction garbled the
///   table's column order); rather than risk encoding a wrong character
///   whitelist, this builder enforces length/line-count limits and
///   rejects the `|` field delimiter (which would corrupt the payload
///   structure if left unescaped) instead of an exact charset whitelist.
library;

import '../utils/money.dart';

enum NbsIpsFieldError {
  accountMissing,
  accountInvalid,
  recipientNameMissing,
  recipientNameTooLong,
  recipientNameTooManyLines,
  recipientNameInvalidCharacter,
  amountInvalid,
  amountOutOfRange,
  paymentCodeMissing,
  paymentCodeInvalid,
  payerNameTooLong,
  payerNameInvalidCharacter,
  purposeTooLong,
  purposeMultiline,
  purposeInvalidCharacter,
  paymentReferenceInvalidFormat,
  paymentReferenceTooLong,
}

class NbsIpsInput {
  /// Either the fixed 18-digit form or the common
  /// `bankCode-accountNumber-controlNumber` display format (e.g.
  /// `840-955845-10`) — see [NbsIpsPayloadBuilder.normalizeAccountNumber].
  final String accountNumber;

  /// May already contain up to 3 lines joined by `\n` (name + address).
  final String recipientName;

  final double amountRsd;

  /// Exactly 3 digits, per NBS Annex 3.
  final String paymentCode;

  final String? payerName;
  final String? purpose;
  final String? paymentReference;

  const NbsIpsInput({
    required this.accountNumber,
    required this.recipientName,
    required this.amountRsd,
    required this.paymentCode,
    this.payerName,
    this.purpose,
    this.paymentReference,
  });
}

class NbsIpsPayloadResult {
  final String? payload;
  final List<NbsIpsFieldError> errors;

  const NbsIpsPayloadResult._({this.payload, this.errors = const []});

  factory NbsIpsPayloadResult.success(String payload) =>
      NbsIpsPayloadResult._(payload: payload);

  factory NbsIpsPayloadResult.failure(List<NbsIpsFieldError> errors) =>
      NbsIpsPayloadResult._(errors: errors);

  bool get isValid => payload != null;
}

class NbsIpsPayloadBuilder {
  static const _maxNameLength = 70;
  static const _maxNameLines = 3;
  static const _maxPurposeLength = 35;
  static const _maxReferenceLength = 25;
  static final _accountDigits = RegExp(r'^\d{18}$');
  static final _accountParts = RegExp(r'^\d{3}-\d{1,13}-\d{2}$');
  static final _paymentCode = RegExp(r'^\d{3}$');
  static final _referenceShape = RegExp(r'^\d{2}[\d-]*$');

  static NbsIpsPayloadResult build(NbsIpsInput input) {
    final errors = <NbsIpsFieldError>[];

    final account = normalizeAccountNumber(input.accountNumber);
    if (input.accountNumber.trim().isEmpty) {
      errors.add(NbsIpsFieldError.accountMissing);
    } else if (account == null) {
      errors.add(NbsIpsFieldError.accountInvalid);
    }

    final recipientName = input.recipientName.trim();
    if (recipientName.isEmpty) {
      errors.add(NbsIpsFieldError.recipientNameMissing);
    } else {
      if (recipientName.contains('|')) errors.add(NbsIpsFieldError.recipientNameInvalidCharacter);
      if (recipientName.length > _maxNameLength) errors.add(NbsIpsFieldError.recipientNameTooLong);
      if (recipientName.split('\n').length > _maxNameLines) {
        errors.add(NbsIpsFieldError.recipientNameTooManyLines);
      }
    }

    String? amountField;
    if (input.amountRsd.isNaN || input.amountRsd.isInfinite || input.amountRsd <= 0) {
      errors.add(NbsIpsFieldError.amountInvalid);
    } else {
      final minorUnits = roundToMinorUnits(input.amountRsd);
      amountField = 'RSD${formatMinorUnits(minorUnits, decimalSeparator: ',')}';
      if (amountField.length < 5 || amountField.length > 18) {
        errors.add(NbsIpsFieldError.amountOutOfRange);
      }
    }

    final paymentCode = input.paymentCode.trim();
    if (paymentCode.isEmpty) {
      errors.add(NbsIpsFieldError.paymentCodeMissing);
    } else if (!_paymentCode.hasMatch(paymentCode)) {
      errors.add(NbsIpsFieldError.paymentCodeInvalid);
    }

    final payerName = input.payerName?.trim();
    if (payerName != null && payerName.isNotEmpty) {
      if (payerName.contains('|')) errors.add(NbsIpsFieldError.payerNameInvalidCharacter);
      if (payerName.length > _maxNameLength) errors.add(NbsIpsFieldError.payerNameTooLong);
    }

    final purpose = input.purpose?.trim();
    if (purpose != null && purpose.isNotEmpty) {
      if (purpose.contains('|')) errors.add(NbsIpsFieldError.purposeInvalidCharacter);
      if (purpose.contains('\n')) errors.add(NbsIpsFieldError.purposeMultiline);
      if (purpose.length > _maxPurposeLength) errors.add(NbsIpsFieldError.purposeTooLong);
    }

    final reference = input.paymentReference?.trim();
    if (reference != null && reference.isNotEmpty) {
      if (!_referenceShape.hasMatch(reference)) {
        errors.add(NbsIpsFieldError.paymentReferenceInvalidFormat);
      } else if (reference.startsWith('97') && reference.contains('-')) {
        // Model 97's own check-digit rules don't allow a dash separator.
        errors.add(NbsIpsFieldError.paymentReferenceInvalidFormat);
      } else if (reference.length > _maxReferenceLength) {
        errors.add(NbsIpsFieldError.paymentReferenceTooLong);
      }
    }

    if (errors.isNotEmpty) return NbsIpsPayloadResult.failure(errors);

    final buffer = StringBuffer()
      ..write('K:PR|V:01|C:1|')
      ..write('R:$account|')
      ..write('N:$recipientName|')
      ..write('I:$amountField');
    if (payerName != null && payerName.isNotEmpty) {
      buffer.write('|P:$payerName');
    }
    buffer.write('|SF:$paymentCode');
    if (purpose != null && purpose.isNotEmpty) {
      buffer.write('|S:$purpose');
    }
    if (reference != null && reference.isNotEmpty) {
      buffer.write('|RO:$reference');
    }

    return NbsIpsPayloadResult.success(buffer.toString());
  }

  /// Converts the common Serbian bank-account display format
  /// (`bankCode-accountNumber-controlNumber`, e.g. `840-955845-10` or
  /// `310-1234567891211-86`) into the fixed 18-digit form the "R" tag
  /// requires (bank code + account number zero-padded to 13 digits +
  /// control number) — the exact transformation demonstrated by the
  /// source document's own worked examples. Also accepts an already-
  /// 18-digit string unchanged. Returns `null` for anything else; never
  /// guesses a padding/format.
  static String? normalizeAccountNumber(String raw) {
    final trimmed = raw.trim();
    if (_accountDigits.hasMatch(trimmed)) return trimmed;
    if (!_accountParts.hasMatch(trimmed)) return null;

    final parts = trimmed.split('-');
    final bank = parts[0];
    final account = parts[1];
    final control = parts[2];
    return '$bank${account.padLeft(13, '0')}$control';
  }
}
