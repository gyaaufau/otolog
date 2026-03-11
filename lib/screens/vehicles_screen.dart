import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../constants/theme.dart';
import '../router.dart';
import '../models/vehicle.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();

  IconData _getVehicleTypeIcon(String? type) {
    if (type == null || type.trim().isEmpty) return Icons.directions_car;

    final typeLower = type.trim().toLowerCase();
    switch (typeLower) {
      case 'car':
        return Icons.directions_car;
      case 'motor':
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              style: TextStyle(color: AppColors.primaryText, fontSize: 14.sp),
              onChanged: (value) {
                context.read<VehicleCubit>().searchVehicles(value);
              },
            ),
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
                        return _buildVehicleCard(vehicle);
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

  Widget _buildVehicleCard(Vehicle vehicle) {
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
                    AppColors.accent.withOpacity(0.25),
                    AppColors.accent.withOpacity(0.1),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.confirmation_number,
                        size: 14.sp,
                        color: AppColors.secondaryText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        vehicle.plateNumber,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  if (vehicle.type != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          vehicle.type!,
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (vehicle.brand != null || vehicle.model != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${vehicle.brand ?? ''} ${vehicle.model ?? ''} ${vehicle.year ?? ''}'
                              .trim(),
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondaryText,
              size: 20.sp,
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
