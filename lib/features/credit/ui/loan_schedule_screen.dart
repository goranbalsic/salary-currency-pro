import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/controls.dart';
import '../../../l10n/l10n.dart';
import '../../pro/pro_controller.dart';
import '../../pro/pro_gate.dart';
import '../../reports/pdf_reports.dart';
import '../domain/loan_engine.dart';

class LoanScheduleScreen extends StatelessWidget {
  const LoanScheduleScreen({super.key, required this.result, required this.currency});

  final LoanResult result;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final pro = context.watch<ProController>();
    final cell = t.bodyMedium!.copyWith(fontFeatures: Fonts.tabular, fontSize: 13.5);
    final head = t.labelSmall!;
    Widget row(List<String> v, {bool header = false}) => Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: Gap.page, vertical: 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: header ? c.ink : c.line))),
          child: Row(
            children: [
              SizedBox(width: 34, child: Text(v[0], style: header ? head : cell)),
              for (var i = 1; i < v.length; i++)
                Expanded(child: Text(v[i], textAlign: TextAlign.right, style: header ? head : cell, maxLines: 1)),
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(l.loanSchedule),
        actions: [
          IconButton(
            tooltip: l.actionDownloadPdf,
            onPressed: () async {
              if (!await requirePro(context, ProFeature.pdfExport) || !context.mounted) return;
              await shareLoanPdf(context, result, currency);
            },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.picture_as_pdf_outlined), if (!pro.can(ProFeature.pdfExport)) ...[const SizedBox(width: 4), const ProBadge()]],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          row([l.loanColNo, l.loanColInstallment.toUpperCase(), l.loanColInterest.toUpperCase(), l.loanColBalance.toUpperCase()], header: true),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: result.rows.length,
                padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 16),
                itemBuilder: (context, i) {
                  final r = result.rows[i];
                  return Semantics(
                    label: '${l.loanColNo} ${r.index}: ${l.loanColInstallment} ${f.money(r.outflow, currency)}, ${l.loanColInterest} ${f.money(r.interest, currency)}, ${l.loanColBalance} ${f.money(r.balance, currency)}',
                    excludeSemantics: true,
                    child: row(['${r.index}', f.number(r.outflow), f.number(r.interest), f.number(r.balance)]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
