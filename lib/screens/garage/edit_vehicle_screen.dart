import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import 'package:drift/drift.dart' as drift;
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';
import '../../database/database.dart';
import '../../resources/colors.dart';
import '../../router.dart';
import '../../widgets/modal_dropdown_field.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({super.key});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _vinController = TextEditingController();
  final _odometerController = TextEditingController();

  String? _selectedType;
  String? _selectedFuelType;
  String? _selectedTransmissionType;
  DateTime? _purchaseDate;
  Vehicle? _vehicle;

  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Truck',
    'Motorcycle',
    'Van',
    'Coupe',
    'Hatchback',
    'Convertible',
    'Wagon',
  ];

  final List<String> _fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid',
    'Plug-in Hybrid',
    'LPG',
  ];

  final List<String> _transmissionTypes = [
    'Automatic',
    'Manual',
    'CVT',
    'Semi-Automatic',
    'Dual-Clutch',
  ];

  int? _vehicleId;
  bool _hasLoadedVehicle = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedVehicle) {
        _loadVehicle();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plateNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _vinController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  void _loadVehicle() {
    if (!mounted || _hasLoadedVehicle) return;

    final vehicleId = int.tryParse(
      GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
    );
    if (vehicleId != null) {
      _vehicleId = vehicleId;
      _hasLoadedVehicle = true;
      context.read<VehicleCubit>().loadVehicleWithServices(vehicleId);
    }
  }

  void _populateFields(Vehicle vehicle) {
    _vehicle = vehicle;
    _nameController.text = vehicle.name;
    _plateNumberController.text = vehicle.plateNumber;
    _brandController.text = vehicle.brand ?? '';
    _modelController.text = vehicle.model ?? '';
    _yearController.text = vehicle.year ?? '';
    _colorController.text = vehicle.color ?? '';
    _vinController.text = vehicle.vin ?? '';
    _odometerController.text = vehicle.odometer?.toString() ?? '';
    _selectedType = vehicle.type;
    _selectedFuelType = vehicle.fuelType;
    _selectedTransmissionType = vehicle.transmissionType;
    _purchaseDate = vehicle.purchaseDate;
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
          context.l10n.editVehicle,
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
      body: BlocConsumer<VehicleCubit, VehicleState>(
        listener: (context, state) {
          print('🔔 DEBUG: Listener called with state: ${state.runtimeType}');
          if (state is VehicleOperationSuccess) {
            print(
              '✅ DEBUG: VehicleOperationSuccess detected - Message: ${state.message}',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primary[500]!,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            // Navigate back to previous screen after successful save
            final navigatorContext = context;
            print('⏳ DEBUG: Starting 500ms delay before navigation');
            Future.delayed(const Duration(milliseconds: 500), () {
              print('🔍 DEBUG: Delay callback fired - mounted: $mounted');
              if (mounted) {
                print('🚀 DEBUG: Attempting navigation with pop()');
                // Try pop() first (same as AppBar back button)
                try {
                  navigatorContext.pop();
                  print('✅ DEBUG: pop() called successfully');
                } catch (e) {
                  print('❌ DEBUG: pop() failed with error: $e');
                  // Fallback to go() if pop() fails
                  if (_vehicleId != null) {
                    print('🔄 DEBUG: Trying fallback to go()');
                    navigatorContext.go('/vehicle/$_vehicleId');
                  }
                }
              } else {
                print('❌ DEBUG: Widget not mounted, skipping navigation');
              }
            });
          } else if (state is VehicleError) {
            print('❌ DEBUG: VehicleError detected - Message: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.secondary[500],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            );
          }

          if (state is VehicleLoaded && state.vehicles.isNotEmpty) {
            final vehicle = state.vehicles.first;
            if (_vehicle == null || _vehicle!.id != vehicle.id) {
              _populateFields(vehicle);
            }
          }

          if (_vehicle == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                const SizedBox(height: 8),
                _buildSectionHeader(context.l10n.basicInformation),
                const SizedBox(height: 16),
                _buildNameField(),
                const SizedBox(height: 20),
                _buildPlateNumberField(),
                const SizedBox(height: 20),
                _buildBrandField(),
                const SizedBox(height: 20),
                _buildModelField(),
                const SizedBox(height: 20),
                _buildYearField(),
                const SizedBox(height: 20),
                _buildColorField(),
                const SizedBox(height: 24),
                _buildSectionHeader(context.l10n.vehicleDetails),
                const SizedBox(height: 16),
                _buildTypeDropdown(),
                const SizedBox(height: 20),
                _buildFuelTypeDropdown(),
                const SizedBox(height: 20),
                _buildTransmissionTypeDropdown(),
                const SizedBox(height: 20),
                _buildVINField(),
                const SizedBox(height: 20),
                _buildOdometerField(),
                const SizedBox(height: 20),
                _buildPurchaseDatePicker(),
                const SizedBox(height: 32),
                _buildSaveButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral[900],
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.vehicleName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.l10n.vehicleNameRequired;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'e.g., My Toyota Camry',
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
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

  Widget _buildPlateNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.plateNumber,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _plateNumberController,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.l10n.plateNumberRequired;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'e.g., B 1234 ABC',
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
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

  Widget _buildBrandField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.brand,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _brandController,
          decoration: InputDecoration(
            hintText: 'e.g., Toyota',
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

  Widget _buildModelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _modelController,
          decoration: InputDecoration(
            hintText: 'e.g., Camry',
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

  Widget _buildYearField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.year,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final year = int.tryParse(value);
              if (year == null ||
                  year < 1900 ||
                  year > DateTime.now().year + 1) {
                return context.l10n.yearInvalid;
              }
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'e.g., 2020',
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildColorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.color,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _colorController,
          decoration: InputDecoration(
            hintText: 'e.g., Black',
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

  Widget _buildTypeDropdown() {
    return ModalDropdownField(
      label: context.l10n.vehicleType,
      hint: context.l10n.selectVehicleType,
      value: _selectedType,
      items: _vehicleTypes,
      showLabel: true,
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  Widget _buildFuelTypeDropdown() {
    return ModalDropdownField(
      label: context.l10n.fuelType,
      hint: context.l10n.selectFuelType,
      value: _selectedFuelType,
      items: _fuelTypes,
      showLabel: true,
      onChanged: (value) {
        setState(() {
          _selectedFuelType = value;
        });
      },
    );
  }

  Widget _buildTransmissionTypeDropdown() {
    return ModalDropdownField(
      label: context.l10n.transmissionType,
      hint: context.l10n.selectTransmissionType,
      value: _selectedTransmissionType,
      items: _transmissionTypes,
      showLabel: true,
      onChanged: (value) {
        setState(() {
          _selectedTransmissionType = value;
        });
      },
    );
  }

  Widget _buildVINField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.vin,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _vinController,
          textCapitalization: TextCapitalization.characters,
          maxLength: 17,
          decoration: InputDecoration(
            hintText: 'e.g., 1HGCM82633A123456',
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
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildOdometerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.currentOdometer,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _odometerController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final odometer = int.tryParse(value);
              if (odometer == null || odometer < 0) {
                return context.l10n.odometerRequired;
              }
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'e.g., 50000',
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.tertiary[500]!,
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

  Widget _buildPurchaseDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.purchaseDate,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                _purchaseDate != null
                    ? AppColors.primary[500]
                    : AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectPurchaseDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _purchaseDate != null
                        ? AppColors.primary[500]!
                        : AppColors.neutral[200]!,
                width: _purchaseDate != null ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color:
                      _purchaseDate != null
                          ? AppColors.primary[500]
                          : AppColors.neutral[500],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _purchaseDate != null
                        ? '${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}'
                        : 'Select purchase date',
                    style: TextStyle(
                      color:
                          _purchaseDate != null
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

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
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
        onPressed: _isSaving ? null : _saveVehicle,
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
            _isSaving
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                : const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
      ),
    );
  }

  void _selectPurchaseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        _purchaseDate = picked;
      });
    }
  }

  void _saveVehicle() async {
    print('🔧 DEBUG: _saveVehicle called');
    if (!_formKey.currentState!.validate() || _vehicle == null) {
      print('❌ DEBUG: Validation failed or vehicle is null');
      return;
    }

    // Set saving state to prevent multiple submissions
    setState(() {
      _isSaving = true;
    });

    final updatedVehicle = Vehicle(
      id: _vehicle!.id,
      name: _nameController.text.trim(),
      plateNumber: _plateNumberController.text.trim(),
      brand:
          _brandController.text.trim().isEmpty
              ? null
              : _brandController.text.trim(),
      model:
          _modelController.text.trim().isEmpty
              ? null
              : _modelController.text.trim(),
      year:
          _yearController.text.trim().isEmpty
              ? null
              : _yearController.text.trim(),
      color:
          _colorController.text.trim().isEmpty
              ? null
              : _colorController.text.trim(),
      type: _selectedType,
      vin:
          _vinController.text.trim().isEmpty
              ? null
              : _vinController.text.trim(),
      odometer:
          _odometerController.text.trim().isEmpty
              ? null
              : int.tryParse(_odometerController.text.trim()),
      fuelType: _selectedFuelType,
      transmissionType: _selectedTransmissionType,
      purchaseDate: _purchaseDate,
      imagePath: _vehicle!.imagePath,
      isPrimary: _vehicle!.isPrimary,
      createdAt: _vehicle!.createdAt,
      updatedAt: DateTime.now(),
    );

    print(
      '✅ DEBUG: Calling updateVehicle for vehicle ID: ${updatedVehicle.id}',
    );
    await context.read<VehicleCubit>().updateVehicle(updatedVehicle);

    // Reset saving state after a short delay to allow navigation to complete
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      });
    }
  }

  // void _showDeleteDialog() {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           title: Text(
  //             context.l10n.deleteVehicle,
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w700,
  //               color: AppColors.neutral[900],
  //               letterSpacing: -0.3,
  //             ),
  //           ),
  //           content: Text(
  //             'Are you sure you want to delete this vehicle? This action cannot be undone and will also delete all associated service records.',
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: AppColors.neutral[700],
  //               height: 1.5,
  //               letterSpacing: 0.2,
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => context.pop(),
  //               child: Text(
  //                 context.l10n.cancel,
  //                 style: TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                   color: AppColors.neutral[600],
  //                   letterSpacing: 0.2,
  //                 ),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 context.pop();
  //                 if (_vehicle != null) {
  //                   context.read<VehicleCubit>().deleteVehicle(_vehicle!.id);
  //                 }
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColors.error,
  //                 foregroundColor: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 24,
  //                   vertical: 12,
  //                 ),
  //               ),
  //               child: Text(
  //                 context.l10n.delete,
  //                 style: TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: 0.2,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //   );
  // }
}
