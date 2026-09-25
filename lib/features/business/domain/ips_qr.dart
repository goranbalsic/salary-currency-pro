import '../../../core/money/money.dart';
import 'identifiers.dart';

enum IpsQrError {
  account,
  recipient,
  amount,
  paymentCode,
  payer,
  purpose,
  reference,
}

/// Builds the NBS IPS "PR" (payment request) QR payload, per the National
/// Bank of Serbia's IPS QR recommendations: `K:PR|V:01|C:1|R:…|N:…|I:RSD…`
/// followed by the optional P, SF, S and RO tags.
abstract final class IpsQr {
  static const _maxName = 70;
  static const _maxPurpose = 35;
  static const _maxReference = 25;

  /// Returns the payload, or the list of fields that make it invalid.
  static ({String? payload, List<IpsQrError> errors}) build({
    required String account,
    required String recipient,
    required double amountRsd,
    String paymentCode = '221',
    String? payer,
    String? purpose,
    String? reference,
  }) {
    final errors = <IpsQrError>[];

    final acct = Identifiers.normalizeSerbianAccount(account);
    if (acct == null || !Identifiers.isValidSerbianAccount(acct)) errors.add(IpsQrError.account);

    final name = _clean(recipient);
    if (name.isEmpty || name.length > _maxName || name.split('\n').length > 3) {
      errors.add(IpsQrError.recipient);
    }

    String? amountField;
    if (!amountRsd.isFinite || amountRsd <= 0 || amountRsd >= 1e12) {
      errors.add(IpsQrError.amount);
    } else {
      final minor = Money.toMinor(amountRsd);
      final major = minor ~/ 100;
      final cents = (minor % 100).toString().padLeft(2, '0');
      amountField = 'RSD$major,$cents';
    }

    final code = paymentCode.trim();
    if (!RegExp(r'^[12]\d{2}$').hasMatch(code)) errors.add(IpsQrError.paymentCode);

    final payerName = payer == null ? '' : _clean(payer);
    if (payerName.length > _maxName || payerName.split('\n').length > 3) errors.add(IpsQrError.payer);

    final purposeText = purpose == null ? '' : _clean(purpose).replaceAll('\n', ' ');
    if (purposeText.length > _maxPurpose) errors.add(IpsQrError.purpose);

    final ref = (reference ?? '').replaceAll(' ', '').trim();
    if (ref.isNotEmpty) {
      final shape = RegExp(r'^\d{2}[0-9-]*$');
      if (!shape.hasMatch(ref) || ref.length > _maxReference || (ref.startsWith('97') && ref.contains('-'))) {
        errors.add(IpsQrError.reference);
      }
    }

    if (errors.isNotEmpty) return (payload: null, errors: errors);

    final b = StringBuffer('K:PR|V:01|C:1|R:$acct|N:$name|I:$amountField');
    if (payerName.isNotEmpty) b.write('|P:$payerName');
    b.write('|SF:$code');
    if (purposeText.isNotEmpty) b.write('|S:$purposeText');
    if (ref.isNotEmpty) b.write('|RO:$ref');
    return (payload: b.toString(), errors: const <IpsQrError>[]);
  }

  /// Removes the field delimiter and trims every line.
  static String _clean(String s) => s.replaceAll('|', ' ').split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).join('\n');
}
