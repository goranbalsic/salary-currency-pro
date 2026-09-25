import 'app/app_config.dart';
import 'app/bootstrap.dart';

/// Production entry point (the build Google Play distributes).
Future<void> main() async {
  AppConfig.flavor = Flavor.prod;
  await bootstrap();
}
