import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import '../resources/theme.dart';
import '../router.dart';
import '../shared/commons/utils/image_picker_helper.dart';
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

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.secondaryText),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: AppColors.accent),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePickerOptions(
    BuildContext context,
    Vehicle vehicle,
  ) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update Vehicle Photo',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildImagePickerOption(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromGallery(vehicle);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildImagePickerOption(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromCamera(vehicle);
                        },
                      ),
                    ),
                  ],
                ),
                if (vehicle.imagePath != null) ...[
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _removeVehicleImage(vehicle);
                      },
                      icon: Icon(Icons.delete_outline, color: AppColors.error),
                      label: Text(
                        'Remove Photo',
                        style: TextStyle(color: AppColors.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(
                          color: AppColors.error.withOpacity(0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28.sp, color: AppColors.accent),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery(Vehicle vehicle) async {
    final imagePickerHelper = ImagePickerHelper();
    final imageFile = await imagePickerHelper.pickImageFromGallery(context);

    if (imageFile != null) {
      _updateVehicleImage(vehicle, imageFile.path);
    }
  }

  Future<void> _pickImageFromCamera(Vehicle vehicle) async {
    final imagePickerHelper = ImagePickerHelper();
    final imageFile = await imagePickerHelper.pickImageFromCamera(context);

    if (imageFile != null) {
      _updateVehicleImage(vehicle, imageFile.path);
    }
  }

  void _updateVehicleImage(Vehicle vehicle, String imagePath) {
    final updatedVehicle = Vehicle(
      name: vehicle.name,
      plateNumber: vehicle.plateNumber,
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      color: vehicle.color,
      type: vehicle.type,
      vin: vehicle.vin,
      purchaseDate: vehicle.purchaseDate,
      odometer: vehicle.odometer,
      fuelType: vehicle.fuelType,
      transmissionType: vehicle.transmissionType,
      imagePath: imagePath,
    )..id = vehicle.id;

    context.read<VehicleCubit>().updateVehicle(updatedVehicle);
  }

  void _removeVehicleImage(Vehicle vehicle) {
    final updatedVehicle = Vehicle(
      name: vehicle.name,
      plateNumber: vehicle.plateNumber,
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      color: vehicle.color,
      type: vehicle.type,
      vin: vehicle.vin,
      purchaseDate: vehicle.purchaseDate,
      odometer: vehicle.odometer,
      fuelType: vehicle.fuelType,
      transmissionType: vehicle.transmissionType,
      imagePath: null,
    )..id = vehicle.id;

    context.read<VehicleCubit>().updateVehicle(updatedVehicle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicle Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: false,
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
                  tooltip: 'Delete vehicle',
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

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 80.h),
              child: Column(
                children: [
                  // Vehicle Info Card
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with icon and name
                        Row(
                          children: [
                            Container(
                              width: 52.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                _getVehicleTypeIcon(vehicle.type),
                                color: AppColors.accent,
                                size: 26.sp,
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
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    vehicle.plateNumber,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.secondaryText,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Vehicle details
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Column(
                            children: [
                              if (vehicle.type != null)
                                _buildDetailRow(
                                  icon: Icons.category_outlined,
                                  label: 'Type',
                                  value: vehicle.type!,
                                ),
                              if (vehicle.brand != null)
                                _buildDetailRow(
                                  icon: Icons.business,
                                  label: 'Brand',
                                  value: vehicle.brand!,
                                ),
                              if (vehicle.model != null)
                                _buildDetailRow(
                                  icon: Icons.model_training,
                                  label: 'Model',
                                  value: vehicle.model!,
                                ),
                              if (vehicle.year != null)
                                _buildDetailRow(
                                  icon: Icons.calendar_today,
                                  label: 'Year',
                                  value: vehicle.year!,
                                ),
                              if (vehicle.color != null)
                                _buildDetailRow(
                                  icon: Icons.palette,
                                  label: 'Color',
                                  value: vehicle.color!,
                                ),
                              if (vehicle.vin != null)
                                _buildDetailRow(
                                  icon: Icons.vpn_key,
                                  label: 'VIN',
                                  value: vehicle.vin!,
                                ),
                              if (vehicle.fuelType != null)
                                _buildDetailRow(
                                  icon: Icons.local_gas_station,
                                  label: 'Fuel Type',
                                  value: vehicle.fuelType!,
                                ),
                              if (vehicle.transmissionType != null)
                                _buildDetailRow(
                                  icon: Icons.settings_input_component,
                                  label: 'Transmission',
                                  value: vehicle.transmissionType!,
                                ),
                              if (vehicle.odometer != null)
                                _buildDetailRow(
                                  icon: Icons.speed,
                                  label: 'Odometer',
                                  value: '${vehicle.odometer} km',
                                ),
                              if (vehicle.purchaseDate != null)
                                _buildDetailRow(
                                  icon: Icons.event,
                                  label: 'Purchase Date',
                                  value: _formatDate(vehicle.purchaseDate!),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vehicle Picture Section
                  if (vehicle.imagePath != null)
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vehicle Photo',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.accent,
                                  size: 20.sp,
                                ),
                                onPressed:
                                    () => _showImagePickerOptions(
                                      context,
                                      vehicle,
                                    ),
                                tooltip: 'Change photo',
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap:
                                () => _showImagePickerOptions(context, vehicle),
                            child: Container(
                              width: double.infinity,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  File(vehicle.imagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 48.sp,
                                            color: AppColors.secondaryText,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Failed to load image',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle Photo',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap:
                                () => _showImagePickerOptions(context, vehicle),
                            child: Container(
                              width: double.infinity,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.border,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64.w,
                                      height: 64.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        size: 32.sp,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Add Vehicle Photo',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Tap to select from gallery or camera',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                          child: _buildStatCard(
                            value: '$serviceCount',
                            label: 'Services',
                            icon: Icons.history,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            value: _formatCurrency(totalCost),
                            label: 'Total Cost',
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Service Records Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Records',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          '$serviceCount record${serviceCount != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (serviceRecords.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 40.h,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 56.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.history_outlined,
                                size: 28.sp,
                                color: AppColors.accent,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No service records',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Start tracking your vehicle maintenance',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children:
                          serviceRecords.map((record) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.r),
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
                                    child: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: _getServiceTypeColor(
                                                record.serviceType,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Icon(
                                              _getServiceTypeIcon(
                                                record.serviceType,
                                              ),
                                              color: Colors.white,
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
                                                  record.serviceType,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.primaryText,
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  _formatDate(
                                                    record.serviceDate,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color:
                                                        AppColors.secondaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (record.cost != null)
                                            Text(
                                              _formatCurrency(record.cost!),
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          SizedBox(width: 8.w),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: AppColors.secondaryText
                                                  .withOpacity(0.6),
                                              size: 18.sp,
                                            ),
                                            onPressed: () {
                                              _showDeleteServiceDialog(
                                                context,
                                                record,
                                              );
                                            },
                                            visualDensity:
                                                VisualDensity.compact,
                                            padding: EdgeInsets.all(4.w),
                                            constraints: BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        onPressed: () {
          context.push(
            AppRoutes.addService.replaceAll(
              ':vehicleId',
              widget.vehicleId.toString(),
            ),
          );
        },
        icon: Icon(Icons.add, color: AppColors.background, size: 20.sp),
        label: Text(
          'Add Service',
          style: TextStyle(
            color: AppColors.background,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
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
