/// Distance unit enum
enum DistanceUnit {
  /// Kilometers
  km,

  /// Miles
  mi,
}

/// Extension to provide display names for distance units
extension DistanceUnitExtension on DistanceUnit {
  /// Get the display name for the unit
  String get displayName {
    switch (this) {
      case DistanceUnit.km:
        return 'km';
      case DistanceUnit.mi:
        return 'mi';
    }
  }

  /// Get the full name for the unit
  String get fullName {
    switch (this) {
      case DistanceUnit.km:
        return 'Kilometers';
      case DistanceUnit.mi:
        return 'Miles';
    }
  }
}
