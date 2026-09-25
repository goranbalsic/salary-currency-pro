import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../app/bootstrap.dart';
import '../../core/format/formats.dart';
import '../../core/money/money.dart';
import '../../core/widgets/common.dart';
import '../../l10n/l10n.dart';
import '../business/data/business_store.dart';
import '../business/domain/invoice.dart';
import '../business/domain/invoice_qr.dart';
import '../business/domain/payment_details.dart';
import '../credit/domain/deposit_engine.dart';
import '../credit/domain/loan_engine.dart';
import '../payroll/data/team_store.dart';
import '../payroll/domain/payroll_models.dart';
import '../payroll/domain/payroll_rules.dart';
import '../payroll/ui/payroll_breakdown.dart';
import '../payroll/ui/payroll_labels.dart';
import '../payroll/ui/team_screen.dart';
import '../pro/pro_controller.dart';
import '../settings/settings_controller.dart';
import 'pdf_kit.dart';

// ------------------------------------------------------------------ sharing

String _stamp(DateTime d) => '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

String _safeName(String s) => s.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-').replaceAll(RegExp('-+'), '-');

Future<ReportKit> _kitFor(BuildContext context) async {
  final fonts = await ReportFonts.load();
  if (!context.mounted) throw StateError('unmounted');
  final profile = context.read<BusinessStore>().profile;
  final serbian = context.read<SettingsController>().country.code == 'RS';
  String? issuer;
  if (profile.showOnReports && !profile.isEmpty) {
    final id = profile.party.taxId.isEmpty ? '' : ' · ${serbian ? context.l10n.invPib : context.l10n.profTaxIdGeneric} ${profile.party.taxId}';
    issuer = '${profile.party.name}$id';
  }
  return ReportKit(fonts: fonts, l: context.l10n, f: context.fmt, issuer: issuer);
}

/// Builds with [build] and opens the share sheet; reports failures.
Future<void> _share(BuildContext context, String fileName, Future<Uint8List> Function(ReportKit kit) build) async {
  final l = context.l10n;
  try {
    final kit = await _kitFor(context);
    final bytes = await build(kit);
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  } catch (e) {
    debugPrint('PDF failed: $e');
    if (context.mounted) showSnack(context, l.errorPdf);
  }
}

Future<void> sharePayrollPdf(BuildContext context, PayrollResult result, {bool annual = false}) =>
    _share(context, 'bilans-pay-${result.system.countryCode.toLowerCase()}-${_stamp(DateTime.now())}.pdf', (kit) => buildPayrollPdf(kit, result, annual: annual));

Future<void> shareLoanPdf(BuildContext context, LoanResult result, String currency) =>
    _share(context, 'bilans-loan-${_stamp(DateTime.now())}.pdf', (kit) => buildLoanPdf(kit, result, currency));

Future<void> shareDepositPdf(BuildContext context, DepositResult result, String currency) =>
    _share(context, 'bilans-savings-${_stamp(DateTime.now())}.pdf', (kit) => buildDepositPdf(kit, result, currency));

Future<void> shareTeamPdf(BuildContext context, List<TeamMember> members, {bool annual = false}) =>
    _share(context, 'bilans-team-${_stamp(DateTime.now())}.pdf', (kit) => buildTeamPdf(kit, members, annual: annual));

// ------------------------------------------------------------------ payroll

