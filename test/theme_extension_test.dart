import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otolog/resources/app_theme_extension.dart';

void main() {
  group('AppThemeExtension', () {
    test('light theme should have correct colors', () {
      final lightTheme = AppThemeExtension.light();

      expect(lightTheme.primary, isNotNull);
      expect(lightTheme.onPrimary, Colors.white);
      expect(lightTheme.secondary, isNotNull);
      expect(lightTheme.onSecondary, Colors.white);
      expect(lightTheme.tertiary, isNotNull);
      expect(lightTheme.onTertiary, Colors.white);
      expect(lightTheme.error, Colors.red);
      expect(lightTheme.onError, Colors.white);
    });

    test('dark theme should have correct colors', () {
      final darkTheme = AppThemeExtension.dark();

      expect(darkTheme.primary, isNotNull);
      expect(darkTheme.onPrimary, Colors.white);
      expect(darkTheme.secondary, isNotNull);
      expect(darkTheme.onSecondary, Colors.white);
      expect(darkTheme.tertiary, isNotNull);
      expect(darkTheme.onTertiary, Colors.white);
      expect(darkTheme.error, isNotNull);
      expect(darkTheme.onError, Colors.white);
    });

    test('lerp should interpolate between light and dark themes', () {
      final lightTheme = AppThemeExtension.light();
      final darkTheme = AppThemeExtension.dark();

      // Test interpolation at 0% (should be light theme)
      final t0 = lightTheme.lerp(darkTheme, 0.0);
      expect(t0.primary, lightTheme.primary);

      // Test interpolation at 100% (should be dark theme)
      final t1 = lightTheme.lerp(darkTheme, 1.0);
      expect(t1.primary, darkTheme.primary);

      // Test interpolation at 50%
      final t05 = lightTheme.lerp(darkTheme, 0.5);
      expect(t05.primary, isNotNull);
      expect(t05.primary, isNot(lightTheme.primary));
      expect(t05.primary, isNot(darkTheme.primary));
    });

    test('copyWith should create new instance with updated values', () {
      final original = AppThemeExtension.light();
      final modified = original.copyWith(primary: Colors.red);

      expect(modified.primary, Colors.red);
      expect(modified.onPrimary, original.onPrimary);
      expect(modified.secondary, original.secondary);
    });

    test('lerp with non-AppThemeExtension should return self', () {
      final lightTheme = AppThemeExtension.light();
      final result = lightTheme.lerp(null, 0.5);

      expect(result, lightTheme);
    });

    test('lerp should handle all color properties', () {
      final lightTheme = AppThemeExtension.light();
      final darkTheme = AppThemeExtension.dark();
      final interpolated = lightTheme.lerp(darkTheme, 0.5);

      // Verify all color properties are interpolated
      expect(interpolated.primary, isNotNull);
      expect(interpolated.onPrimary, isNotNull);
      expect(interpolated.secondary, isNotNull);
      expect(interpolated.onSecondary, isNotNull);
      expect(interpolated.tertiary, isNotNull);
      expect(interpolated.onTertiary, isNotNull);
      expect(interpolated.surface, isNotNull);
      expect(interpolated.onSurface, isNotNull);
      expect(interpolated.scaffoldBackground, isNotNull);
      expect(interpolated.cardBackground, isNotNull);
      expect(interpolated.inputBackground, isNotNull);
      expect(interpolated.hintText, isNotNull);
      expect(interpolated.border, isNotNull);
      expect(interpolated.focusedBorder, isNotNull);
      expect(interpolated.error, isNotNull);
      expect(interpolated.onError, isNotNull);
      expect(interpolated.icon, isNotNull);
      expect(interpolated.appBarBackground, isNotNull);
      expect(interpolated.appBarForeground, isNotNull);
    });
  });
}
