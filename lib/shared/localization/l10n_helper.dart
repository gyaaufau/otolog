import 'package:flutter/material.dart';
import 'package:otolog/l10n/app_localizations.dart';

/// Helper class for accessing localization strings throughout the app.
///
/// Usage:
/// ```dart
/// // In a build method or any method with BuildContext
/// final l10n = L10n.of(context);
/// Text(l10n.home)
///
/// // Or use the extension method
/// Text(context.l10n.home)
/// ```
class L10n {
  L10n(this.locale);

  final Locale locale;

  /// Get the AppLocalizations instance for the given context.
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Get the current locale.
  static Locale currentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }
}

/// Extension on BuildContext to easily access localization strings.
///
/// Usage:
/// ```dart
/// Text(context.l10n.home)
/// ```
extension BuildContextL10nExtension on BuildContext {
  AppLocalizations get l10n => L10n.of(this);

  Locale get locale => L10n.currentLocale(this);
}

/// Supported locales for the application.
///
/// Add new locales here as you add more language support.
class AppLocales {
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    // Add more locales here in the future, e.g.:
    // Locale('id'), // Indonesian
    // Locale('es'), // Spanish
  ];

  /// Get the display name for a locale.
  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