Future<Uint8List> buildPayrollPdf(ReportKit kit, PayrollResult r, {bool annual = false, DateTime? now}) async {
  final l = kit.l;
  final f = kit.f;
  final date = now ?? DateTime.now();
  final d = r.system.decimals;
  final cur = r.system.currency;
  final k = annual ? 12.0 : 1.0;
  String m(double v) => f.money(Money.round(v * k, d), cur, decimals: d);
  String neg(double v) => v == 0 ? m(0) : '−${m(v)}';
  String pct(double? rate) {
    if (rate == null) return '';
    final p = rate * 100;
    final dec = (p - p.roundToDouble()).abs() < 1e-9 ? 0 : ((p * 10 - (p * 10).roundToDouble()).abs() < 1e-9 ? 1 : 2);
    return f.percentValue(p, decimals: dec);
  }

  final rulesDate = f.date(PayrollRules.effectiveFrom(r.system));
  final shares = percentShares([r.net > 0 ? r.net : 0, r.totalTax, r.employeeTotal, r.employerTotal]);
  final doc = kit.document(l.payTitle);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: ReportKit.margin,
    header: (ctx) => kit.header(ctx,
        title: l.payTitle, subtitle: '${l.systemName(r.system)} · ${annual ? l.commonAnnual : l.commonMonthly} · ${l.payRulesFrom(rulesDate)}', date: date),
    footer: (ctx) => kit.footer(ctx),
    build: (ctx) => [
      kit.keyFigures([
        (l.payGross, m(r.gross)),
        (l.payNetTotal, m(r.net)),
        (l.payTotalCost, m(r.totalCost)),
        (l.payWedgeLabel, f.percent(r.taxWedge)),
      ]),
      pw.SizedBox(height: 14),
      kit.overline(l.payComposition, top: 4),
      kit.composition([
        (l.segNet, r.net > 0 ? r.net : 0, PdfInk.chart1, f.percentValue(shares[0], decimals: 1)),
        (l.segTax, r.totalTax, PdfInk.chart2, f.percentValue(shares[1], decimals: 1)),
        (l.segEmployee, r.employeeTotal, PdfInk.chart3, f.percentValue(shares[2], decimals: 1)),
        (l.segEmployer, r.employerTotal, PdfInk.chart4, f.percentValue(shares[3], decimals: 1)),
      ]),
      kit.overline(l.payEmployee, top: 16),
      kit.row(l.payGross, m(r.gross)),
      for (final line in r.employeeLines)
        kit.row(
          payrollItemLabel(l, line.item),
          neg(line.amount),
          hint: pct(line.rate),
          note: line.base != null ? l.payOnBase(m(line.base!)) : (line.rate == null ? l.payFixedMonthly : null),
        ),
      if (payrollAllowanceLabel(l, r.system) != null && r.allowance > 0) kit.row(payrollAllowanceLabel(l, r.system)!, m(r.allowance)),
      if (r.system != PayrollSystem.montenegro) kit.row(l.payTaxBase, m(r.taxableBase)),
      if (r.taxBands.length <= 1)
        kit.row(l.payIncomeTax, neg(r.incomeTax), hint: pct(r.taxBands.firstOrNull?.rate))
      else
        for (var i = 0; i < r.taxBands.length; i++)
          kit.row(i == 0 ? l.payIncomeTax : '', neg(r.taxBands[i].tax), note: l.payTaxOn(pct(r.taxBands[i].rate), m(r.taxBands[i].taxable))),
      if (r.surtax > 0) kit.row(l.paySurtax, neg(r.surtax), hint: pct(r.options.montenegroSurtaxRate)),
      kit.total(l.payNetTotal, m(r.net)),
      if (r.employerLines.isNotEmpty) ...[
        kit.overline(l.payEmployer),
        for (final line in r.employerLines)
          kit.row(payrollItemLabel(l, line.item), m(line.amount), hint: pct(line.rate), note: line.base != null ? l.payOnBase(m(line.base!)) : null),
        kit.total(l.payTotalCost, m(r.totalCost)),
      ],
      pw.SizedBox(height: 8),
      for (final (text, _) in payrollNoteTexts(l, f, r)) kit.paragraph(text),
      if (annual) kit.paragraph(l.payAnnualNote),
      kit.paragraph(l.payDisclaimer(rulesDate)),
      kit.overline(l.sourcesTitle),
      for (final s in PayrollRules.sources(r.system)) kit.paragraph('• $s'),
    ],
  ));
  return doc.save();
}

