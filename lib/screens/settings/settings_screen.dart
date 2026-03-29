import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/widgets/language_selector.dart';
import '../../router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Language Selector
          const LanguageSelector(),
          const Divider(),

          // Database Viewer
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Database Viewer'),
            subtitle: const Text('View all database records'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(AppRoutes.databaseViewer);
            },
          ),
          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: const Text('App information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show about dialog
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(l10n.about),
                      content: const Text('OtoLog - Vehicle Service Log App'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
