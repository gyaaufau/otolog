import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../resources/colors.dart';
import '../router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      body: SafeArea(
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              );
            }

            if (state is VehicleError) {
              return _buildErrorState(state.message);
            }

            if (state is VehicleLoaded) {
              return _buildContent(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.error,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.neutral[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<VehicleCubit>().loadHomeData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(VehicleLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VehicleCubit>().loadHomeData(
          selectedVehicleId: state.selectedVehicleId,
        );
      },
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(child: _buildHeader(state)),

          // Vehicle Switcher Section
          SliverToBoxAdapter(child: _buildVehicleSwitcher(state)),

          // Statistics Section
          SliverToBoxAdapter(child: _buildStatistics(state)),

          // Quick Actions
          SliverToBoxAdapter(child: _buildQuickActions(state)),

          // Recent Services Section
          SliverToBoxAdapter(child: _buildRecentServices(state)),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader(VehicleLoaded state) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      color: AppColors.neutral[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomeBack,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutral[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.yourGarage,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral[900],
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${state.vehicles.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.trackVehicleMaintenance,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutral[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSwitcher(VehicleLoaded state) {
    if (state.vehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedVehicle =
        state.selectedVehicleId != null
            ? state.vehicles.firstWhere(
              (v) => v.id == state.selectedVehicleId,
              orElse: () => state.vehicles.first,
            )
            : state.vehicles.first;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: InkWell(
        onTap: () {
          if (state.vehicles.length > 1) {
            _showVehicleSelector(state);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    selectedVehicle.imagePath != null &&
                            selectedVehicle.imagePath!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(selectedVehicle.imagePath!),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _getVehicleTypeIcon(selectedVehicle.type);
                            },
                          ),
                        )
                        : _getVehicleTypeIcon(selectedVehicle.type),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedVehicle.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral[900],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${selectedVehicle.brand ?? ''} ${selectedVehicle.model ?? ''}'
                          .trim(),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.neutral[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (state.vehicles.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.switchVehicle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVehicleSelector(VehicleLoaded state) {
    final l10n = context.l10n;
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
                          l10n.selectVehicle,
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
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = state.vehicles[index];
                        final isSelected =
                            vehicle.id == state.selectedVehicleId;
                        return InkWell(
                          onTap: () {
                            context.read<VehicleCubit>().selectVehicle(
                              vehicle.id,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child:
                                      vehicle.imagePath != null &&
                                              vehicle.imagePath!.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.file(
                                              File(vehicle.imagePath!),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return _getVehicleTypeIcon(
                                                  vehicle.type,
                                                );
                                              },
                                            ),
                                          )
                                          : _getVehicleTypeIcon(vehicle.type),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle.name,
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
                                        '${vehicle.brand ?? ''} ${vehicle.model ?? ''}'
                                            .trim(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.neutral[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildStatistics(VehicleLoaded state) {
    final l10n = context.l10n;
    final odometerValue = state.odometer ?? 0;
    final formattedOdometer = _formatOdometer(odometerValue);
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              l10n.lastOdometer,
              formattedOdometer,
              Icons.speed_outlined,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: _buildStatItem(
              l10n.totalServices,
              '${state.serviceCount ?? 0}',
              Icons.build_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white.withOpacity(0.9)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(VehicleLoaded state) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickActions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildActionButton(
                    l10n.addVehicle,
                    Icons.add_circle_outline,
                    AppColors.primary,
                    () => context.push(AppRoutes.addVehicle),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    l10n.addService,
                    Icons.construction,
                    AppColors.tertiary,
                    () => context.push(AppRoutes.addService),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentServices(VehicleLoaded state) {
    final l10n = context.l10n;
    final recentServices = state.serviceRecords ?? [];

    if (recentServices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentServices,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: () => context.push(AppRoutes.serviceLogs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.seeAll,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recentServices
              .take(3)
              .map((service) => _buildServiceCard(service)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(dynamic service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
              _getServiceIcon(service.serviceType),
              size: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
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
                  ),
                ),
                const SizedBox(height: 4),
                if (service.description != null &&
                    service.description!.isNotEmpty)
                  Text(
                    service.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${service.cost?.toStringAsFixed(0) ?? '0'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(service.serviceDate),
                style: TextStyle(fontSize: 11, color: AppColors.neutral[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatOdometer(int odometer) {
    final l10n = context.l10n;
    if (odometer == 0) {
      return '0 ${l10n.km}';
    }
    // Format odometer value with comma separators (e.g., 50,000 km)
    final valueStr = odometer.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < valueStr.length; i++) {
      final char = valueStr[valueStr.length - 1 - i];
      buffer.write(char);
      if ((i + 1) % 3 == 0 && i != valueStr.length - 1) {
        buffer.write(',');
      }
    }
    return '${buffer.toString().split('').reversed.join()} ${l10n.km}';
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

    return Icon(iconData, size: 24, color: AppColors.primary);
  }

  IconData _getServiceIcon(String serviceType) {
    final type = serviceType.toLowerCase();

    if (type.contains('oil') || type.contains('change')) {
      return Icons.oil_barrel;
    } else if (type.contains('tire') || type.contains('wheel')) {
      return Icons.settings;
    } else if (type.contains('brake')) {
      return Icons.disc_full;
    } else if (type.contains('battery') || type.contains('electrical')) {
      return Icons.battery_charging_full;
    } else if (type.contains('air') ||
        type.contains('filter') ||
        type.contains('ac')) {
      return Icons.air;
    } else if (type.contains('engine') || type.contains('motor')) {
      return Icons.engineering;
    } else if (type.contains('transmission') || type.contains('gear')) {
      return Icons.settings_suggest;
    } else if (type.contains('suspension') || type.contains('shock')) {
      return Icons.car_repair;
    } else if (type.contains('inspection') || type.contains('check')) {
      return Icons.fact_check;
    } else if (type.contains('wash') || type.contains('clean')) {
      return Icons.cleaning_services;
    } else if (type.contains('paint') || type.contains('body')) {
      return Icons.format_paint;
    } else {
      return Icons.build;
    }
  }
}
