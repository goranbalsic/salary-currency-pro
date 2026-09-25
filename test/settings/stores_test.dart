import 'dart:convert';

import 'package:bilans/core/storage/store.dart';
import 'package:bilans/features/business/data/business_store.dart';
import 'package:bilans/features/business/domain/invoice.dart';
import 'package:bilans/features/history/history_store.dart';
import 'package:bilans/features/settings/data/backup.dart';
import 'package:bilans/features/settings/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Invoice inv(String id, {InvoiceStatus status = InvoiceStatus.issued, String currency = 'RSD', double? rate, String client = 'Client'}) => Invoice(
  id: id,
  number: '$id/2026',
  status: status,
  issueDate: DateTime(2026, 5, 1),
  serviceDate: DateTime(2026, 5, 1),
  dueDate: DateTime(2026, 5, 16),
  place: '',
  client: InvoiceParty(name: client),
  currency: currency,
  items: const [InvoiceItem(description: 'Work', unitPrice: 1000)],
  vatRegistered: false,
  rsdRate: rate,
  createdAt: DateTime(2026, 5, 1),
);

void main() {
  late Store store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = await Store.open();
  });

  group('Store', () {
    test('unreadable JSON reads as missing', () async {
      await store.setString('x', '{broken');
      expect(store.readJson('x'), isNull);
    });

    test('export only includes app keys', () async {
      SharedPreferences.setMockInitialValues({'other.key': 1, 'bilans.mine': 'v'});
      final s = await Store.open();
      expect(s.exportAll(), {'mine': 'v'});
    });
  });

  group('BusinessStore', () {
    test('the free quota counts creations, not current invoices', () async {
      final b = BusinessStore(store);
      await b.upsertInvoice(inv('1'));
      await b.upsertInvoice(inv('2'));
      await b.upsertInvoice(inv('1', status: InvoiceStatus.paid));
      expect(b.createdCount, 2);
      await b.deleteInvoice('1');
      expect(b.invoices.length, 1);
      expect(b.createdCount, 2);
      expect(BusinessStore(store).createdCount, 2, reason: 'persisted');
    });

    test('revenue counts issued and paid invoices, flags missing rates', () async {
      final b = BusinessStore(store);
      await b.upsertInvoice(inv('1'));
      await b.upsertInvoice(inv('2', status: InvoiceStatus.draft));
      await b.upsertInvoice(inv('3', status: InvoiceStatus.cancelled));
      await b.upsertInvoice(inv('4', currency: 'EUR'));
      await b.upsertInvoice(inv('5', currency: 'EUR', rate: 117));
      await b.addManual(DateTime(2026, 6, 1), 500, 'cash');
      final r = b.revenue();
      expect(r.missingRate, 1);
      expect(r.entries.map((e) => e.amountRsd).toList()..sort(), [500, 1000, 117000]);
    });

    test('recent clients are distinct, newest first', () async {
      final b = BusinessStore(store);
      await b.upsertInvoice(inv('1', client: 'Alpha'));
      await b.upsertInvoice(inv('2', client: 'alpha '));
      await b.upsertInvoice(inv('3', client: 'Beta'));
      expect(b.recentClients.map((c) => c.name.trim().toLowerCase()).toSet(), {'alpha', 'beta'});
      expect(b.recentClients.length, 2);
    });

    test('profile round trip with defaults for missing fields', () async {
      final b = BusinessStore(store);
      await b.saveProfile(
        const BusinessProfile(
          party: InvoiceParty(name: 'Studio'),
          iban: 'RS35160000502000123464',
          swift: 'AIKBRS22',
        ),
      );
      final p = BusinessStore(store).profile;
      expect(p.party.name, 'Studio');
      expect(p.iban, 'RS35160000502000123464');
      expect(p.paymentCode, '221');
      expect(p.defaultDueDays, 15);
      expect(BusinessProfile.fromJson({'due': 9999}).defaultDueDays, 365);
    });
  });

  group('HistoryStore', () {
    test('identical recents move to the top instead of duplicating', () async {
      final h = HistoryStore(store);
      await h.recordRecent(ToolId.vat, {'amount': 1});
      await h.recordRecent(ToolId.vat, {'amount': 2});
      await h.recordRecent(ToolId.vat, {'amount': 1});
      expect(h.recent.length, 2);
      expect(h.recent.first.inputs['amount'], 1);
    });

    test('recent list is capped; saved items are kept', () async {
      final h = HistoryStore(store);
      await h.saveNamed(ToolId.loan, {'principal': 1}, ' My loan ');
      for (var i = 0; i < 30; i++) {
        await h.recordRecent(ToolId.vat, {'amount': i});
      }
      expect(h.recent.length, HistoryStore.maxRecent);
      expect(h.saved.single.name, 'My loan');
      await h.clearRecent();
      expect(h.recent, isEmpty);
      expect(h.savedCount, 1);
      final id = h.saved.single.id;
      await h.rename(id, 'Car');
      expect(HistoryStore(store).saved.single.name, 'Car');
      await h.remove(id);
      expect(h.all, isEmpty);
    });
  });

  group('Backup', () {
    test('exports app data but never purchase state or rate caches', () async {
      await store.writeJson('settings.v1', {'country': 'RS', 'onboarded': true});
      await store.writeJson('pro.v1', {'active': true});
      await store.writeJson('fx.nbs.v1', {'x': 1});
      final text = Backup.encode(store, now: DateTime(2026, 9, 25));
      final decoded = jsonDecode(text) as Map<String, Object?>;
      expect(decoded['format'], Backup.format);
      final data = decoded['data']! as Map<String, Object?>;
      expect(data.keys, ['settings.v1']);
    });

    test('rejects files that are not Bilans backups', () {
      expect(Backup.decode('not json'), isNull);
      expect(Backup.decode('{"format":"other","version":1,"data":{}}'), isNull);
      expect(Backup.decode('{"format":"bilans-backup","version":99,"data":{}}'), isNull);
      expect(Backup.decode('{"format":"bilans-backup","version":1,"data":[]}'), isNull);
      expect(Backup.decode('{"format":"bilans-backup","version":1,"data":{"a":"b"}}'), {'a': 'b'});
    });

    test('restore replaces data but keeps this device’s purchase state', () async {
      await store.writeJson('pro.v1', {'active': true, 'productId': 'pro_lifetime'});
      await store.writeJson('team.v1', [
        {'id': 'old'},
      ]);
      await Backup.restore(store, {
        'settings.v1': jsonEncode({'country': 'HR', 'onboarded': true}),
        'pro.v1': jsonEncode({'active': false}),
      });
      expect(store.readJson('team.v1'), isNull);
      expect((store.readJson('pro.v1')! as Map)['active'], isTrue);
      expect(SettingsController(store).country.code, 'HR');
    });

    test('wipe clears everything except device-only keys', () async {
      await store.writeJson('settings.v1', {'country': 'RS', 'onboarded': true});
      await store.writeJson('pro.v1', {'active': true});
      await Backup.wipe(store);
      expect(store.readJson('settings.v1'), isNull);
      expect(store.readJson('pro.v1'), isNotNull);
      expect(SettingsController(store).onboarded, isFalse);
    });

    test('file name carries the date', () {
      expect(Backup.fileName(DateTime(2026, 3, 7)), 'bilans-backup-2026-03-07.json');
    });
  });
}
