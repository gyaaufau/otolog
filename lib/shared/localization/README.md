# Localization Quick Reference

## Quick Start

### 1. Import the helper

```dart
import 'package:otolog/shared/localization/l10n_helper.dart';
```

### 2. Use in your widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.home); // Recommended way
  }
}
```

## Common Usage Patterns

### Button Labels

```dart
ElevatedButton(
  onPressed: () {},
  child: Text(context.l10n.save),
)
```

### Form Fields

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: context.l10n.vehicleName,
  ),
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return context.l10n.requiredField;
    }
    return null;
  },
)
```

### Dialogs

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(context.l10n.deleteConfirmation),
    content: Text(context.l10n.deleteVehicleMessage),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      TextButton(
        onPressed: () {
          // Handle action
          Navigator.pop(context);
        },
        child: Text(context.l10n.confirm),
      ),
    ],
  ),
);
```

### App Bar

```dart
AppBar(
  title: Text(context.l10n.vehicles),
  actions: [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {},
      tooltip: context.l10n.addVehicle,
    ),
  ],
)
```

### Snackbars

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(context.l10n.vehicleAdded)),
);
```

## Available Translation Keys

### Navigation

- `home` - Home
- `garage` - Garage
- `serviceLogs` - Service Logs
- `settings` - Settings

### Common Actions

- `add` - Add
- `edit` - Edit
- `delete` - Delete
- `save` - Save
- `cancel` - Cancel
- `confirm` - Confirm

### Vehicle Related

- `vehicles` - Vehicles
- `addVehicle` - Add Vehicle
- `editVehicle` - Edit Vehicle
- `vehicleDetails` - Vehicle Details
- `vehicleName` - Vehicle Name
- `vehicleType` - Vehicle Type
- `make` - Make
- `model` - Model
- `year` - Year
- `licensePlate` - License Plate
- `vin` - VIN
- `odometer` - Odometer
- `color` - Color
- `purchaseDate` - Purchase Date
- `purchasePrice` - Purchase Price
- `currentValue` - Current Value
- `notes` - Notes

### Service Related

- `service` - Service
- `addService` - Add Service
- `editService` - Edit Service
- `serviceDetails` - Service Details
- `serviceDate` - Service Date
- `serviceType` - Service Type
- `serviceProvider` - Service Provider
- `cost` - Cost
- `odometerReading` - Odometer Reading
- `description` - Description
- `nextServiceDate` - Next Service Date
- `nextServiceOdometer` - Next Service Odometer

### Service Types

- `oilChange` - Oil Change
- `tireRotation` - Tire Rotation
- `brakeService` - Brake Service
- `inspection` - Inspection
- `maintenance` - Maintenance
- `repair` - Repair
- `other` - Other

### Vehicle Types

- `car` - Car
- `motorcycle` - Motorcycle
- `truck` - Truck
- `suv` - SUV
- `van` - Van

### Validation

- `required` - Required
- `optional` - Optional
- `requiredField` - This field is required
- `invalidFormat` - Invalid format

### Messages

- `success` - Success
- `vehicleAdded` - Vehicle added successfully
- `vehicleUpdated` - Vehicle updated successfully
- `vehicleDeleted` - Vehicle deleted successfully
- `serviceAdded` - Service record added successfully
- `serviceUpdated` - Service record updated successfully
- `serviceDeleted` - Service record deleted successfully
- `error` - Error
- `somethingWentWrong` - Something went wrong. Please try again.

### Search

- `search` - Search
- `searchVehicles` - Search vehicles...
- `searchServices` - Search services...

### Confirmation

- `deleteConfirmation` - Delete Confirmation
- `deleteVehicleMessage` - Are you sure you want to delete this vehicle?
- `deleteServiceMessage` - Are you sure you want to delete this service record?

### Empty States

- `noVehicles` - No vehicles added yet
- `addFirstVehicle` - Add your first vehicle to get started
- `noServices` - No service records yet
- `addFirstService` - Add your first service record

### Statistics

- `totalVehicles` - Total Vehicles
- `totalServices` - Total Services
- `totalSpent` - Total Spent

### Sections

- `recentServices` - Recent Services
- `upcomingServices` - Upcoming Services

### Settings

- `language` - Language
- `theme` - Theme
- `about` - About
- `darkMode` - Dark Mode
- `lightMode` - Light Mode
- `systemMode` - System Mode

### Location

- `location` - Location
- `selectLocation` - Select Location
- `useCurrentLocation` - Use Current Location

### Photo

- `photo` - Photo
- `addPhoto` - Add Photo
- `changePhoto` - Change Photo
- `removePhoto` - Remove Photo
- `takePhoto` - Take Photo
- `chooseFromGallery` - Choose from Gallery

### Units

- `km` - km
- `miles` - miles

### Common

- `yes` - Yes
- `no` - No
- `close` - Close
- `done` - Done
- `back` - Back
- `next` - Next
- `or` - or
- `and` - and
- `today` - Today
- `yesterday` - Yesterday
- `tomorrow` - Tomorrow

## Adding New Languages

See [LOCALIZATION.md](../../../../LOCALIZATION.md) for detailed instructions on adding new languages.

## Examples

For complete working examples, see [l10n_example.dart](l10n_example.dart).
