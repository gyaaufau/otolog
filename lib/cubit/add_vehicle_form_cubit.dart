import 'package:flutter_bloc/flutter_bloc.dart';

// Add Vehicle Form State
class AddVehicleFormState {
  final int currentStep;
  final String name;
  final String plateNumber;
  final String brand;
  final String model;
  final String year;
  final String color;
  final String? selectedType;
  final String? selectedFuelType;
  final String? selectedTransmissionType;
  final DateTime? purchaseDate;
  final String vin;
  final String odometer;
  final String? imagePath;

  const AddVehicleFormState({
    this.currentStep = 0,
    this.name = '',
    this.plateNumber = '',
    this.brand = '',
    this.model = '',
    this.year = '',
    this.color = '',
    this.selectedType,
    this.selectedFuelType,
    this.selectedTransmissionType,
    this.purchaseDate,
    this.vin = '',
    this.odometer = '',
    this.imagePath,
  });

  AddVehicleFormState copyWith({
    int? currentStep,
    String? name,
    String? plateNumber,
    String? brand,
    String? model,
    String? year,
    String? color,
    String? selectedType,
    String? selectedFuelType,
    String? selectedTransmissionType,
    DateTime? purchaseDate,
    String? vin,
    String? odometer,
    String? imagePath,
  }) {
    return AddVehicleFormState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      selectedType: selectedType ?? this.selectedType,
      selectedFuelType: selectedFuelType ?? this.selectedFuelType,
      selectedTransmissionType:
          selectedTransmissionType ?? this.selectedTransmissionType,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      vin: vin ?? this.vin,
      odometer: odometer ?? this.odometer,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

// Add Vehicle Form Cubit
class AddVehicleFormCubit extends Cubit<AddVehicleFormState> {
  AddVehicleFormCubit() : super(const AddVehicleFormState());

  void updateName(String name) => emit(state.copyWith(name: name));

  void updatePlateNumber(String plateNumber) =>
      emit(state.copyWith(plateNumber: plateNumber));

  void updateBrand(String brand) => emit(state.copyWith(brand: brand));

  void updateModel(String model) => emit(state.copyWith(model: model));

  void updateYear(String year) => emit(state.copyWith(year: year));

  void updateColor(String color) => emit(state.copyWith(color: color));

  void updateType(String? type) => emit(state.copyWith(selectedType: type));

  void updateFuelType(String? fuelType) =>
      emit(state.copyWith(selectedFuelType: fuelType));

  void updateTransmissionType(String? transmissionType) =>
      emit(state.copyWith(selectedTransmissionType: transmissionType));

  void updatePurchaseDate(DateTime? purchaseDate) =>
      emit(state.copyWith(purchaseDate: purchaseDate));

  void updateVin(String vin) => emit(state.copyWith(vin: vin));

  void updateOdometer(String odometer) =>
      emit(state.copyWith(odometer: odometer));

  void updateImagePath(String? imagePath) =>
      emit(state.copyWith(imagePath: imagePath));

  void nextStep() => emit(state.copyWith(currentStep: state.currentStep + 1));

  void previousStep() =>
      emit(state.copyWith(currentStep: state.currentStep - 1));

  void resetForm() => emit(const AddVehicleFormState());
}
