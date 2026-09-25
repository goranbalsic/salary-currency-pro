import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/forms.dart';
import '../../../l10n/l10n.dart';
import '../../fx/ui/currency_sheet.dart';
import '../../settings/settings_controller.dart';
import '../data/business_store.dart';
import '../domain/identifiers.dart';
import '../domain/invoice.dart';

/// Currencies an invoice can be issued in.
const invoiceCurrencies = ['RSD', 'EUR', 'USD', 'CHF', 'GBP', 'BAM', 'MKD', 'RON', 'HUF', 'CZK', 'PLN', 'SEK', 'NOK', 'DKK', 'CAD', 'AUD', 'JPY', 'CNY', 'TRY'];

/// Validation shared by the profile and the invoice editor.
abstract final class BusinessValidators {
  /// Serbian PIB (9 digits with a check digit) — only enforced when
  /// [serbian] is true; elsewhere the tax ID is free-form.
  static String? pib(AppLocalizations l, String value, {required bool serbian}) {
    final v = value.trim();
    if (v.isEmpty || !serbian) return null;
    if (!RegExp(r'^\d{9}$').hasMatch(v)) return l.profPibLength;
    return Identifiers.isValidPib(v) ? null : l.profInvalidPib;
  }

  static String? maticniBroj(AppLocalizations l, String value, {required bool serbian}) {
    final v = value.trim();
    if (v.isEmpty || !serbian) return null;
    if (!RegExp(r'^\d{8}$').hasMatch(v)) return l.profMbLength;
    return Identifiers.isValidMaticniBroj(v) ? null : l.profInvalidMb;
  }

  /// A Serbian account or an IBAN; empty is allowed. Outside Serbia a
  /// domestic account is free-form (formats differ), an IBAN is checked.
  static String? account(AppLocalizations l, String value, {required bool serbian}) {
    final v = value.trim();
    if (v.isEmpty) return null;
    if (RegExp(r'^[A-Za-z]{2}').hasMatch(v)) return iban(l, v);
    if (!serbian) return RegExp(r'^[0-9 \-]{5,40}$').hasMatch(v) ? null : l.profInvalidAccountShape;
    if (Identifiers.normalizeSerbianAccount(v) == null) return l.profInvalidAccountShape;
    return Identifiers.isValidSerbianAccount(v) ? null : l.profInvalidAccount;
  }

  static String? iban(AppLocalizations l, String value) {
    final compact = value.replaceAll(' ', '').toUpperCase();
    if (compact.isEmpty) return null;
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{10,30}$').hasMatch(compact)) return l.profInvalidIban;
    return Identifiers.isValidIban(compact) ? null : l.profInvalidIban;
  }

  static String? swift(AppLocalizations l, String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return Identifiers.isValidBic(v) ? null : l.profInvalidSwift;
  }

