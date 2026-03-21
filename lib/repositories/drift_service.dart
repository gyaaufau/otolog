import 'dart:developer';
import 'package:drift/drift.dart';
import '../database/database.dart';

class DriftService {
  final AppDatabase database;

  DriftService(this.database);

  // Vehicle Operations
  Future<int> addVehicle(VehiclesCompanion vehicle) async {
    return await database.addVehicle(vehicle);
  }

  Future<bool> updateVehicle(Vehicle vehicle) async {
    return await database.updateVehicle(vehicle);
  }

  Future<bool> deleteVehicle(int id) async {
    final result = await database.deleteVehicle(id);
    return result > 0;
  }

  Future<Vehicle?> getVehicle(int id) async {
    return await database.getVehicle(id);
  }

  Future<List<Vehicle>> getAllVehicles() async {
    log('Fetching all vehicles from Drift DB');
    return await database.getAllVehicles();
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    return await database.searchVehicles(query);
  }

  Future<List<Vehicle>> filterVehiclesByType(String type) async {
    return await database.filterVehiclesByType(type);
  }

  Future<void> markAsPrimary(int vehicleId) async {
    await database.markAsPrimary(vehicleId);
  }

  // Service Record Operations
  Future<int> addServiceRecord(ServiceRecordsCompanion record) async {
    return await database.addServiceRecord(record);
  }

  Future<bool> updateServiceRecord(ServiceRecord record) async {
    return await database.updateServiceRecord(record);
  }

  Future<bool> deleteServiceRecord(int id) async {
    final result = await database.deleteServiceRecord(id);
    return result > 0;
  }

  Future<ServiceRecord?> getServiceRecord(int id) async {
    return await database.getServiceRecord(id);
  }

  Future<List<ServiceRecord>> getServiceRecordsByVehicle(int vehicleId) async {
    return await database.getServiceRecordsByVehicle(vehicleId);
  }

  Future<List<ServiceRecord>> getAllServiceRecords() async {
    return await database.getAllServiceRecords();
  }

  // Statistics
  Future<double> getTotalCostByVehicle(int vehicleId) async {
    return await database.getTotalCostByVehicle(vehicleId);
  }

  Future<double> getTotalCostAllVehicles() async {
    return await database.getTotalCostAllVehicles();
  }

  Future<int> getServiceCountByVehicle(int vehicleId) async {
    return await database.getServiceCountByVehicle(vehicleId);
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    await database.clearAll();
  }
}
