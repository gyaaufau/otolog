import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
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
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('App information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show about dialog
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('About'),
                      content: const Text('OtoLog - Vehicle Service Log App'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
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
