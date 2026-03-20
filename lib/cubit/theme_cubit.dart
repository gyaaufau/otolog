import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);

    if (themeModeString != null) {
      final themeMode = _parseThemeMode(themeModeString);
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  ThemeMode _parseThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeModeToString(themeMode));
    emit(state.copyWith(themeMode: themeMode));
  }

  void toggleTheme() {
    final currentMode = state.themeMode;
    ThemeMode newMode;

    if (currentMode == ThemeMode.light) {
      newMode = ThemeMode.dark;
    } else if (currentMode == ThemeMode.dark) {
      newMode = ThemeMode.system;
    } else {
      newMode = ThemeMode.light;
    }

    setThemeMode(newMode);
  }
}
