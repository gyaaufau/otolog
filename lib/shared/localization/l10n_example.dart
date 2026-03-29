import 'package:flutter/material.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

/// Example widget demonstrating how to use localization in OtoLog.
///
/// This widget shows various ways to access and use localized strings.
/// You can use this as a reference when implementing localization in your own widgets.
class LocalizationExample extends StatelessWidget {
  const LocalizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1: Using context.l10n extension (Recommended)
          _buildSection(context, 'Using context.l10n Extension', [
            _buildItem(context, l10n.home),
            _buildItem(context, l10n.garage),
            _buildItem(context, l10n.serviceLogs),
            _buildItem(context, l10n.settings),
          ]),

          const SizedBox(height: 24),

          // Example 2: Common actions
          _buildSection(context, 'Common Actions', [
            _buildItem(context, l10n.add),
            _buildItem(context, l10n.edit),
            _buildItem(context, l10n.delete),
            _buildItem(context, l10n.save),
            _buildItem(context, l10n.cancel),
          ]),

          const SizedBox(height: 24),

          // Example 3: Vehicle-related strings
          _buildSection(context, 'Vehicle Related', [
            _buildItem(context, l10n.vehicles),
            _buildItem(context, l10n.addVehicle),
            _buildItem(context, l10n.vehicleName),
            _buildItem(context, l10n.vehicleType),
            _buildItem(context, l10n.make),
            _buildItem(context, l10n.model),
            _buildItem(context, l10n.year),
            _buildItem(context, l10n.licensePlate),
          ]),

          const SizedBox(height: 24),

          // Example 4: Service-related strings
          _buildSection(context, 'Service Related', [
            _buildItem(context, l10n.service),
            _buildItem(context, l10n.addService),
            _buildItem(context, l10n.serviceDate),
            _buildItem(context, l10n.serviceType),
            _buildItem(context, l10n.cost),
            _buildItem(context, l10n.odometerReading),
          ]),

          const SizedBox(height: 24),

          // Example 5: Success messages
          _buildSection(context, 'Success Messages', [
            _buildItem(context, l10n.vehicleAdded),
            _buildItem(context, l10n.vehicleUpdated),
            _buildItem(context, l10n.vehicleDeleted),
            _buildItem(context, l10n.serviceAdded),
            _buildItem(context, l10n.serviceUpdated),
          ]),

          const SizedBox(height: 24),

          // Example 6: Current locale info
          _buildSection(context, 'Locale Information', [
            _buildItem(
              context,
              'Current Locale: ${context.locale.languageCode}',
            ),
            _buildItem(context, 'Display Name: ${context.locale}'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

/// Example of a widget that uses localization in a practical way.
/// This shows how you might implement a vehicle list item with localization.
class LocalizedVehicleListItem extends StatelessWidget {
  const LocalizedVehicleListItem({
    super.key,
    required this.vehicleName,
    required this.vehicleType,
    required this.licensePlate,
  });

  final String vehicleName;
  final String vehicleType;
  final String licensePlate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.directions_car),
        title: Text(vehicleName),
        subtitle: Text(
          '${l10n.vehicleType}: $vehicleType • ${l10n.licensePlate}: $licensePlate',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Handle edit
              },
              tooltip: l10n.edit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Handle delete
                _showDeleteConfirmation(context);
              },
              tooltip: l10n.delete,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.l10n.deleteConfirmation),
            content: Text(context.l10n.deleteVehicleMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle delete
                },
                child: Text(context.l10n.confirm),
              ),
            ],
          ),
    );
  }
}

/// Example of a form with localized labels and validation messages.
class LocalizedVehicleForm extends StatelessWidget {
  const LocalizedVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: l10n.vehicleName,
              hintText: 'Enter vehicle name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: l10n.licensePlate,
              hintText: 'Enter license plate',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save
                  },
                  child: Text(l10n.save),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Handle cancel
                  },
                  child: Text(l10n.cancel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
