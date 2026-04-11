import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing first-launch onboarding visibility.
class OnboardingRepository {
  static const String _completedKey = 'onboarding_completed';

  /// Returns `true` when onboarding has already been completed.
  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  /// Marks onboarding as completed so it won't show again on next launch.
  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, true);
  }

  /// Clears the onboarding completion flag. Useful for debugging or tests.
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedKey);
  }
}
