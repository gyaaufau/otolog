import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/service_record.dart';
import '../models/vehicle.dart';
import '../resources/theme.dart';
import '../router.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int serviceId;
  final int vehicleId;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.vehicleId,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ServiceRecord? _serviceRecord;
  Vehicle? _vehicle;
  ServiceRecord? _lastService;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<VehicleCubit>().loadVehicleWithServices(widget.vehicleId);
  }

  ServiceRecord? _findLastService(
    List<ServiceRecord> allServices,
    ServiceRecord currentService,
  ) {
    try {
      final sameTypeServices =
          allServices
              .where(
                (s) =>
                    s.serviceType.toLowerCase() ==
                    currentService.serviceType.toLowerCase(),
              )
              .toList();
      sameTypeServices.sort((a, b) => b.serviceDate.compareTo(a.serviceDate));
      if (sameTypeServices.length > 1) {
        return sameTypeServices[1]; // Return second most recent (last before current)
      }
    } catch (e) {
      return null;
    }
    return null;
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

  String _formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
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

  void _showDeleteDialog(BuildContext context) {
    if (_serviceRecord == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Service Record'),
            content: Text(
              'Are you sure you want to delete this ${_serviceRecord!.serviceType} record?',
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
                    _serviceRecord!.id,
                    widget.vehicleId,
                  );
                  context.pop();
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        actions: [
          if (_serviceRecord != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleLoaded) {
            // Find service record
            final serviceRecords = state.serviceRecords ?? [];
            _serviceRecord = serviceRecords.firstWhere(
              (record) => record.id == widget.serviceId,
              orElse: () => _serviceRecord!,
            );

            // Find vehicle
            if (state.vehicles.isNotEmpty) {
              _vehicle = state.vehicles.first;
            }

            // Find last service of the same type
            if (_serviceRecord != null) {
              _lastService = _findLastService(serviceRecords, _serviceRecord!);
            }

            if (_serviceRecord == null) {
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
                      'Service record not found',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Type and Icon
                        Row(
                          children: [
                            Container(
                              width: 64.w,
                              height: 64.h,
                              decoration: BoxDecoration(
                                color: _getServiceTypeColor(
                                  _serviceRecord!.serviceType,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                _getServiceTypeIcon(
                                  _serviceRecord!.serviceType,
                                ),
                                color: Colors.white,
                                size: 32.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _serviceRecord!.serviceType,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    _formatDate(_serviceRecord!.serviceDate),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_serviceRecord!.cost != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatCurrency(_serviceRecord!.cost!),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  Text(
                                    'Cost',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // Vehicle Information
                        if (_vehicle != null) ...[
                          InkWell(
                            onTap: () {
                              context.push(
                                AppRoutes.vehicleDetail.replaceAll(
                                  ':vehicleId',
                                  _vehicle!.id.toString(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      _getVehicleTypeIcon(_vehicle?.type),
                                      color: AppColors.accent,
                                      size: 20.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _vehicle!.name,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          _vehicle!.plateNumber,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
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
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Last Service Information
                  if (_lastService != null) ...[
                    Text(
                      'Last Service of This Type',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: _getServiceTypeColor(
                                _lastService!.serviceType,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              _getServiceTypeIcon(_lastService!.serviceType),
                              color: _getServiceTypeColor(
                                _lastService!.serviceType,
                              ),
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lastService!.serviceType,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _formatDate(_lastService!.serviceDate),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_lastService!.cost != null)
                            Text(
                              _formatCurrency(_lastService!.cost!),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Service Details
                  Text(
                    'Service Details',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Service Date',
                          _formatDate(_serviceRecord!.serviceDate),
                        ),
                        if (_serviceRecord!.mechanic != null) ...[
                          SizedBox(height: 16.h),
                          _buildDetailRow(
                            Icons.person,
                            'Mechanic',
                            _serviceRecord!.mechanic!,
                          ),
                        ],
                        if (_serviceRecord!.description != null) ...[
                          SizedBox(height: 16.h),
                          _buildDetailRow(
                            Icons.description,
                            'Description',
                            _serviceRecord!.description!,
                          ),
                        ],
                        if (_serviceRecord!.notes != null) ...[
                          SizedBox(height: 16.h),
                          _buildDetailRow(
                            Icons.note,
                            'Notes',
                            _serviceRecord!.notes!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Timestamp Information
                  Text(
                    'Timestamp Information',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.add_circle_outline,
                          'Created At',
                          _formatDateTime(_serviceRecord!.createdAt),
                        ),
                        SizedBox(height: 16.h),
                        _buildDetailRow(
                          Icons.update,
                          'Last Updated',
                          _formatDateTime(_serviceRecord!.updatedAt),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
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
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.accent),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, color: AppColors.primaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
