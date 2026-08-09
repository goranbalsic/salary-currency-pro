import 'bootstrap.dart';
import 'config/app_flavor.dart';

/// The `prod` flavor's entrypoint — run via
/// `flutter run --flavor prod -t lib/main_prod.dart`. Production-equivalent
/// QA and the eventual Play release: no developer override, selector,
/// hidden route, or preference bypass exists — [EntitlementService] always
/// talks to the real (or, pre-Play-Console, honestly "unavailable") billing
/// adapter, and the Entitlement Preview Settings section is compile-time
/// absent (see `AppConfig.isDev` gates throughout the Settings screen).
void main() async {
  AppConfig.initialize(AppFlavor.prod);
  await bootstrap();
}
