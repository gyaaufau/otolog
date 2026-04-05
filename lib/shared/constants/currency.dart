/// Currency symbol enum
enum Currency {
  /// US Dollar
  usd,

  /// Euro
  eur,

  /// British Pound
  gbp,

  /// Japanese Yen
  jpy,

  /// Indonesian Rupiah
  idr,

  /// Singapore Dollar
  sgd,

  /// Malaysian Ringgit
  myr,

  /// Australian Dollar
  aud,

  /// Canadian Dollar
  cad,

  /// Indian Rupee
  inr,

  /// Chinese Yuan
  cny,

  /// Thai Baht
  thb,
}

/// Extension to provide display names for currency symbols
extension CurrencyExtension on Currency {
  /// Get the currency symbol
  String get symbol {
    switch (this) {
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
      case Currency.gbp:
        return '£';
      case Currency.jpy:
        return '¥';
      case Currency.idr:
        return 'Rp';
      case Currency.sgd:
        return 'S\$';
      case Currency.myr:
        return 'RM';
      case Currency.aud:
        return 'A\$';
      case Currency.cad:
        return 'C\$';
      case Currency.inr:
        return '₹';
      case Currency.cny:
        return '¥';
      case Currency.thb:
        return '฿';
    }
  }

  /// Get the currency code
  String get code {
    switch (this) {
      case Currency.usd:
        return 'USD';
      case Currency.eur:
        return 'EUR';
      case Currency.gbp:
        return 'GBP';
      case Currency.jpy:
        return 'JPY';
      case Currency.idr:
        return 'IDR';
      case Currency.sgd:
        return 'SGD';
      case Currency.myr:
        return 'MYR';
      case Currency.aud:
        return 'AUD';
      case Currency.cad:
        return 'CAD';
      case Currency.inr:
        return 'INR';
      case Currency.cny:
        return 'CNY';
      case Currency.thb:
        return 'THB';
    }
  }

  /// Get the full name for the currency
  String get fullName {
    switch (this) {
      case Currency.usd:
        return 'US Dollar';
      case Currency.eur:
        return 'Euro';
      case Currency.gbp:
        return 'British Pound';
      case Currency.jpy:
        return 'Japanese Yen';
      case Currency.idr:
        return 'Indonesian Rupiah';
      case Currency.sgd:
        return 'Singapore Dollar';
      case Currency.myr:
        return 'Malaysian Ringgit';
      case Currency.aud:
        return 'Australian Dollar';
      case Currency.cad:
        return 'Canadian Dollar';
      case Currency.inr:
        return 'Indian Rupee';
      case Currency.cny:
        return 'Chinese Yuan';
      case Currency.thb:
        return 'Thai Baht';
    }
  }
}
