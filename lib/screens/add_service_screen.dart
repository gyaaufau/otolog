import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/service_record.dart';

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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Service record added successfully'),
                backgroundColor: Colors.black87,
              ),
            );
            Navigator.pop(context);
          } else if (state is VehicleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            final isLoading = state is VehicleLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items:
                          _serviceTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
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
                    const SizedBox(height: 16),
                    // Date Picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Service Date *',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          DateFormat('dd MMM yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Cost
                    TextFormField(
                      controller: _costController,
                      decoration: InputDecoration(
                        labelText: 'Cost (Rp)',
                        hintText: 'e.g., 500000',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // Mechanic
                    TextFormField(
                      controller: _mechanicController,
                      decoration: InputDecoration(
                        labelText: 'Mechanic',
                        hintText: 'e.g., Bengkel ABC',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'e.g., Changed oil and filter',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        hintText: 'e.g., Next service in 6 months',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Add Service Record',
                                  style: TextStyle(fontSize: 16),
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
