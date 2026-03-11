import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import '../constants/theme.dart';
import '../router.dart';
import 'add_service_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final int vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
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
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        actions: [
          BlocBuilder<VehicleCubit, VehicleState>(
            builder: (context, state) {
              if (state is VehicleLoaded && state.vehicles.isNotEmpty) {
                return IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
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
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
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
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  vehicle.plateNumber,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      if (vehicle.type != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 18.sp,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                vehicle.type!,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (vehicle.brand != null || vehicle.model != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              if (vehicle.brand != null) ...[
                                Icon(
                                  Icons.business_outlined,
                                  size: 18.sp,
                                  color: AppColors.secondaryText,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  vehicle.brand!,
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                              ],
                              if (vehicle.model != null) ...[
                                Icon(
                                  Icons.category_outlined,
                                  size: 18.sp,
                                  color: AppColors.secondaryText,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  vehicle.model!,
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 14.sp,
                                  ),
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
                                size: 18.sp,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                vehicle.year!,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                            ],
                            if (vehicle.color != null) ...[
                              Icon(
                                Icons.palette_outlined,
                                size: 18.sp,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                vehicle.color!,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                // Statistics
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 80.h,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$serviceCount',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Services',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 80.h,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _formatCurrency(totalCost),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Total Cost',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
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
                                  size: 64.sp,
                                  color: AppColors.secondaryText,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No service records yet',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Tap + to add your first service record',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: serviceRecords.length,
                            itemBuilder: (context, index) {
                              final record = serviceRecords[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  leading: Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: _getServiceTypeColor(
                                        record.serviceType,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      _getServiceTypeIcon(record.serviceType),
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                  ),
                                  title: Text(
                                    record.serviceType,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDate(record.serviceDate),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                        if (record.cost != null)
                                          Text(
                                            _formatCurrency(record.cost!),
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppColors.primaryText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: AppColors.secondaryText,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      _showDeleteServiceDialog(context, record);
                                    },
                                  ),
                                  onTap: () {
                                    context.push(
                                      AppRoutes.serviceDetail
                                          .replaceAll(
                                            ':vehicleId',
                                            widget.vehicleId.toString(),
                                          )
                                          .replaceAll(
                                            ':serviceId',
                                            record.id.toString(),
                                          ),
                                    );
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
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () {
          context.push(
            AppRoutes.addService.replaceAll(
              ':vehicleId',
              widget.vehicleId.toString(),
            ),
          );
        },
        child: Icon(Icons.add, color: AppColors.background, size: 24.sp),
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
                  context.pop();
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
