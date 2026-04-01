import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/database.dart';
import '../repositories/drift_service.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final DriftService _driftService;

  // Cache for all vehicles to preserve state across navigation
  List<Vehicle>? _cachedAllVehicles;
  List<ServiceRecord>? _cachedAllServiceRecords;

  VehicleCubit(this._driftService) : super(const VehicleInitial()) {
    _logState('VehicleCubit initialized', const VehicleInitial());
  }

  void _logState(String action, VehicleState state) {
    final timestamp = DateTime.now().toIso8601String();
    print('═══════════════════════════════════════════════════════════════');
    print('🚗 VEHICLE CUBIT DEBUG [$timestamp]');
    print('📍 Action: $action');
    print('📊 State Type: ${state.runtimeType}');

    if (state is VehicleLoaded) {
      print('📋 Vehicles Count: ${state.vehicles.length}');
      print('🔍 Filter Type: ${state.filterType ?? "None"}');
      print('⭐ Selected Vehicle ID: ${state.selectedVehicleId ?? "None"}');
      print('📝 Service Records: ${state.serviceRecords?.length ?? 0}');
      print('💰 Total Cost: ${state.totalCost ?? 0}');
      print('🔧 Service Count: ${state.serviceCount ?? 0}');

      // Log each vehicle
      for (int i = 0; i < state.vehicles.length; i++) {
        final v = state.vehicles[i];
        print(
          '   └─ Vehicle $i: ID=${v.id}, Name="${v.name}", Primary=${v.isPrimary}',
        );
      }
    } else if (state is VehicleError) {
      print('❌ Error: ${state.message}');
    }

    print('═══════════════════════════════════════════════════════════════');
  }

  // Load all vehicles
  Future<void> loadVehicles() async {
    emit(const VehicleLoading());
    _logState('loadVehicles - Loading started', const VehicleLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();

      // Cache all vehicles for later use
      _cachedAllVehicles = vehicles;
      _cachedAllServiceRecords = serviceRecords;

      final newState = VehicleLoaded(
        vehicles: vehicles,
        serviceRecords: serviceRecords,
      );
      emit(newState);
      _logState('loadVehicles - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to load vehicles: ${e.toString()}',
      );
      emit(errorState);
      _logState('loadVehicles - Error', errorState);
    }
  }

  // Load vehicle with service records (for detail screen)
  Future<void> loadVehicleWithServices(int vehicleId) async {
    emit(const VehicleLoading());
    _logState(
      'loadVehicleWithServices($vehicleId) - Loading started',
      const VehicleLoading(),
    );
    try {
      final vehicle = await _driftService.getVehicle(vehicleId);
      if (vehicle == null) {
        final errorState = const VehicleError('Vehicle not found');
        emit(errorState);
        _logState(
          'loadVehicleWithServices($vehicleId) - Vehicle not found',
          errorState,
        );
        return;
      }

      final serviceRecords = await _driftService.getServiceRecordsByVehicle(
        vehicleId,
      );
      final totalCost = await _driftService.getTotalCostByVehicle(vehicleId);
      final serviceCount = await _driftService.getServiceCountByVehicle(
        vehicleId,
      );

      final newState = VehicleLoaded(
        vehicles: [vehicle],
        serviceRecords: serviceRecords,
        totalCost: totalCost,
        serviceCount: serviceCount,
      );
      emit(newState);
      _logState(
        'loadVehicleWithServices($vehicleId) - Success (single vehicle)',
        newState,
      );
    } catch (e) {
      final errorState = VehicleError(
        'Failed to load vehicle: ${e.toString()}',
      );
      emit(errorState);
      _logState('loadVehicleWithServices($vehicleId) - Error', errorState);
    }
  }

  // Restore all vehicles (call when returning to vehicles list screen)
  Future<void> restoreAllVehicles() async {
    print('🔄 RESTORING ALL VEHICLES - Called from vehicles screen');

    // If we have cached vehicles, restore them immediately
    if (_cachedAllVehicles != null && _cachedAllServiceRecords != null) {
      final newState = VehicleLoaded(
        vehicles: _cachedAllVehicles!,
        serviceRecords: _cachedAllServiceRecords!,
      );
      emit(newState);
      _logState('restoreAllVehicles - Restored from cache', newState);
      return;
    }

    // Otherwise, reload from database
    emit(const VehicleLoading());
    _logState(
      'restoreAllVehicles - Loading from database',
      const VehicleLoading(),
    );
    try {
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();

      // Cache them
      _cachedAllVehicles = vehicles;
      _cachedAllServiceRecords = serviceRecords;

      final newState = VehicleLoaded(
        vehicles: vehicles,
        serviceRecords: serviceRecords,
      );
      emit(newState);
      _logState('restoreAllVehicles - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to restore vehicles: ${e.toString()}',
      );
      emit(errorState);
      _logState('restoreAllVehicles - Error', errorState);
    }
  }

  // Add new vehicle
  Future<void> addVehicle(VehiclesCompanion vehicle) async {
    emit(const VehicleLoading());
    _logState('addVehicle - Loading started', const VehicleLoading());
    try {
      await _driftService.addVehicle(vehicle);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();

      // Update cache
      _cachedAllVehicles = vehicles;
      _cachedAllServiceRecords = serviceRecords;

      final newState = VehicleLoaded(
        vehicles: vehicles,
        serviceRecords: serviceRecords,
      );
      emit(newState);
      _logState('addVehicle - Success', newState);
    } catch (e) {
      final errorState = VehicleError('Failed to add vehicle: ${e.toString()}');
      emit(errorState);
      _logState('addVehicle - Error', errorState);
    }
  }

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    print('🔧 DEBUG: updateVehicle called for vehicle ID: ${vehicle.id}');
    // Don't emit VehicleLoading to avoid refreshing the edit screen
    // since we're about to navigate away anyway
    _logState('updateVehicle(${vehicle.id}) - Started', state);
    try {
      await _driftService.updateVehicle(vehicle);
      print('✅ DEBUG: Vehicle updated in database');

      // Update cache with the updated vehicle
      final vehicles = await _driftService.getAllVehicles();
      _cachedAllVehicles = vehicles;
      _cachedAllServiceRecords = await _driftService.getAllServiceRecords();

      // Emit success state for UI feedback
      print('🎉 DEBUG: About to emit VehicleOperationSuccess');
      emit(const VehicleOperationSuccess('Vehicle updated successfully'));
      print('✅ DEBUG: VehicleOperationSuccess emitted');
    } catch (e) {
      print('❌ DEBUG: Error in updateVehicle: ${e.toString()}');
      final errorState = VehicleError(
        'Failed to update vehicle: ${e.toString()}',
      );
      emit(errorState);
      _logState('updateVehicle(${vehicle.id}) - Error', errorState);
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(int vehicleId) async {
    emit(const VehicleLoading());
    _logState(
      'deleteVehicle($vehicleId) - Loading started',
      const VehicleLoading(),
    );
    try {
      await _driftService.deleteVehicle(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();

      // Update cache
      _cachedAllVehicles = vehicles;
      _cachedAllServiceRecords = serviceRecords;

      final newState = VehicleLoaded(
        vehicles: vehicles,
        serviceRecords: serviceRecords,
      );
      emit(newState);
      _logState('deleteVehicle($vehicleId) - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to delete vehicle: ${e.toString()}',
      );
      emit(errorState);
      _logState('deleteVehicle($vehicleId) - Error', errorState);
    }
  }

  // Mark vehicle as primary
  Future<void> markAsPrimary(int vehicleId) async {
    emit(const VehicleLoading());
    _logState(
      'markAsPrimary($vehicleId) - Loading started',
      const VehicleLoading(),
    );
    try {
      await _driftService.markAsPrimary(vehicleId);
      final vehicles = await _driftService.getAllVehicles();
      final serviceRecords = await _driftService.getAllServiceRecords();

      // Update cache
      _cachedAllVehicles = vehicles;
      _cachedAllServiceRecords = serviceRecords;

      final newState = VehicleLoaded(
        vehicles: vehicles,
        serviceRecords: serviceRecords,
      );
      emit(newState);
      _logState('markAsPrimary($vehicleId) - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to mark vehicle as primary: ${e.toString()}',
      );
      emit(errorState);
      _logState('markAsPrimary($vehicleId) - Error', errorState);
    }
  }

  // Search vehicles
  Future<void> searchVehicles(String query) async {
    emit(const VehicleLoading());
    _logState(
      'searchVehicles("$query") - Loading started',
      const VehicleLoading(),
    );
    try {
      final serviceRecords = await _driftService.getAllServiceRecords();
      VehicleLoaded newState;
      if (query.isEmpty) {
        final vehicles = await _driftService.getAllVehicles();
        newState = VehicleLoaded(
          vehicles: vehicles,
          serviceRecords: serviceRecords,
        );
      } else {
        final vehicles = await _driftService.searchVehicles(query);
        newState = VehicleLoaded(
          vehicles: vehicles,
          serviceRecords: serviceRecords,
        );
      }
      emit(newState);
      _logState('searchVehicles("$query") - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to search vehicles: ${e.toString()}',
      );
      emit(errorState);
      _logState('searchVehicles("$query") - Error', errorState);
    }
  }

  // Filter vehicles by type
  Future<void> filterVehiclesByType(String? type) async {
    emit(const VehicleLoading());
    _logState(
      'filterVehiclesByType("$type") - Loading started',
      const VehicleLoading(),
    );
    try {
      final serviceRecords = await _driftService.getAllServiceRecords();
      VehicleLoaded newState;
      if (type == null || type.isEmpty) {
        final vehicles = await _driftService.getAllVehicles();
        newState = VehicleLoaded(
          vehicles: vehicles,
          serviceRecords: serviceRecords,
          filterType: null,
        );
      } else {
        final vehicles = await _driftService.filterVehiclesByType(type);
        newState = VehicleLoaded(
          vehicles: vehicles,
          serviceRecords: serviceRecords,
          filterType: type,
        );
      }
      emit(newState);
      _logState('filterVehiclesByType("$type") - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to filter vehicles: ${e.toString()}',
      );
      emit(errorState);
      _logState('filterVehiclesByType("$type") - Error', errorState);
    }
  }

  // Add service record
  Future<void> addServiceRecord(ServiceRecordsCompanion record) async {
    emit(const VehicleLoading());
    _logState('addServiceRecord - Loading started', const VehicleLoading());
    try {
      await _driftService.addServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId.value);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to add service record: ${e.toString()}',
      );
      emit(errorState);
      _logState('addServiceRecord - Error', errorState);
    }
  }

  // Update service record
  Future<void> updateServiceRecord(ServiceRecord record) async {
    emit(const VehicleLoading());
    _logState(
      'updateServiceRecord(${record.id}) - Loading started',
      const VehicleLoading(),
    );
    try {
      await _driftService.updateServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to update service record: ${e.toString()}',
      );
      emit(errorState);
      _logState('updateServiceRecord(${record.id}) - Error', errorState);
    }
  }

  // Delete service record
  Future<void> deleteServiceRecord(int recordId, int vehicleId) async {
    emit(const VehicleLoading());
    _logState(
      'deleteServiceRecord($recordId) - Loading started',
      const VehicleLoading(),
    );
    try {
      await _driftService.deleteServiceRecord(recordId);
      await loadVehicleWithServices(vehicleId);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to delete service record: ${e.toString()}',
      );
      emit(errorState);
      _logState('deleteServiceRecord($recordId) - Error', errorState);
    }
  }

  // Get statistics
  Future<void> getStatistics() async {
    emit(const VehicleLoading());
    _logState('getStatistics - Loading started', const VehicleLoading());
    try {
      final vehicles = await _driftService.getAllVehicles();
      final totalCost = await _driftService.getTotalCostAllVehicles();

      int totalServices = 0;
      for (var vehicle in vehicles) {
        totalServices += await _driftService.getServiceCountByVehicle(
          vehicle.id,
        );
      }

      final newState = VehicleLoaded(
        vehicles: vehicles,
        totalCost: totalCost,
        serviceCount: totalServices,
      );
      emit(newState);
      _logState('getStatistics - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to load statistics: ${e.toString()}',
      );
      emit(errorState);
      _logState('getStatistics - Error', errorState);
    }
  }

  // Load home screen data
  Future<void> loadHomeData({int? selectedVehicleId}) async {
    emit(const VehicleLoading());
    _logState('loadHomeData - Loading started', const VehicleLoading());
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

      final newState = VehicleLoaded(
        vehicles: vehicles,
        serviceRecords: limitedRecentServices,
        totalCost: totalCost,
        serviceCount: totalServices,
        selectedVehicleId: targetVehicleId,
        odometer: targetOdometer,
      );
      emit(newState);
      _logState('loadHomeData - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to load home data: ${e.toString()}',
      );
      emit(errorState);
      _logState('loadHomeData - Error', errorState);
    }
  }

  // Select vehicle for home screen
  Future<void> selectVehicle(int vehicleId) async {
    final currentState = state;
    if (currentState is! VehicleLoaded) {
      return;
    }

    _logState('selectVehicle($vehicleId) - Starting', currentState);
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

      final newState = currentState.copyWith(
        serviceRecords: limitedRecentServices,
        totalCost: totalCost,
        serviceCount: totalServices,
        selectedVehicleId: vehicleId,
        odometer: selectedVehicle.odometer,
      );
      emit(newState);
      _logState('selectVehicle($vehicleId) - Success', newState);
    } catch (e) {
      final errorState = VehicleError(
        'Failed to select vehicle: ${e.toString()}',
      );
      emit(errorState);
      _logState('selectVehicle($vehicleId) - Error', errorState);
    }
  }
}
