import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/database.dart';
import '../repositories/drift_service.dart';
import 'vehicle_list_state.dart';

class VehicleListCubit extends Cubit<VehicleListState> {
  final DriftService _driftService;

  VehicleListCubit(this._driftService) : super(const VehicleListInitial());

  // Load all vehicles
  Future<void> loadVehicles() async {
    emit(const VehicleListLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListLoaded(vehicles: vehicles, serviceRecords: serviceRecords),
      );
    } catch (e) {
      emit(VehicleListError('Failed to load vehicles: ${e.toString()}'));
    }
  }

  // Add new vehicle
  Future<void> addVehicle(VehiclesCompanion vehicle) async {
    emit(const VehicleListLoading());
    try {
      await _driftService.addVehicle(vehicle);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListOperationSuccess(
          message: 'Vehicle added successfully',
          vehicles: vehicles,
          serviceRecords: serviceRecords,
        ),
      );
    } catch (e) {
      emit(VehicleListError('Failed to add vehicle: ${e.toString()}'));
    }
  }

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _driftService.updateVehicle(vehicle);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListOperationSuccess(
          message: 'Vehicle updated successfully',
          vehicles: vehicles,
          serviceRecords: serviceRecords,
        ),
      );
    } catch (e) {
      emit(VehicleListError('Failed to update vehicle: ${e.toString()}'));
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(int vehicleId) async {
    emit(const VehicleListLoading());
    try {
      await _driftService.deleteVehicle(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListLoaded(vehicles: vehicles, serviceRecords: serviceRecords),
      );
    } catch (e) {
      emit(VehicleListError('Failed to delete vehicle: ${e.toString()}'));
    }
  }

  // Mark vehicle as primary
  Future<void> markAsPrimary(int vehicleId) async {
    emit(const VehicleListLoading());
    try {
      await _driftService.markAsPrimary(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListLoaded(vehicles: vehicles, serviceRecords: serviceRecords),
      );
    } catch (e) {
      emit(
        VehicleListError('Failed to mark vehicle as primary: ${e.toString()}'),
      );
    }
  }

  // Toggle vehicle as primary
  Future<void> togglePrimary(int vehicleId) async {
    emit(const VehicleListLoading());
    try {
      await _driftService.togglePrimary(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListLoaded(vehicles: vehicles, serviceRecords: serviceRecords),
      );
    } catch (e) {
      emit(
        VehicleListError('Failed to toggle primary vehicle: ${e.toString()}'),
      );
    }
  }

  // Search vehicles
  Future<void> searchVehicles(String query) async {
    emit(const VehicleListLoading());
    try {
      List<Vehicle> vehicles;
      List<ServiceRecord> serviceRecords;
      if (query.isEmpty) {
        vehicles = await _driftService.getAllVehicles();
        serviceRecords = await _driftService.getAllServiceRecords();
      } else {
        vehicles = await _driftService.searchVehicles(query);
        serviceRecords = await _driftService.getAllServiceRecords();
      }
      emit(
        VehicleListLoaded(vehicles: vehicles, serviceRecords: serviceRecords),
      );
    } catch (e) {
      emit(VehicleListError('Failed to search vehicles: ${e.toString()}'));
    }
  }

  // Filter vehicles by type
  Future<void> filterVehiclesByType(String? type) async {
    emit(const VehicleListLoading());
    try {
      List<Vehicle> vehicles;
      List<ServiceRecord> serviceRecords;
      if (type == null || type.isEmpty) {
        vehicles = await _driftService.getAllVehicles();
        serviceRecords = await _driftService.getAllServiceRecords();
        emit(
          VehicleListLoaded(
            vehicles: vehicles,
            serviceRecords: serviceRecords,
            filterType: null,
          ),
        );
      } else {
        vehicles = await _driftService.filterVehiclesByType(type);
        serviceRecords = await _driftService.getAllServiceRecords();
        emit(
          VehicleListLoaded(
            vehicles: vehicles,
            serviceRecords: serviceRecords,
            filterType: type,
          ),
        );
      }
    } catch (e) {
      emit(VehicleListError('Failed to filter vehicles: ${e.toString()}'));
    }
  }

  // Refresh vehicles list
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is VehicleListLoaded &&
        currentState.serviceRecords != null) {
      // If we don't have service records, load them
      await loadVehicles();
    } else if (currentState is VehicleListLoaded) {
      // Preserve current state including service records
      emit(currentState.copyWith());
    }
  }

  // Load home screen data (vehicles and selected vehicle)
  Future<void> loadHomeData({int? selectedVehicleId}) async {
    emit(const VehicleListLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();

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
          targetVehicleId!,
        );
        totalCost = await _driftService.getTotalCostByVehicle(targetVehicleId!);
        totalServices = await _driftService.getServiceCountByVehicle(
          targetVehicleId!,
        );

        // Get only last 5 recent services
        recentServices = recentServices.take(5).toList();
      }

      emit(VehicleListLoaded(vehicles: vehicles));
    } catch (e) {
      emit(VehicleListError('Failed to load home data: ${e.toString()}'));
    }
  }

  // Select vehicle for home screen
  Future<void> selectVehicle(int vehicleId) async {
    try {
      final vehicles = await _driftService.getAllVehicles();
      final recentServices = await _driftService.getServiceRecordsByVehicle(
        vehicleId,
      );
      final totalCost = await _driftService.getTotalCostByVehicle(vehicleId);
      final totalServices = await _driftService.getServiceCountByVehicle(
        vehicleId,
      );

      // Get only last 5 recent services
      final limitedRecentServices = recentServices.take(5).toList();

      final currentState = state;
      if (currentState is VehicleListLoaded) {
        emit(currentState.copyWith());
      }
    } catch (e) {
      emit(VehicleListError('Failed to select vehicle: ${e.toString()}'));
    }
  }

  // Delete service record
  Future<void> deleteServiceRecord(int recordId, int vehicleId) async {
    emit(const VehicleListLoading());
    try {
      await _driftService.deleteServiceRecord(recordId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();
      emit(
        VehicleListLoaded(vehicles: vehicles, serviceRecords: serviceRecords),
      );
    } catch (e) {
      emit(
        VehicleListError('Failed to delete service record: ${e.toString()}'),
      );
    }
  }
}
