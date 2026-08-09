/// PROMPT-003J checkpoint 1's dev/prod build matrix. Set exactly once, by
/// whichever entrypoint (`main_dev.dart` / `main_prod.dart` / the default
/// `main.dart`, which is prod-safe) calls [AppConfig.initialize] as the
/// very first line of `main()` — never exposed as a Settings toggle or any
/// other runtime-editable preference. Every dev-only capability in this
/// app (the Entitlement Preview simulator, `EntitlementService`'s
/// simulated-entitlement mode) reads [AppConfig.flavor] to decide whether
/// it may exist at all, not just whether to show itself.
enum AppFlavor { dev, prod }

class AppConfig {
  AppConfig._();

  static AppFlavor _flavor = AppFlavor.prod;

  /// Must be called exactly once, before [WidgetsFlutterBinding.ensureInitialized]
  /// even, so every later line of startup can trust [flavor] is already
  /// correct. Defaults to [AppFlavor.prod] if never called at all (a bare
  /// `flutter run` with no `-t` target uses `main.dart`, which calls this
  /// with [AppFlavor.prod] explicitly) — the safe default is always
  /// production behavior, never an accidental dev bypass.
  static void initialize(AppFlavor flavor) {
    _flavor = flavor;
  }

  static AppFlavor get flavor => _flavor;
  static bool get isDev => _flavor == AppFlavor.dev;
}
