import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/vehicle.dart';
import '../resources/theme.dart';
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
  final _imagePickerHelper = ImagePickerHelper();

  String? _selectedType;
  String? _selectedFuelType;
  String? _selectedTransmissionType;
  DateTime? _purchaseDate;
  String? _selectedColor;
  File? _imageFile;

  static const List<String> _vehicleTypes = [
    'Car',
    'Motorcycle',
    'Truck',
    'Van',
    'Bus',
    'SUV',
    'Sedan',
    'Hatchback',
    'Coupe',
    'Convertible',
    'Wagon',
    'Other',
  ];

  static const List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'LPG',
    'CNG',
    'Hydrogen',
    'Other',
  ];

  static const List<String> _transmissionTypes = [
    'Automatic',
    'Manual',
    'CVT',
    'Semi-Automatic',
    'Dual-Clutch',
    'Other',
  ];

  static const List<Map<String, dynamic>> _colorOptions = [
    {'name': 'White', 'color': Colors.white},
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Silver', 'color': Colors.grey},
    {'name': 'Gray', 'color': Color(0xFF808080)},
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Brown', 'color': Colors.brown},
    {'name': 'Beige', 'color': Color(0xFFF5F5DC)},
    {'name': 'Gold', 'color': Color(0xFFFFD700)},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Pink', 'color': Colors.pink},
    {'name': 'Cyan', 'color': Colors.cyan},
    {'name': 'Other', 'color': Colors.transparent},
  ];

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

  Future<void> _pickImage() async {
    final imageFile = await _imagePickerHelper.pickImageFromGallery(context);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _selectPurchaseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.background,
              surface: AppColors.surface,
              onSurface: AppColors.primaryText,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
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
        color: _selectedColor?.isEmpty ?? true ? null : _selectedColor,
        type:
            _selectedType?.trim().isEmpty ?? true
                ? null
                : _selectedType?.trim(),
        vin:
            _vinController.text.trim().isEmpty
                ? null
                : _vinController.text.trim(),
        purchaseDate: _purchaseDate,
        odometer:
            _odometerController.text.trim().isEmpty
                ? null
                : int.tryParse(_odometerController.text.trim()),
        fuelType:
            _selectedFuelType?.trim().isEmpty ?? true
                ? null
                : _selectedFuelType?.trim(),
        transmissionType:
            _selectedTransmissionType?.trim().isEmpty ?? true
                ? null
                : _selectedTransmissionType?.trim(),
        imagePath: _imageFile?.path,
      );

      context.read<VehicleCubit>().addVehicle(vehicle);
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    final isMacOS = ImagePickerHelper.isMacOS(context);

    return GestureDetector(
      onTap: isMacOS ? null : _pickImage,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                isMacOS ? AppColors.border.withOpacity(0.5) : AppColors.border,
            width: isMacOS ? 1 : 2,
          ),
        ),
        child:
            _imageFile != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isMacOS ? Icons.block : Icons.add_photo_alternate,
                      size: 48.sp,
                      color:
                          isMacOS ? AppColors.warning : AppColors.secondaryText,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      isMacOS
                          ? 'Photo upload not available on macOS'
                          : 'Tap to add vehicle photo',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            isMacOS
                                ? AppColors.warning
                                : AppColors.secondaryText,
                        fontWeight:
                            isMacOS ? FontWeight.w500 : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    if (isMacOS)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Please use mobile devices to add vehicle photos',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Text(
                        'Optional',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.secondaryText.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1,
          ),
          itemCount: _colorOptions.length,
          itemBuilder: (context, index) {
            final colorOption = _colorOptions[index];
            final isSelected = _selectedColor == colorOption['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (colorOption['name'] == 'Other') {
                    _selectedColor = null;
                  } else {
                    _selectedColor = colorOption['name'];
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      colorOption['color'] == Colors.transparent
                          ? AppColors.inputBackground
                          : colorOption['color'] as Color,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child:
                    colorOption['name'] == 'Other'
                        ? Icon(
                          Icons.more_horiz,
                          color: AppColors.secondaryText,
                          size: 16.sp,
                        )
                        : null,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vehicle added successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else if (state is VehicleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            final isLoading = state is VehicleLoading;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker
                    _buildImagePicker(),
                    SizedBox(height: 24.h),

                    // Basic Information Section
                    _buildSectionHeader(
                      'Basic Information',
                      Icons.info_outline,
                    ),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Name *',
                        hintText: 'e.g., My Car',
                        prefixIcon: Icon(Icons.directions_car, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a vehicle name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Type *',
                        hintText: 'Select vehicle type',
                        prefixIcon: Icon(Icons.category, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      dropdownColor: AppColors.surface,
                      items:
                          _vehicleTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select a vehicle type';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _plateNumberController,
                      decoration: InputDecoration(
                        labelText: 'Plate Number *',
                        hintText: 'e.g., B 1234 ABC',
                        prefixIcon: Icon(
                          Icons.confirmation_number,
                          size: 20.sp,
                        ),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a plate number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Vehicle Details Section
                    _buildSectionHeader('Vehicle Details', Icons.build),

                    TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: 'Brand',
                        hintText: 'e.g., Toyota',
                        prefixIcon: Icon(Icons.business, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Model',
                        hintText: 'e.g., Avanza',
                        prefixIcon: Icon(Icons.model_training, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        hintText: 'e.g., 2020',
                        prefixIcon: Icon(Icons.calendar_today, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                    ),
                    SizedBox(height: 16.h),

                    _buildColorPicker(),
                    SizedBox(height: 24.h),

                    // Technical Information Section
                    _buildSectionHeader(
                      'Technical Information',
                      Icons.settings,
                    ),

                    TextFormField(
                      controller: _vinController,
                      decoration: InputDecoration(
                        labelText: 'VIN (Vehicle Identification Number)',
                        hintText: 'e.g., 1HGCM82633A123456',
                        prefixIcon: Icon(Icons.vpn_key, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 17,
                    ),
                    SizedBox(height: 16.h),

                    DropdownButtonFormField<String>(
                      value: _selectedFuelType,
                      decoration: InputDecoration(
                        labelText: 'Fuel Type',
                        hintText: 'Select fuel type',
                        prefixIcon: Icon(Icons.local_gas_station, size: 20.sp),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      dropdownColor: AppColors.surface,
                      items:
                          _fuelTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFuelType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    DropdownButtonFormField<String>(
                      value: _selectedTransmissionType,
                      decoration: InputDecoration(
                        labelText: 'Transmission Type',
                        hintText: 'Select transmission type',
                        prefixIcon: Icon(
                          Icons.settings_input_component,
                          size: 20.sp,
                        ),
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      dropdownColor: AppColors.surface,
                      items:
                          _transmissionTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTransmissionType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _odometerController,
                      decoration: InputDecoration(
                        labelText: 'Current Odometer (km)',
                        hintText: 'e.g., 50000',
                        prefixIcon: Icon(Icons.speed, size: 20.sp),
                        suffixText: 'km',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primaryText,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    GestureDetector(
                      onTap: _selectPurchaseDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: AppColors.secondaryText,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Purchase Date',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    _purchaseDate != null
                                        ? '${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}'
                                        : 'Select purchase date',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color:
                                          _purchaseDate != null
                                              ? AppColors.primaryText
                                              : AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.secondaryText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    SizedBox(
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child:
                            isLoading
                                ? SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.background,
                                        ),
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, size: 20.sp),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Add Vehicle',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.background,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
