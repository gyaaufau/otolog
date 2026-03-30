import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/cubit/language_cubit.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import '../../router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Preferences Section
            _buildSectionHeader(context, l10n.preferences),
            _buildPreferencesSection(context),

            const SizedBox(height: 24),

            // Data Management Section (Commented out)
            // _buildSectionHeader(context, 'Data Management'),
            // _buildDataManagementSection(context),

            // const SizedBox(height: 24),

            // Support Section
            _buildSectionHeader(context, l10n.support),
            _buildSupportSection(context),

            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader(context, l10n.about),
            _buildAboutSection(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Language Selector
          _buildLanguageSelector(context),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => _showLanguageDialog(context, state.locale),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.language,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral[900],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getLanguageDisplayName(state.locale),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.neutral[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.neutral[400],
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, Locale currentLocale) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) =>
              _LanguageSelectionBottomSheet(currentLocale: currentLocale),
    );
  }

  String _getLanguageDisplayName(Locale locale) {
    return AppLocales.getLocaleDisplayName(locale);
  }

  Widget _buildThemeSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.palette_outlined, color: AppColors.primary, size: 22),
      ),
      title: Text(
        l10n.theme,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral[900],
        ),
      ),
      subtitle: Text(
        'System',
        style: TextStyle(fontSize: 13, color: AppColors.neutral[600]),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.neutral[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'System',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral[700],
          ),
        ),
      ),
      onTap: () => _showThemeSelector(context),
    );
  }

  Widget _buildNotificationSetting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SwitchListTile(
      value: true,
      onChanged: (value) {
        // TODO: Implement notification toggle
      },
      secondary: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.tertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.notifications_outlined,
          color: AppColors.tertiary,
          size: 22,
        ),
      ),
      title: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral[900],
        ),
      ),
      subtitle: Text(
        'Receive service reminders',
        style: TextStyle(fontSize: 13, color: AppColors.neutral[600]),
      ),
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDataManagementSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            context,
            icon: Icons.download_outlined,
            iconColor: AppColors.primary,
            title: 'Export Data',
            subtitle: 'Download all your data',
            onTap: () => _showExportDialog(context),
          ),
          _buildSettingItem(
            context,
            icon: Icons.backup_outlined,
            iconColor: AppColors.secondary[500]!,
            title: 'Backup',
            subtitle: 'Create a backup of your data',
            onTap: () => _showBackupDialog(context),
          ),
          _buildSettingItem(
            context,
            icon: Icons.delete_outline,
            iconColor: Colors.red,
            title: 'Clear Data',
            subtitle: 'Remove all data from the app',
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            context,
            icon: Icons.help_outline,
            iconColor: AppColors.primary,
            title: l10n.helpAndFaq,
            subtitle: l10n.findAnswersToCommonQuestions,
            onTap: () => _showHelpDialog(context),
          ),
          _buildSettingItem(
            context,
            icon: Icons.star_outline,
            iconColor: Colors.amber,
            title: l10n.rateApp,
            subtitle: 'Rate us on the app store',
            onTap: () => _showRateAppDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            iconColor: AppColors.primary,
            title: l10n.about,
            subtitle: l10n.appInformation,
            onTap: () => _showAboutDialog(context),
          ),
          _buildSettingItem(
            context,
            icon: Icons.description_outlined,
            iconColor: AppColors.secondary[500]!,
            title: l10n.termsOfService,
            subtitle: l10n.readOurTermsAndConditions,
            onTap: () => _showTermsDialog(context),
          ),
          _buildSettingItem(
            context,
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.secondary[500]!,
            title: l10n.privacyPolicy,
            subtitle: l10n.learnHowWeProtectYourData,
            onTap: () => _showPrivacyDialog(context),
          ),
          _buildSettingItem(
            context,
            icon: Icons.storage_outlined,
            iconColor: AppColors.tertiary,
            title: l10n.databaseViewer,
            subtitle: l10n.viewAllDatabaseRecords,
            onTap: () => context.push(AppRoutes.databaseViewer),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral[900],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.neutral[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    return Column(
      children: [
        Text(
          'OtoLog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral[900],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: TextStyle(fontSize: 14, color: AppColors.neutral[600]),
        ),
        const SizedBox(height: 8),
        Text(
          '© 2024 OtoLog. All rights reserved.',
          style: TextStyle(fontSize: 12, color: AppColors.neutral[500]),
        ),
      ],
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.neutral[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Theme',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral[900],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.neutral[500],
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildThemeOption(
                    context,
                    icon: Icons.light_mode_outlined,
                    title: 'Light Mode',
                    subtitle: 'Use light theme',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement light theme
                    },
                  ),
                  _buildThemeOption(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement dark theme
                    },
                  ),
                  _buildThemeOption(
                    context,
                    icon: Icons.brightness_auto_outlined,
                    title: 'System Mode',
                    subtitle: 'Follow system settings',
                    isSelected: true,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement system theme
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.neutral[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.neutral[900],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.download_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text('Export Data'),
              ],
            ),
            content: const Text(
              'This will export all your vehicle and service records to a JSON file. The file will be saved to your device\'s downloads folder.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement export functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Export functionality coming soon!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Export'),
              ),
            ],
          ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.backup_outlined, color: AppColors.secondary[500]),
                const SizedBox(width: 12),
                const Text('Create Backup'),
              ],
            ),
            content: const Text(
              'This will create a backup of all your data. You can restore this backup later if needed.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement backup functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Backup functionality coming soon!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary[500],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Backup'),
              ),
            ],
          ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning_outlined, color: Colors.red),
                const SizedBox(width: 12),
                const Text('Clear All Data'),
              ],
            ),
            content: const Text(
              'Are you sure you want to clear all data? This action cannot be undone and will permanently delete all your vehicles and service records.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement clear data functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clear data functionality coming soon!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.helpAndFaq),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.howDoIAddAVehicle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(l10n.howDoIAddAVehicleAnswer),
                  SizedBox(height: 16),
                  Text(
                    l10n.howDoIAddAServiceRecord,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(l10n.howDoIAddAServiceRecordAnswer),
                  SizedBox(height: 16),
                  Text(
                    l10n.howDoISwitchBetweenVehicles,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(l10n.howDoISwitchBetweenVehiclesAnswer),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 12),
                Text(l10n.rateOtoLog),
              ],
            ),
            content: Text(l10n.rateOtoLogDescription),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.maybeLater),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement app store link
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.openingAppStore)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.rateNow),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.about),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'OtoLog',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.appInformation,
                  style: TextStyle(fontSize: 14, color: AppColors.neutral[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 13, color: AppColors.neutral[500]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.termsOfService),
            content: SingleChildScrollView(
              child: Text(l10n.termsOfServiceContent),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.privacyPolicy),
            content: SingleChildScrollView(
              child: Text(l10n.privacyPolicyContent),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
    );
  }
}

