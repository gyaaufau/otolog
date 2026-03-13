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
  String? type;
  String? vin;
  DateTime? purchaseDate;
  int? odometer;
  String? fuelType;
  String? transmissionType;
  String? imagePath;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Vehicle({
    required this.name,
    required this.plateNumber,
    this.brand,
    this.model,
    this.year,
    this.color,
    this.type,
    this.vin,
    this.purchaseDate,
    this.odometer,
    this.fuelType,
    this.transmissionType,
    this.imagePath,
  });

  @override
  String toString() {
    return 'Vehicle{id: $id, name: $name, plateNumber: $plateNumber, brand: $brand, model: $model, year: $year, color: $color, type: $type, vin: $vin, purchaseDate: $purchaseDate, odometer: $odometer, fuelType: $fuelType, transmissionType: $transmissionType, imagePath: $imagePath}';
  }
}
