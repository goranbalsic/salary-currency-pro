import 'al_strategy.dart';
import 'ba_fbih_strategy.dart';
import 'ba_rs_strategy.dart';
import 'bg_strategy.dart';
import 'freelance_tax_strategy.dart';
import 'hr_strategy.dart';
import 'me_strategy.dart';
import 'mk_strategy.dart';
import 'ro_strategy.dart';
import 'rs_strategy.dart';
import 'si_strategy.dart';

/// One strategy instance per regime id — see [kFreelanceRegimeIds] in
/// freelance_tax_rules.dart for the fixed set of 10 ids this must cover.
const Map<String, FreelanceTaxStrategy> kFreelanceStrategies = {
  'rs': RsFreelanceStrategy(),
  'bg': BgFreelanceStrategy(),
  'hr': HrFreelanceStrategy(),
  'ba_fbih': BaFbihFreelanceStrategy(),
  'ba_rs': BaRsFreelanceStrategy(),
  'me': MeFreelanceStrategy(),
  'mk': MkFreelanceStrategy(),
  'si': SiFreelanceStrategy(),
  'al': AlFreelanceStrategy(),
  'ro': RoFreelanceStrategy(),
};

FreelanceTaxStrategy freelanceStrategyFor(String regimeId) {
  final s = kFreelanceStrategies[regimeId];
  if (s == null) {
    throw ArgumentError('No freelance tax strategy registered for "$regimeId".');
  }
  return s;
}