/// Bottom sheet for language selection
class _LanguageSelectionBottomSheet extends StatelessWidget {
  final Locale currentLocale;

  const _LanguageSelectionBottomSheet({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.language,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral[900],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.neutral[500],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Language options
            ...AppLocales.supportedLocales.map((locale) {
              final isSelected = locale == currentLocale;
              final displayName = AppLocales.getLocaleDisplayName(locale);

              return _buildLanguageOption(
                context,
                displayName: displayName,
                isSelected: isSelected,
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage(locale);
                  Navigator.pop(context);
                },
              );
            }).toList(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String displayName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? AppColors.primary : AppColors.neutral[900],
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// Import AppColors
class AppColors {
  static const MaterialColor primary = MaterialColor(0xFF0056D2, <int, Color>{
    50: Color(0xFFF0F5FD),
    100: Color(0xFFCCDEF6),
    200: Color(0xFF99BDED),
    300: Color(0xFF669BE4),
    400: Color(0xFF3378DB),
    500: Color(0xFF0056D2),
    600: Color(0xFF0044AA),
    700: Color(0xFF003380),
    800: Color(0xFF002255),
    900: Color(0xFF00112A),
  });

  static const MaterialColor secondary = MaterialColor(0xFF415A77, <int, Color>{
    50: Color(0xFFF2F4F6),
    100: Color(0xFFD8DEE5),
    200: Color(0xFFB2BDC9),
    300: Color(0xFF8D9CAE),
    400: Color(0xFF677B92),
    500: Color(0xFF415A77),
    600: Color(0xFF34485F),
    700: Color(0xFF273647),
    800: Color(0xFF1A2430),
    900: Color(0xFF0D1218),
  });

  static const MaterialColor tertiary = MaterialColor(0xFFFF6B00, <int, Color>{
    50: Color(0xFFFFF0E5),
    100: Color(0xFFFFE1CC),
    200: Color(0xFFFFC499),
    300: Color(0xFFFFA666),
    400: Color(0xFFFF8933),
    500: Color(0xFFFF6B00),
    600: Color(0xFFCC5500),
    700: Color(0xFF994000),
    800: Color(0xFF662A00),
    900: Color(0xFF331500),
  });

  static const MaterialColor neutral = MaterialColor(0xFF1B263B, <int, Color>{
    50: Color(0xFFF4F5F6),
    100: Color(0xFFD1D4D7),
    200: Color(0xFFA4A8B0),
    300: Color(0xFF767D89),
    400: Color(0xFF485162),
    500: Color(0xFF1B263B),
    600: Color(0xFF161F2E),
    700: Color(0xFF111824),
    800: Color(0xFF0B0F17),
    900: Color(0xFF05070C),
  });
}
