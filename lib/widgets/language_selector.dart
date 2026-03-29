import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otolog/cubit/language_cubit.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

/// Widget for selecting the app language
///
/// This widget displays a dropdown menu with all supported languages
/// and allows the user to change the app language.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(context.l10n.language),
          subtitle: Text(_getLanguageDisplayName(state.locale)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context, state.locale),
        );
      },
    );
  }

  /// Show dialog to select language
  void _showLanguageDialog(BuildContext context, Locale currentLocale) {
    showDialog(
      context: context,
      builder:
          (context) => _LanguageSelectionDialog(currentLocale: currentLocale),
    );
  }

  /// Get display name for a locale
  String _getLanguageDisplayName(Locale locale) {
    return AppLocales.getLocaleDisplayName(locale);
  }
}

/// Dialog for language selection
class _LanguageSelectionDialog extends StatelessWidget {
  final Locale currentLocale;

  const _LanguageSelectionDialog({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.language),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AppLocales.supportedLocales.length,
          itemBuilder: (context, index) {
            final locale = AppLocales.supportedLocales[index];
            final isSelected = locale == currentLocale;
            final displayName = AppLocales.getLocaleDisplayName(locale);

            return RadioListTile<Locale>(
              value: locale,
              groupValue: currentLocale,
              title: Text(displayName),
              subtitle: Text(locale.languageCode.toUpperCase()),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  context.read<LanguageCubit>().changeLanguage(newLocale);
                  Navigator.of(context).pop();
                }
              },
              selected: isSelected,
              activeColor: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }
}

/// Compact version of language selector for use in settings cards
class CompactLanguageSelector extends StatelessWidget {
  const CompactLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.language),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.language,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLanguageDisplayName(state.locale),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButton<Locale>(
                  value: state.locale,
                  items:
                      AppLocales.supportedLocales.map((locale) {
                        return DropdownMenuItem<Locale>(
                          value: locale,
                          child: Text(_getLanguageDisplayName(locale)),
                        );
                      }).toList(),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      context.read<LanguageCubit>().changeLanguage(newLocale);
                    }
                  },
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get display name for a locale
  String _getLanguageDisplayName(Locale locale) {
    return AppLocales.getLocaleDisplayName(locale);
  }
}

/// Simple dropdown language selector
class DropdownLanguageSelector extends StatelessWidget {
  const DropdownLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return DropdownButtonFormField<Locale>(
          value: state.locale,
          decoration: InputDecoration(
            labelText: context.l10n.language,
            prefixIcon: const Icon(Icons.language),
            border: const OutlineInputBorder(),
          ),
          items:
              AppLocales.supportedLocales.map((locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(_getLanguageDisplayName(locale)),
                );
              }).toList(),
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              context.read<LanguageCubit>().changeLanguage(newLocale);
            }
          },
        );
      },
    );
  }

  /// Get display name for a locale
  String _getLanguageDisplayName(Locale locale) {
    return AppLocales.getLocaleDisplayName(locale);
  }
}
