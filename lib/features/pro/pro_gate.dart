import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'paywall_screen.dart';
import 'pro_controller.dart';

/// Returns true when Pro is (or just became) active; otherwise shows the
/// paywall with [feature] as context and reports the outcome.
Future<bool> requirePro(BuildContext context, ProFeature feature) async {
  final pro = context.read<ProController>();
  if (pro.can(feature)) return true;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => PaywallScreen(feature: feature)),
  );
  return pro.can(feature);
}
