import 'bootstrap.dart';
import 'config/app_flavor.dart';

/// The bare/default entrypoint (`flutter run` with no `-t`, and any
/// existing tooling — VS Code launch configs, `flutter run` from a
/// terminal — that doesn't yet know about the dev/prod split). Explicitly
/// initializes the **prod** flavor so this default path can never
/// accidentally carry the dev entitlement-simulation bypass — see
/// `main_dev.dart`/`main_prod.dart` for the two flavor-specific
/// entrypoints PROMPT-003J checkpoint 1 adds, and
/// `_userprompts/PROMPT-003G_Release_Readiness_Developer_Builds_v2.md`
/// (recorded as PROMPT-003J — see DECISIONS.md D-033/D-034 for the ID
/// note) for the full requirement this satisfies.
void main() async {
  AppConfig.initialize(AppFlavor.prod);
  await bootstrap();
}
