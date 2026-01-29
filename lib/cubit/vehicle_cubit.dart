import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import '../repositories/isar_service.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final IsarService _isarService;

  VehicleCubit(this._isarService) : super(const VehicleInitial());

  // Load all vehicles
  Future<void> loadVehicles() async {
    emit(const VehicleLoading());
    try {
      final vehicles = await _isarService.getAllVehicles();
      emit(VehicleLoaded(vehicles: vehicles));
    } catch (e) {
      emit(VehicleError('Failed to load vehicles: ${e.toString()}'));
    }
  }

  // Load vehicle with service records
  Future<void> loadVehicleWithServices(int vehicleId) async {
    emit(const VehicleLoading());
    try {
      final vehicle = await _isarService.getVehicle(vehicleId);
      if (vehicle == null) {
        emit(const VehicleError('Vehicle not found'));
        return;
      }

      final serviceRecords = await _isarService.getServiceRecordsByVehicle(
        vehicleId,
      );
      final totalCost = await _isarService.getTotalCostByVehicle(vehicleId);
      final serviceCount = await _isarService.getServiceCountByVehicle(
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
  Future<void> addVehicle(Vehicle vehicle) async {
    emit(const VehicleLoading());
    try {
      await _isarService.addVehicle(vehicle);
      final vehicles = await _isarService.getAllVehicles();
      emit(VehicleLoaded(vehicles: vehicles));
      emit(const VehicleOperationSuccess('Vehicle added successfully'));
    } catch (e) {
      emit(VehicleError('Failed to add vehicle: ${e.toString()}'));
    }
  }

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    emit(const VehicleLoading());
    try {
      await _isarService.updateVehicle(vehicle);
      final vehicles = await _isarService.getAllVehicles();
      emit(VehicleLoaded(vehicles: vehicles));
      emit(const VehicleOperationSuccess('Vehicle updated successfully'));
    } catch (e) {
      emit(VehicleError('Failed to update vehicle: ${e.toString()}'));
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(int vehicleId) async {
    emit(const VehicleLoading());
    try {
      await _isarService.deleteVehicle(vehicleId);
      final vehicles = await _isarService.getAllVehicles();
      emit(VehicleLoaded(vehicles: vehicles));
      emit(const VehicleOperationSuccess('Vehicle deleted successfully'));
    } catch (e) {
      emit(VehicleError('Failed to delete vehicle: ${e.toString()}'));
    }
  }

  // Search vehicles
  Future<void> searchVehicles(String query) async {
    emit(const VehicleLoading());
    try {
      if (query.isEmpty) {
        final vehicles = await _isarService.getAllVehicles();
        emit(VehicleLoaded(vehicles: vehicles));
      } else {
        final vehicles = await _isarService.searchVehicles(query);
        emit(VehicleLoaded(vehicles: vehicles));
      }
    } catch (e) {
      emit(VehicleError('Failed to search vehicles: ${e.toString()}'));
    }
  }

  // Add service record
  Future<void> addServiceRecord(ServiceRecord record) async {
    emit(const VehicleLoading());
    try {
      await _isarService.addServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId);
      emit(const VehicleOperationSuccess('Service record added successfully'));
    } catch (e) {
      emit(VehicleError('Failed to add service record: ${e.toString()}'));
    }
  }

  // Update service record
  Future<void> updateServiceRecord(ServiceRecord record) async {
    emit(const VehicleLoading());
    try {
      await _isarService.updateServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId);
      emit(
        const VehicleOperationSuccess('Service record updated successfully'),
      );
    } catch (e) {
      emit(VehicleError('Failed to update service record: ${e.toString()}'));
    }
  }

  // Delete service record
  Future<void> deleteServiceRecord(int recordId, int vehicleId) async {
    emit(const VehicleLoading());
    try {
      await _isarService.deleteServiceRecord(recordId);
      await loadVehicleWithServices(vehicleId);
      emit(
        const VehicleOperationSuccess('Service record deleted successfully'),
      );
    } catch (e) {
      emit(VehicleError('Failed to delete service record: ${e.toString()}'));
    }
  }

  // Get statistics
  Future<void> getStatistics() async {
    emit(const VehicleLoading());
    try {
      final vehicles = await _isarService.getAllVehicles();
      final totalCost = await _isarService.getTotalCostAllVehicles();

      int totalServices = 0;
      for (var vehicle in vehicles) {
        totalServices += await _isarService.getServiceCountByVehicle(
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
}
