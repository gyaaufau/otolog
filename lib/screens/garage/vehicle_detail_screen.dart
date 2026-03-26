import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';
import '../../resources/colors.dart';
import '../../router.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int? _vehicleId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_vehicleId == null) {
      final vehicleId = int.tryParse(
        GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
      );
      if (vehicleId != null) {
        setState(() {
          _vehicleId = vehicleId;
        });
        context.read<VehicleCubit>().loadVehicleWithServices(vehicleId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      appBar: AppBar(
        backgroundColor: AppColors.neutral[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.neutral[900],
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Vehicle Details',
          style: TextStyle(
            color: AppColors.neutral[900],
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          if (_vehicleId != null)
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppColors.neutral[700]),
              onPressed: () {
                context.push(
                  AppRoutes.editVehicle.replaceFirst(
                    ':vehicleId',
                    _vehicleId.toString(),
                  ),
                );
              },
            ),
          if (_vehicleId != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () {
                _showDeleteConfirmationDialog();
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.neutral[200]!, width: 1),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<VehicleCubit, VehicleState>(
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

          if (state is VehicleLoaded && state.vehicles.isNotEmpty) {
            final vehicle = state.vehicles.first;
            return _buildVehicleDetail(vehicle, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildVehicleDetail(dynamic vehicle, VehicleLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleHeader(vehicle),
          SizedBox(height: 24.h),
          _buildVehicleSpecifications(vehicle),
          SizedBox(height: 24.h),
          _buildVehicleDetails(vehicle),
          SizedBox(height: 24.h),
          _buildPurchaseInfo(vehicle),
          SizedBox(height: 24.h),
          _buildServiceStatistics(state),
          SizedBox(height: 24.h),
          if (state.serviceRecords != null &&
              state.serviceRecords!.isNotEmpty) ...[
            _buildRecentServices(state.serviceRecords!),
            SizedBox(height: 24.h),
          ],
          _buildActionButtons(vehicle),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildVehicleHeader(dynamic vehicle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    vehicle.imagePath != null && vehicle.imagePath!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(vehicle.imagePath!),
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _getVehicleTypeIcon(vehicle.type);
                            },
                          ),
                        )
                        : _getVehicleTypeIcon(vehicle.type),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral[900],
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        if (vehicle.isPrimary ?? false) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.tertiary[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 12,
                                  color: AppColors.tertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Primary',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.tertiary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${vehicle.brand ?? ''} ${vehicle.model ?? ''}'.trim(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral[600],
                        letterSpacing: 0.1,
                      ),
                    ),
                    if (vehicle.year != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        vehicle.year!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral[500],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.neutral[100]),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Plate Number',
                  vehicle.plateNumber,
                  Icons.confirmation_number_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  'Odometer',
                  vehicle.odometer != null
                      ? '${vehicle.odometer!.toString()} km'
                      : 'N/A',
                  Icons.speed_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.neutral[500]),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[500],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral[900],
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildVehicleSpecifications(dynamic vehicle) {
    final specs = [
      if (vehicle.type != null) _SpecItem('Type', vehicle.type!),
      if (vehicle.color != null) _SpecItem('Color', vehicle.color!),
      if (vehicle.fuelType != null) _SpecItem('Fuel Type', vehicle.fuelType!),
      if (vehicle.transmissionType != null)
        _SpecItem('Transmission', vehicle.transmissionType!),
    ];

    if (specs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: specs.length,
            itemBuilder: (context, index) {
              return _buildSpecCard(specs[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard(_SpecItem spec) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.neutral[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  spec.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[500],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    spec.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral[900],
                      letterSpacing: -0.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetails(dynamic vehicle) {
    final details = [
      if (vehicle.vin != null && vehicle.vin!.isNotEmpty)
        _DetailItem('VIN', vehicle.vin!),
    ];

    if (details.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            'Vehicle Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildDetailRow(detail),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(_DetailItem detail) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral[500],
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail.value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseInfo(dynamic vehicle) {
    if (vehicle.purchaseDate == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase Date',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[500],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(vehicle.purchaseDate!),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[900],
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStatistics(VehicleLoaded state) {
    final totalCost = state.totalCost ?? 0.0;
    final serviceCount = state.serviceCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Service Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Services',
                  serviceCount.toString(),
                  Icons.build_outlined,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.neutral[200]),
              Expanded(
                child: _buildStatItem(
                  'Total Cost',
                  _formatCurrency(totalCost),
                  Icons.payments_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.neutral[500]),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[500],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral[900],
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentServices(List<dynamic> services) {
    final recentServices = services.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.3,
                ),
              ),
              if (services.length > 3)
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.serviceLogs);
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ...recentServices.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            return Column(
              children: [
                _buildServiceItem(service),
                if (index < recentServices.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(height: 1, color: AppColors.neutral[100]),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServiceItem(dynamic service) {
    return GestureDetector(
      onTap: () {
        if (_vehicleId != null) {
          context.push(
            AppRoutes.serviceDetail
                .replaceFirst(':vehicleId', _vehicleId.toString())
                .replaceFirst(':serviceId', service.id.toString()),
          );
        }
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getServiceTypeIcon(service.serviceType),
              size: 24,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[900],
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(service.serviceDate),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutral[500],
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          if (service.cost != null) ...[
            Text(
              _formatCurrency(service.cost),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(Icons.chevron_right, color: AppColors.neutral[400]),
        ],
      ),
    );
  }

  Widget _buildActionButtons(dynamic vehicle) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
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
              if (_vehicleId != null) {
                context.push(
                  AppRoutes.addService.replaceFirst(
                    ':vehicleId',
                    _vehicleId.toString(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_outlined, size: 20),
                SizedBox(width: 12),
                Text(
                  'Add Service Record',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutral[200]!, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral[900]!.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_vehicleId != null) {
                      context.push(
                        AppRoutes.editVehicle.replaceFirst(
                          ':vehicleId',
                          _vehicleId.toString(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.neutral[900],
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.tertiary[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.tertiary[200]!, width: 1),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (!(vehicle.isPrimary ?? false) && _vehicleId != null) {
                      context.read<VehicleCubit>().markAsPrimary(_vehicleId!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.tertiary[600],
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        vehicle.isPrimary ?? false
                            ? Icons.star
                            : Icons.star_outline,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        vehicle.isPrimary ?? false ? 'Primary' : 'Set Primary',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    if (_vehicleId == null) return;

    final state = context.read<VehicleCubit>().state;
    if (state is! VehicleLoaded || state.vehicles.isEmpty) return;

    final vehicle = state.vehicles.first;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Vehicle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${vehicle.name}"? This action cannot be undone and will also delete all associated service records.',
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
                  context.read<VehicleCubit>().deleteVehicle(_vehicleId!);
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
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

  Widget _getVehicleTypeIcon(String? type) {
    IconData iconData;
    switch (type?.toLowerCase()) {
      case 'sedan':
        iconData = Icons.directions_car;
        break;
      case 'suv':
        iconData = Icons.directions_car;
        break;
      case 'truck':
        iconData = Icons.local_shipping;
        break;
      case 'motorcycle':
        iconData = Icons.two_wheeler;
        break;
      case 'van':
        iconData = Icons.airport_shuttle;
        break;
      default:
        iconData = Icons.directions_car;
    }

    return Icon(iconData, size: 44, color: AppColors.primary);
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
}

class _SpecItem {
  final String label;
  final String value;

  _SpecItem(this.label, this.value);
}

class _DetailItem {
  final String label;
  final String value;

  _DetailItem(this.label, this.value);
}
