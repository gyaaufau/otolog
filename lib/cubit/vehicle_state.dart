import 'package:equatable/equatable.dart';
import '../database/database.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final List<ServiceRecord>? serviceRecords;
  final double? totalCost;
  final int? serviceCount;
  final String? filterType;
  final int? selectedVehicleId;
  final int? odometer;

  const VehicleLoaded({
    required this.vehicles,
    this.serviceRecords,
    this.totalCost,
    this.serviceCount,
    this.filterType,
    this.selectedVehicleId,
    this.odometer,
  });

  VehicleLoaded copyWith({
    List<Vehicle>? vehicles,
    List<ServiceRecord>? serviceRecords,
    double? totalCost,
    int? serviceCount,
    String? filterType,
    int? selectedVehicleId,
    int? odometer,
  }) {
    return VehicleLoaded(
      vehicles: vehicles ?? this.vehicles,
      serviceRecords: serviceRecords ?? this.serviceRecords,
      totalCost: totalCost ?? this.totalCost,
      serviceCount: serviceCount ?? this.serviceCount,
      filterType: filterType ?? this.filterType,
      selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
      odometer: odometer ?? this.odometer,
    );
  }

  @override
  List<Object?> get props => [
    vehicles,
    serviceRecords,
    totalCost,
    serviceCount,
    filterType,
    selectedVehicleId,
    odometer,
  ];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleOperationSuccess extends VehicleState {
  final String message;

  const VehicleOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
