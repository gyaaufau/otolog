import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../resources/theme.dart';
import '../router.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IconData _getVehicleTypeIcon(String? type) {
    if (type == null) return Icons.directions_car;

    switch (type!.toLowerCase()) {
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
    context.read<VehicleCubit>().loadHomeData();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Vehicle? _getVehicleById(List<Vehicle> vehicles, int vehicleId) {
    try {
      return vehicles.firstWhere((v) => v.id == vehicleId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<VehicleCubit>().loadHomeData();
          },
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildStatsSection(),
                _buildRecentServicesSection(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        IconData headerIcon = Icons.directions_car;

        if (state is VehicleLoaded &&
            state.serviceRecords != null &&
            state.serviceRecords!.isNotEmpty) {
          // Find the most recent service and use its vehicle type for the icon
          final latestService = state.serviceRecords!.reduce(
            (a, b) => a.serviceDate.isAfter(b.serviceDate) ? a : b,
          );
          final vehicle = _getVehicleById(
            state.vehicles,
            latestService.vehicleId,
          );
          if (vehicle != null) {
            headerIcon = _getVehicleTypeIcon(vehicle.type);
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.2),
                      AppColors.accent.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(headerIcon, color: AppColors.accent, size: 24.sp),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoaded) {
          final vehicleCount = state.vehicles.length;
          final serviceCount = state.serviceCount ?? 0;
          final totalCost = state.totalCost ?? 0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                // Top Row: Last Service and Vehicle Count
                Row(
                  children: [
                    Expanded(flex: 2, child: _buildOverviewCard(state)),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 1,
                      child: _buildStatCard(
                        icon: Icons.directions_car,
                        label: 'Vehicles',
                        value: vehicleCount.toString(),
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Bottom Row: Service Count and Total Cost
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildStatCard(
                        icon: Icons.build,
                        label: 'Services',
                        value: serviceCount.toString(),
                        color: AppColors.warning,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: _buildStatCard(
                        icon: Icons.attach_money,
                        label: 'Total Cost',
                        value: _formatCurrency(totalCost),
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(VehicleLoaded state) {
    // Get the latest service
    ServiceRecord? latestService;
    Vehicle? latestVehicle;

    if (state.serviceRecords != null && state.serviceRecords!.isNotEmpty) {
      // Find the service with the most recent date
      latestService = state.serviceRecords!.reduce(
        (a, b) => a.serviceDate.isAfter(b.serviceDate) ? a : b,
      );
      latestVehicle = _getVehicleById(state.vehicles, latestService.vehicleId);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Service',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          if (latestService != null && latestVehicle != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(latestService.serviceDate),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getVehicleTypeIcon(latestVehicle.type),
                          size: 14.sp,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            latestVehicle.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    if (latestVehicle.type != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          latestVehicle.type!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            )
          else
            Text(
              'No services recorded yet',
              style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentServicesSection() {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoaded &&
            state.serviceRecords != null &&
            state.serviceRecords!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Services',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.analytics);
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 140.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: state.serviceRecords!.length,
                  itemBuilder: (context, index) {
                    final service = state.serviceRecords![index];
                    final vehicle = _getVehicleById(
                      state.vehicles,
                      service.vehicleId,
                    );
                    return _buildRecentServiceCard(service, vehicle);
                  },
                ),
              ),
              SizedBox(height: 24.h),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRecentServiceCard(ServiceRecord service, Vehicle? vehicle) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.serviceDetail
              .replaceAll(':vehicleId', service.vehicleId.toString())
              .replaceAll(':serviceId', service.id.toString()),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    service.serviceType,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                if (service.cost != null)
                  Text(
                    _formatCurrency(service.cost!),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            if (vehicle != null)
              Row(
                children: [
                  Icon(
                    _getVehicleTypeIcon(vehicle.type),
                    size: 14.sp,
                    color: AppColors.secondaryText,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (vehicle.type != null)
                          Text(
                            vehicle.type!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14.sp,
                  color: AppColors.secondaryText,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatDate(service.serviceDate),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
