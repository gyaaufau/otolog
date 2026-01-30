import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/service_record.dart';
import '../constants/theme.dart';

class AddServiceScreen extends StatefulWidget {
  final int vehicleId;

  const AddServiceScreen({super.key, required this.vehicleId});

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

  DateTime _selectedDate = DateTime.now();

  final List<String> _serviceTypes = [
    'General Service',
    'Oil Change',
    'Tire Service',
    'Brake Service',
    'Battery',
    'Air Conditioning',
    'Transmission',
    'Suspension',
    'Other',
  ];

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _mechanicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final record = ServiceRecord(
        vehicleId: widget.vehicleId,
        serviceType: _serviceTypeController.text.trim(),
        serviceDate: _selectedDate,
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        cost:
            _costController.text.trim().isEmpty
                ? null
                : double.tryParse(_costController.text.trim()),
        mechanic:
            _mechanicController.text.trim().isEmpty
                ? null
                : _mechanicController.text.trim(),
        notes:
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
      );

      context.read<VehicleCubit>().addServiceRecord(record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service Record'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Service record added successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
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
                    // Service Type Dropdown
                    DropdownButtonFormField<String>(
                      initialValue:
                          _serviceTypeController.text.isEmpty
                              ? null
                              : _serviceTypeController.text,
                      decoration: InputDecoration(
                        labelText: 'Service Type *',
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      items:
                          _serviceTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _serviceTypeController.text = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a service type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Date Picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Service Date *',
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: Text(
                          DateFormat('dd MMM yyyy').format(_selectedDate),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Cost
                    TextFormField(
                      controller: _costController,
                      decoration: InputDecoration(
                        labelText: 'Cost (Rp)',
                        hintText: 'e.g., 500000',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
                    // Mechanic
                    TextFormField(
                      controller: _mechanicController,
                      decoration: InputDecoration(
                        labelText: 'Mechanic',
                        hintText: 'e.g., Bengkel ABC',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'e.g., Changed oil and filter',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
                      maxLines: 2,
                    ),
                    SizedBox(height: 16.h),
                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        hintText: 'e.g., Next service in 6 months',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
                      maxLines: 3,
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child:
                            isLoading
                                ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.background,
                                        ),
                                  ),
                                )
                                : Text(
                                  'Add Service Record',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.background,
                                  ),
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
