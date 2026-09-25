import 'app/app_config.dart';
import 'app/bootstrap.dart';

/// Development entry point: `flutter run --flavor dev -t lib/main_dev.dart`.
/// Installs next to the Play build and has a Pro simulator in Settings.
Future<void> main() async {
  AppConfig.flavor = Flavor.dev;
  await bootstrap();
}
