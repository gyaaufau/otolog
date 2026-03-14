import 'package:equatable/equatable.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  final List<Vehicle> vehicles;
  final List<ServiceRecord> allServiceRecords;
  final double totalCostAllVehicles;
  final int totalServiceCount;
  final Map<String, double> monthlySpending;
  final Map<String, int> serviceTypeDistribution;
  final Map<int, double> costPerVehicle;
  final List<ServiceRecord> recentServices;

  const AnalyticsLoaded({
    required this.vehicles,
    required this.allServiceRecords,
    required this.totalCostAllVehicles,
    required this.totalServiceCount,
    required this.monthlySpending,
    required this.serviceTypeDistribution,
    required this.costPerVehicle,
    required this.recentServices,
  });

  @override
  List<Object?> get props => [
    vehicles,
    allServiceRecords,
    totalCostAllVehicles,
    totalServiceCount,
    monthlySpending,
    serviceTypeDistribution,
    costPerVehicle,
    recentServices,
  ];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
