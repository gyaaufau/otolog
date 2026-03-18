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
      emit(VehicleLoaded(vehicles: vehicles, serviceRecords: serviceRecords));
    } catch (e) {
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
      emit(VehicleLoaded(vehicles: vehicles));
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
      emit(VehicleLoaded(vehicles: vehicles));
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
      emit(VehicleLoaded(vehicles: vehicles));
    } catch (e) {
      emit(VehicleError('Failed to delete vehicle: ${e.toString()}'));
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
  Future<void> loadHomeData() async {
    emit(const VehicleLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();
      final recentServices = await _driftService.getAllServiceRecords();
      final totalCost = await _driftService.getTotalCostAllVehicles();

      int totalServices = 0;
      for (var vehicle in vehicles) {
        totalServices += await _driftService.getServiceCountByVehicle(
          vehicle.id,
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
        ),
      );
    } catch (e) {
      emit(VehicleError('Failed to load home data: ${e.toString()}'));
    }
  }
}