// --------------------------------------------------------------------- loan

Future<Uint8List> buildLoanPdf(ReportKit kit, LoanResult r, String currency, {DateTime? now}) async {
  final l = kit.l;
  final f = kit.f;
  final date = now ?? DateTime.now();
  final i = r.input;
  String m(double v) => f.money(v, currency);
  String n(double v) => f.number(v, decimals: Formats.currencyDecimals(currency));
  final term = i.months >= 12 && i.months % 12 == 0 ? l.commonYearsCount(i.months ~/ 12) : l.commonMonthsCount(i.months);
  final subtitle = [
    m(i.principal),
    '${f.percentValue(i.annualRatePercent)} ${l.commonPercentPa.replaceAll('%', '').trim()}',
    term,
    i.type == RepaymentType.annuity ? l.loanAnnuity : l.loanLinear,
  ].join(' · ');
  final byYear = r.byYear;
  var balanceByYear = <double>[];
  for (var y = 0; y < byYear.length; y++) {
    final idx = ((y + 1) * 12).clamp(1, r.rows.length) - 1;
    balanceByYear = [...balanceByYear, r.rows[idx].balance];
  }
  final doc = kit.document(l.toolLoan);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: ReportKit.margin,
    header: (ctx) => kit.header(ctx, title: l.toolLoan, subtitle: subtitle, date: date),
    footer: (ctx) => kit.footer(ctx),
    build: (ctx) => [
      kit.keyFigures([
        (i.type == RepaymentType.annuity ? l.loanInstallment : l.loanFirstInstallment, m(r.firstInstallment)),
        (l.loanEir, r.eirAnnual == null ? '—' : f.percent(r.eirAnnual!, decimals: 2)),
        (l.loanTotalInterest, m(r.totalInterest)),
        (l.loanTotal, m(r.totalCost)),
      ]),
      pw.SizedBox(height: 10),
      kit.row(l.loanAmount, m(i.principal)),
      kit.row(l.loanRate, f.percentValue(i.annualRatePercent)),
      kit.row(l.loanTerm, term),
      if (i.upfrontFeeTotal > 0) kit.row(l.loanFee, m(i.upfrontFeeTotal)),
      if (i.monthlyFee > 0) kit.row(l.loanMonthlyFee, m(i.monthlyFee)),
      kit.row(l.loanTotalInterest, m(r.totalInterest)),
      kit.total(l.loanTotal, m(r.totalCost)),
      if (r.totalFees > 0) kit.paragraph(l.loanTotalIncludes(m(r.totalFees))),
      kit.paragraph(l.loanEirNote),
      kit.overline(l.loanByYear, top: 16),
      kit.table(
        headers: [l.depColYear, l.loanPrincipal, l.loanInterest, l.loanColBalance],
        flex: [1, 2, 2, 2],
        right: {1, 2, 3},
        rows: [
          for (var y = 0; y < byYear.length; y++) ['${y + 1}', n(byYear[y].principal), n(byYear[y].interest), n(balanceByYear[y])],
        ],
      ),
      kit.overline(l.loanSchedule, top: 16),
      kit.table(
        headers: [l.loanColNo, l.loanColInstallment, l.loanColInterest, l.loanColPrincipal, l.loanColBalance],
        flex: [0.8, 2, 2, 2, 2],
        right: {1, 2, 3, 4},
        rows: [
          for (final row in r.rows) ['${row.index}', n(row.installment), n(row.interest), n(row.principal), n(row.balance)],
        ],
        footer: ['', n(Money.sum(r.rows.map((e) => e.installment))), n(r.totalInterest), n(i.principal), ''],
      ),
    ],
  ));
  return doc.save();
}

// ------------------------------------------------------------------ deposit

