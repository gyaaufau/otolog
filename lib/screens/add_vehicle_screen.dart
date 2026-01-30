import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../models/vehicle.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _plateNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
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
        color:
            _colorController.text.trim().isEmpty
                ? null
                : _colorController.text.trim(),
      );

      context.read<VehicleCubit>().addVehicle(vehicle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vehicle added successfully'),
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
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Name *',
                        hintText: 'e.g., My Car',
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a vehicle name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _plateNumberController,
                      decoration: InputDecoration(
                        labelText: 'Plate Number *',
                        hintText: 'e.g., B 1234 ABC',
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
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a plate number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: 'Brand',
                        hintText: 'e.g., Toyota',
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
                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Model',
                        hintText: 'e.g., Avanza',
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
                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        hintText: 'e.g., 2020',
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
                      maxLength: 4,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _colorController,
                      decoration: InputDecoration(
                        labelText: 'Color',
                        hintText: 'e.g., White',
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
                                  'Add Vehicle',
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
