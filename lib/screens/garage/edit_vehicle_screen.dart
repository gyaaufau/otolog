import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';
import '../../database/database.dart';
import '../../resources/colors.dart';
import '../../router.dart';

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

  @override
  void initState() {
    super.initState();
    _loadVehicle();
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
    final vehicleId = int.tryParse(
      GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
    );
    if (vehicleId != null) {
      context.read<VehicleCubit>().loadVehicleWithServices(vehicleId);
    }
  }

  void _populateFields(Vehicle vehicle) {
    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      appBar: AppBar(
        backgroundColor: AppColors.neutral[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.neutral[900]),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Vehicle',
          style: TextStyle(
            color: AppColors.neutral[900],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.tertiary),
            onPressed: _showDeleteDialog,
          ),
          TextButton(
            onPressed: _saveVehicle,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocConsumer<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
              ),
            );
            context.pop();
          } else if (state is VehicleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.tertiary,
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
              padding: const EdgeInsets.all(24),
              children: [
                _buildSectionHeader('Basic Information'),
                const SizedBox(height: 16),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildPlateNumberField(),
                const SizedBox(height: 16),
                _buildBrandField(),
                const SizedBox(height: 16),
                _buildModelField(),
                const SizedBox(height: 16),
                _buildYearField(),
                const SizedBox(height: 16),
                _buildColorField(),
                const SizedBox(height: 24),

                _buildSectionHeader('Vehicle Details'),
                const SizedBox(height: 16),
                _buildTypeDropdown(),
                const SizedBox(height: 16),
                _buildFuelTypeDropdown(),
                const SizedBox(height: 16),
                _buildTransmissionTypeDropdown(),
                const SizedBox(height: 16),
                _buildVINField(),
                const SizedBox(height: 16),
                _buildOdometerField(),
                const SizedBox(height: 16),
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
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral[900],
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildNameField() {
    return _buildTextField(
      controller: _nameController,
      label: 'Vehicle Name',
      hint: 'e.g., My Toyota Camry',
      icon: Icons.drive_eta,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vehicle name is required';
        }
        return null;
      },
    );
  }

  Widget _buildPlateNumberField() {
    return _buildTextField(
      controller: _plateNumberController,
      label: 'Plate Number',
      hint: 'e.g., B 1234 ABC',
      icon: Icons.confirmation_number,
      textCapitalization: TextCapitalization.characters,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Plate number is required';
        }
        return null;
      },
    );
  }

  Widget _buildBrandField() {
    return _buildTextField(
      controller: _brandController,
      label: 'Brand',
      hint: 'e.g., Toyota',
      icon: Icons.business,
    );
  }

  Widget _buildModelField() {
    return _buildTextField(
      controller: _modelController,
      label: 'Model',
      hint: 'e.g., Camry',
      icon: Icons.directions_car,
    );
  }

  Widget _buildYearField() {
    return _buildTextField(
      controller: _yearController,
      label: 'Year',
      hint: 'e.g., 2020',
      icon: Icons.calendar_today,
      keyboardType: TextInputType.number,
      maxLength: 4,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final year = int.tryParse(value);
          if (year == null || year < 1900 || year > DateTime.now().year + 1) {
            return 'Please enter a valid year';
          }
        }
        return null;
      },
    );
  }

  Widget _buildColorField() {
    return _buildTextField(
      controller: _colorController,
      label: 'Color',
      hint: 'e.g., Black',
      icon: Icons.palette,
    );
  }

  Widget _buildTypeDropdown() {
    return _buildDropdownField(
      label: 'Vehicle Type',
      hint: 'Select vehicle type',
      icon: Icons.category,
      value: _selectedType,
      items: _vehicleTypes,
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  Widget _buildFuelTypeDropdown() {
    return _buildDropdownField(
      label: 'Fuel Type',
      hint: 'Select fuel type',
      icon: Icons.local_gas_station,
      value: _selectedFuelType,
      items: _fuelTypes,
      onChanged: (value) {
        setState(() {
          _selectedFuelType = value;
        });
      },
    );
  }

  Widget _buildTransmissionTypeDropdown() {
    return _buildDropdownField(
      label: 'Transmission',
      hint: 'Select transmission type',
      icon: Icons.settings,
      value: _selectedTransmissionType,
      items: _transmissionTypes,
      onChanged: (value) {
        setState(() {
          _selectedTransmissionType = value;
        });
      },
    );
  }

  Widget _buildVINField() {
    return _buildTextField(
      controller: _vinController,
      label: 'VIN (Vehicle Identification Number)',
      hint: 'e.g., 1HGCM82633A123456',
      icon: Icons.qr_code_2,
      textCapitalization: TextCapitalization.characters,
      maxLength: 17,
    );
  }

  Widget _buildOdometerField() {
    return _buildTextField(
      controller: _odometerController,
      label: 'Current Odometer (km)',
      hint: 'e.g., 50000',
      icon: Icons.speed,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final odometer = int.tryParse(value);
          if (odometer == null || odometer < 0) {
            return 'Please enter a valid odometer reading';
          }
        }
        return null;
      },
    );
  }

  Widget _buildPurchaseDatePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.event, color: AppColors.neutral[400]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _purchaseDate != null
                      ? '${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}'
                      : 'Select purchase date',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        _purchaseDate != null
                            ? AppColors.neutral[900]
                            : AppColors.neutral[500],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _selectPurchaseDate,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutral[400]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                  maxLength: maxLength,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppColors.neutral[500],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 14, color: AppColors.neutral[900]),
                  validator: validator,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutral[400]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    hint: Text(
                      hint,
                      style: TextStyle(
                        color: AppColors.neutral[500],
                        fontSize: 14,
                      ),
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.neutral[400],
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutral[900],
                    ),
                    items:
                        items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        final isLoading = state is VehicleLoading;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveVehicle,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.neutral[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                    : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        );
      },
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
            colorScheme: ColorScheme.light(primary: AppColors.primary),
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

  void _saveVehicle() {
    if (!_formKey.currentState!.validate() || _vehicle == null) {
      return;
    }

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

    context.read<VehicleCubit>().updateVehicle(updatedVehicle);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Vehicle',
              style: TextStyle(
                color: AppColors.neutral[900],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this vehicle? This action cannot be undone and will also delete all associated service records.',
              style: TextStyle(color: AppColors.neutral[600], fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.neutral[600],
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  if (_vehicle != null) {
                    context.read<VehicleCubit>().deleteVehicle(_vehicle!.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
