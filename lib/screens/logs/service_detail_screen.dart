import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/localization/l10n_helper.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';
import '../../resources/colors.dart';
import '../../router.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int? _vehicleId;
  int? _serviceId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_vehicleId == null || _serviceId == null) {
      final vehicleId = int.tryParse(
        GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
      );
      final serviceId = int.tryParse(
        GoRouterState.of(context).pathParameters['serviceId'] ?? '',
      );

      if (vehicleId != null) {
        setState(() {
          _vehicleId = vehicleId;
          _serviceId = serviceId;
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
          context.l10n.serviceDetails,
          style: TextStyle(
            color: AppColors.neutral[900],
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.neutral[700]),
            onPressed: () {
              if (_vehicleId != null && _serviceId != null) {
                context.push(
                  AppRoutes.editService
                      .replaceFirst(':vehicleId', _vehicleId.toString())
                      .replaceFirst(':serviceId', _serviceId.toString()),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              // Show delete confirmation
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

          if (state is VehicleLoaded) {
            final service = state.serviceRecords?.firstWhere(
              (s) => s.id == _serviceId,
              orElse: () => state.serviceRecords!.first,
            );
            final vehicle = state.vehicles.firstWhere(
              (v) => v.id == service!.vehicleId,
              orElse: () => state.vehicles.first,
            );

            return _buildServiceDetail(service!, vehicle);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildServiceDetail(dynamic service, dynamic vehicle) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceHeader(service, vehicle),
          const SizedBox(height: 32),
          _buildServiceInfo(service),
          const SizedBox(height: 32),
          if (service.description != null &&
              service.description!.isNotEmpty) ...[
            _buildSection(
              context.l10n.description,
              Icons.description_outlined,
              service.description!,
            ),
            const SizedBox(height: 24),
          ],
          if (service.notes != null && service.notes!.isNotEmpty) ...[
            _buildSection(
              context.l10n.notes,
              Icons.note_outlined,
              service.notes!,
            ),
            const SizedBox(height: 24),
          ],
          _buildActionButtons(context, service, vehicle),
        ],
      ),
    );
  }

  Widget _buildServiceHeader(dynamic service, dynamic vehicle) {
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
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getServiceTypeIcon(service.serviceType),
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceType,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral[900],
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neutral[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 16,
                            color: AppColors.neutral[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            vehicle.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutral[700],
                            ),
                          ),
                        ],
                      ),
                    ),
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
              if (service.cost != null) ...[
                Expanded(
                  child: _buildSummaryItem(
                    context.l10n.totalCost,
                    _formatCurrency(service.cost),
                    Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: _buildSummaryItem(
                  context.l10n.serviceDate,
                  _formatDate(service.serviceDate),
                  Icons.calendar_today_outlined,
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
        ),
      ],
    );
  }

  Widget _buildServiceInfo(dynamic service) {
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
          if (service.mechanic != null && service.mechanic!.isNotEmpty) ...[
            _buildInfoRow(
              Icons.person_outline,
              context.l10n.mechanicShop,
              service.mechanic!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.neutral[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.neutral[600]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral[500],
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
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

  Widget _buildSection(String title, IconData icon, String content) {
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
            children: [
              Icon(icon, size: 24, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.neutral[700],
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    dynamic service,
    dynamic vehicle,
  ) {
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
              if (_vehicleId != null && _serviceId != null) {
                context.push(
                  AppRoutes.editService
                      .replaceFirst(':vehicleId', _vehicleId.toString())
                      .replaceFirst(':serviceId', _serviceId.toString()),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit_outlined, size: 20),
                const SizedBox(width: 12),
                Text(
                  context.l10n.editService,
                  style: const TextStyle(
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.error.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              _showDeleteConfirmationDialog(service, vehicle);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.error,
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
                Icon(Icons.delete_outline, size: 20),
                SizedBox(width: 12),
                Text(
                  context.l10n.deleteService,
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
      ],
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
              context.l10n.deleteService,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: Text(
              context.l10n.deleteServiceConfirmation(
                service.serviceType,
                vehicle.name,
              ),
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
                  context.l10n.cancel,
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
                child: Text(
                  context.l10n.delete,
                  style: const TextStyle(
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
              context.l10n.somethingWentWrong,
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

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(double cost) {
    return 'Rp ${cost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
