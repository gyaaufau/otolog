import 'package:shared_preferences/shared_preferences.dart';
import '../shared/constants/unit.dart';

/// Repository for managing distance unit persistence
class UnitRepository {
  static const String _unitKey = 'distance_unit';

  /// Save the selected distance unit to persistent storage
  Future<void> saveUnit(DistanceUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit.name);
  }

  /// Get the saved distance unit from persistent storage
  /// Returns null if no unit has been saved
  Future<DistanceUnit?> getSavedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final unitString = prefs.getString(_unitKey);

    if (unitString == null) {
      return null;
    }

    try {
      return DistanceUnit.values.firstWhere((unit) => unit.name == unitString);
    } catch (e) {
      return null;
    }
  }

  /// Clear the saved unit (reset to default)
  Future<void> clearUnit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unitKey);
  }
}
