import 'package:equatable/equatable.dart';
import '../database/database.dart';

abstract class ServiceVehicleSelectorState extends Equatable {
  const ServiceVehicleSelectorState();

  @override
  List<Object?> get props => [];
}

class ServiceVehicleSelectorInitial extends ServiceVehicleSelectorState {
  const ServiceVehicleSelectorInitial();
}

class ServiceVehicleSelectorLoading extends ServiceVehicleSelectorState {
  const ServiceVehicleSelectorLoading();
}

class ServiceVehicleSelectorLoaded extends ServiceVehicleSelectorState {
  final List<Vehicle> vehicles;
  final int? selectedVehicleId;

  const ServiceVehicleSelectorLoaded({
    required this.vehicles,
    this.selectedVehicleId,
  });

  ServiceVehicleSelectorLoaded copyWith({
    List<Vehicle>? vehicles,
    int? selectedVehicleId,
  }) {
    return ServiceVehicleSelectorLoaded(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
    );
  }

  @override
  List<Object?> get props => [vehicles, selectedVehicleId];
}

class ServiceVehicleSelectorError extends ServiceVehicleSelectorState {
  final String message;

  const ServiceVehicleSelectorError(this.message);

  @override
  List<Object?> get props => [message];
}
