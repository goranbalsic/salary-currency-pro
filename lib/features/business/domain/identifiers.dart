/// Checksum validation for Serbian business identifiers and IBANs, so a
/// typo is caught before it lands on an invoice or in a payment QR code.
abstract final class Identifiers {
  static String digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  /// Serbian tax ID (PIB): 9 digits, ISO 7064 MOD 11,10 check digit.
  static bool isValidPib(String input) {
    final s = input.trim();
    if (!RegExp(r'^\d{9}$').hasMatch(s)) return false;
    var p = 10;
    for (var i = 0; i < 8; i++) {
      var t = (p + int.parse(s[i])) % 10;
      if (t == 0) t = 10;
      p = (t * 2) % 11;
    }
    final check = (11 - p) % 10;
    return check == int.parse(s[8]);
  }

  /// Serbian company registration number (matični broj): 8 digits,
  /// weights 8..2, mod 11.
  static bool isValidMaticniBroj(String input) {
    final s = input.trim();
    if (!RegExp(r'^\d{8}$').hasMatch(s)) return false;
    var sum = 0;
    for (var i = 0; i < 7; i++) {
      sum += int.parse(s[i]) * (8 - i);
    }
    final r = sum % 11;
    // Remainders 0 and 1 both map to a check digit of 0.
    final check = r <= 1 ? 0 : 11 - r;
    return check == int.parse(s[7]);
  }

  /// Normalizes a Serbian account number to its 18-digit form: bank code
  /// (3) + account (13, zero-padded) + control (2). Accepts `160-5020001234-64`
  /// or 18 digits. Returns null when the shape is wrong.
  static String? normalizeSerbianAccount(String input) {
    final s = input.trim().replaceAll(' ', '');
    if (RegExp(r'^\d{18}$').hasMatch(s)) return s;
    final m = RegExp(r'^(\d{3})-(\d{1,13})-(\d{2})$').firstMatch(s);
    if (m == null) return null;
    return '${m[1]}${m[2]!.padLeft(13, '0')}${m[3]}';
  }

  /// Formats an 18-digit Serbian account as `bank-account-control`, without
  /// leading zeros in the middle part.
  static String formatSerbianAccount(String digits18) {
    if (digits18.length != 18) return digits18;
    final middle = digits18.substring(3, 16).replaceFirst(RegExp(r'^0+(?=\d)'), '');
    return '${digits18.substring(0, 3)}-$middle-${digits18.substring(16)}';
  }

  /// ISO 7064 MOD 97-10 check on a Serbian account number.
  static bool isValidSerbianAccount(String input) {
    final n = normalizeSerbianAccount(input);
    if (n == null) return false;
    final base = BigInt.parse(n.substring(0, 16));
    final control = int.parse(n.substring(16));
    final expected = 98 - (base * BigInt.from(100) % BigInt.from(97)).toInt();
    return control == expected;
  }

  /// ISO 13616 IBAN check (any country).
  static bool isValidIban(String input) {
    final s = input.replaceAll(' ', '').toUpperCase();
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{10,30}$').hasMatch(s)) return false;
    final rearranged = s.substring(4) + s.substring(0, 4);
    final buffer = StringBuffer();
    for (final c in rearranged.codeUnits) {
      if (c >= 65 && c <= 90) {
        buffer.write(c - 55);
      } else {
        buffer.writeCharCode(c);
      }
    }
    return BigInt.parse(buffer.toString()) % BigInt.from(97) == BigInt.one;
  }

  /// Builds an IBAN from a country code and a domestic account (BBAN),
  /// computing the check digits. For a valid Serbian account this is
  /// always `RS35…`.
  static String ibanFrom(String country, String bban) {
    final cc = country.toUpperCase();
    final digits = StringBuffer();
    for (final c in '$bban${cc}00'.codeUnits) {
      if (c >= 65 && c <= 90) {
        digits.write(c - 55);
      } else {
        digits.writeCharCode(c);
      }
    }
    final check = 98 - (BigInt.parse(digits.toString()) % BigInt.from(97)).toInt();
    return '$cc${check.toString().padLeft(2, '0')}$bban';
  }

  /// SWIFT/BIC: 4 bank letters, 2 country letters, 2 location characters
  /// and an optional 3-character branch code.
  static bool isValidBic(String input) => RegExp(r'^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$').hasMatch(input.replaceAll(' ', '').toUpperCase());

  /// Groups an IBAN in blocks of four for display.
  static String formatIban(String input) {
    final s = input.replaceAll(' ', '').toUpperCase();
    final parts = <String>[];
    for (var i = 0; i < s.length; i += 4) {
      parts.add(s.substring(i, i + 4 > s.length ? s.length : i + 4));
    }
    return parts.join(' ');
  }
}
