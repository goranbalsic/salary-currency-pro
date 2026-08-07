/// A short, attributed finance/money quote bundled offline (no backend, no
/// API key) with translations for every supported app language, keyed by
/// locale code (see Country.localeCode).
class FinanceQuote {
  final String id;
  final String author;
  final Map<String, String> text;

  const FinanceQuote({
    required this.id,
    required this.author,
    required this.text,
  });

  String textFor(String localeCode) => text[localeCode] ?? text['en'] ?? '';

  factory FinanceQuote.fromJson(Map<String, dynamic> json) => FinanceQuote(
        id: json['id'] as String,
        author: json['author'] as String,
        text: (json['text'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as String),
        ),
      );
}
