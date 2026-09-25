import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../fx/data/rates_controller.dart';
import '../../fx/domain/rates.dart';
import '../../fx/ui/currency_sheet.dart';
import '../../settings/settings_controller.dart';
import '../data/business_store.dart';
import '../domain/business_math.dart';
import '../domain/invoice.dart';
import 'profile_screen.dart';

/// Creates, edits or duplicates an invoice. Pops the saved [Invoice].
class InvoiceEditorScreen extends StatefulWidget {
  const InvoiceEditorScreen({super.key, this.invoiceId, this.duplicateOf});

  /// Edit this existing invoice.
  final String? invoiceId;

  /// Start a new invoice prefilled from this one.
  final Invoice? duplicateOf;

  @override
  State<InvoiceEditorScreen> createState() => _InvoiceEditorScreenState();
}

class _ItemDraft {
  _ItemDraft({required this.key, String description = '', String unit = '', this.quantity = 1, this.price, required this.vat})
    : description = TextEditingController(text: description),
      unit = TextEditingController(text: unit);

  final int key;
  final TextEditingController description;
  final TextEditingController unit;
  double? quantity;
  double? price;
  double vat;

  InvoiceItem toItem() => InvoiceItem(
    description: description.text.trim(),
    quantity: quantity ?? 0,
    unit: unit.text.trim(),
    unitPrice: price ?? 0,
    vatPercent: vat,
  );

  void dispose() {
    description.dispose();
    unit.dispose();
  }
}

enum _RateState { none, loading, ok, unavailable, failed }

class _InvoiceEditorScreenState extends State<InvoiceEditorScreen> {
  final _form = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _place = TextEditingController();
  final _clientName = TextEditingController();
  final _clientAddress = TextEditingController();
  final _clientCity = TextEditingController();
  final _clientCountry = TextEditingController();
  final _clientTaxId = TextEditingController();
  final _clientRegNo = TextEditingController();
  final _clientEmail = TextEditingController();
  final _note = TextEditingController();
  final _reference = TextEditingController();
  final List<_ItemDraft> _items = [];
  var _nextKey = 0;

  late String _id;
  late DateTime _createdAt;
  InvoiceStatus _status = InvoiceStatus.draft;
  late DateTime _issue;
  late DateTime _service;
  late DateTime _due;
  DateTime? _paidDate;
  bool _serviceFollowsIssue = true;
  bool _dueFollowsIssue = true;
  late String _currency;
  late bool _vatRegistered;
  late int _dueDays;
  late List<double> _vatRates;
  bool _serbian = false;
  bool _existing = false;

  double? _rate;
  DateTime? _rateDate;
  _RateState _rateState = _RateState.none;
  int _rateRequest = 0;

  bool _loaded = false;
  bool _saving = false;
  bool _showErrors = false;
  String _initial = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final business = context.read<BusinessStore>();
    final settings = context.read<SettingsController>();
    final profile = business.profile;
    _serbian = settings.country.code == 'RS';
    _vatRates = vatRatesByCountry[settings.country.code] ?? const [20];
    _dueDays = profile.defaultDueDays;
    final today = _day(DateTime.now());
    final existing = widget.invoiceId == null ? null : business.invoiceById(widget.invoiceId!);
    final source = existing ?? widget.duplicateOf;

    if (existing != null) {
      _existing = true;
      _id = existing.id;
      _createdAt = existing.createdAt;
      _status = existing.status;
      _number.text = existing.number;
      _issue = _day(existing.issueDate);
      _service = _day(existing.serviceDate);
      _due = _day(existing.dueDate);
      _paidDate = existing.paidDate;
      _serviceFollowsIssue = _service == _issue;
      _dueFollowsIssue = false;
      _currency = existing.currency;
      _vatRegistered = existing.vatRegistered;
      _rate = existing.rsdRate;
      _rateDate = existing.rsdRateDate;
      if (_rate != null) _rateState = _RateState.ok;
    } else {
      _id = business.newId();
      _createdAt = DateTime.now();
      _number.text = nextInvoiceNumber(business.invoices, today.year);
      _issue = today;
      _service = today;
      _due = DateTime(today.year, today.month, today.day + _dueDays);
      _currency = source?.currency ?? profile.defaultCurrency;
      _vatRegistered = profile.vatRegistered;
    }

