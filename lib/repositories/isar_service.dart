import 'package:isar/isar.dart';
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

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [VehicleSchema, ServiceRecordSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  // Vehicle Operations
  Future<int> addVehicle(Vehicle vehicle) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      vehicle.createdAt = DateTime.now();
      vehicle.updatedAt = DateTime.now();
      return await isar.vehicles.put(vehicle);
    });
  }

  Future<int> updateVehicle(Vehicle vehicle) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      vehicle.updatedAt = DateTime.now();
      return await isar.vehicles.put(vehicle);
    });
  }

  Future<bool> deleteVehicle(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      // Delete all service records for this vehicle first
      await isar.serviceRecords.filter().vehicleIdEqualTo(id).deleteAll();
      return await isar.vehicles.delete(id);
    });
  }

  Future<Vehicle?> getVehicle(int id) async {
    final isar = await db;
    return await isar.vehicles.get(id);
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final isar = await db;
    return await isar.vehicles.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    final isar = await db;
    return await isar.vehicles
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .plateNumberContains(query, caseSensitive: false)
        .findAll();
  }

  // Service Record Operations
  Future<int> addServiceRecord(ServiceRecord record) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      record.createdAt = DateTime.now();
      record.updatedAt = DateTime.now();
      return await isar.serviceRecords.put(record);
    });
  }

  Future<int> updateServiceRecord(ServiceRecord record) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      record.updatedAt = DateTime.now();
      return await isar.serviceRecords.put(record);
    });
  }

  Future<bool> deleteServiceRecord(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      return await isar.serviceRecords.delete(id);
    });
  }

  Future<ServiceRecord?> getServiceRecord(int id) async {
    final isar = await db;
    return await isar.serviceRecords.get(id);
  }

  Future<List<ServiceRecord>> getServiceRecordsByVehicle(int vehicleId) async {
    final isar = await db;
    return await isar.serviceRecords
        .filter()
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
        await isar.serviceRecords
            .filter()
            .vehicleIdEqualTo(vehicleId)
            .findAll();

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
        .filter()
        .vehicleIdEqualTo(vehicleId)
        .count();
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
