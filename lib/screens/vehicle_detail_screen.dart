import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import 'add_service_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final int vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadVehicleWithServices(widget.vehicleId);
  }

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          BlocBuilder<VehicleCubit, VehicleState>(
            builder: (context, state) {
              if (state is VehicleLoaded && state.vehicles.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    _showDeleteDialog(context, state.vehicles.first);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleLoaded && state.vehicles.isNotEmpty) {
            final vehicle = state.vehicles.first;
            final serviceRecords = state.serviceRecords ?? [];
            final totalCost = state.totalCost ?? 0;
            final serviceCount = state.serviceCount ?? 0;

            return Column(
              children: [
                // Vehicle Info Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                vehicle.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicle.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vehicle.plateNumber,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (vehicle.brand != null || vehicle.model != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              if (vehicle.brand != null) ...[
                                Icon(
                                  Icons.business_outlined,
                                  size: 18,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  vehicle.brand!,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 16),
                              ],
                              if (vehicle.model != null) ...[
                                Icon(
                                  Icons.category_outlined,
                                  size: 18,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  vehicle.model!,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ],
                          ),
                        ),
                      if (vehicle.year != null || vehicle.color != null)
                        Row(
                          children: [
                            if (vehicle.year != null) ...[
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                vehicle.year!,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 16),
                            ],
                            if (vehicle.color != null) ...[
                              Icon(
                                Icons.palette_outlined,
                                size: 18,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                vehicle.color!,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                // Statistics
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$serviceCount',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Services',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _formatCurrency(totalCost),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total Cost',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Service Records
                Expanded(
                  child:
                      serviceRecords.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history_outlined,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No service records yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap + to add your first service record',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: serviceRecords.length,
                            itemBuilder: (context, index) {
                              final record = serviceRecords[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getServiceTypeColor(
                                        record.serviceType,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getServiceTypeIcon(record.serviceType),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    record.serviceType,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDate(record.serviceDate),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        if (record.cost != null)
                                          Text(
                                            _formatCurrency(record.cost!),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      _showDeleteServiceDialog(context, record);
                                    },
                                  ),
                                  onTap: () {
                                    _showServiceDetailDialog(context, record);
                                  },
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          } else if (state is VehicleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddServiceScreen(vehicleId: widget.vehicleId),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getServiceTypeColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'oil change':
        return Colors.amber;
      case 'tire service':
        return Colors.brown;
      case 'brake service':
        return Colors.red;
      case 'battery':
        return Colors.blue;
      case 'air conditioning':
        return Colors.cyan;
      case 'general service':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceTypeIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'oil change':
        return Icons.oil_barrel;
      case 'tire service':
        return Icons.tire_repair;
      case 'brake service':
        return Icons.disc_full;
      case 'battery':
        return Icons.battery_charging_full;
      case 'air conditioning':
        return Icons.ac_unit;
      case 'general service':
        return Icons.build;
      default:
        return Icons.settings;
    }
  }

  void _showDeleteDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Vehicle'),
            content: Text(
              'Are you sure you want to delete ${vehicle.name}? This will also delete all service records.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<VehicleCubit>().deleteVehicle(vehicle.id);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showDeleteServiceDialog(BuildContext context, ServiceRecord record) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Service Record'),
            content: Text(
              'Are you sure you want to delete this ${record.serviceType} record?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<VehicleCubit>().deleteServiceRecord(
                    record.id,
                    widget.vehicleId,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showServiceDetailDialog(BuildContext context, ServiceRecord record) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(record.serviceType),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Date',
                    _formatDate(record.serviceDate),
                  ),
                  if (record.cost != null)
                    _buildDetailRow(
                      Icons.attach_money,
                      'Cost',
                      _formatCurrency(record.cost!),
                    ),
                  if (record.mechanic != null)
                    _buildDetailRow(Icons.person, 'Mechanic', record.mechanic!),
                  if (record.description != null)
                    _buildDetailRow(
                      Icons.description,
                      'Description',
                      record.description!,
                    ),
                  if (record.notes != null)
                    _buildDetailRow(Icons.note, 'Notes', record.notes!),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
