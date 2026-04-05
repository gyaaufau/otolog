import 'package:shared_preferences/shared_preferences.dart';
import '../shared/constants/currency.dart';

/// Repository for managing currency symbol persistence
class CurrencyRepository {
  static const String _currencyKey = 'currency_symbol';

  /// Save the selected currency symbol to persistent storage
  Future<void> saveCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency.name);
  }

  /// Get the saved currency symbol from persistent storage
  /// Returns null if no currency has been saved
  Future<Currency?> getSavedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyString = prefs.getString(_currencyKey);

    if (currencyString == null) {
      return null;
    }

    try {
      return Currency.values.firstWhere(
        (currency) => currency.name == currencyString,
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear the saved currency (reset to default)
  Future<void> clearCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currencyKey);
  }
}
