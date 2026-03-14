import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import '../repositories/isar_service.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final IsarService _isarService;

  AnalyticsCubit(this._isarService) : super(const AnalyticsInitial());

  // Load analytics data
  Future<void> loadAnalytics() async {
    emit(const AnalyticsLoading());
    try {
      final vehicles = await _isarService.getAllVehicles();
      final allServiceRecords = await _isarService.getAllServiceRecords();
      final totalCostAllVehicles = await _isarService.getTotalCostAllVehicles();

      // Calculate total service count
      int totalServiceCount = 0;
      for (var vehicle in vehicles) {
        totalServiceCount += await _isarService.getServiceCountByVehicle(
          vehicle.id,
        );
      }

      // Calculate monthly spending
      final monthlySpending = _calculateMonthlySpending(allServiceRecords);

      // Calculate service type distribution
      final serviceTypeDistribution = _calculateServiceTypeDistribution(
        allServiceRecords,
      );

      // Calculate cost per vehicle
      final costPerVehicle = await _calculateCostPerVehicle(vehicles);

      // Get recent services (last 10)
      final recentServices = allServiceRecords.take(10).toList();

      emit(
        AnalyticsLoaded(
          vehicles: vehicles,
          allServiceRecords: allServiceRecords,
          totalCostAllVehicles: totalCostAllVehicles,
          totalServiceCount: totalServiceCount,
          monthlySpending: monthlySpending,
          serviceTypeDistribution: serviceTypeDistribution,
          costPerVehicle: costPerVehicle,
          recentServices: recentServices,
        ),
      );
    } catch (e) {
      emit(AnalyticsError('Failed to load analytics: ${e.toString()}'));
    }
  }

  // Calculate monthly spending for the last 6 months
  Map<String, double> _calculateMonthlySpending(
    List<ServiceRecord> serviceRecords,
  ) {
    final Map<String, double> monthlySpending = {};
    final now = DateTime.now();

    // Initialize last 6 months
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = DateFormat('MMM yyyy').format(month);
      monthlySpending[monthKey] = 0.0;
    }

    // Calculate spending per month
    for (var record in serviceRecords) {
      if (record.cost != null) {
        final monthKey = DateFormat('MMM yyyy').format(record.serviceDate);
        if (monthlySpending.containsKey(monthKey)) {
          monthlySpending[monthKey] = monthlySpending[monthKey]! + record.cost!;
        }
      }
    }

    return monthlySpending;
  }

  // Calculate service type distribution
  Map<String, int> _calculateServiceTypeDistribution(
    List<ServiceRecord> serviceRecords,
  ) {
    final Map<String, int> distribution = {};

    for (var record in serviceRecords) {
      final serviceType = record.serviceType;
      distribution[serviceType] = (distribution[serviceType] ?? 0) + 1;
    }

    return distribution;
  }

  // Calculate cost per vehicle
  Future<Map<int, double>> _calculateCostPerVehicle(
    List<Vehicle> vehicles,
  ) async {
    final Map<int, double> costPerVehicle = {};

    for (var vehicle in vehicles) {
      final cost = await _isarService.getTotalCostByVehicle(vehicle.id);
      costPerVehicle[vehicle.id] = cost;
    }

    return costPerVehicle;
  }

  // Get average cost per service
  double getAverageCostPerService(double totalCost, int serviceCount) {
    if (serviceCount == 0) return 0.0;
    return totalCost / serviceCount;
  }

  // Get most expensive service
  ServiceRecord? getMostExpensiveService(List<ServiceRecord> records) {
    if (records.isEmpty) return null;
    return records.reduce((a, b) => (a.cost ?? 0) > (b.cost ?? 0) ? a : b);
  }

  // Get most common service type
  String? getMostCommonServiceType(Map<String, int> distribution) {
    if (distribution.isEmpty) return null;
    return distribution.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
