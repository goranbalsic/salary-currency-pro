import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/salary_calculator.dart';
import '../models/country.dart';
import '../models/tax_config.dart';
import '../services/tax_config_service.dart';
import '../utils/validators.dart';

enum SalaryCalcMode { grossToNet, netToGross }

enum ConfigLoadStatus { loading, ready, error }

/// Max sane monthly salary in any local currency — anything above this is
/// flagged as a likely typo rather than silently calculated.
const double kMaxSalaryAmount = 100000000;

/// Shared across the salary calculator and onboarding (which pre-selects a
/// country before this provider is ever constructed) — kept as one public
/// constant so both stay pointed at the same stored value.
const prefsCountryKey = 'salary_selected_country_id';
const prefsEntityKey = 'salary_selected_entity_id';

class SalaryCalculatorProvider extends ChangeNotifier {
  final TaxConfigService _configService;
  final String? _initialCountryId;
  final String? _initialEntityId;
  double? _initialSurtaxRate;

  SalaryCalculatorProvider({
    TaxConfigService? configService,
    SalaryCalcMode? initialMode,
    String? initialAmountText,
    this._initialCountryId,
    this._initialEntityId,
    this._initialSurtaxRate,
  }) : _configService = configService ?? TaxConfigService() {
    if (initialMode != null) mode = initialMode;
    if (initialAmountText != null) amountText = initialAmountText;
    _restoreSelectionAndLoad();
  }

  ConfigLoadStatus configStatus = ConfigLoadStatus.loading;
  String? configError;
  CountryTaxConfig? config;

  Country selectedCountry = countryById('rs');
  CountryEntity? selectedEntity;

  /// User-adjustable local surtax rate (Croatia's municipal "prirez" is the
  /// only case today); null means "use the config default".
  double? localSurtaxRate;

  SalaryCalcMode mode = SalaryCalcMode.grossToNet;
  String amountText = '';
  AmountIssue? amountIssue;
  SalaryBreakdown? result;

  Future<void> _restoreSelectionAndLoad() async {
    if (_initialCountryId != null) {
      final match = kCountries.where((c) => c.id == _initialCountryId);
      if (match.isNotEmpty) selectedCountry = match.first;
      if (selectedCountry.hasEntities) {
        final entities = selectedCountry.entities!;
        selectedEntity = entities.firstWhere(
          (e) => e.id == _initialEntityId,
          orElse: () => entities.first,
        );
      }
    } else {
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedCountryId = prefs.getString(prefsCountryKey);
        if (savedCountryId != null) {
          final match = kCountries.where((c) => c.id == savedCountryId);
          if (match.isNotEmpty) selectedCountry = match.first;
        }
        if (selectedCountry.hasEntities) {
          final savedEntityId = prefs.getString(prefsEntityKey);
          final entities = selectedCountry.entities!;
          selectedEntity = entities.firstWhere(
            (e) => e.id == savedEntityId,
            orElse: () => entities.first,
          );
        }
      } catch (_) {
        // shared_preferences unavailable — fall back to the default country.
      }
    }
    await _loadConfig();
  }

  String get _configId => selectedEntity?.id ?? selectedCountry.id;

  String get _configAsset => selectedCountry.hasEntities
      ? (selectedEntity ?? selectedCountry.entities!.first).taxConfigAsset
      : selectedCountry.taxConfigAsset!;

  Future<void> _loadConfig() async {
    configStatus = ConfigLoadStatus.loading;
    notifyListeners();
    try {
      config = await _configService.load(_configId, _configAsset);
      configStatus = ConfigLoadStatus.ready;
      localSurtaxRate = _initialSurtaxRate ?? config!.localSurtax?.defaultRate;
      _initialSurtaxRate = null;
    } on TaxConfigUnavailableException catch (e) {
      configError = e.message;
      configStatus = ConfigLoadStatus.error;
    } catch (e) {
      configError = 'Unexpected error loading tax configuration: $e';
      configStatus = ConfigLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> retryLoadConfig() => _loadConfig();

  Future<void> selectCountry(Country country) async {
    if (country.id == selectedCountry.id) return;
    selectedCountry = country;
    selectedEntity = country.hasEntities ? country.entities!.first : null;
    _clearStaleResult();
    unawaited(_persistSelection());
    await _loadConfig();
  }

  Future<void> selectEntity(CountryEntity entity) async {
    if (selectedEntity?.id == entity.id) return;
    selectedEntity = entity;
    _clearStaleResult();
    unawaited(_persistSelection());
    await _loadConfig();
  }

  void setLocalSurtaxRate(double rate) {
    localSurtaxRate = rate;
    _clearStaleResult();
    notifyListeners();
  }

  Future<void> _persistSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefsCountryKey, selectedCountry.id);
      if (selectedEntity != null) {
        await prefs.setString(prefsEntityKey, selectedEntity!.id);
      }
    } catch (_) {
      // Best-effort persistence only.
    }
  }

  void setMode(SalaryCalcMode newMode) {
    if (newMode == mode) return;
    mode = newMode;
    _clearStaleResult();
    notifyListeners();
  }

  void setAmount(String text) {
    amountText = text;
    _clearStaleResult();
    notifyListeners();
  }

  void _clearStaleResult() {
    result = null;
    amountIssue = null;
  }

  void calculate() {
    final cfg = config;
    if (cfg == null) return;

    final parsed = parseAmountInput(
      amountText,
      max: kMaxSalaryAmount,
      allowZero: false,
    );
    amountIssue = parsed.issue;
    if (!parsed.isValid) {
      result = null;
      notifyListeners();
      return;
    }

    final calculator = SalaryCalculator(
      cfg,
      localSurtaxRateOverride: localSurtaxRate,
    );
    result = mode == SalaryCalcMode.grossToNet
        ? calculator.fromBruto(parsed.value!)
        : calculator.fromNeto(parsed.value!);
    notifyListeners();
  }
}
