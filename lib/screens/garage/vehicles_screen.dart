import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/cubit/unit_cubit.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/commons/utils/unit_converter.dart';
import 'package:otolog/shared/constants/unit.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import '../../cubit/vehicle_list_cubit.dart';
import '../../cubit/vehicle_list_state.dart';
import '../../resources/colors.dart';
import '../../router.dart';
import '../../widgets/search_bar_widget.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('🚗 VehiclesScreen: initState - Loading all vehicles');
    context.read<VehicleListCubit>().loadVehicles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🚗 VehiclesScreen: didChangeDependencies - Restoring all vehicles');
    // Restore all vehicles when returning from detail screen
    context.read<VehicleListCubit>().refresh();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilter(),
            Expanded(
              child: BlocListener<VehicleListCubit, VehicleListState>(
                listener: (context, state) {
                  print(
                    '🚗 VehiclesScreen: State changed - ${state.runtimeType}',
                  );
                  if (state is VehicleListLoaded) {
                    print(
                      '🚗 VehiclesScreen: Vehicle count = ${state.vehicles.length}',
                    );
                  }
                },
                child: BlocBuilder<VehicleListCubit, VehicleListState>(
                  builder: (context, state) {
                    if (state is VehicleListLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          strokeWidth: 2,
                        ),
                      );
                    }

                    if (state is VehicleListError) {
                      return _buildErrorState(state.message);
                    }

                    if (state is VehicleListLoaded) {
                      return _buildVehiclesList(state);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddVehicleButton(),
    );
  }

  Widget _buildHeader() {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: AppColors.neutral[50],
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.vehicles,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        children: [
          // Professional Search Bar
          SearchBarWidget(
            controller: _searchController,
            hintText: l10n.searchVehicles,
            onChanged: (value) {
              context.read<VehicleListCubit>().searchVehicles(value);
            },
            onClear: () {
              context.read<VehicleListCubit>().searchVehicles('');
            },
          ),
          const SizedBox(height: 16),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(l10n.all, null),
                const SizedBox(width: 10),
                _buildFilterChip(l10n.sedan, 'Sedan'),
                const SizedBox(width: 10),
                _buildFilterChip(l10n.suv, 'SUV'),
                const SizedBox(width: 10),
                _buildFilterChip(l10n.truck, 'Truck'),
                const SizedBox(width: 10),
                _buildFilterChip(l10n.motorcycle, 'Motorcycle'),
                const SizedBox(width: 10),
                _buildFilterChip(l10n.van, 'Van'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        final isSelected =
            state is VehicleListLoaded && state.filterType == value;
        return GestureDetector(
          onTap: () {
            final currentFilter =
                state is VehicleListLoaded ? state.filterType : null;
            final newFilter = isSelected ? null : value;
            if (currentFilter != newFilter) {
              context.read<VehicleListCubit>().filterVehiclesByType(newFilter);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.primary.withOpacity(0.12)
                      : AppColors.neutral[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isSelected
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.transparent,
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.neutral[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehiclesList(VehicleListLoaded state) {
    final l10n = context.l10n;
    if (state.vehicles.isEmpty) {
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
                  Icons.directions_car_outlined,
                  size: 56,
                  color: AppColors.neutral[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.noVehiclesFound,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _searchController.text.isNotEmpty
                    ? l10n.tryAdjustingSearchOrFilters
                    : l10n.addFirstVehicleToGetStarted,
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
        await context.read<VehicleListCubit>().refresh();
      },
      color: AppColors.primary,
      backgroundColor: AppColors.neutral[50],
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        itemCount: state.vehicles.length,
        itemBuilder: (context, index) {
          return _buildVehicleCard(state.vehicles[index]);
        },
      ),
    );
  }

  Widget _buildVehicleCard(dynamic vehicle) {
    return GestureDetector(
      onTap:
          () => context.push(
            AppRoutes.vehicleDetail.replaceFirst(
              ':vehicleId',
              vehicle.id.toString(),
            ),
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
                  width: 72,
                  height: 72,
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
                  child:
                      vehicle.imagePath != null && vehicle.imagePath!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(vehicle.imagePath!),
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _getVehicleTypeIcon(vehicle.type);
                              },
                            ),
                          )
                          : _getVehicleTypeIcon(vehicle.type),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral[900],
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vehicle.brand ?? ''} ${vehicle.model ?? ''}'.trim(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral[600],
                          letterSpacing: 0.1,
                        ),
                      ),
                      if (vehicle.year != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          vehicle.year!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.neutral[500],
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (vehicle.isPrimary ?? false) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.primary,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tertiary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                GestureDetector(
                  onTap: () => _showVehicleOptionsSheet(vehicle),
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
                  Icons.confirmation_number_outlined,
                  vehicle.plateNumber,
                  context.l10n.plate,
                ),
                if (vehicle.type != null) ...[
                  const SizedBox(width: 28),
                  _buildInfoItem(
                    Icons.category_outlined,
                    vehicle.type!,
                    context.l10n.type,
                  ),
                ],
                const SizedBox(width: 28),
                _buildInfoItem(
                  Icons.speed_outlined,
                  _formatOdometer(vehicle.odometer),
                  context.l10n.odometerLabel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Expanded(
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

    return Icon(iconData, size: 36, color: AppColors.primary);
  }

  String _formatOdometer(int? odometer) {
    final unitState = context.watch<UnitCubit>().state;
    if (odometer == null) {
      return '0 ${unitState.unit.displayName}';
    }
    return UnitConverter.formatDistance(odometer!, unitState.unit);
  }

  Widget _buildAddVehicleButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, right: 24),
      child: FloatingActionButton.extended(
        heroTag: 'add_vehicle_fab',
        onPressed: () => context.push(AppRoutes.addVehicle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          context.l10n.addVehicle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
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
              l10n.somethingWentWrong,
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
                  context.read<VehicleListCubit>().refresh();
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
                child: Text(
                  l10n.retry,
                  style: const TextStyle(
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

  void _showVehicleOptionsSheet(dynamic vehicle) {
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
                    context.l10n.vehicleOptions,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral[900],
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildOptionButton(
                    icon: Icons.star_outline,
                    label:
                        (vehicle.isPrimary ?? false) == true
                            ? context.l10n.primaryVehicle
                            : context.l10n.markAsPrimary,
                    onTap: () {
                      Navigator.pop(context);
                      if ((vehicle.isPrimary ?? false) != true) {
                        context.read<VehicleListCubit>().markAsPrimary(
                          vehicle.id,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    icon: Icons.edit_outlined,
                    label: context.l10n.editVehicle,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.editVehicle.replaceFirst(
                          ':vehicleId',
                          vehicle.id.toString(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    icon: Icons.delete_outline,
                    label: context.l10n.deleteVehicle,
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmationDialog(vehicle);
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

  void _showDeleteConfirmationDialog(dynamic vehicle) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              l10n.deleteVehicle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: Text(
              l10n.deleteVehicleConfirmation,
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
                  l10n.cancel,
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
                  context.read<VehicleListCubit>().deleteVehicle(vehicle.id);
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
                child: Text(
                  l10n.delete,
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
