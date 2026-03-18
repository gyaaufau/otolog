import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../resources/theme.dart';
import '../router.dart';
import '../database/database.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilterType;

  // List of vehicle types for filter
  final List<String> _vehicleTypes = [
    'Car',
    'Motorcycle',
    'Truck',
    'Van',
    'Bus',
    'SUV',
    'Sedan',
    'Hatchback',
    'Coupe',
    'Convertible',
    'Wagon',
  ];

  IconData _getVehicleTypeIcon(String? type) {
    if (type == null || type.trim().isEmpty) return Icons.directions_car;

    final typeLower = type.trim().toLowerCase();
    switch (typeLower) {
      case 'car':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'truck':
        return Icons.local_shipping;
      case 'van':
        return Icons.airport_shuttle;
      case 'bus':
        return Icons.directions_bus;
      case 'suv':
        return Icons.sports_score;
      case 'sedan':
        return Icons.directions_car_filled;
      case 'hatchback':
        return Icons.car_repair;
      case 'coupe':
        return Icons.car_rental;
      case 'convertible':
        return Icons.directions_car_rounded;
      case 'wagon':
        return Icons.airport_shuttle;
      default:
        return Icons.directions_car;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadVehicles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<VehicleCubit>().state;
    if (state is VehicleLoaded) {
      _selectedFilterType = state.filterType;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (bottomSheetContext) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by Vehicle Type',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: AppColors.secondaryText,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children:
                          _vehicleTypes.map((type) {
                            final isSelected = _selectedFilterType == type;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  _selectedFilterType =
                                      isSelected ? null : type;
                                });
                                setState(() {
                                  _selectedFilterType =
                                      isSelected ? null : type;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.accent
                                          : AppColors.inputBackground,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.accent
                                            : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isSelected
                                            ? AppColors.background
                                            : AppColors.primaryText,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedFilterType = null;
                              });
                              setState(() {
                                _selectedFilterType = null;
                              });
                              context.read<VehicleCubit>().filterVehiclesByType(
                                null,
                              );
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.secondaryText,
                              side: BorderSide(color: AppColors.border),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Remove Filter',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<VehicleCubit>().filterVehiclesByType(
                                _selectedFilterType,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.background,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Apply Filter',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              );
            },
          ),
    );
  }

  int _getServiceCountForVehicle(
    int vehicleId,
    List<ServiceRecord>? serviceRecords,
  ) {
    if (serviceRecords == null) return 0;
    return serviceRecords
        .where((service) => service.vehicleId == vehicleId)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search vehicles...',
                      hintStyle: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.secondaryText,
                        size: 20.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                    ),
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14.sp,
                    ),
                    onChanged: (value) {
                      context.read<VehicleCubit>().searchVehicles(value);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                BlocBuilder<VehicleCubit, VehicleState>(
                  builder: (context, state) {
                    final hasActiveFilter =
                        state is VehicleLoaded && state.filterType != null;
                    return GestureDetector(
                      onTap: () => _showFilterBottomSheet(context),
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color:
                              hasActiveFilter
                                  ? AppColors.accent
                                  : AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color:
                                hasActiveFilter
                                    ? AppColors.accent
                                    : AppColors.border,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.filter_list,
                                color:
                                    hasActiveFilter
                                        ? AppColors.background
                                        : AppColors.secondaryText,
                                size: 22.sp,
                              ),
                            ),
                            if (hasActiveFilter)
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<VehicleCubit, VehicleState>(
            builder: (context, state) {
              if (state is VehicleLoaded && state.filterType != null) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: 14.sp,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${state.filterType}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accent,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilterType = null;
                                });
                                context
                                    .read<VehicleCubit>()
                                    .filterVehiclesByType(null);
                              },
                              child: Icon(
                                Icons.close,
                                size: 16.sp,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<VehicleCubit, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                } else if (state is VehicleLoaded) {
                  if (state.vehicles.isEmpty) {
                    return _buildEmptyState();
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<VehicleCubit>().loadVehicles();
                    },
                    color: AppColors.accent,
                    backgroundColor: AppColors.surface,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: state.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = state.vehicles[index];
                        return _buildVehicleCard(vehicle, state.serviceRecords);
                      },
                    ),
                  );
                } else if (state is VehicleError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () {
          context.push(AppRoutes.addVehicle);
        },
        child: Icon(Icons.add, color: AppColors.background, size: 24.sp),
      ),
    );
  }

  Color _getColorFromName(String? colorName) {
    if (colorName == null || colorName.isEmpty) return Colors.grey;

    switch (colorName.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'silver':
        return Colors.grey;
      case 'gray':
        return const Color(0xFF808080);
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      case 'beige':
        return const Color(0xFFF5F5DC);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  Widget _buildVehicleCard(
    Vehicle vehicle,
    List<ServiceRecord>? serviceRecords,
  ) {
    final serviceCount = _getServiceCountForVehicle(vehicle.id, serviceRecords);

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.vehicleDetail.replaceAll(
            ':vehicleId',
            vehicle.id.toString(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withOpacity(0.2),
                    AppColors.accent.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  _getVehicleTypeIcon(vehicle.type),
                  color: AppColors.accent,
                  size: 28.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.primaryText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        vehicle.plateNumber,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 13.sp,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (vehicle.color != null &&
                          vehicle.color!.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _getColorFromName(vehicle.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          vehicle.color!,
                          style: TextStyle(
                            color: AppColors.secondaryText.withOpacity(0.8),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (vehicle.brand != null ||
                      vehicle.model != null ||
                      vehicle.year != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '${vehicle.brand ?? ''} ${vehicle.model ?? ''} ${vehicle.year ?? ''}'
                          .trim()
                          .replaceAll(RegExp(r'\s+'), ' '),
                      style: TextStyle(
                        color: AppColors.secondaryText.withOpacity(0.7),
                        fontSize: 12.sp,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.build_outlined,
                    size: 13.sp,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    serviceCount.toString(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Icon(
              Icons.directions_car_outlined,
              size: 48.sp,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Vehicles Yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first vehicle to start\ntracking maintenance records',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.secondaryText,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              context.push(AppRoutes.addVehicle);
            },
            icon: Icon(Icons.add, size: 18.sp),
            label: Text('Add Vehicle', style: TextStyle(fontSize: 14.sp)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 40.sp,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryText, fontSize: 14.sp),
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: () {
              context.read<VehicleCubit>().loadVehicles();
            },
            icon: Icon(Icons.refresh, size: 18.sp),
            label: Text('Retry', style: TextStyle(fontSize: 14.sp)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: BorderSide(color: AppColors.accent),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
