import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../l10n/app_localizations.dart';
import '../../shared/localization/l10n_helper.dart';
import '../../cubit/vehicle_detail_cubit.dart';
import '../../cubit/vehicle_detail_state.dart';
import '../../cubit/vehicle_list_cubit.dart';
import '../../cubit/service_vehicle_selector_cubit.dart';
import '../../cubit/service_vehicle_selector_state.dart';
import '../../database/database.dart';
import '../../resources/colors.dart';
import '../../widgets/modal_dropdown_field.dart';
import '../../router.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _mechanicController = TextEditingController();
  final _notesController = TextEditingController();
  final _odometerController = TextEditingController();

  DateTime? _serviceDate;
  String? _selectedServiceType;
  int? _vehicleId;
  bool _isSaving = false;

  List<String> get _serviceTypes => [
    context.l10n.oilChange,
    context.l10n.tireRotation,
    context.l10n.brakeService,
    context.l10n.batteryReplacement,
    context.l10n.engineTuneUp,
    context.l10n.airFilterReplacement,
    context.l10n.transmissionService,
    context.l10n.coolantFlush,
    context.l10n.sparkPlugReplacement,
    context.l10n.wheelAlignment,
    context.l10n.suspensionService,
    context.l10n.exhaustSystemRepair,
    context.l10n.acService,
    context.l10n.inspection,
    context.l10n.other,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('📱 [AddServiceScreen] didChangeDependencies called');

    if (_vehicleId == null) {
      final vehicleId = int.tryParse(
        GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
      );
      print('📱 [AddServiceScreen] Vehicle ID from route: $vehicleId');
      if (vehicleId != null) {
        setState(() {
          _vehicleId = vehicleId;
        });
        print('📱 [AddServiceScreen] Local _vehicleId set to: $_vehicleId');
        context.read<VehicleDetailCubit>().loadVehicleWithServices(vehicleId);
      }
    } else {
      print('📱 [AddServiceScreen] Local _vehicleId already set: $_vehicleId');
    }

    // Load all vehicles for vehicle selection
    print(
      '📱 [AddServiceScreen] Calling loadVehicles() on ServiceVehicleSelectorCubit',
    );
    context.read<ServiceVehicleSelectorCubit>().loadVehicles();
  }

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _mechanicController.dispose();
    _notesController.dispose();
    _odometerController.dispose();
    super.dispose();
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
          context.l10n.addServiceRecord,
          style: TextStyle(
            color: AppColors.neutral[900],
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
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
      body: Column(
        children: [
          BlocBuilder<ServiceVehicleSelectorCubit, ServiceVehicleSelectorState>(
            builder: (context, vehicleSelectorState) {
              print('📱 [AddServiceScreen] BlocBuilder rebuilt');
              print(
                '📱 [AddServiceScreen]   State type: ${vehicleSelectorState.runtimeType}',
              );

              if (vehicleSelectorState is ServiceVehicleSelectorLoading) {
                print('📱 [AddServiceScreen]   State is Loading');
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              if (vehicleSelectorState is ServiceVehicleSelectorError) {
                print(
                  '📱 [AddServiceScreen]   State is Error: ${vehicleSelectorState.message}',
                );
                return Expanded(
                  child: Center(child: Text(context.l10n.failedToLoadVehicles)),
                );
              }

              if (vehicleSelectorState is ServiceVehicleSelectorLoaded) {
                print(
                  '📱 [AddServiceScreen]   State is Loaded with ${vehicleSelectorState.vehicles.length} vehicles',
                );
                print(
                  '📱 [AddServiceScreen]   selectedVehicleId in state: ${vehicleSelectorState.selectedVehicleId}',
                );
                print('📱 [AddServiceScreen]   local _vehicleId: $_vehicleId');

                // Sync local _vehicleId with cubit state if they differ
                if (vehicleSelectorState.selectedVehicleId != null &&
                    vehicleSelectorState.selectedVehicleId != _vehicleId) {
                  print(
                    '📱 [AddServiceScreen]   ⚠️ Syncing local _vehicleId with cubit state',
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _vehicleId = vehicleSelectorState.selectedVehicleId;
                    });
                    print(
                      '📱 [AddServiceScreen]   Local _vehicleId synced to: $_vehicleId',
                    );
                  });
                }

                if (_vehicleId == null &&
                    vehicleSelectorState.selectedVehicleId == null &&
                    vehicleSelectorState.vehicles.isNotEmpty) {
                  final defaultVehicle = vehicleSelectorState.vehicles.first;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted || _vehicleId != null) {
                      return;
                    }

                    context.read<ServiceVehicleSelectorCubit>().selectVehicle(
                      defaultVehicle.id,
                    );
                    setState(() {
                      _vehicleId = defaultVehicle.id;
                    });
                  });
                }
              }

              final vehicles =
                  vehicleSelectorState is ServiceVehicleSelectorLoaded
                      ? vehicleSelectorState.vehicles
                      : <dynamic>[];

              final selectedVehicleId =
                  vehicleSelectorState is ServiceVehicleSelectorLoaded
                      ? vehicleSelectorState.selectedVehicleId
                      : null;

              return Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVehicleSelector(vehicles, selectedVehicleId),
                        const SizedBox(height: 24),
                        _buildServiceTypeField(),
                        const SizedBox(height: 20),
                        _buildServiceDatePicker(),
                        const SizedBox(height: 20),
                        _buildOdometerField(),
                        const SizedBox(height: 20),
                        _buildDescriptionField(),
                        const SizedBox(height: 20),
                        _buildCostField(),
                        const SizedBox(height: 20),
                        _buildMechanicField(),
                        const SizedBox(height: 20),
                        _buildNotesField(),
                        const SizedBox(height: 32),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSelector(List<dynamic> vehicles, int? selectedVehicleId) {
    final l10n = context.l10n;
    print('📱 [AddServiceScreen] _buildVehicleSelector called');
    print('📱 [AddServiceScreen]   vehicles.length: ${vehicles.length}');
    print(
      '📱 [AddServiceScreen]   selectedVehicleId from cubit: $selectedVehicleId',
    );
    print('📱 [AddServiceScreen]   local _vehicleId: $_vehicleId');

    dynamic selectedVehicle;
    if (selectedVehicleId != null && vehicles.isNotEmpty) {
      try {
        selectedVehicle = vehicles.firstWhere((v) => v.id == selectedVehicleId);
        print(
          '📱 [AddServiceScreen]   Found selected vehicle: id=${selectedVehicle.id}, name="${selectedVehicle.name}"',
        );
      } catch (e) {
        print(
          '📱 [AddServiceScreen]   ⚠️ Vehicle with id=$selectedVehicleId not found, using first vehicle',
        );
        selectedVehicle = vehicles.first;
      }
    } else if (vehicles.isNotEmpty) {
      print(
        '📱 [AddServiceScreen]   No selectedVehicleId, using first vehicle',
      );
      selectedVehicle = vehicles.first;
    } else {
      print('📱 [AddServiceScreen]   No vehicles available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectVehicle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                _vehicleId != null
                    ? AppColors.primary[500]
                    : AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap:
              vehicles.isEmpty
                  ? null
                  : () => _showVehicleSelectionModal(vehicles),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _vehicleId != null
                        ? AppColors.primary[500]!
                        : AppColors.neutral[200]!,
                width: _vehicleId != null ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selectedVehicle != null
                      ? Icons.directions_car
                      : Icons.add_circle_outline,
                  color:
                      selectedVehicle != null
                          ? AppColors.primary[500]
                          : AppColors.neutral[400],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      selectedVehicle != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedVehicle.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.neutral[900],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (selectedVehicle.brand != null ||
                                  selectedVehicle.model != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '${selectedVehicle.brand ?? ''} ${selectedVehicle.model ?? ''}'
                                      .trim(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          )
                          : Text(
                            l10n.selectAVehicle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.neutral[400],
                            ),
                          ),
                ),
                Icon(
                  Icons.keyboard_arrow_up,
                  color: AppColors.neutral[500],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (vehicles.isEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiary[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.tertiary[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.tertiary[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.noVehiclesAvailablePleaseAddVehicleFirst,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.tertiary[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showVehicleSelectionModal(List<dynamic> vehicles) {
    final l10n = context.l10n;
    print('📱 [AddServiceScreen] _showVehicleSelectionModal called');
    print(
      '📱 [AddServiceScreen]   Showing ${vehicles.length} vehicles in modal',
    );
    print('📱 [AddServiceScreen]   Current local _vehicleId: $_vehicleId');

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
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        final isSelected = vehicle.id == _vehicleId;
                        print(
                          '📱 [AddServiceScreen]   Vehicle $index: id=${vehicle.id}, name="${vehicle.name}", isSelected=$isSelected (comparing with local _vehicleId=$_vehicleId)',
                        );

                        return InkWell(
                          onTap: () {
                            print(
                              '📱 [AddServiceScreen]   Vehicle tapped: id=${vehicle.id}, name="${vehicle.name}"',
                            );
                            print(
                              '📱 [AddServiceScreen]   Calling selectVehicle(${vehicle.id}) on cubit',
                            );

                            // Update cubit state
                            context
                                .read<ServiceVehicleSelectorCubit>()
                                .selectVehicle(vehicle.id);

                            // FIX: Also update local _vehicleId to stay in sync
                            setState(() {
                              _vehicleId = vehicle.id;
                            });
                            print(
                              '📱 [AddServiceScreen]   Local _vehicleId updated to: $_vehicleId',
                            );

                            Navigator.pop(context);
                            print('📱 [AddServiceScreen]   Modal closed');
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
                                  child: Icon(
                                    Icons.directions_car,
                                    size: 24,
                                    color: AppColors.primary,
                                  ),
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

  Widget _buildServiceTypeField() {
    final l10n = context.l10n;
    return ModalDropdownField(
      label: l10n.serviceType,
      hint: l10n.selectServiceType,
      value: _selectedServiceType,
      items: _serviceTypes,
      showLabel: true,
      onChanged: (value) {
        setState(() {
          _selectedServiceType = value;
        });
      },
    );
  }

  Widget _buildServiceDatePicker() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.serviceDate,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                _serviceDate != null
                    ? AppColors.primary[500]
                    : AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _serviceDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary[500]!,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: AppColors.neutral[900]!,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && mounted) {
              setState(() {
                _serviceDate = picked;
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _serviceDate != null
                        ? AppColors.primary[500]!
                        : AppColors.neutral[200]!,
                width: _serviceDate != null ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color:
                      _serviceDate != null
                          ? AppColors.primary[500]
                          : AppColors.neutral[500],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _serviceDate != null
                        ? '${_serviceDate!.day}/${_serviceDate!.month}/${_serviceDate!.year}'
                        : l10n.selectServiceDate,
                    style: TextStyle(
                      color:
                          _serviceDate != null
                              ? AppColors.neutral[900]
                              : AppColors.neutral[400],
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOdometerField() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.odometer,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral[700],
                letterSpacing: 0.15,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${l10n.optional})',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.neutral[500],
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _odometerController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: l10n.enterOdometerReading,
            hintStyle: TextStyle(color: AppColors.neutral[400], fontSize: 15),
            prefixIcon: Icon(Icons.speed, color: AppColors.neutral[500]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary[500]!,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.describeServicePerformed,
            hintStyle: TextStyle(color: AppColors.neutral[400], fontSize: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary[500]!,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCostField() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.costIDR,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _costController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: l10n.exampleCost,
            hintStyle: TextStyle(color: AppColors.neutral[400], fontSize: 15),
            prefixIcon: Icon(Icons.attach_money, color: AppColors.neutral[500]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary[500]!,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMechanicField() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mechanicShop,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _mechanicController,
          decoration: InputDecoration(
            hintText: l10n.exampleMechanic,
            hintStyle: TextStyle(color: AppColors.neutral[400], fontSize: 15),
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.neutral[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary[500]!,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.notes,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral[700],
                letterSpacing: 0.15,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${l10n.optional})',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.neutral[500],
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.additionalNotesOrObservations,
            hintStyle: TextStyle(color: AppColors.neutral[400], fontSize: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary[500]!,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
      builder: (context, state) {
        final isLoading = _isSaving || state is VehicleDetailLoading;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary[500]!,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveService,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                    : Text(
                      context.l10n.saveServiceRecord,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
          ),
        );
      },
    );
  }

  Future<void> _saveService() async {
    print('📱 [AddServiceScreen] _saveService called');
    print(
      '📱 [AddServiceScreen]   Form validation: ${_formKey.currentState!.validate()}',
    );
    print('📱 [AddServiceScreen]   _vehicleId: $_vehicleId');
    print(
      '📱 [AddServiceScreen]   _selectedServiceType: $_selectedServiceType',
    );
    print('📱 [AddServiceScreen]   _serviceDate: $_serviceDate');

    if (_formKey.currentState!.validate() &&
        _vehicleId != null &&
        _selectedServiceType != null &&
        _serviceDate != null) {
      print(
        '📱 [AddServiceScreen] ✅ All validations passed, creating service record',
      );

      final service = ServiceRecordsCompanion.insert(
        vehicleId: _vehicleId!,
        serviceType: _selectedServiceType!,
        serviceDate: _serviceDate!,
        description:
            _descriptionController.text.trim().isEmpty
                ? const drift.Value.absent()
                : drift.Value(_descriptionController.text.trim()),
        cost:
            _costController.text.trim().isEmpty
                ? const drift.Value.absent()
                : drift.Value(double.tryParse(_costController.text.trim())),
        mechanic:
            _mechanicController.text.trim().isEmpty
                ? const drift.Value.absent()
                : drift.Value(_mechanicController.text.trim()),
        notes:
            _notesController.text.trim().isEmpty
                ? const drift.Value.absent()
                : drift.Value(_notesController.text.trim()),
        odometer:
            _odometerController.text.trim().isEmpty
                ? const drift.Value.absent()
                : drift.Value(int.tryParse(_odometerController.text.trim())),
      );

      print(
        '📱 [AddServiceScreen]   Service record created with vehicleId: ${_vehicleId}',
      );
      print(
        '📱 [AddServiceScreen]   Calling addServiceRecord on VehicleDetailCubit',
      );
      setState(() {
        _isSaving = true;
      });

      final vehicleDetailCubit = context.read<VehicleDetailCubit>();
      await vehicleDetailCubit.addServiceRecord(service);

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      if (vehicleDetailCubit.state is VehicleDetailError) {
        final errorState = vehicleDetailCubit.state as VehicleDetailError;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorState.message),
            backgroundColor: AppColors.secondary[500],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      print('📱 [AddServiceScreen]   Refreshing VehicleListCubit');
      await context.read<VehicleListCubit>().loadVehicles();
      if (!mounted) {
        return;
      }

      print('📱 [AddServiceScreen]   Navigating back');
      context.pop();
    } else {
      print('📱 [AddServiceScreen] ❌ Validation failed');
      print(
        '📱 [AddServiceScreen]   Form valid: ${_formKey.currentState!.validate()}',
      );
      print(
        '📱 [AddServiceScreen]   _vehicleId != null: ${_vehicleId != null}',
      );
      print(
        '📱 [AddServiceScreen]   _selectedServiceType != null: ${_selectedServiceType != null}',
      );
      print(
        '📱 [AddServiceScreen]   _serviceDate != null: ${_serviceDate != null}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.pleaseFillInAllRequiredFields,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.tertiary[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
