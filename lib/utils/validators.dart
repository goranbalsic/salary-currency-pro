/// Shared numeric input validation so every screen rejects negative numbers,
/// flags implausible values as likely typos, and never crashes on empty
/// or malformed input.
library;

enum AmountIssue { empty, invalid, negative, zeroNotAllowed, tooLarge }

class AmountParseResult {
  final double? value;
  final AmountIssue? issue;

  const AmountParseResult({this.value, this.issue});

  bool get isValid => issue == null && value != null;
}

/// Parses a free-text amount field.
///
/// [max] is the sane upper bound for this field (e.g. a monthly salary
/// shouldn't be in the billions) — values above it are flagged as likely
/// typos rather than silently computed with.
AmountParseResult parseAmountInput(
  String? raw, {
  double max = 100000000,
  bool allowZero = true,
}) {
  if (raw == null || raw.trim().isEmpty) {
    return const AmountParseResult(issue: AmountIssue.empty);
  }

  final normalized = raw.trim().replaceAll(',', '.');
  final value = double.tryParse(normalized);
  if (value == null || value.isNaN || value.isInfinite) {
    return const AmountParseResult(issue: AmountIssue.invalid);
  }
  if (value < 0) {
    return AmountParseResult(value: value, issue: AmountIssue.negative);
  }
  if (!allowZero && value == 0) {
    return AmountParseResult(value: value, issue: AmountIssue.zeroNotAllowed);
  }
  if (value > max) {
    return AmountParseResult(value: value, issue: AmountIssue.tooLarge);
  }
  return AmountParseResult(value: value);
}