  static String? email(AppLocalizations l, String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v) ? null : l.profInvalidEmail;
  }

  /// Tidies an account for printing: IBANs upper-cased in groups of four.
  static String tidyAccount(String value) {
    final v = value.trim();
    if (RegExp(r'^[A-Za-z]{2}').hasMatch(v)) return Identifiers.formatIban(v);
    return v.replaceAll(' ', '');
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.firstRun = false});

  /// Opened from "new invoice" before any details exist; pops `true` once
  /// the details are saved.
  final bool firstRun;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _taxId = TextEditingController();
  final _regNo = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _account = TextEditingController();
  final _bank = TextEditingController();
  final _iban = TextEditingController();
  final _swift = TextEditingController();
  final _paymentCode = TextEditingController();
  final _note = TextEditingController();
  bool _vat = false;
  bool _showOnReports = true;
  int _dueDays = 15;
  String _currency = 'RSD';
  String _initial = '';
  bool _loaded = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final p = context.read<BusinessStore>().profile;
    final settings = context.read<SettingsController>();
    final l = context.l10n;
    _name.text = p.party.name;
    _address.text = p.party.address;
    _city.text = p.party.city;
    _country.text = p.party.country.isEmpty && p.isEmpty ? l.countryName(settings.country.code) : p.party.country;
    _taxId.text = p.party.taxId;
    _regNo.text = p.party.registrationNo;
    _email.text = p.party.email;
    _phone.text = p.phone;
    _account.text = p.bankAccount;
    _bank.text = p.bankName;
    _iban.text = p.iban;
    _swift.text = p.swift;
    _paymentCode.text = p.paymentCode;
    _note.text = p.defaultNote;
    _vat = p.vatRegistered;
    _showOnReports = p.showOnReports;
    _dueDays = p.defaultDueDays;
    _currency = p.isEmpty ? settings.homeCurrency : p.defaultCurrency;
    _initial = jsonEncode(_current().toJson());
  }

  @override
  void dispose() {
    for (final c in [_name, _address, _city, _country, _taxId, _regNo, _email, _phone, _account, _bank, _iban, _swift, _paymentCode, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _serbian => context.read<SettingsController>().country.code == 'RS';

  BusinessProfile _current() => BusinessProfile(
        party: InvoiceParty(
          name: _name.text.trim(),
          address: _address.text.trim(),
          city: _city.text.trim(),
          country: _country.text.trim(),
          taxId: _taxId.text.trim(),
          registrationNo: _regNo.text.trim(),
          email: _email.text.trim(),
        ),
        bankAccount: BusinessValidators.tidyAccount(_account.text),
        bankName: _bank.text.trim(),
        iban: _iban.text.trim().isEmpty ? '' : Identifiers.formatIban(_iban.text),
        swift: _swift.text.replaceAll(' ', '').toUpperCase(),
        phone: _phone.text.trim(),
        vatRegistered: _vat,
        paymentCode: _paymentCode.text.trim().isEmpty ? '221' : _paymentCode.text.trim(),
        defaultDueDays: _dueDays,
        defaultCurrency: _currency,
        defaultNote: _note.text.trim(),
        showOnReports: _showOnReports,
      );

  bool get _dirty => jsonEncode(_current().toJson()) != _initial;

  Future<void> _save() async {
    if (_saving) return;
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) {
      showSnack(context, l.formFixErrors);
      return;
    }
    setState(() => _saving = true);
    final profile = _current();
    await context.read<BusinessStore>().saveProfile(profile);
    if (!mounted) return;
    _initial = jsonEncode(profile.toJson());
    showSnack(context, l.profSaved);
    Navigator.of(context).pop(true);
  }

  Future<void> _pickCurrency() async {
    final picked = await showCurrencySheet(context, current: _currency, available: invoiceCurrencies, pinned: invoiceCurrencies.take(4).toList());
    if (picked != null) setState(() => _currency = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final serbian = _serbian;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!_dirty || await confirmDiscard(context)) navigator.pop(false);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.profTitle)),
        bottomNavigationBar: BottomActions(
          children: [
            FilledButton(onPressed: _saving ? null : _save, child: Text(l.actionSave)),
          ],
        ),
        body: Form(
          key: _form,
          child: PageBody(
            padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 32),
            children: [
              if (widget.firstRun) ...[
                InfoNote(l.invProfileMissing, icon: Icons.storefront_outlined),
                const SizedBox(height: 18),
              ] else ...[
                FinePrint(l.profIntro),
                const SizedBox(height: 18),
              ],
              FormSection(
                title: l.profSectionBusiness,
                children: [
                  TextBox(
                    controller: _name,
                    label: l.profName,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 120,
                    autofillHints: const [AutofillHints.organizationName],
                    validator: (v) => (v ?? '').trim().isEmpty ? l.profNameRequired : null,
                  ),
                  TextBox(
                    controller: _address,
                    label: l.profAddress,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 120,
                    autofillHints: const [AutofillHints.streetAddressLine1],
                  ),
                  TextBox(
                    controller: _city,
                    label: l.profCity,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 80,
                    autofillHints: const [AutofillHints.addressCity],
                  ),
                  TextBox(controller: _country, label: l.profCountry, textCapitalization: TextCapitalization.words, maxLength: 60),
                  TextBox(
                    controller: _taxId,
                    label: serbian ? l.profTaxId : l.profTaxIdGeneric,
                    keyboardType: serbian ? TextInputType.number : TextInputType.text,
                    inputFormatters: serbian ? [FilteringTextInputFormatter.digitsOnly] : null,
                    maxLength: serbian ? 9 : 30,
                    validator: (v) => BusinessValidators.pib(l, v ?? '', serbian: serbian),
                  ),
                  TextBox(
                    controller: _regNo,
                    label: serbian ? l.profRegNo : l.profRegNoGeneric,
                    keyboardType: serbian ? TextInputType.number : TextInputType.text,
                    inputFormatters: serbian ? [FilteringTextInputFormatter.digitsOnly] : null,
                    maxLength: serbian ? 8 : 30,
                    validator: (v) => BusinessValidators.maticniBroj(l, v ?? '', serbian: serbian),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: l.profSectionPayment,
                children: [
                  TextBox(
                    controller: _account,
                    label: l.profAccount,
                    hint: serbian ? '160-0000000000000-00' : 'IBAN',
                    helper: serbian ? l.profAccountHint : null,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 42,
                    validator: (v) => BusinessValidators.account(l, v ?? '', serbian: serbian),
                  ),
                  TextBox(controller: _bank, label: l.profBank, textCapitalization: TextCapitalization.words, maxLength: 60),
                  if (serbian)
                    TextBox(
                      controller: _iban,
                      label: l.profIban,
                      hint: 'RS35 …',
                      helper: l.profIbanHint,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 42,
                      validator: (v) => BusinessValidators.iban(l, v ?? ''),
                    ),
                  TextBox(
                    controller: _swift,
                    label: l.profSwift,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 11,
                    validator: (v) => BusinessValidators.swift(l, v ?? ''),
                  ),
                  if (serbian)
                    TextBox(
                      controller: _paymentCode,
                      label: l.profPaymentCode,
                      helper: l.profPaymentCodeHint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 3,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return null;
                        return RegExp(r'^[12]\d{2}$').hasMatch(s) ? null : l.profInvalidPaymentCode;
                      },
                    ),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: l.profSectionContact,
                children: [
                  TextBox(
                    controller: _email,
                    label: l.profEmail,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 100,
                    autofillHints: const [AutofillHints.email],
                    validator: (v) => BusinessValidators.email(l, v ?? ''),
                  ),
                  TextBox(
                    controller: _phone,
                    label: l.profPhone,
                    keyboardType: TextInputType.phone,
                    maxLength: 40,
                    autofillHints: const [AutofillHints.telephoneNumber],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: l.profSectionInvoices,
                children: [
                  PickerBox(
                    label: l.profCurrency,
                    value: '$_currency · ${l.currencyName(_currency) ?? _currency}',
                    leading: CodeTile(_currency, width: 40),
                    onTap: _pickCurrency,
                  ),
                  NumberBox(
                    label: l.profDueDays,
                    value: _dueDays.toDouble(),
                    formats: f,
                    decimals: 0,
                    maxIntegerDigits: 3,
                    suffixText: l.profDueDaysSuffix,
                    onChanged: (v) => setState(() => _dueDays = (v ?? 0).round().clamp(0, 365)),
                  ),
                  TextBox(
                    controller: _note,
                    label: l.profNote,
                    maxLines: 4,
                    minLines: 2,
                    maxLength: 400,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchRow(
                label: l.profVat,
                hint: l.profVatHint,
                value: _vat,
                onChanged: (v) => setState(() => _vat = v),
              ),
              SwitchRow(
                label: l.profShowOnReports,
                value: _showOnReports,
                divider: false,
                onChanged: (v) => setState(() => _showOnReports = v),
              ),
              const SizedBox(height: 8),
              Text(l.profPrivacy, style: t.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
