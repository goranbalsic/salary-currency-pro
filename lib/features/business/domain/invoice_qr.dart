import '../data/business_store.dart';
import 'invoice.dart';
import 'ips_qr.dart';

/// Joins up to three non-empty lines while the text fits [max] characters
/// (newlines count). The first line is always kept, shortened if needed.
String fitLines(Iterable<String> lines, {int max = 70}) {
  final clean = lines.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  if (clean.isEmpty) return '';
  var out = clean.first.length > max ? clean.first.substring(0, max).trimRight() : clean.first;
  var count = 1;
  for (final line in clean.skip(1)) {
    if (count == 3) break;
    if (out.length + 1 + line.length > max) break;
    out = '$out\n$line';
    count++;
  }
  return out;
}

/// The NBS IPS payment-request QR for a dinar invoice, or null when the
/// invoice is not in dinars (IPS carries RSD only).
({String? payload, List<IpsQrError> errors})? invoiceIpsQr(Invoice inv, BusinessProfile p, {required String purposeLabel}) {
  if (inv.currency != 'RSD') return null;
  final purpose = '$purposeLabel ${inv.number}'.trim();
  return IpsQr.build(
    account: p.bankAccount,
    recipient: fitLines([p.party.name, p.party.address, p.party.city]),
    amountRsd: inv.total,
    paymentCode: p.paymentCode,
    payer: fitLines([inv.client.name, inv.client.address, inv.client.city]),
    purpose: purpose.length > 35 ? purpose.substring(0, 35).trimRight() : purpose,
    reference: inv.reference,
  );
}
