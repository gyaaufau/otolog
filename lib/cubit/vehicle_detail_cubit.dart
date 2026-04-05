import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../repositories/drift_service.dart';
import 'vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  final DriftService _driftService;

  VehicleDetailCubit(this._driftService) : super(const VehicleDetailInitial());

  // Load vehicle with service records (for detail screen)
  Future<void> loadVehicleWithServices(int vehicleId) async {
    emit(const VehicleDetailLoading());
    try {
      final vehicle = await _driftService.getVehicle(vehicleId);
      if (vehicle == null) {
        emit(const VehicleDetailError('Vehicle not found'));
        return;
      }

      final serviceRecords = await _driftService.getServiceRecordsByVehicle(
        vehicleId,
      );
      final totalCost = await _driftService.getTotalCostByVehicle(vehicleId);
      final serviceCount = await _driftService.getServiceCountByVehicle(
        vehicleId,
      );

      // Calculate additional statistics
      final averageCost = serviceCount > 0 ? totalCost / serviceCount : 0.0;
      final lastServiceDate =
          serviceRecords.isNotEmpty
              ? serviceRecords
                  .map((r) => r.serviceDate)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
              : null;
      final daysSinceLastService =
          lastServiceDate != null
              ? DateTime.now().difference(lastServiceDate).inDays
              : 0;

      emit(
        VehicleDetailLoaded(
          vehicle: vehicle,
          serviceRecords: serviceRecords,
          totalCost: totalCost,
          serviceCount: serviceCount,
          averageCost: averageCost,
          lastServiceDate: lastServiceDate,
          daysSinceLastService: daysSinceLastService,
        ),
      );
    } catch (e) {
      emit(VehicleDetailError('Failed to load vehicle: ${e.toString()}'));
    }
  }

  // Add service record
  Future<void> addServiceRecord(ServiceRecordsCompanion record) async {
    try {
      await _driftService.addServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId.value);
    } catch (e) {
      emit(VehicleDetailError('Failed to add service record: ${e.toString()}'));
    }
  }

  // Update service record
  Future<void> updateServiceRecord(ServiceRecord record) async {
    try {
      await _driftService.updateServiceRecord(record);
      await loadVehicleWithServices(record.vehicleId);
    } catch (e) {
      emit(
        VehicleDetailError('Failed to update service record: ${e.toString()}'),
      );
    }
  }

  // Delete service record
  Future<void> deleteServiceRecord(int recordId, int vehicleId) async {
    try {
      await _driftService.deleteServiceRecord(recordId);
      await loadVehicleWithServices(vehicleId);
    } catch (e) {
      emit(
        VehicleDetailError('Failed to delete service record: ${e.toString()}'),
      );
    }
  }

  // Refresh vehicle detail
  Future<void> refresh(int vehicleId) async {
    await loadVehicleWithServices(vehicleId);
  }

  // Update vehicle image
  Future<void> updateVehicleImage(int vehicleId, String imagePath) async {
    try {
      final vehicle = await _driftService.getVehicle(vehicleId);
      if (vehicle == null) {
        emit(const VehicleDetailError('Vehicle not found'));
        return;
      }

      final updatedVehicle = vehicle.copyWith(
        imagePath: Value(imagePath),
        updatedAt: DateTime.now(),
      );

      await _driftService.updateVehicle(updatedVehicle);
      await loadVehicleWithServices(vehicleId);
    } catch (e) {
      emit(
        VehicleDetailError('Failed to update vehicle image: ${e.toString()}'),
      );
    }
  }
}
