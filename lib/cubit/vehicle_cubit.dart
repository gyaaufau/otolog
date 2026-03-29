import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/database.dart';
import '../repositories/drift_service.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final DriftService _driftService;

  VehicleCubit(this._driftService) : super(const VehicleInitial());

  // Load all vehicles
  Future<void> loadVehicles() async {
    emit(const VehicleLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();

      print('DEBUG: Loaded ${vehicles.length} vehicles');
      for (var v in vehicles) {
        print('DEBUG: Vehicle ${v.name} has isPrimary: ${v.isPrimary}');
      }

      print('DEBUG: Primary vehicle already exists or no vehicles');
      emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
    } catch (e) {
      print('DEBUG: Error loading vehicles: $e');
      emit(VehicleError('Failed to load vehicles: ${e.toString()}'));
    }
  }

  // Load vehicle with service records
  Future<void> loadVehicleWithServices(int vehicleId) async {
    emit(const VehicleLoading());
    try {
      final vehicle = await _driftService.getVehicle(vehicleId);
      if (vehicle == null) {
        emit(const VehicleError('Vehicle not found'));
        return;
      }

      final serviceRecords = await _driftService.getServiceRecordsByVehicle(
        vehicleId,
      );
      final totalCost = await _driftService.getTotalCostByVehicle(vehicleId);
      final serviceCount = await _driftService.getServiceCountByVehicle(
        vehicleId,
      );

      emit(
        VehicleLoaded(
          vehicles: [vehicle],
          serviceRecords: serviceRecords,
          totalCost: totalCost,
          serviceCount: serviceCount,
        ),
      );
    } catch (e) {
      emit(VehicleError('Failed to load vehicle: ${e.toString()}'));
    }
  }

  // Add new vehicle
  Future<void> addVehicle(VehiclesCompanion vehicle) async {
    emit(const VehicleLoading());
    try {
      await _driftService.addVehicle(vehicle);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
    } catch (e) {
      emit(VehicleError('Failed to add vehicle: ${e.toString()}'));
    }
  }

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    emit(const VehicleLoading());
    try {
      await _driftService.updateVehicle(vehicle);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
    } catch (e) {
      emit(VehicleError('Failed to update vehicle: ${e.toString()}'));
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(int vehicleId) async {
    emit(const VehicleLoading());
    try {
      await _driftService.deleteVehicle(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
    } catch (e) {
      emit(VehicleError('Failed to delete vehicle: ${e.toString()}'));
    }
  }

  // Mark vehicle as primary
  Future<void> markAsPrimary(int vehicleId) async {
    emit(const VehicleLoading());
    try {
      await _driftService.markAsPrimary(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
    } catch (e) {
      emit(VehicleError('Failed to mark vehicle as primary: ${e.toString()}'));
    }
  }

  // Search vehicles
  Future<void> searchVehicles(String query) async {
    emit(const VehicleLoading());
    try {
      final serviceRecords = await _driftService.getAllServiceRecords();
      if (query.isEmpty) {
        final vehicles = await _driftService.getAllVehicles();
        emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
      } else {
        final vehicles = await _driftService.searchVehicles(query);
        emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
      }
    } catch (e) {
      emit(VehicleError('Failed to search vehicles: ${e.toString()}'));
    }
  }

  // Filter vehicles by type
  Future<void> filterVehiclesByType(String? type) async {
    emit(const VehicleLoading());
    try {
      final serviceRecords = await _driftService.getAllServiceRecords();
      if (type == null || type.isEmpty) {
        final vehicles = await _driftService.getAllVehicles();
        emit(
          VehicleLoaded(
            vehicles: vehicles,
            serviceRecords: serviceRecords,
            filterType: null,
          ),
        );
      } else {
        final vehicles = await _driftService.filterVehiclesByType(type);
        emit(
          VehicleLoaded(
            vehicles: vehicles,
            serviceRecords: serviceRecords,
            filterType: type,
          ),
        );
      }
    } catch (e) {
      emit(VehicleError('Failed to filter vehicles: ${e.toString()}'));
    }
  }

  // Add service record
  Future<void> addServiceRecord(ServiceRecordsCompanion record) async {
    emit(const VehicleLoading());
    try {
      await _driftService.addServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId.value);
    } catch (e) {
      emit(VehicleError('Failed to add service record: ${e.toString()}'));
    }
  }

  // Update service record
  Future<void> updateServiceRecord(ServiceRecord record) async {
    emit(const VehicleLoading());
    try {
      await _driftService.updateServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId);
    } catch (e) {
      emit(VehicleError('Failed to update service record: ${e.toString()}'));
    }
  }

  // Delete service record
  Future<void> deleteServiceRecord(int recordId, int vehicleId) async {
    emit(const VehicleLoading());
    try {
      await _driftService.deleteServiceRecord(recordId);
      await loadVehicleWithServices(vehicleId);
    } catch (e) {
      emit(VehicleError('Failed to delete service record: ${e.toString()}'));
    }
  }

  // Get statistics
  Future<void> getStatistics() async {
    emit(const VehicleLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();
      final totalCost = await _driftService.getTotalCostAllVehicles();

      int totalServices = 0;
      for (var vehicle in vehicles) {
        totalServices += await _driftService.getServiceCountByVehicle(
          vehicle.id,
        );
      }

      emit(
        VehicleLoaded(
          vehicles: vehicles,
          totalCost: totalCost,
          serviceCount: totalServices,
        ),
      );
    } catch (e) {
      emit(VehicleError('Failed to load statistics: ${e.toString()}'));
    }
  }

  // Load home screen data
  Future<void> loadHomeData({int? selectedVehicleId}) async {
    emit(const VehicleLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();

      // If no selectedVehicleId is provided, use the primary vehicle or first vehicle
      int? targetVehicleId = selectedVehicleId;
      int? targetOdometer;
      if (targetVehicleId == null && vehicles.isNotEmpty) {
        final primaryVehicle = vehicles.firstWhere(
          (v) => v.isPrimary == true,
          orElse: () => vehicles.first,
        );
        targetVehicleId = primaryVehicle.id;
        targetOdometer = primaryVehicle.odometer;
      } else if (targetVehicleId != null) {
        final targetVehicle = vehicles.firstWhere(
          (v) => v.id == targetVehicleId,
          orElse: () => vehicles.first,
        );
        targetOdometer = targetVehicle.odometer;
      }

      List<ServiceRecord> recentServices = [];
      double totalCost = 0;
      int totalServices = 0;

      if (targetVehicleId != null) {
        recentServices = await _driftService.getServiceRecordsByVehicle(
          targetVehicleId,
        );
        totalCost = await _driftService.getTotalCostByVehicle(targetVehicleId);
        totalServices = await _driftService.getServiceCountByVehicle(
          targetVehicleId,
        );
      }

      // Get only last 5 recent services
      final limitedRecentServices = recentServices.take(5).toList();

      emit(
        VehicleLoaded(
          vehicles: vehicles,
          serviceRecords: limitedRecentServices,
          totalCost: totalCost,
          serviceCount: totalServices,
          selectedVehicleId: targetVehicleId,
          odometer: targetOdometer,
        ),
      );
    } catch (e) {
      emit(VehicleError('Failed to load home data: ${e.toString()}'));
    }
  }

  // Select vehicle for home screen
  Future<void> selectVehicle(int vehicleId) async {
    final currentState = state;
    if (currentState is! VehicleLoaded) {
      return;
    }

    try {
      final vehicles = currentState.vehicles;
      final selectedVehicle = vehicles.firstWhere(
        (v) => v.id == vehicleId,
        orElse: () => vehicles.first,
      );
      final recentServices = await _driftService.getServiceRecordsByVehicle(
        vehicleId,
      );
      final totalCost = await _driftService.getTotalCostByVehicle(vehicleId);
      final totalServices = await _driftService.getServiceCountByVehicle(
        vehicleId,
      );

      // Get only last 5 recent services
      final limitedRecentServices = recentServices.take(5).toList();

      emit(
        currentState.copyWith(
          serviceRecords: limitedRecentServices,
          totalCost: totalCost,
          serviceCount: totalServices,
          selectedVehicleId: vehicleId,
          odometer: selectedVehicle.odometer,
        ),
      );
    } catch (e) {
      emit(VehicleError('Failed to select vehicle: ${e.toString()}'));
    }
  }
}