Future<Uint8List> buildDepositPdf(ReportKit kit, DepositResult r, String currency, {DateTime? now}) async {
  final l = kit.l;
  final f = kit.f;
  final date = now ?? DateTime.now();
  final i = r.input;
  String m(double v) => f.money(v, currency);
  String n(double v) => f.number(v, decimals: Formats.currencyDecimals(currency));
  final term = i.months >= 12 && i.months % 12 == 0 ? l.commonYearsCount(i.months ~/ 12) : l.commonMonthsCount(i.months);
  final payout = switch (i.compounding) {
    Compounding.atMaturity => l.depAtMaturity,
    Compounding.monthly => l.depMonthly,
    Compounding.annually => l.depAnnually,
  };
  final yieldValue = r.effectiveAnnualYield;
  final doc = kit.document(l.toolDeposit);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: ReportKit.margin,
    header: (ctx) => kit.header(ctx, title: l.toolDeposit, subtitle: '${m(i.principal)} · ${f.percentValue(i.annualRatePercent)} · $term', date: date),
    footer: (ctx) => kit.footer(ctx),
    build: (ctx) => [
      kit.keyFigures([
        (l.depFinal, m(r.finalBalance)),
        (l.depNetInterest, m(r.netInterest)),
        (l.depTaxAmount, m(r.tax)),
        if (yieldValue != null) (l.depYieldLabel, f.percent(yieldValue, decimals: 2)),
      ]),
      pw.SizedBox(height: 10),
      kit.row(l.depAmount, m(i.principal)),
      if (i.monthlyContribution > 0) kit.row(l.depContribution, m(i.monthlyContribution)),
      kit.row(l.depRate, f.percentValue(i.annualRatePercent)),
      kit.row(l.depTerm, term),
      kit.row(l.depPayout, payout),
      kit.row(l.depTax, f.percentValue(i.taxPercent, decimals: i.taxPercent == i.taxPercent.roundToDouble() ? 0 : 2)),
      kit.row(l.depPaidIn, m(r.totalContributed)),
      kit.row(l.depGrossInterest, m(r.grossInterest)),
      kit.row(l.depTaxAmount, '−${m(r.tax)}'),
      kit.total(l.depFinal, m(r.finalBalance)),
      if (r.years.length > 1) ...[
        kit.overline(l.depByYear, top: 16),
        kit.table(
          headers: [l.depColYear, l.depPaidIn, l.depColInterest, l.depColBalance],
          flex: [1, 2, 2, 2],
          right: {1, 2, 3},
          rows: [
            for (final y in r.years) ['${y.year}', n(y.contributed), n(Money.sub(y.grossInterest, y.tax)), n(y.balance)],
          ],
        ),
      ],
    ],
  ));
  return doc.save();
}

// --------------------------------------------------------------------- team

Future<Uint8List> buildTeamPdf(ReportKit kit, List<TeamMember> members, {bool annual = false, DateTime? now}) async {
  final l = kit.l;
  final f = kit.f;
  final date = now ?? DateTime.now();
  final mult = annual ? 12 : 1;
  final totals = TeamTotals.of(members);
  final doc = kit.document(l.teamTitle);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: ReportKit.margin,
    header: (ctx) => kit.header(ctx, title: l.teamTitle, subtitle: '${l.teamMembers(members.length)} · ${annual ? l.commonAnnual : l.commonMonthly}', date: date),
    footer: (ctx) => kit.footer(ctx),
    build: (ctx) => [
      for (final t in totals) ...[
        if (totals.length > 1) kit.overline(t.currency, top: 4),
        kit.keyFigures([
          (l.payTotalCost, f.money(t.cost * mult, t.currency, decimals: t.decimals)),
          (l.payGross, f.money(t.gross * mult, t.currency, decimals: t.decimals)),
          (l.payNetTotal, f.money(t.net * mult, t.currency, decimals: t.decimals)),
        ]),
        pw.SizedBox(height: 10),
      ],
      kit.overline(l.teamMembers(members.length), top: 8),
      kit.table(
        headers: [l.teamName, l.paySystemTitle, l.payGross, l.payNetTotal, l.segEmployer, l.payTotalCost],
        flex: [3, 1.2, 2, 2, 2, 2],
        right: {2, 3, 4, 5},
        rows: [
          for (final mbr in members)
            () {
              final r = mbr.compute();
              String n(double v) => f.number(v * mult, decimals: mbr.system.decimals);
              final name = mbr.name.isEmpty ? l.teamUnnamed : mbr.name;
              return [
                mbr.role.isEmpty ? name : '$name\n${mbr.role}',
                '${mbr.system.countryCode} · ${mbr.system.currency}',
                n(r.gross),
                r.net > 0 ? n(r.net) : '—',
                n(r.employerTotal),
                n(r.totalCost),
              ];
            }(),
        ],
      ),
      pw.SizedBox(height: 8),
      kit.paragraph(l.teamNote),
      if (totals.length > 1) kit.paragraph(l.teamCurrenciesNote),
    ],
  ));
  return doc.save();
}

