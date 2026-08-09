import 'bootstrap.dart';
import 'config/app_flavor.dart';

/// The `dev` flavor's entrypoint — run via
/// `flutter run --flavor dev -t lib/main_dev.dart`. Owner/local-QA only:
/// distinct application ID (`applicationIdSuffix ".dev"`, see
/// `android/app/build.gradle.kts`), distinct app label/icon (see
/// `android/app/src/dev/res/`), and — via [AppConfig.flavor] —
/// [EntitlementService] runs in simulated-entitlement mode (defaults to
/// fully unlocked Pro, overridable via Settings → Entitlement Preview)
/// instead of talking to real Play Billing. See DECISIONS.md D-034.
void main() async {
  AppConfig.initialize(AppFlavor.dev);
  await bootstrap();
}
