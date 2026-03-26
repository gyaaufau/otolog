import 'package:flutter/material.dart';
import 'colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color surface;
  final Color onSurface;
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color inputBackground;
  final Color hintText;
  final Color border;
  final Color focusedBorder;
  final Color error;
  final Color onError;
  final Color icon;
  final Color appBarBackground;
  final Color appBarForeground;

  const AppThemeExtension({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.surface,
    required this.onSurface,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.inputBackground,
    required this.hintText,
    required this.border,
    required this.focusedBorder,
    required this.error,
    required this.onError,
    required this.icon,
    required this.appBarBackground,
    required this.appBarForeground,
  });

  AppThemeExtension.light()
    : primary = AppColors.primary,
      onPrimary = Colors.white,
      secondary = AppColors.secondary,
      onSecondary = Colors.white,
      tertiary = AppColors.tertiary,
      onTertiary = Colors.white,
      surface = AppColors.neutral[50]!,
      onSurface = AppColors.neutral[900]!,
      scaffoldBackground = AppColors.neutral[50]!,
      cardBackground = Colors.white,
      inputBackground = AppColors.neutral[50]!,
      hintText = AppColors.neutral[400]!,
      border = AppColors.neutral[200]!,
      focusedBorder = AppColors.primary,
      error = Colors.red,
      onError = Colors.white,
      icon = AppColors.neutral[700]!,
      appBarBackground = AppColors.primary,
      appBarForeground = Colors.white;

  AppThemeExtension.dark()
    : primary = AppColors.primary[400]!,
      onPrimary = Colors.white,
      secondary = AppColors.secondary[400]!,
      onSecondary = Colors.white,
      tertiary = AppColors.tertiary[400]!,
      onTertiary = Colors.white,
      surface = AppColors.neutral[800]!,
      onSurface = AppColors.neutral[50]!,
      scaffoldBackground = AppColors.neutral[900]!,
      cardBackground = AppColors.neutral[800]!,
      inputBackground = AppColors.neutral[800]!,
      hintText = AppColors.neutral[400]!,
      border = AppColors.neutral[600]!,
      focusedBorder = AppColors.primary[400]!,
      error = Colors.red[400]!,
      onError = Colors.white,
      icon = AppColors.neutral[50]!,
      appBarBackground = AppColors.neutral[800]!,
      appBarForeground = AppColors.neutral[50]!;

  @override
  AppThemeExtension copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? surface,
    Color? onSurface,
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? inputBackground,
    Color? hintText,
    Color? border,
    Color? focusedBorder,
    Color? error,
    Color? onError,
    Color? icon,
    Color? appBarBackground,
    Color? appBarForeground,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      inputBackground: inputBackground ?? this.inputBackground,
      hintText: hintText ?? this.hintText,
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      icon: icon ?? this.icon,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarForeground: appBarForeground ?? this.appBarForeground,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      border: Color.lerp(border, other.border, t)!,
      focusedBorder: Color.lerp(focusedBorder, other.focusedBorder, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      appBarForeground:
          Color.lerp(appBarForeground, other.appBarForeground, t)!,
    );
  }

  static AppThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>()!;
  }
}