// ------------------------------------------------------------------ invoice

enum InvoiceLanguage { app, english, bilingual }

const _invoiceLanguageKey = 'invoice.pdfLanguage.v1';

/// Shares an invoice PDF. When the app is not in English, asks whether to
/// print it in the app language, in English, or in both.
Future<void> shareInvoicePdf(BuildContext context, Invoice inv) async {
  final l = context.l10n;
  final locale = Localizations.localeOf(context);
  final store = context.read<AppServices>().store;
  var choice = InvoiceLanguage.app;
  if (locale.languageCode != 'en') {
    final last = InvoiceLanguage.values.where((v) => v.name == store.getString(_invoiceLanguageKey)).firstOrNull ?? InvoiceLanguage.app;
    final picked = await _pickInvoiceLanguage(context, AppLanguage.fromLocale(locale).nativeName, last);
    if (picked == null || !context.mounted) return;
    choice = picked;
    await store.setString(_invoiceLanguageKey, picked.name);
    if (!context.mounted) return;
  }
  final profile = context.read<BusinessStore>().profile;
  final serbian = context.read<SettingsController>().country.code == 'RS';
  final branded = !context.read<ProController>().isPro;
  final english = lookupAppLocalizations(const Locale('en'));
  final primary = choice == InvoiceLanguage.english ? english : l;
  final secondary = choice == InvoiceLanguage.bilingual ? english : null;
  final formats = choice == InvoiceLanguage.english ? Formats('en') : context.fmt;
  try {
    final fonts = await ReportFonts.load();
    final bytes = await buildInvoicePdf(
      ReportKit(fonts: fonts, l: primary, f: formats, branded: branded),
      inv,
      profile,
      serbian: serbian,
      secondary: secondary,
    );
    await Printing.sharePdf(bytes: bytes, filename: '${_safeName('${primary.invDocTitle}-${inv.number}')}.pdf');
  } catch (e) {
    debugPrint('Invoice PDF failed: $e');
    if (context.mounted) showSnack(context, l.errorPdf);
  }
}

