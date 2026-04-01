import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

// Vehicles table
@DataClassName('Vehicle')
class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get plateNumber => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get year => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get vin => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  IntColumn get odometer => integer().nullable()();
  TextColumn get fuelType => text().nullable()();
  TextColumn get transmissionType => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Service records table
@DataClassName('ServiceRecord')
class ServiceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get serviceType => text()();
  DateTimeColumn get serviceDate => dateTime()();
  TextColumn get description => text().nullable()();
  RealColumn get cost => real().nullable()();
  TextColumn get mechanic => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Database class
@DriftDatabase(tables: [Vehicles, ServiceRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Migration from version 1 to 2: Add isPrimary column
        if (from == 1 && to >= 2) {
          await customStatement(
            'ALTER TABLE vehicles ADD COLUMN isPrimary INTEGER NOT NULL DEFAULT 0',
          );
        }
        // Migration from version 2 to 3: Ensure isPrimary column exists
        if (from == 2 && to >= 3) {
          // Check if isPrimary column exists, if not add it
          try {
            await customStatement(
              'ALTER TABLE vehicles ADD COLUMN isPrimary INTEGER NOT NULL DEFAULT 0',
            );
          } catch (e) {
            // Column already exists, ignore the error
            if (!e.toString().contains('duplicate column name')) {
              rethrow;
            }
          }
        }
      },
    );
  }

  // Vehicle operations
  Future<int> addVehicle(VehiclesCompanion vehicle) {
    return into(vehicles).insert(vehicle);
  }

  Future<bool> updateVehicle(Vehicle vehicle) {
    return update(
      vehicles,
    ).replace(vehicle.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> markAsPrimary(int vehicleId) async {
    print('DEBUG: markAsPrimary called with vehicleId: $vehicleId');
    // First, set all vehicles' isPrimary to false
    await (update(vehicles)..where(
      (tbl) => tbl.id.isBiggerThanValue(0),
    )).write(const VehiclesCompanion(isPrimary: Value(false)));
    print('DEBUG: Set all vehicles isPrimary to false');
    // Then, set the selected vehicle's isPrimary to true
    await (update(vehicles)..where(
      (tbl) => tbl.id.equals(vehicleId),
    )).write(const VehiclesCompanion(isPrimary: Value(true)));
    print('DEBUG: Set vehicle $vehicleId isPrimary to true');
  }

  Future<void> togglePrimary(int vehicleId) async {
    print('DEBUG: togglePrimary called with vehicleId: $vehicleId');
    // Get the current vehicle to check if it's primary
    final vehicle = await getVehicle(vehicleId);
    if (vehicle == null) {
      print('DEBUG: Vehicle not found');
      return;
    }

    if (vehicle.isPrimary == true) {
      // If currently primary, set all vehicles' isPrimary to false
      await (update(vehicles)..where(
        (tbl) => tbl.id.isBiggerThanValue(0),
      )).write(const VehiclesCompanion(isPrimary: Value(false)));
      print('DEBUG: Set all vehicles isPrimary to false (toggled off)');
    } else {
      // If not primary, set this vehicle as primary
      await markAsPrimary(vehicleId);
      print('DEBUG: Set vehicle $vehicleId isPrimary to true (toggled on)');
    }
  }

  Future<int> deleteVehicle(int id) {
    return (delete(vehicles)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Vehicle?> getVehicle(int id) {
    return (select(vehicles)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Vehicle>> getAllVehicles() {
    return (select(vehicles)..orderBy([
      (tbl) => OrderingTerm.desc(tbl.isPrimary), // Primary vehicles first
      (tbl) => OrderingTerm.desc(tbl.createdAt), // Then by creation date
    ])).get();
  }

  Future<List<Vehicle>> searchVehicles(String query) {
    final lowerQuery = query.toLowerCase();
    return (select(vehicles)..where(
      (tbl) =>
          tbl.name.lower().contains(lowerQuery) |
          tbl.plateNumber.lower().contains(lowerQuery),
    )).get();
  }

  Future<List<Vehicle>> filterVehiclesByType(String type) {
    return (select(vehicles)
          ..where((tbl) => tbl.type.equals(type))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  // Service record operations
  Future<int> addServiceRecord(ServiceRecordsCompanion record) {
    return into(serviceRecords).insert(record);
  }

  Future<bool> updateServiceRecord(ServiceRecord record) {
    return update(
      serviceRecords,
    ).replace(record.copyWith(updatedAt: DateTime.now()));
  }

  Future<int> deleteServiceRecord(int id) {
    return (delete(serviceRecords)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<ServiceRecord?> getServiceRecord(int id) {
    return (select(serviceRecords)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<ServiceRecord>> getServiceRecordsByVehicle(int vehicleId) {
    return (select(serviceRecords)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.serviceDate)]))
        .get();
  }

  Future<List<ServiceRecord>> getAllServiceRecords() {
    return (select(serviceRecords)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.serviceDate)])).get();
  }

  // Statistics
  Future<double> getTotalCostByVehicle(int vehicleId) async {
    final query = select(serviceRecords)
      ..where((tbl) => tbl.vehicleId.equals(vehicleId));

    final results = await query.get();
    double total = 0.0;
    for (final row in results) {
      total += row.cost ?? 0.0;
    }
    return total;
  }

  Future<double> getTotalCostAllVehicles() async {
    final query = select(serviceRecords);

    final results = await query.get();
    double total = 0.0;
    for (final row in results) {
      total += row.cost ?? 0.0;
    }
    return total;
  }

  Future<int> getServiceCountByVehicle(int vehicleId) async {
    final result =
        await (selectOnly(serviceRecords)
              ..addColumns([serviceRecords.id.count()])
              ..where(serviceRecords.vehicleId.equals(vehicleId)))
            .getSingle();
    return result.read(serviceRecords.id.count()) ?? 0;
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    await delete(serviceRecords).go();
    await delete(vehicles).go();
  }
}

// Database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'otolog.db'));

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        // Enable foreign keys
        database.execute('PRAGMA foreign_keys = ON');
      },
    );
  });
}

// Singleton database instance
final AppDatabase database = AppDatabase(_openConnection());
