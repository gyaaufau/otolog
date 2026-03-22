import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';
import '../../database/database.dart';
import '../../resources/colors.dart';
import '../../widgets/modal_dropdown_field.dart';
import '../../router.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _mechanicController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _serviceDate;
  String? _selectedServiceType;
  Vehicle? _selectedVehicle;
  ServiceRecord? _existingService;
  int? _vehicleId;
  int? _serviceId;

  final List<String> _serviceTypes = [
    'Oil Change',
    'Tire Rotation',
    'Brake Service',
    'Battery Replacement',
    'Engine Tune-up',
    'Air Filter Replacement',
    'Transmission Service',
    'Coolant Flush',
    'Spark Plug Replacement',
    'Wheel Alignment',
    'Suspension Service',
    'Exhaust System Repair',
    'AC Service',
    'Inspection',
    'Other',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_vehicleId == null || _serviceId == null) {
      final vehicleId = int.tryParse(
        GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
      );
      final serviceId = int.tryParse(
        GoRouterState.of(context).pathParameters['serviceId'] ?? '',
      );

      if (vehicleId != null && serviceId != null) {
        setState(() {
          _vehicleId = vehicleId;
          _serviceId = serviceId;
        });
        context.read<VehicleCubit>().loadVehicleWithServices(vehicleId);
      }
    }
  }

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _mechanicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeForm(ServiceRecord service, Vehicle vehicle) {
    if (_existingService == null) {
      setState(() {
        _existingService = service;
        _selectedVehicle = vehicle;
        _selectedServiceType = service.serviceType;
        _serviceDate = service.serviceDate;
        _serviceTypeController.text = service.serviceType;
        _descriptionController.text = service.description ?? '';
        _costController.text = service.cost?.toString() ?? '';
        _mechanicController.text = service.mechanic ?? '';
        _notesController.text = service.notes ?? '';
      });
    }
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
          'Edit Service Record',
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
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2,
              ),
            );
          }

          if (state is VehicleLoaded && state.serviceRecords != null) {
            final service = state.serviceRecords!.firstWhere(
              (s) => s.id == _serviceId,
              orElse: () => state.serviceRecords!.first,
            );
            final vehicle = state.vehicles.firstWhere(
              (v) => v.id == service.vehicleId,
              orElse: () => state.vehicles.first,
            );

            _initializeForm(service, vehicle);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleSelector(state.vehicles),
                    const SizedBox(height: 24),
                    _buildServiceTypeField(),
                    const SizedBox(height: 20),
                    _buildServiceDatePicker(),
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildVehicleSelector(List<Vehicle> vehicles) {
    if (vehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral[200]!, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Vehicle>(
              value: _selectedVehicle,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.neutral[600],
              ),
              style: TextStyle(
                color: AppColors.neutral[900],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items:
                  vehicles.map((vehicle) {
                    return DropdownMenuItem<Vehicle>(
                      value: vehicle,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.15),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.directions_car,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicle.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.neutral[900],
                                  ),
                                ),
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
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVehicle = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTypeField() {
    return ModalDropdownField(
      label: 'Service Type',
      hint: 'Select service type',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Date',
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
              color: Colors.white,
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
                        : 'Select service date',
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

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
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
            hintText: 'Describe the service performed...',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cost (IDR)',
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
            hintText: 'e.g., 500000',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mechanic / Shop',
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
            hintText: 'e.g., Bengkel Jaya',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[700],
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Additional notes or observations...',
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
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        final isLoading = state is VehicleLoading;
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
            onPressed: isLoading ? null : _updateService,
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
                    : const Text(
                      'Update Service Record',
                      style: TextStyle(
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

  void _updateService() {
    if (_formKey.currentState!.validate() &&
        _selectedVehicle != null &&
        _selectedServiceType != null &&
        _serviceDate != null &&
        _existingService != null) {
      final updatedService = _existingService!.copyWith(
        vehicleId: _selectedVehicle!.id,
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
      );

      context.read<VehicleCubit>().updateServiceRecord(updatedService);
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please fill in all required fields',
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
