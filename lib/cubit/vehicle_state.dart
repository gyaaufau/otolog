import 'package:equatable/equatable.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';

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

  const VehicleLoaded({
    required this.vehicles,
    this.serviceRecords,
    this.totalCost,
    this.serviceCount,
  });

  VehicleLoaded copyWith({
    List<Vehicle>? vehicles,
    List<ServiceRecord>? serviceRecords,
    double? totalCost,
    int? serviceCount,
  }) {
    return VehicleLoaded(
      vehicles: vehicles ?? this.vehicles,
      serviceRecords: serviceRecords ?? this.serviceRecords,
      totalCost: totalCost ?? this.totalCost,
      serviceCount: serviceCount ?? this.serviceCount,
    );
  }

  @override
  List<Object?> get props => [
    vehicles,
    serviceRecords,
    totalCost,
    serviceCount,
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
