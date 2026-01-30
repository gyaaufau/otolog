import 'package:isar_plus/isar_plus.dart';

part 'vehicle.g.dart';

@collection
class Vehicle {
  late int id;
  late String name;
  late String plateNumber;
  String? brand;
  String? model;
  String? year;
  String? color;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Vehicle({
    required this.name,
    required this.plateNumber,
    this.brand,
    this.model,
    this.year,
    this.color,
  });

  @override
  String toString() {
    return 'Vehicle{id: $id, name: $name, plateNumber: $plateNumber, brand: $brand, model: $model, year: $year, color: $color}';
  }
}