    _place.text = source?.place ?? _placeFromCity(profile.party.city);
    final client = source?.client ?? const InvoiceParty();
    _setClient(client);
    _note.text = source?.note ?? profile.defaultNote;
    _reference.text = existing?.reference ?? '';
    final items = source?.items.where((i) => !i.isBlank).toList() ?? const <InvoiceItem>[];
    if (items.isEmpty) {
      _items.add(_newItem());
    } else {
      for (final i in items) {
        _items.add(
          _ItemDraft(
            key: _nextKey++,
            description: i.description,
            unit: i.unit,
            quantity: i.quantity,
            price: i.unitPrice,
            vat: _vatRegistered ? i.vatPercent : 0,
          ),
        );
      }
    }
    _initial = _snapshot();
    if (_rateState != _RateState.ok) unawaited(_fetchRate());
  }

  @override
  void dispose() {
    for (final c in [_number, _place, _clientName, _clientAddress, _clientCity, _clientCountry, _clientTaxId, _clientRegNo, _clientEmail, _note, _reference]) {
      c.dispose();
    }
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static String _placeFromCity(String city) => city.trim().replaceFirst(RegExp(r'^\d+\s*'), '');

  _ItemDraft _newItem() => _ItemDraft(key: _nextKey++, vat: _vatRegistered ? _vatRates.first : 0);

  void _setClient(InvoiceParty p) {
    _clientName.text = p.name;
    _clientAddress.text = p.address;
    _clientCity.text = p.city;
    _clientCountry.text = p.country;
    _clientTaxId.text = p.taxId;
    _clientRegNo.text = p.registrationNo;
    _clientEmail.text = p.email;
  }

  InvoiceParty get _client => InvoiceParty(
    name: _clientName.text.trim(),
    address: _clientAddress.text.trim(),
    city: _clientCity.text.trim(),
    country: _clientCountry.text.trim(),
    taxId: _clientTaxId.text.trim(),
    registrationNo: _clientRegNo.text.trim(),
    email: _clientEmail.text.trim(),
  );

  bool get _needsRate => _serbian && _currency != 'RSD';

  Invoice _build(InvoiceStatus status) => Invoice(
    id: _id,
    number: _number.text.trim(),
    status: status,
    issueDate: _issue,
    serviceDate: _service,
    dueDate: _due,
    place: _place.text.trim(),
    client: _client,
    currency: _currency,
    items: [for (final i in _items) i.toItem()],
    vatRegistered: _vatRegistered,
    note: _note.text.trim(),
    reference: _reference.text.trim(),
    rsdRate: _needsRate ? _rate : null,
    rsdRateDate: _needsRate ? _rateDate : null,
    paidDate: status == InvoiceStatus.paid ? _paidDate : null,
    createdAt: _createdAt,
  );

  String _snapshot() {
    final j = _build(_status).toJson()
      ..remove('rsdRate')
      ..remove('rsdRateDate');
    return jsonEncode(j);
  }

  bool get _dirty => _snapshot() != _initial;

  // ---------------------------------------------------------------- rates

  Future<void> _fetchRate() async {
    if (!_needsRate) {
      setState(() {
        _rate = null;
        _rateDate = null;
        _rateState = _RateState.none;
      });
      return;
    }
    final request = ++_rateRequest;
    setState(() => _rateState = _RateState.loading);
    final rates = context.read<RatesController>();
    RatePoint? point;
    var failed = false;
    try {
      point = await rates.nbsRateOn(_currency, _issue);
    } catch (_) {
      failed = true;
    }
    if (!mounted || request != _rateRequest) return;
    setState(() {
      if (point != null) {
        _rate = point.value;
        _rateDate = point.date;
        _rateState = _RateState.ok;
      } else {
        _rate = null;
        _rateDate = null;
        _rateState = failed ? _RateState.failed : _RateState.unavailable;
      }
    });
  }

  // ------------------------------------------------------------ validation

  String? _numberError(AppLocalizations l) {
    final n = _number.text.trim();
    if (n.isEmpty) return l.invErrorNumber;
    final taken = context.read<BusinessStore>().invoices.any((i) => i.id != _id && i.number.trim().toLowerCase() == n.toLowerCase());
    return taken ? l.invErrorNumberTaken(n) : null;
  }

  String? get _dueError => _due.isBefore(_issue) ? context.l10n.invErrorDue : null;

  bool get _itemsValid => _items.any((i) => i.description.text.trim().isNotEmpty && (i.price ?? 0) > 0 && (i.quantity ?? 0) > 0);

  Future<void> _save(InvoiceStatus status) async {
    if (_saving) return;
    final l = context.l10n;
    setState(() => _showErrors = true);
    final formOk = _form.currentState?.validate() ?? false;
    final issuing = status != InvoiceStatus.draft;
    final problems = <String>[
      ?_numberError(l),
      ?_dueError,
      if (issuing && _clientName.text.trim().isEmpty) l.invErrorClient,
      if (issuing && !_itemsValid) l.invErrorItems,
    ];
    if (!formOk || problems.isNotEmpty) {
      showSnack(context, problems.isNotEmpty ? problems.first : l.formFixErrors);
      return;
    }
    setState(() => _saving = true);
    final invoice = _build(status);
    final store = context.read<BusinessStore>();
    await store.upsertInvoice(invoice);
    if (!mounted) return;
    _initial = _snapshot();
    Navigator.of(context).pop(invoice);
  }

  // ------------------------------------------------------------------- UI

  Future<void> _pickCurrency() async {
    final picked = await showCurrencySheet(context, current: _currency, available: invoiceCurrencies, pinned: invoiceCurrencies.take(4).toList());
    if (picked == null || picked == _currency) return;
    setState(() => _currency = picked);
    unawaited(_fetchRate());
  }

  void _setIssue(DateTime d) {
    setState(() {
      _issue = d;
      if (_serviceFollowsIssue) _service = d;
      if (_dueFollowsIssue) _due = DateTime(d.year, d.month, d.day + _dueDays);
    });
    unawaited(_fetchRate());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final business = context.watch<BusinessStore>();
    final draftInvoice = _build(_status);
    final recent = business.recentClients.take(6).toList();
    final title = _existing ? l.invEdit : l.invNew;
    final isDraft = _status == InvoiceStatus.draft;
    final decimals = Formats.currencyDecimals(_currency);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!_dirty || await confirmDiscard(context)) navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        bottomNavigationBar: BottomActions(
          children: isDraft
              ? [
                  OutlinedButton(
                    onPressed: _saving ? null : () => _save(InvoiceStatus.draft),
                    child: ButtonLabel(l.invSaveDraft),
                  ),
                  FilledButton(
                    onPressed: _saving ? null : () => _save(InvoiceStatus.issued),
                    child: ButtonLabel(l.invIssue),
                  ),
                ]
              : [FilledButton(onPressed: _saving ? null : () => _save(_status), child: ButtonLabel(l.invSave))],
        ),
        body: Form(
          key: _form,
          child: PageBody(
            padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 32),
            children: [
              FormSection(
                title: l.invDocTitle,
                children: [
                  TextBox(
                    controller: _number,
                    label: l.invNumber,
                    maxLength: 30,
                    validator: (_) => _showErrors ? _numberError(l) : null,
                  ),
                  _Pair(
                    DateBox(label: l.invIssueDate, value: _issue, onChanged: _setIssue),
                    DateBox(
                      label: l.invServiceDate,
                      value: _service,
                      onChanged: (d) => setState(() {
                        _service = d;
                        _serviceFollowsIssue = d == _issue;
                      }),
                    ),
                  ),
                  _Pair(
                    DateBox(
                      label: l.invDueDate,
                      value: _due,
                      errorText: _dueError,
                      onChanged: (d) => setState(() {
                        _due = d;
                        _dueFollowsIssue = false;
                      }),
                    ),
                    TextBox(controller: _place, label: l.invPlace, textCapitalization: TextCapitalization.words, maxLength: 60),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: l.invClient,
                children: [
                  if (recent.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(l.invRecentClients, style: t.bodySmall),
                          const SizedBox(width: 10),
                          for (final p in recent) ...[
                            PillChip(
                              label: p.name,
                              selected: _clientName.text.trim() == p.name,
                              onTap: () => setState(() => _setClient(p)),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ],
                      ),
                    ),
                  TextBox(
                    controller: _clientName,
                    label: l.invClientName,
                    maxLength: 120,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                    validator: (v) => _showErrors && _status != InvoiceStatus.draft && (v ?? '').trim().isEmpty ? l.invErrorClient : null,
                  ),
                  TextBox(controller: _clientAddress, label: l.invClientAddress, maxLength: 120, textCapitalization: TextCapitalization.words),
                  _Pair(
                    TextBox(controller: _clientCity, label: l.invClientCity, maxLength: 80, textCapitalization: TextCapitalization.words),
                    TextBox(controller: _clientCountry, label: l.invClientCountry, maxLength: 60, textCapitalization: TextCapitalization.words),
                  ),
                  _Pair(
                    TextBox(controller: _clientTaxId, label: l.invClientTaxId, maxLength: 30),
                    TextBox(controller: _clientRegNo, label: l.invClientRegNo, maxLength: 30),
                  ),
                  TextBox(
                    controller: _clientEmail,
                    label: l.invClientEmail,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 100,
                    validator: (v) => BusinessValidators.email(l, v ?? ''),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: l.invItems,
                children: [
                  PickerBox(
                    label: l.invCurrency,
                    value: '$_currency · ${l.currencyName(_currency) ?? _currency}',
                    leading: CodeTile(_currency, width: 40),
                    onTap: _pickCurrency,
                  ),
                  for (var i = 0; i < _items.length; i++)
                    _ItemCard(
                      key: ValueKey(_items[i].key),
                      index: i,
                      item: _items[i],
                      currency: _currency,
                      decimals: decimals,
                      vatRegistered: _vatRegistered,
                      vatRates: _vatRates,
                      canRemove: _items.length > 1,
                      onChanged: () => setState(() {}),
                      onRemove: () {
                        final removed = _items[i];
                        setState(() => _items.removeAt(i));
                        // The fields still hold the controllers until the
                        // next frame has rebuilt without them.
                        WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
                      },
                    ),
                  if (_showErrors && _status != InvoiceStatus.draft && !_itemsValid) Text(l.invErrorItems, style: t.bodySmall!.copyWith(color: c.brick)),
                  if (_items.length < 50)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _items.add(_newItem())),
                      icon: const Icon(Icons.add),
                      label: Text(l.invAddItem),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _Totals(invoice: draftInvoice, rateState: _rateState, needsRate: _needsRate, onRetryRate: _fetchRate),
              const SizedBox(height: 24),
              FormSection(
                title: l.invNote,
                children: [
                  TextBox(controller: _note, label: l.invNote, maxLines: 5, minLines: 2, maxLength: 600, textCapitalization: TextCapitalization.sentences),
                  if (_currency == 'RSD')
                    TextBox(
                      controller: _reference,
                      label: l.invReference,
                      hint: l.invReferenceHint,
                      keyboardType: TextInputType.number,
                      maxLength: 28,
                    ),
                ],
              ),
              if (!_vatRegistered) ...[
                const SizedBox(height: 16),
                FinePrint(l.invNotInVat),
              ],
              if (_serbian) ...[
                const SizedBox(height: 12),
                FinePrint(l.invSefNote),
              ],
              if (_paidDate != null && _status == InvoiceStatus.paid) ...[
                const SizedBox(height: 12),
                FinePrint(l.invPaidOn(f.date(_paidDate!))),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Two fields side by side, stacked on narrow screens or large text.
class _Pair extends StatelessWidget {
  const _Pair(this.a, this.b);
  final Widget a;
  final Widget b;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300 || scale > 1.25) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [a, const SizedBox(height: 12), b]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: a),
            const SizedBox(width: 10),
            Expanded(child: b),
          ],
        );
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    super.key,
    required this.index,
    required this.item,
    required this.currency,
    required this.decimals,
    required this.vatRegistered,
    required this.vatRates,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final _ItemDraft item;
  final String currency;
  final int decimals;
  final bool vatRegistered;
  final List<double> vatRates;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final line = item.toItem();
    return Panel(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('${index + 1}.', style: t.titleMedium!.copyWith(fontFamily: Fonts.serif)),
              ),
              if (canRemove)
                IconButton(
                  tooltip: l.invRemoveItem,
                  onPressed: onRemove,
                  icon: Icon(Icons.close, size: 20, color: c.ink2),
                )
              else
                const SizedBox(height: 48),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextBox(
                  controller: item.description,
                  label: l.invItemDescription,
                  maxLines: 3,
                  minLines: 1,
                  maxLength: 300,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => onChanged(),
                ),
                const SizedBox(height: 12),
                _Pair(
                  NumberBox(
                    label: l.invItemQty,
                    value: item.quantity,
                    formats: f,
                    decimals: 3,
                    maxIntegerDigits: 7,
                    onChanged: (v) {
                      item.quantity = v;
                      onChanged();
                    },
                  ),
                  TextBox(controller: item.unit, label: l.invItemUnit, hint: l.invItemUnitHint, maxLength: 12),
                ),
                const SizedBox(height: 12),
                _Pair(
                  NumberBox(
                    label: l.invItemPrice,
                    value: item.price,
                    formats: f,
                    decimals: decimals,
                    maxIntegerDigits: 10,
                    suffixText: f.currencySymbol(currency),
                    onChanged: (v) {
                      item.price = v;
                      onChanged();
                    },
                  ),
                  vatRegistered
                      ? _VatPicker(
                          value: item.vat,
                          rates: vatRates,
                          onChanged: (v) {
                            item.vat = v;
                            onChanged();
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: Text(l.invColAmount, style: t.bodySmall)),
                    Text(
                      f.money(vatRegistered ? line.gross : line.net, currency),
                      style: t.titleMedium!.copyWith(fontFeatures: Fonts.tabular),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VatPicker extends StatelessWidget {
  const _VatPicker({required this.value, required this.rates, required this.onChanged});

  final double value;
  final List<double> rates;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final options = {...rates, 0.0}.toList();
    String label(double r) => f.percentValue(r, decimals: r == r.roundToDouble() ? 0 : 1);
    return PickerBox(
      label: l.invItemVat,
      value: label(value),
      onTap: () async {
        final picked = await showModalBottomSheet<double>(
          context: context,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final r in options)
                  ListTile(
                    title: Text(label(r)),
                    trailing: r == value ? Icon(Icons.check, color: context.colors.green) : null,
                    onTap: () => Navigator.of(context).pop(r),
                  ),
              ],
            ),
          ),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.invoice, required this.rateState, required this.needsRate, required this.onRetryRate});

  final Invoice invoice;
  final _RateState rateState;
  final bool needsRate;
  final VoidCallback onRetryRate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final cur = invoice.currency;
    return Panel(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (invoice.vatRegistered) ...[
            LedgerRow(label: l.invSubtotal, value: f.money(invoice.netTotal, cur)),
            LedgerRow(label: l.invVat, value: f.money(invoice.vatTotal, cur), divider: false),
          ],
          LedgerTotal(label: l.invTotal, value: f.money(invoice.total, cur)),
          if (needsRate) ...[
            switch (rateState) {
              _RateState.ok when invoice.rsdRate != null => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LedgerRow(label: l.invTotalRsd, value: f.money(invoice.totalRsd ?? 0, 'RSD'), divider: false),
                    Text(
                      l.invRateLine(f.rate(invoice.rsdRate!), f.date(invoice.rsdRateDate ?? invoice.issueDate)),
                      style: t.bodySmall,
                    ),
                  ],
                ),
              ),
              _RateState.loading => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: c.ink2)),
                    const SizedBox(width: 10),
                    Text(l.invRateFetching, style: t.bodySmall),
                  ],
                ),
              ),
              _ => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        rateState == _RateState.failed ? l.invRateOffline : l.invRateUnavailable,
                        style: t.bodySmall,
                      ),
                    ),
                    TextButton(onPressed: onRetryRate, child: Text(l.invRateRetry)),
                  ],
                ),
              ),
            },
          ],
        ],
      ),
    );
  }
}
