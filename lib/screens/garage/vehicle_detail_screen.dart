import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/cubit/unit_cubit.dart';
import 'package:otolog/cubit/currency_cubit.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/commons/utils/image_picker_helper.dart';
import 'package:otolog/shared/commons/utils/unit_converter.dart';
import 'package:otolog/shared/constants/unit.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import '../../cubit/vehicle_detail_cubit.dart';
import '../../cubit/vehicle_detail_state.dart';
import '../../cubit/vehicle_list_cubit.dart';
import '../../cubit/vehicle_list_state.dart';
import '../../resources/colors.dart';
import '../../router.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int? _vehicleId;
  bool? _localIsPrimary;
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

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
        context.read<VehicleDetailCubit>().loadVehicleWithServices(vehicleId);
      }
    }
  }

  Future<void> _showImagePickerOptions() async {
    if (_vehicleId == null) return;

    // Store cubit reference before showing modal to avoid context issues
    final cubit = context.read<VehicleDetailCubit>();
    final vehicleId = _vehicleId!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.neutral[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      context.l10n.changePhoto,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral[900],
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(height: 1, color: AppColors.neutral[100]),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      context.l10n.takePhoto,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral[900],
                        letterSpacing: -0.1,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final image = await _imagePickerHelper
                          .pickImageFromCamera(context);
                      if (image != null) {
                        cubit.updateVehicleImage(vehicleId, image.path);
                      }
                    },
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      context.l10n.chooseFromGallery,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral[900],
                        letterSpacing: -0.1,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final image = await _imagePickerHelper
                          .pickImageFromGallery(context);
                      if (image != null) {
                        cubit.updateVehicleImage(vehicleId, image.path);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
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
          context.l10n.vehicleDetails,
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
      // Listen to VehicleListCubit for toggle primary updates
      body: BlocListener<VehicleListCubit, VehicleListState>(
        listener: (context, state) {
          // Sync local state with actual state after toggle completes
          if (state is VehicleListLoaded && _vehicleId != null) {
            final updatedVehicle = state.vehicles.firstWhere(
              (v) => v.id == _vehicleId,
              orElse: () => state.vehicles.first,
            );
            setState(() {
              _localIsPrimary = updatedVehicle.isPrimary;
            });
          }
        },
        child: BlocConsumer<VehicleDetailCubit, VehicleDetailState>(
          listener: (context, state) {
            // Sync local state when vehicle data loads
            if (state is VehicleDetailLoaded) {
              setState(() {
                _localIsPrimary = state.vehicle.isPrimary;
              });
            }
            // Reload vehicle data when returning from edit screen
            if (state is VehicleDetailOperationSuccess && _vehicleId != null) {
              print('🔄 Reloading vehicle data after edit');
              context.read<VehicleDetailCubit>().loadVehicleWithServices(
                _vehicleId!,
              );
            }
          },
          builder: (context, state) {
            if (state is VehicleDetailLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  strokeWidth: 2,
                ),
              );
            }
            if (state is VehicleDetailError) {
              return _buildErrorState(state.message);
            }

            if (state is VehicleDetailLoaded) {
              return _buildVehicleDetail(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildVehicleDetail(VehicleDetailLoaded state) {
    final vehicle = state.vehicle;
    final purchaseInfoWidget = _buildPurchaseInfo(vehicle);
    final hasPurchaseInfo = vehicle.purchaseDate != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleHeader(vehicle),
          SizedBox(height: 24.h),
          _buildPrimaryToggleSection(vehicle),
          SizedBox(height: 24.h),
          _buildVehicleSpecifications(vehicle),
          SizedBox(height: 24.h),
          _buildVehicleDetails(vehicle),
          SizedBox(height: hasPurchaseInfo ? 24.h : 12.h),
          purchaseInfoWidget,
          SizedBox(height: hasPurchaseInfo ? 24.h : 12.h),
          _buildServiceStatistics(state),
          SizedBox(height: 24.h),
          _buildRecentServices(state.serviceRecords),
          SizedBox(height: 24.h),
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
                        if (_localIsPrimary ?? vehicle.isPrimary ?? false) ...[
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
                                  context.l10n.primary,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showImagePickerOptions,
              icon: Icon(Icons.camera_alt, size: 18),
              label: Text(context.l10n.changePhoto),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.neutral[100]),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context.l10n.plate,
                  vehicle.plateNumber,
                  Icons.confirmation_number_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context.l10n.odometer,
                  _formatOdometer(vehicle.odometer),
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
      if (vehicle.type != null) _SpecItem(context.l10n.type, vehicle.type!),
      if (vehicle.color != null) _SpecItem(context.l10n.color, vehicle.color!),
      if (vehicle.fuelType != null)
        _SpecItem(context.l10n.fuelType, vehicle.fuelType!),
      if (vehicle.transmissionType != null)
        _SpecItem(context.l10n.transmissionType, vehicle.transmissionType!),
    ];

    if (specs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
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
            context.l10n.specifications,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 16.h),
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
      padding: const EdgeInsets.all(8),
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
                const SizedBox(height: 2),
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
        _DetailItem(context.l10n.vin, vehicle.vin!),
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
            context.l10n.vehicleDetails,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20),
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
                  context.l10n.purchaseDate,
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

  Widget _buildServiceStatistics(VehicleDetailLoaded state) {
    final totalCost = state.totalCost;
    final serviceCount = state.serviceCount;
    final averageCost = state.averageCost;
    final daysSinceLastService = state.daysSinceLastService;

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
            context.l10n.serviceStatistics,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildEnhancedStatCard(
                    context.l10n.totalServicesLabel,
                    serviceCount.toString(),
                    Icons.build_outlined,
                    AppColors.primary,
                    _getTrendIndicator(serviceCount > 5),
                  );
                case 1:
                  return BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, currencyState) {
                      final currencySymbol =
                          context.read<CurrencyCubit>().currentCurrencySymbol;
                      return _buildEnhancedStatCard(
                        context.l10n.totalCostLabel,
                        '$currencySymbol${totalCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        Icons.payments_outlined,
                        AppColors.tertiary,
                        null,
                      );
                    },
                  );
                case 2:
                  return BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, currencyState) {
                      final currencySymbol =
                          context.read<CurrencyCubit>().currentCurrencySymbol;
                      return _buildEnhancedStatCard(
                        context.l10n.averageCostLabel,
                        '$currencySymbol${averageCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        Icons.trending_up_outlined,
                        AppColors.secondary,
                        null,
                      );
                    },
                  );
                case 3:
                  return _buildEnhancedStatCard(
                    context.l10n.daysSinceLastServiceLabel,
                    '$daysSinceLastService',
                    Icons.access_time_outlined,
                    _getDaysSinceServiceColor(daysSinceLastService),
                    _getDaysSinceServiceTrend(daysSinceLastService),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
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

  Widget _buildEnhancedStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String? trend,
  ) {
    final isCurrencyValue =
        value.contains('\$') ||
        value.contains('€') ||
        value.contains('£') ||
        value.contains('¥') ||
        value.contains('Rp') ||
        value.contains('IDR') ||
        value.contains('USD') ||
        value.contains('EUR') ||
        value.contains('GBP');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              if (trend != null)
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color:
                          trend == 'up'
                              ? AppColors.tertiary.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trend == 'up'
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 10,
                          color:
                              trend == 'up'
                                  ? AppColors.tertiary
                                  : AppColors.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          trend == 'up' ? 'Good' : 'Check',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color:
                                trend == 'up'
                                    ? AppColors.tertiary
                                    : AppColors.error,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[500],
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isCurrencyValue ? 16 : 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _getTrendIndicator(bool isPositive) {
    return isPositive ? 'up' : null;
  }

  Color _getDaysSinceServiceColor(int days) {
    if (days <= 30) {
      return AppColors.tertiary;
    } else if (days <= 90) {
      return AppColors.secondary;
    } else {
      return AppColors.error;
    }
  }

  String? _getDaysSinceServiceTrend(int days) {
    if (days <= 30) {
      return 'up';
    } else if (days <= 90) {
      return null;
    } else {
      return 'down';
    }
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
                context.l10n.recentServices,
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
                    context.go(AppRoutes.serviceLogs);
                  },
                  child: Text(
                    context.l10n.seeAll,
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
          SizedBox(height: 20),
          if (recentServices.isEmpty)
            _buildEmptyRecentServicesState()
          else
            ...recentServices.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;
              return Column(
                children: [
                  _buildServiceItem(service),
                  if (index < recentServices.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 1,
                        color: AppColors.neutral[100],
                      ),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildEmptyRecentServicesState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.neutral[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.build_outlined,
              size: 32,
              color: AppColors.neutral[400],
            ),
          ),
          SizedBox(height: 16),
          Text(
            context.l10n.noServices,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[700],
              letterSpacing: -0.1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            context.l10n.addFirstService,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral[500],
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
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
            BlocBuilder<CurrencyCubit, CurrencyState>(
              builder: (context, currencyState) {
                final currencySymbol =
                    context.read<CurrencyCubit>().currentCurrencySymbol;
                return Text(
                  '$currencySymbol${service.cost!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral[900],
                    letterSpacing: -0.1,
                  ),
                );
              },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_outlined, size: 20),
                const SizedBox(width: 12),
                Text(
                  context.l10n.addServiceRecord,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.l10n.edit,
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
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.error.withOpacity(0.3),
              width: 1,
            ),
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
              _showDeleteConfirmationDialog();
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
                const Icon(Icons.delete_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.l10n.delete,
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
      ],
    );
  }

  Widget _buildPrimaryToggleSection(dynamic vehicle) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.primary,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[900],
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.setPrimaryVehicleDescription,
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
          const SizedBox(width: 16),
          CupertinoSwitch(
            value: _localIsPrimary ?? vehicle.isPrimary ?? false,
            activeColor: AppColors.primary,
            onChanged: (value) {
              if (_vehicleId != null) {
                // Update local state immediately for smooth UI
                setState(() {
                  _localIsPrimary = value;
                });
                // Call cubit method to update database
                context.read<VehicleListCubit>().togglePrimary(_vehicleId!);
              }
            },
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

  void _showDeleteConfirmationDialog() {
    if (_vehicleId == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              context.l10n.deleteVehicle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: Text(
              context.l10n.deleteVehicleConfirmation,
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
                  context.read<VehicleListCubit>().deleteVehicle(_vehicleId!);
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
    final currencySymbol = context.read<CurrencyCubit>().currentCurrencySymbol;
    return '$currencySymbol${cost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _formatOdometer(int? odometer) {
    final unitState = context.watch<UnitCubit>().state;
    if (odometer == null) {
      return 'N/A';
    }
    return UnitConverter.formatDistance(odometer!, unitState.unit);
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
