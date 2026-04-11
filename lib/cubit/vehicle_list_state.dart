import 'package:equatable/equatable.dart';
import '../database/database.dart';

abstract class VehicleListState extends Equatable {
  const VehicleListState();

  @override
  List<Object?> get props => [];
}

class VehicleListInitial extends VehicleListState {
  const VehicleListInitial();
}

class VehicleListLoading extends VehicleListState {
  const VehicleListLoading();
}

class VehicleListLoaded extends VehicleListState {
  final List<Vehicle> vehicles;
  final List<ServiceRecord>? serviceRecords;
  final String? filterType;

  const VehicleListLoaded({
    required this.vehicles,
    this.serviceRecords,
    this.filterType,
  });

  VehicleListLoaded copyWith({
    List<Vehicle>? vehicles,
    List<ServiceRecord>? serviceRecords,
    String? filterType,
  }) {
    return VehicleListLoaded(
      vehicles: vehicles ?? this.vehicles,
      serviceRecords: serviceRecords ?? this.serviceRecords,
      filterType: filterType ?? this.filterType,
    );
  }

  @override
  List<Object?> get props => [vehicles, serviceRecords, filterType];
}

class VehicleListError extends VehicleListState {
  final String message;

  const VehicleListError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleListOperationSuccess extends VehicleListLoaded {
  final String message;

  const VehicleListOperationSuccess({
    required this.message,
    required super.vehicles,
    super.serviceRecords,
    super.filterType,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
