import '../../../shared/constants/unit.dart';

/// Utility class for converting between distance units
class UnitConverter {
  /// Convert kilometers to miles
  /// 1 kilometer = 0.621371 miles
  static double kmToMi(double km) {
    return km * 0.621371;
  }

  /// Convert miles to kilometers
  /// 1 mile = 1.60934 kilometers
  static double miToKm(double mi) {
    return mi * 1.60934;
  }

  /// Convert a value from one unit to another
  static double convert(double value, DistanceUnit from, DistanceUnit to) {
    if (from == to) return value;

    // Convert to kilometers first, then to target unit
    double kmValue;
    switch (from) {
      case DistanceUnit.km:
        kmValue = value;
        break;
      case DistanceUnit.mi:
        kmValue = miToKm(value);
        break;
    }

    // Convert from kilometers to target unit
    switch (to) {
      case DistanceUnit.km:
        return kmValue;
      case DistanceUnit.mi:
        return kmToMi(kmValue);
    }
  }

  /// Format a distance value with the appropriate unit
  /// Returns a formatted string like "50,000 km" or "31,069 mi"
  static String formatDistance(int valueInKm, DistanceUnit unit) {
    double convertedValue;
    switch (unit) {
      case DistanceUnit.km:
        convertedValue = valueInKm.toDouble();
        break;
      case DistanceUnit.mi:
        convertedValue = kmToMi(valueInKm.toDouble());
        break;
    }

    // Format with comma separators
    final valueStr = _formatNumber(convertedValue.round());
    return '$valueStr ${unit.displayName}';
  }

  /// Format a number with comma separators
  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Get the appropriate unit label for display
  static String getUnitLabel(DistanceUnit unit) {
    return unit.displayName;
  }
}
