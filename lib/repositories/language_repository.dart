import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing language persistence
class LanguageRepository {
  static const String _localeKey = 'app_locale';

  /// Save the selected locale to persistent storage
  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.toString());
  }

  /// Get the saved locale from persistent storage
  /// Returns null if no locale has been saved
  Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);

    if (localeString == null) {
      return null;
    }

    try {
      // Parse the locale string (format: "en" or "en_US")
      final parts = localeString.split('_');
      if (parts.length == 1) {
        return Locale(parts[0]);
      } else if (parts.length == 2) {
        return Locale(parts[0], parts[1]);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Clear the saved locale (reset to default)
  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}
