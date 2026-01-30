import 'dart:developer';

import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';

class IsarService {
  late final Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = Isar.open(
      schemas: [VehicleSchema, ServiceRecordSchema],
      directory: dir.path,
      inspector: true,
    );

    return Future.value(isar);
  }

  // Vehicle Operations
  Future<int> addVehicle(Vehicle vehicle) async {
    final isar = await db;
    return await isar.write((isar) {
      vehicle.createdAt = DateTime.now();
      vehicle.updatedAt = DateTime.now();
      vehicle.id = isar.vehicles.autoIncrement();
      isar.vehicles.put(vehicle);
      return vehicle.id;
    });
  }

  Future<bool> updateVehicle(Vehicle vehicle) async {
    final isar = await db;
    return await isar.write((isar) {
      vehicle.updatedAt = DateTime.now();
      isar.vehicles.put(vehicle);
      return true;
    });
  }

  Future<bool> deleteVehicle(int id) async {
    final isar = await db;
    return await isar.write((isar) {
      // Delete all service records for this vehicle first
      isar.serviceRecords.where().vehicleIdEqualTo(id).deleteAll();
      return isar.vehicles.delete(id);
    });
  }

  Future<Vehicle?> getVehicle(int id) async {
    final isar = await db;
    return await isar.vehicles.get(id);
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final isar = await db;

    log('Fetching all vehicles from Isar DB');
    return await isar.vehicles.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    final isar = await db;
    return await isar.vehicles
        .where()
        .nameContains(query, caseSensitive: false)
        .or()
        .plateNumberContains(query, caseSensitive: false)
        .findAll();
  }

  // Service Record Operations
  Future<int> addServiceRecord(ServiceRecord record) async {
    final isar = await db;
    return await isar.write((isar) {
      record.createdAt = DateTime.now();
      record.updatedAt = DateTime.now();
      record.id = isar.serviceRecords.autoIncrement();
      isar.serviceRecords.put(record);
      return record.id;
    });
  }

  Future<bool> updateServiceRecord(ServiceRecord record) async {
    final isar = await db;
    return await isar.write((isar) {
      record.updatedAt = DateTime.now();
      isar.serviceRecords.put(record);
      return true;
    });
  }

  Future<bool> deleteServiceRecord(int id) async {
    final isar = await db;
    return await isar.write((isar) {
      return isar.serviceRecords.delete(id);
    });
  }

  Future<ServiceRecord?> getServiceRecord(int id) async {
    final isar = await db;
    return await isar.serviceRecords.get(id);
  }

  Future<List<ServiceRecord>> getServiceRecordsByVehicle(int vehicleId) async {
    final isar = await db;
    return await isar.serviceRecords
        .where()
        .vehicleIdEqualTo(vehicleId)
        .sortByServiceDateDesc()
        .findAll();
  }

  Future<List<ServiceRecord>> getAllServiceRecords() async {
    final isar = await db;
    return await isar.serviceRecords.where().sortByServiceDateDesc().findAll();
  }

  // Statistics
  Future<double> getTotalCostByVehicle(int vehicleId) async {
    final isar = await db;
    final records =
        await isar.serviceRecords.where().vehicleIdEqualTo(vehicleId).findAll();

    return records.fold<double>(0, (sum, record) => sum + (record.cost ?? 0));
  }

  Future<double> getTotalCostAllVehicles() async {
    final isar = await db;
    final records = await isar.serviceRecords.where().findAll();

    return records.fold<double>(0, (sum, record) => sum + (record.cost ?? 0));
  }

  Future<int> getServiceCountByVehicle(int vehicleId) async {
    final isar = await db;
    return await isar.serviceRecords
        .where()
        .vehicleIdEqualTo(vehicleId)
        .count();
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    final isar = await db;
    await isar.write((isar) {
      isar.clear();
    });
  }
}
