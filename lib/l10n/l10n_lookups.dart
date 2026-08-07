import 'package:flutter/material.dart';

import '../models/expense_entry.dart';
import 'app_localizations.dart';

/// Maps a [Country.id] to its localized display name. Country/entity ids
/// are stable identifiers (see lib/models/country.dart); the display text
/// lives here instead of on the model so it can vary by app language.
String localizedCountryName(AppLocalizations l10n, String countryId) {
  switch (countryId) {
    case 'rs':
      return l10n.countryRs;
    case 'hr':
      return l10n.countryHr;
    case 'ba':
      return l10n.countryBa;
    case 'me':
      return l10n.countryMe;
    case 'mk':
      return l10n.countryMk;
    case 'si':
      return l10n.countrySi;
    case 'bg':
      return l10n.countryBg;
    case 'al':
      return l10n.countryAl;
    case 'ro':
      return l10n.countryRo;
    default:
      return countryId;
  }
}

/// Maps a [CountryEntity.id] to its localized display name.
String localizedEntityName(AppLocalizations l10n, String entityId) {
  switch (entityId) {
    case 'fbih':
      return l10n.entityFbih;
    case 'republika_srpska':
      return l10n.entityRepublikaSrpska;
    default:
      return entityId;
  }
}

/// code -> native display name for every supported UI language. Deliberately
/// shown in each language's own script/name (not translated into the
/// current app language) — that's how every language picker in the wild
/// works, since a Bulgarian speaker needs to recognize "Български"
/// regardless of what language the UI is currently in. Shared by the
/// Settings language picker and onboarding, so both list the same set.
const kLanguageNames = <String, String>{
  'en': 'English',
  'sr': 'Srpski',
  'hr': 'Hrvatski',
  'bs': 'Bosanski',
  'mk': 'Македонски',
  'sl': 'Slovenščina',
  'bg': 'Български',
  'sq': 'Shqip',
  'ro': 'Română',
};

/// Maps a [ContributionRate.id] (from a country's tax config JSON) to its
/// localized display name. Falls back to the id itself for a concept not
/// yet covered here — new countries only need a new case if they introduce
/// a genuinely new contribution concept.
String localizedContributionLabel(AppLocalizations l10n, String contributionId) {
  switch (contributionId) {
    case 'pio':
      return l10n.contribPio;
    case 'health':
      return l10n.contribHealth;
    case 'unemployment':
      return l10n.contribUnemployment;
    case 'pension':
      return l10n.contribPension;
    case 'social':
      return l10n.contribSocial;
    case 'childProtection':
      return l10n.contribChildProtection;
    case 'healthAndEmployment':
      return l10n.contribHealthAndEmployment;
    case 'cas':
      return l10n.contribCas;
    case 'cass':
      return l10n.contribCass;
    case 'cam':
      return l10n.contribCam;
    default:
      return contributionId;
  }
}

/// Maps an [ExpenseCategories] id to its localized display name.
String localizedCategoryLabel(AppLocalizations l10n, String categoryId) {
  switch (categoryId) {
    case ExpenseCategories.housing:
      return l10n.catHousing;
    case ExpenseCategories.utilities:
      return l10n.catUtilities;
    case ExpenseCategories.groceries:
      return l10n.catGroceries;
    case ExpenseCategories.transport:
      return l10n.catTransport;
    case ExpenseCategories.health:
      return l10n.catHealth;
    case ExpenseCategories.education:
      return l10n.catEducation;
    case ExpenseCategories.entertainment:
      return l10n.catEntertainment;
    case ExpenseCategories.otherExpense:
      return l10n.catOtherExpense;
    case ExpenseCategories.salary:
      return l10n.catSalary;
    case ExpenseCategories.freelance:
      return l10n.catFreelance;
    case ExpenseCategories.otherIncome:
      return l10n.catOtherIncome;
    default:
      return categoryId;
  }
}

/// Icon shown next to a category in lists and pickers.
IconData categoryIcon(String categoryId) {
  switch (categoryId) {
    case ExpenseCategories.housing:
      return Icons.home_outlined;
    case ExpenseCategories.utilities:
      return Icons.bolt_outlined;
    case ExpenseCategories.groceries:
      return Icons.local_grocery_store_outlined;
    case ExpenseCategories.transport:
      return Icons.directions_bus_outlined;
    case ExpenseCategories.health:
      return Icons.local_hospital_outlined;
    case ExpenseCategories.education:
      return Icons.school_outlined;
    case ExpenseCategories.entertainment:
      return Icons.movie_outlined;
    case ExpenseCategories.salary:
      return Icons.account_balance_wallet_outlined;
    case ExpenseCategories.freelance:
      return Icons.laptop_mac_outlined;
    case ExpenseCategories.otherIncome:
    case ExpenseCategories.otherExpense:
    default:
      return Icons.more_horiz;
  }
}
