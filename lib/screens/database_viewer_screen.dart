import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:otolog/cubit/currency_cubit.dart';
import '../database/database.dart';

class DatabaseViewerScreen extends StatefulWidget {
  const DatabaseViewerScreen({super.key});

  @override
  State<DatabaseViewerScreen> createState() => _DatabaseViewerScreenState();
}

class _DatabaseViewerScreenState extends State<DatabaseViewerScreen> {
  final AppDatabase db = database;
  String? selectedTable;
  List<dynamic> tableData = [];
  bool isLoading = false;
  String? errorMessage;

  final List<String> availableTables = ['Vehicles', 'ServiceRecords'];

  @override
  void initState() {
    super.initState();
    _loadTableData('Vehicles');
  }

  Future<void> _loadTableData(String tableName) async {
    setState(() {
      isLoading = true;
      selectedTable = tableName;
      errorMessage = null;
      tableData = [];
    });

    try {
      if (tableName == 'Vehicles') {
        final data = await db.getAllVehicles();
        setState(() {
          tableData = data;
        });
      } else if (tableName == 'ServiceRecords') {
        final data = await db.getAllServiceRecords();
        setState(() {
          tableData = data;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    if (selectedTable != null) {
      await _loadTableData(selectedTable!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Table selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Text(
                  'Table: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedTable,
                      isExpanded: true,
                      items:
                          availableTables.map((table) {
                            return DropdownMenuItem<String>(
                              value: table,
                              child: Text(table),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _loadTableData(value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data display
          Expanded(child: _buildDataView()),
        ],
      ),
    );
  }

  Widget _buildDataView() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (tableData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.table_chart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No data in this table',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tableData.length,
      itemBuilder: (context, index) {
        return _buildRecordCard(tableData[index], index);
      },
    );
  }

  Widget _buildRecordCard(dynamic record, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(
          _getRecordTitle(record),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('ID: ${_getRecordId(record)}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildRecordDetails(record),
          ),
        ],
      ),
    );
  }

  String _getRecordTitle(dynamic record) {
    if (record is Vehicle) {
      return '${record.name} (${record.plateNumber})';
    } else if (record is ServiceRecord) {
      return '${record.serviceType} - ${_formatDate(record.serviceDate)}';
    }
    return 'Unknown Record';
  }

  int _getRecordId(dynamic record) {
    if (record is Vehicle) {
      return record.id;
    } else if (record is ServiceRecord) {
      return record.id;
    }
    return 0;
  }

  Widget _buildRecordDetails(dynamic record) {
    if (record is Vehicle) {
      return _buildVehicleDetails(record);
    } else if (record is ServiceRecord) {
      return _buildServiceRecordDetails(record);
    }
    return const Text('Unknown record type');
  }

  Widget _buildVehicleDetails(Vehicle vehicle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('ID', vehicle.id.toString()),
        _buildDetailRow('Name', vehicle.name),
        _buildDetailRow('Plate Number', vehicle.plateNumber),
        _buildDetailRow('Brand', vehicle.brand ?? 'N/A'),
        _buildDetailRow('Model', vehicle.model ?? 'N/A'),
        _buildDetailRow('Year', vehicle.year ?? 'N/A'),
        _buildDetailRow('Color', vehicle.color ?? 'N/A'),
        _buildDetailRow('Type', vehicle.type ?? 'N/A'),
        _buildDetailRow('VIN', vehicle.vin ?? 'N/A'),
        _buildDetailRow(
          'Purchase Date',
          vehicle.purchaseDate != null
              ? _formatDate(vehicle.purchaseDate!)
              : 'N/A',
        ),
        _buildDetailRow('Odometer', vehicle.odometer?.toString() ?? 'N/A'),
        _buildDetailRow('Fuel Type', vehicle.fuelType ?? 'N/A'),
        _buildDetailRow('Transmission', vehicle.transmissionType ?? 'N/A'),
        _buildDetailRow('Image Path', vehicle.imagePath ?? 'N/A'),
        _buildDetailRow('Is Primary', vehicle.isPrimary ? 'Yes' : 'No'),
        _buildDetailRow('Created At', _formatDate(vehicle.createdAt)),
        _buildDetailRow('Updated At', _formatDate(vehicle.updatedAt)),
      ],
    );
  }

  Widget _buildServiceRecordDetails(ServiceRecord record) {
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, currencyState) {
        final currencySymbol =
            context.read<CurrencyCubit>().currentCurrencySymbol;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', record.id.toString()),
            _buildDetailRow('Vehicle ID', record.vehicleId.toString()),
            _buildDetailRow('Service Type', record.serviceType),
            _buildDetailRow('Service Date', _formatDate(record.serviceDate)),
            _buildDetailRow('Description', record.description ?? 'N/A'),
            _buildDetailRow(
              'Cost',
              record.cost != null
                  ? '$currencySymbol${record.cost!.toStringAsFixed(2)}'
                  : 'N/A',
            ),
            _buildDetailRow('Mechanic', record.mechanic ?? 'N/A'),
            _buildDetailRow('Notes', record.notes ?? 'N/A'),
            _buildDetailRow('Created At', _formatDate(record.createdAt)),
            _buildDetailRow('Updated At', _formatDate(record.updatedAt)),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}
