import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../resources/colors.dart';
import '../widgets/search_bar_widget.dart';
import '../router.dart';

class ServiceLogsScreen extends StatefulWidget {
  const ServiceLogsScreen({super.key});

  @override
  State<ServiceLogsScreen> createState() => _ServiceLogsScreenState();
}

class _ServiceLogsScreenState extends State<ServiceLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  dynamic? _selectedVehicle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Load vehicles when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VehicleCubit>().loadVehicles();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilter(),
            Expanded(
              child: BlocBuilder<VehicleCubit, VehicleState>(
                builder: (context, state) {
                  if (state is VehicleLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (state is VehicleError) {
                    return _buildErrorState(state.message);
                  }

                  if (state is VehicleLoaded) {
                    return _buildServiceLogsList(state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddServiceButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      color: AppColors.neutral[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Logs',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -1.0,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Track all your vehicle maintenance',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.neutral[600],
              height: 1.4,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        final vehicles = state is VehicleLoaded ? state.vehicles : [];
        final allServices =
            state is VehicleLoaded ? (state.serviceRecords ?? []) : [];

        // Filter services by selected vehicle
        final filteredServices =
            _selectedVehicle != null
                ? allServices
                    .where((s) => s.vehicleId == _selectedVehicle!.id)
                    .toList()
                : allServices;

        // Calculate total cost
        final totalCost = filteredServices.fold<double>(0.0, (sum, service) {
          return sum + (service.cost ?? 0.0);
        });

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            children: [
              // Total Cost
              if (vehicles.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Cost',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatCurrency(totalCost),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Vehicle Dropdown and Search
              if (vehicles.isNotEmpty) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SearchBarWidget(
                          controller: _searchController,
                          hintText: 'Search services...',
                          onChanged: (value) {
                            // Filter services based on search
                          },
                          onClear: () {
                            _searchController.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.neutral[200]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<dynamic>(
                              value: _selectedVehicle,
                              hint: Text(
                                'All Vehicles',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.neutral[700],
                                ),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.neutral[500],
                              ),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem<dynamic>(
                                  value: null,
                                  child: Text(
                                    'All Vehicles',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.neutral[700],
                                    ),
                                  ),
                                ),
                                ...vehicles.map((vehicle) {
                                  return DropdownMenuItem<dynamic>(
                                    value: vehicle,
                                    child: Text(
                                      vehicle.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.neutral[900],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedVehicle = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SearchBarWidget(
                  controller: _searchController,
                  hintText: 'Search services...',
                  onChanged: (value) {
                    // Filter services based on search
                  },
                  onClear: () {
                    _searchController.clear();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceLogsList(VehicleLoaded state) {
    final allServices = state.serviceRecords ?? [];
    final vehicles = state.vehicles;

    // Filter services by selected vehicle
    final filteredServices =
        _selectedVehicle != null
            ? allServices
                .where((s) => s.vehicleId == _selectedVehicle!.id)
                .toList()
            : allServices;

    if (filteredServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.neutral[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.build_outlined,
                  size: 56,
                  color: AppColors.neutral[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Service Records',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                vehicles.isEmpty
                    ? 'Add a vehicle first to start tracking services'
                    : _selectedVehicle != null
                    ? 'No service records for ${_selectedVehicle!.name}'
                    : 'Add your first service record to get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.neutral[600],
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VehicleCubit>().loadVehicles();
      },
      color: AppColors.primary,
      backgroundColor: AppColors.neutral[50],
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          final vehicle = vehicles.firstWhere(
            (v) => v.id == service.vehicleId,
            orElse: () => vehicles.first,
          );
          return _buildServiceCard(service, vehicle);
        },
      ),
    );
  }

  Widget _buildServiceCard(dynamic service, dynamic vehicle) {
    return GestureDetector(
      onTap:
          () => context.push(
            AppRoutes.serviceDetail
                .replaceFirst(':vehicleId', service.vehicleId.toString())
                .replaceFirst(':serviceId', service.id.toString()),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral[900]!.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceTypeIcon(service.serviceType),
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceType,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral[900],
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral[600],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showServiceOptionsSheet(service, vehicle),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.neutral[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: AppColors.neutral[500],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(height: 1, color: AppColors.neutral[100]),
            const SizedBox(height: 18),
            Row(
              children: [
                _buildInfoItem(
                  Icons.calendar_today_outlined,
                  _formatDate(service.serviceDate),
                  'Date',
                ),
                if (service.cost != null) ...[
                  const SizedBox(width: 28),
                  _buildInfoItem(
                    Icons.payments_outlined,
                    _formatCurrency(service.cost),
                    'Cost',
                  ),
                ],
                if (service.mechanic != null &&
                    service.mechanic!.isNotEmpty) ...[
                  const SizedBox(width: 28),
                  _buildInfoItem(
                    Icons.person_outline,
                    service.mechanic!,
                    'Mechanic',
                    isFlexible: true,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String value,
    String label, {
    bool isFlexible = false,
  }) {
    return Expanded(
      flex: isFlexible ? 2 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[400],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[800],
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getServiceTypeIcon(String serviceType) {
    final type = serviceType.toLowerCase();
    if (type.contains('oil')) return Icons.oil_barrel;
    if (type.contains('tire') || type.contains('wheel'))
      return Icons.tire_repair;
    if (type.contains('brake')) return Icons.disc_full;
    if (type.contains('battery')) return Icons.battery_charging_full;
    if (type.contains('engine')) return Icons.settings;
    if (type.contains('air') || type.contains('filter')) return Icons.air;
    if (type.contains('transmission')) return Icons.sync;
    if (type.contains('inspection') || type.contains('check'))
      return Icons.fact_check;
    return Icons.build;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double cost) {
    return 'Rp ${cost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Widget _buildAddServiceButton() {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        final vehicles = state is VehicleLoaded ? state.vehicles : [];

        if (vehicles.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 24, right: 24),
          child: FloatingActionButton.extended(
            onPressed: () {
              if (_selectedVehicle != null) {
                // Navigate directly to add service for selected vehicle
                context.push(
                  AppRoutes.addService.replaceFirst(
                    ':vehicleId',
                    _selectedVehicle!.id.toString(),
                  ),
                );
              } else {
                // Show vehicle selection dialog
                _showVehicleSelectionDialog(vehicles);
              }
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Add Service',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showVehicleSelectionDialog(List<dynamic> vehicles) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Select Vehicle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.addService.replaceFirst(
                          ':vehicleId',
                          vehicle.id.toString(),
                        ),
                      );
                    },
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.15),
                            AppColors.primary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      vehicle.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral[900],
                      ),
                    ),
                    subtitle: Text(
                      '${vehicle.brand ?? ''} ${vehicle.model ?? ''}'.trim(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral[600],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[600],
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.tertiary[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 56,
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.neutral[600],
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary[700]!],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<VehicleCubit>().loadVehicles();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceOptionsSheet(dynamic service, dynamic vehicle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.neutral[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Service Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral[900],
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildOptionButton(
                    icon: Icons.visibility_outlined,
                    label: 'View Details',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.serviceDetail
                            .replaceFirst(
                              ':vehicleId',
                              service.vehicleId.toString(),
                            )
                            .replaceFirst(':serviceId', service.id.toString()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit Service',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.editService
                            .replaceFirst(
                              ':vehicleId',
                              service.vehicleId.toString(),
                            )
                            .replaceFirst(':serviceId', service.id.toString()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete Service',
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmationDialog(service, vehicle);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDestructive ? AppColors.tertiary[50]! : AppColors.neutral[50]!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDestructive
                  ? AppColors.tertiary[200]!
                  : AppColors.neutral[200]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      isDestructive
                          ? AppColors.tertiary[600]
                          : AppColors.neutral[700],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive
                              ? AppColors.tertiary[600]
                              : AppColors.neutral[900],
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(dynamic service, dynamic vehicle) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${service.serviceType}" for ${vehicle.name}? This action cannot be undone.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.neutral[700],
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[600],
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<VehicleCubit>().deleteServiceRecord(
                    service.id,
                    service.vehicleId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
