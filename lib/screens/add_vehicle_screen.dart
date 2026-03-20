import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../database/database.dart';
import '../resources/colors.dart';
import '../router.dart';
import '../widgets/form_input_field.dart';
import '../widgets/modal_dropdown_field.dart';
import '../widgets/form_date_field.dart';
import '../shared/commons/utils/image_picker_helper.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _vinController = TextEditingController();
  final _odometerController = TextEditingController();
  late PageController _pageController;

  String? _selectedType;
  String? _selectedFuelType;
  String? _selectedTransmissionType;
  DateTime? _purchaseDate;
  File? _selectedImage;

  int _currentStep = 0;
  final int _totalSteps = 3;

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

  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
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
    _pageController.dispose();
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
          'Add Vehicle',
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
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleOperationSuccess) {
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
            context.pop();
          } else if (state is VehicleError) {
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
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    _buildBasicInformationStep(),
                    _buildVehicleDetailsStep(),
                    _buildVehiclePhotosStep(),
                  ],
                ),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_totalSteps, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              return Expanded(
                child: Row(
                  children: [
                    _buildStepDot(index, isCompleted, isCurrent),
                    if (index < _totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color:
                                isCompleted
                                    ? AppColors.primary[500]!
                                    : AppColors.neutral[200]!,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            _getStepTitle(_currentStep),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getStepSubtitle(_currentStep),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.neutral[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(int index, bool isCompleted, bool isCurrent) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isCompleted || isCurrent
                ? AppColors.primary[500]!
                : AppColors.neutral[200]!,
      ),
      child: Center(
        child:
            isCompleted
                ? Icon(Icons.check_rounded, color: Colors.white, size: 18)
                : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isCurrent ? Colors.white : AppColors.neutral[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Vehicle Details';
      case 2:
        return 'Vehicle Photos';
      default:
        return '';
    }
  }

  String _getStepSubtitle(int step) {
    switch (step) {
      case 0:
        return 'Enter the basic vehicle information';
      case 1:
        return 'Provide detailed vehicle specifications';
      case 2:
        return 'Add a photo of your vehicle';
      default:
        return '';
    }
  }

  Widget _buildBasicInformationStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
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
      ],
    );
  }

  Widget _buildVehicleDetailsStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
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
      ],
    );
  }

  Widget _buildVehiclePhotosStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [_buildPhotoPicker()],
    );
  }

  Widget _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Photo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[900],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: AppColors.neutral[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _selectedImage != null
                        ? AppColors.primary[500]!
                        : AppColors.neutral[300]!,
                width: 2,
              ),
            ),
            child:
                _selectedImage != null
                    ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 64,
                          color: AppColors.neutral[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to add photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.neutral[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Optional',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutral[500],
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final image = await _imagePickerHelper.pickImageFromGallery(context);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.neutral[50],
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[200]!.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.neutral[900],
                    side: BorderSide(color: AppColors.neutral[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child:
                  _currentStep < _totalSteps - 1
                      ? ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary[500]!,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      )
                      : BlocBuilder<VehicleCubit, VehicleState>(
                        builder: (context, state) {
                          final isLoading = state is VehicleLoading;
                          return Container(
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
                              onPressed: isLoading ? null : _saveVehicle,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child:
                                  isLoading
                                      ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                      : const Text(
                                        'Add Vehicle',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNameField() {
    return FormInputField(
      controller: _nameController,
      label: 'Vehicle Name',
      hint: 'e.g., My Toyota Camry',
      icon: Icons.drive_eta_rounded,
      showLabel: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vehicle name is required';
        }
        return null;
      },
    );
  }

  Widget _buildPlateNumberField() {
    return FormInputField(
      controller: _plateNumberController,
      label: 'Plate Number',
      hint: 'e.g., B 1234 ABC',
      icon: Icons.confirmation_number_rounded,
      textCapitalization: TextCapitalization.characters,
      showLabel: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Plate number is required';
        }
        return null;
      },
    );
  }

  Widget _buildBrandField() {
    return FormInputField(
      controller: _brandController,
      label: 'Brand',
      hint: 'e.g., Toyota',
      icon: Icons.business_rounded,
      showLabel: true,
    );
  }

  Widget _buildModelField() {
    return FormInputField(
      controller: _modelController,
      label: 'Model',
      hint: 'e.g., Camry',
      icon: Icons.directions_car_rounded,
      showLabel: true,
    );
  }

  Widget _buildYearField() {
    return FormInputField(
      controller: _yearController,
      label: 'Year',
      hint: 'e.g., 2020',
      icon: Icons.calendar_today_rounded,
      keyboardType: TextInputType.number,
      maxLength: 4,
      showLabel: true,
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
    return FormInputField(
      controller: _colorController,
      label: 'Color',
      hint: 'e.g., Black',
      icon: Icons.palette_rounded,
      showLabel: true,
    );
  }

  Widget _buildTypeDropdown() {
    return ModalDropdownField(
      label: 'Vehicle Type',
      hint: 'Select vehicle type',
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
      label: 'Fuel Type',
      hint: 'Select fuel type',
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
      label: 'Transmission Type',
      hint: 'Select transmission type',
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
    return FormInputField(
      controller: _vinController,
      label: 'VIN (Vehicle Identification Number)',
      hint: 'e.g., 1HGCM82633A123456',
      icon: Icons.qr_code_2_rounded,
      textCapitalization: TextCapitalization.characters,
      maxLength: 17,
      showLabel: true,
    );
  }

  Widget _buildOdometerField() {
    return FormInputField(
      controller: _odometerController,
      label: 'Current Odometer (km)',
      hint: 'e.g., 50000',
      icon: Icons.speed_rounded,
      keyboardType: TextInputType.number,
      showLabel: true,
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
    return FormDateField(
      label: 'Purchase Date',
      hint: 'Select purchase date',
      icon: Icons.event_rounded,
      value: _purchaseDate,
      showLabel: false,
      onChanged: (date) {
        setState(() {
          _purchaseDate = date;
        });
      },
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vehicle = VehiclesCompanion.insert(
      name: _nameController.text.trim(),
      plateNumber: _plateNumberController.text.trim(),
      brand:
          _brandController.text.trim().isEmpty
              ? const drift.Value.absent()
              : drift.Value(_brandController.text.trim()),
      model:
          _modelController.text.trim().isEmpty
              ? const drift.Value.absent()
              : drift.Value(_modelController.text.trim()),
      year:
          _yearController.text.trim().isEmpty
              ? const drift.Value.absent()
              : drift.Value(_yearController.text.trim()),
      color:
          _colorController.text.trim().isEmpty
              ? const drift.Value.absent()
              : drift.Value(_colorController.text.trim()),
      type:
          _selectedType == null
              ? const drift.Value.absent()
              : drift.Value(_selectedType),
      vin:
          _vinController.text.trim().isEmpty
              ? const drift.Value.absent()
              : drift.Value(_vinController.text.trim()),
      odometer:
          _odometerController.text.trim().isEmpty
              ? const drift.Value.absent()
              : drift.Value(int.tryParse(_odometerController.text.trim())),
      fuelType:
          _selectedFuelType == null
              ? const drift.Value.absent()
              : drift.Value(_selectedFuelType),
      transmissionType:
          _selectedTransmissionType == null
              ? const drift.Value.absent()
              : drift.Value(_selectedTransmissionType),
      purchaseDate:
          _purchaseDate == null
              ? const drift.Value.absent()
              : drift.Value(_purchaseDate),
      imagePath:
          _selectedImage == null
              ? const drift.Value.absent()
              : drift.Value(_selectedImage!.path),
    );

    context.read<VehicleCubit>().addVehicle(vehicle);
  }
}
