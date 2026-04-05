import 'package:equatable/equatable.dart';
import '../database/database.dart';

abstract class VehicleDetailState extends Equatable {
  const VehicleDetailState();

  @override
  List<Object?> get props => [];
}

class VehicleDetailInitial extends VehicleDetailState {
  const VehicleDetailInitial();
}

class VehicleDetailLoading extends VehicleDetailState {
  const VehicleDetailLoading();
}

class VehicleDetailLoaded extends VehicleDetailState {
  final Vehicle vehicle;
  final List<ServiceRecord> serviceRecords;
  final double totalCost;
  final int serviceCount;
  final double averageCost;
  final DateTime? lastServiceDate;
  final int daysSinceLastService;

  const VehicleDetailLoaded({
    required this.vehicle,
    required this.serviceRecords,
    required this.totalCost,
    required this.serviceCount,
    required this.averageCost,
    this.lastServiceDate,
    required this.daysSinceLastService,
  });

  VehicleDetailLoaded copyWith({
    Vehicle? vehicle,
    List<ServiceRecord>? serviceRecords,
    double? totalCost,
    int? serviceCount,
    double? averageCost,
    DateTime? lastServiceDate,
    int? daysSinceLastService,
  }) {
    return VehicleDetailLoaded(
      vehicle: vehicle ?? this.vehicle,
      serviceRecords: serviceRecords ?? this.serviceRecords,
      totalCost: totalCost ?? this.totalCost,
      serviceCount: serviceCount ?? this.serviceCount,
      averageCost: averageCost ?? this.averageCost,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      daysSinceLastService: daysSinceLastService ?? this.daysSinceLastService,
    );
  }

  @override
  List<Object?> get props => [
    vehicle,
    serviceRecords,
    totalCost,
    serviceCount,
    averageCost,
    lastServiceDate,
    daysSinceLastService,
  ];
}

class VehicleDetailError extends VehicleDetailState {
  final String message;

  const VehicleDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleDetailOperationSuccess extends VehicleDetailState {
  final String message;

  const VehicleDetailOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