Future<InvoiceLanguage?> _pickInvoiceLanguage(BuildContext context, String appLanguage, InvoiceLanguage current) {
  final l = context.l10n;
  return showModalBottomSheet<InvoiceLanguage>(
    context: context,
    useSafeArea: true,
    builder: (context) {
      final t = Theme.of(context).textTheme;
      Widget option(InvoiceLanguage v, String label) => ListTile(
            title: Text(label, style: t.titleMedium),
            trailing: v == current ? const Icon(Icons.check) : null,
            onTap: () => Navigator.of(context).pop(v),
          );
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 8), child: Text(l.pdfLanguageTitle, style: t.titleLarge)),
            option(InvoiceLanguage.app, appLanguage),
            option(InvoiceLanguage.english, 'English'),
            option(InvoiceLanguage.bilingual, l.pdfLanguageBoth(appLanguage)),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

Future<Uint8List> buildInvoicePdf(
  ReportKit kit,
  Invoice inv,
  BusinessProfile profile, {
  required bool serbian,
  AppLocalizations? secondary,
}) async {
  final l = kit.l;
  final f = kit.f;
  final s = secondary;
  final cur = inv.currency;
  // "Primary / Secondary" labels for bilingual invoices.
  String t(String Function(AppLocalizations x) pick) {
    final a = pick(l);
    if (s == null) return a;
    final b = pick(s);
    return a == b ? a : '$a / $b';
  }

  String m(double v) => f.money(v, cur);
  final seller = profile.party;
  final payment = PaymentDetails.of(profile, inv);
  final qr = serbian && inv.status != InvoiceStatus.paid && inv.status != InvoiceStatus.cancelled
      ? invoiceIpsQr(inv, profile, purposeLabel: l.invDocTitle)
      : null;
  final showVat = inv.vatRegistered;
  String qty(double q) {
    if (q == q.roundToDouble()) return f.number(q, decimals: 0);
    final str = q.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '');
    return f.number(q, decimals: str.length - str.indexOf('.') - 1);
  }

  pw.Widget partyBlock(InvoiceParty p, {required bool isSeller}) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(p.name.isEmpty ? '—' : p.name, style: isSeller ? kit.serif(16, semibold: true) : kit.strong.copyWith(fontSize: 11)),
          pw.SizedBox(height: 2),
          for (final line in [p.address, p.city, p.country])
            if (line.trim().isNotEmpty) pw.Text(line, style: kit.body),
          if (p.taxId.isNotEmpty || p.registrationNo.isNotEmpty)
            pw.Text(
              [
                if (p.taxId.isNotEmpty) '${serbian ? t((x) => x.invPib) : t((x) => x.profTaxIdGeneric)}: ${p.taxId}',
                if (p.registrationNo.isNotEmpty) '${serbian ? t((x) => x.invMb) : t((x) => x.profRegNoGeneric)}: ${p.registrationNo}',
              ].join('   '),
              style: kit.body,
            ),
          if (isSeller && (p.email.isNotEmpty || profile.phone.isNotEmpty))
            pw.Text([if (p.email.isNotEmpty) p.email, if (profile.phone.isNotEmpty) profile.phone].join(' · '), style: kit.body),
          if (!isSeller && p.email.isNotEmpty) pw.Text(p.email, style: kit.body),
        ],
      );

  pw.Widget meta(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2.5),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.SizedBox(width: 96, child: pw.Text(label, style: kit.small)),
            pw.Text(value, style: kit.body),
          ],
        ),
      );

  final headers = [
    '#',
    t((x) => x.invColItem),
    t((x) => x.invColQty),
    t((x) => x.invItemUnit),
    t((x) => x.invColPrice),
    if (showVat) t((x) => x.invItemVat),
    t((x) => x.invColAmount),
  ];
  final lines = inv.lines;
  final rows = <List<String>>[
    for (var i = 0; i < lines.length; i++)
      [
        '${i + 1}',
        lines[i].description,
        qty(lines[i].quantity),
        lines[i].unit,
        f.number(lines[i].unitPrice, decimals: Formats.currencyDecimals(cur)),
        if (showVat) f.percentValue(lines[i].vatPercent, decimals: lines[i].vatPercent == lines[i].vatPercent.roundToDouble() ? 0 : 1),
        f.number(lines[i].net, decimals: Formats.currencyDecimals(cur)),
      ],
  ];

  final statements = <String>[
    if (!inv.vatRegistered) t((x) => x.invNotInVat),
    t((x) => x.invValidWithoutStamp),
  ];

  final doc = kit.document('${l.invDocTitle} ${inv.number}');
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(44, 40, 44, 36),
    footer: (ctx) => kit.footer(ctx, note: kit.branded ? l.invCreatedWith : ''),
    build: (ctx) => [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(child: partyBlock(seller, isSeller: true)),
          pw.SizedBox(width: 16),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(t((x) => x.invDocTitle).toUpperCase(), style: kit.label.copyWith(fontSize: 8, letterSpacing: 1.6)),
              pw.SizedBox(height: 2),
              pw.Text(inv.number, style: kit.serif(22, semibold: true)),
              if (inv.status == InvoiceStatus.cancelled)
                pw.Text(t((x) => x.statusCancelled).toUpperCase(), style: kit.strong.copyWith(color: const PdfColor.fromInt(0xFFA5402B))),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 14),
      pw.Container(height: 0.6, color: PdfInk.line),
      pw.SizedBox(height: 12),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(t((x) => x.invBuyer).toUpperCase(), style: kit.label),
                pw.SizedBox(height: 4),
                partyBlock(inv.client, isSeller: false),
              ],
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              meta(t((x) => x.invIssueDate), f.date(inv.issueDate)),
              meta(t((x) => x.invServiceDate), f.date(inv.serviceDate)),
              meta(t((x) => x.invDueDate), f.date(inv.dueDate)),
              if (inv.place.isNotEmpty) meta(t((x) => x.invPlace), inv.place),
              meta(t((x) => x.invCurrency), cur),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 18),
      kit.table(
        headers: headers,
        rows: rows,
        flex: showVat ? [0.5, 5, 1.1, 0.9, 1.7, 0.9, 1.9] : [0.5, 5.6, 1.1, 0.9, 1.8, 2],
        right: showVat ? {2, 4, 5, 6} : {2, 4, 5},
      ),
      pw.SizedBox(height: 8),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Spacer(flex: 5),
          pw.Expanded(
            flex: 5,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                if (showVat) ...[
                  kit.row(t((x) => x.invSubtotal), m(inv.netTotal)),
                  kit.row(t((x) => x.invVat), m(inv.vatTotal), divider: false),
                ],
                kit.total(t((x) => x.invTotalDue), m(inv.total), size: 15),
              ],
            ),
          ),
        ],
      ),
      if (serbian && cur != 'RSD' && inv.totalRsd != null)
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${t((x) => x.invTotalRsd)}: ${f.money(inv.totalRsd!, 'RSD')}\n'
            '${t((x) => x.invRateLine(f.rate(inv.rsdRate!), f.date(inv.rsdRateDate ?? inv.issueDate)))}',
            style: kit.small,
            textAlign: pw.TextAlign.right,
          ),
        ),
      pw.SizedBox(height: 18),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (!payment.isEmpty) ...[
                  pw.Text(t((x) => x.profSectionPayment).toUpperCase(), style: kit.label),
                  pw.SizedBox(height: 4),
                  if (payment.account != null) meta(t((x) => x.invAccount), payment.account!),
                  if (payment.iban != null) meta('IBAN', payment.iban!),
                  if (payment.swift != null) meta('SWIFT/BIC', payment.swift!),
                  if (payment.bank != null) meta(t((x) => x.invBank), payment.bank!),
                  if (payment.reference != null) meta(t((x) => x.invReferenceLabel), payment.reference!),
                ],
                if (inv.note.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Text(inv.note, style: kit.body),
                ],
                pw.SizedBox(height: 10),
                for (final st in statements) pw.Text(st, style: kit.small),
              ],
            ),
          ),
          if (qr?.payload != null) ...[
            pw.SizedBox(width: 16),
            pw.Column(
              children: [
                pw.BarcodeWidget(
                  barcode: Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium),
                  data: qr!.payload!,
                  width: 30 * PdfPageFormat.mm,
                  height: 30 * PdfPageFormat.mm,
                  drawText: false,
                ),
                pw.SizedBox(height: 4),
                pw.SizedBox(width: 30 * PdfPageFormat.mm, child: pw.Text(t((x) => x.invQrCaption), style: kit.small, textAlign: pw.TextAlign.center)),
              ],
            ),
          ],
        ],
      ),
    ],
  ));
  return doc.save();
}
