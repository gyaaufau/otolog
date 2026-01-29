import 'package:isar/isar.dart';

part 'service_record.g.dart';

@collection
class ServiceRecord {
  Id id = Isar.autoIncrement;

  late int vehicleId;
  late String serviceType;
  late DateTime serviceDate;
  String? description;
  double? cost;
  String? mechanic;
  String? notes;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  ServiceRecord({
    required this.vehicleId,
    required this.serviceType,
    required this.serviceDate,
    this.description,
    this.cost,
    this.mechanic,
    this.notes,
  });

  @override
  String toString() {
    return 'ServiceRecord{id: $id, vehicleId: $vehicleId, serviceType: $serviceType, serviceDate: $serviceDate, cost: $cost}';
  }
}
