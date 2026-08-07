import 'package:flutter_test/flutter_test.dart';
import 'package:salary_currency_pro/services/quote_service.dart';

const _expectedLocales = ['en', 'sr', 'hr', 'bs', 'mk', 'sl', 'bg', 'sq', 'ro'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final service = QuoteService();

  test('loads the bundled quote pack with every language present per quote',
      () async {
    final quotes = await service.loadAll();
    expect(quotes, isNotEmpty);
    for (final quote in quotes) {
      expect(quote.id, isNotEmpty);
      expect(quote.author, isNotEmpty);
      for (final locale in _expectedLocales) {
        expect(
          quote.text[locale],
          isNotNull,
          reason: '${quote.id} is missing a "$locale" translation',
        );
        expect(
          quote.text[locale]!.trim(),
          isNotEmpty,
          reason: '${quote.id} has an empty "$locale" translation',
        );
      }
    }
  });

  test('quoteOfTheDay is deterministic for a given date', () async {
    final quotes = await service.loadAll();
    final date = DateTime(2026, 3, 15);
    final a = service.quoteOfTheDay(quotes, now: date);
    final b = service.quoteOfTheDay(quotes, now: date);
    expect(a.id, b.id);
  });

  test('quoteOfTheDay rotates across different days', () async {
    final quotes = await service.loadAll();
    final seenIds = <String>{};
    for (var day = 0; day < quotes.length; day++) {
      final quote = service.quoteOfTheDay(
        quotes,
        now: DateTime(2026, 1, 1).add(Duration(days: day)),
      );
      seenIds.add(quote.id);
    }
    // Every quote in the pack should show up at least once across a full
    // rotation the length of the pack.
    expect(seenIds.length, quotes.length);
  });

  test('textFor falls back to English for an unknown locale', () async {
    final quotes = await service.loadAll();
    final quote = quotes.first;
    expect(quote.textFor('xx'), quote.text['en']);
  });
}
