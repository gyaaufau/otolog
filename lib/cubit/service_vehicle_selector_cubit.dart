import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/database.dart';
import '../repositories/drift_service.dart';
import 'service_vehicle_selector_state.dart';

class ServiceVehicleSelectorCubit extends Cubit<ServiceVehicleSelectorState> {
  final DriftService _driftService;

  ServiceVehicleSelectorCubit(this._driftService)
    : super(const ServiceVehicleSelectorInitial()) {
    print('🚗 [ServiceVehicleSelectorCubit] Initialized');
  }

  // Load vehicles for selection
  Future<void> loadVehicles() async {
    print('🚗 [ServiceVehicleSelectorCubit] loadVehicles() called');

    // Preserve the current selectedVehicleId if it exists
    final currentSelectedVehicleId =
        state is ServiceVehicleSelectorLoaded
            ? (state as ServiceVehicleSelectorLoaded).selectedVehicleId
            : null;
    print(
      '🚗 [ServiceVehicleSelectorCubit] Preserving current selectedVehicleId: $currentSelectedVehicleId',
    );

    emit(const ServiceVehicleSelectorLoading());
    print('🚗 [ServiceVehicleSelectorCubit] State changed to Loading');

    try {
      print(
        '🚗 [ServiceVehicleSelectorCubit] Fetching vehicles from database...',
      );
      final vehicles = await _driftService.getAllVehicles();
      print(
        '🚗 [ServiceVehicleSelectorCubit] Successfully loaded ${vehicles.length} vehicles',
      );
      for (var i = 0; i < vehicles.length; i++) {
        final v = vehicles[i];
        print(
          '  🚗 [ServiceVehicleSelectorCubit]   Vehicle $i: id=${v.id}, name="${v.name}", brand="${v.brand ?? 'N/A'}", model="${v.model ?? 'N/A'}"',
        );
      }

      // Emit state with preserved selectedVehicleId
      emit(
        ServiceVehicleSelectorLoaded(
          vehicles: vehicles,
          selectedVehicleId: currentSelectedVehicleId,
        ),
      );
      print(
        '🚗 [ServiceVehicleSelectorCubit] State changed to Loaded with ${vehicles.length} vehicles and selectedVehicleId=$currentSelectedVehicleId',
      );
    } catch (e, stackTrace) {
      print('🚗 [ServiceVehicleSelectorCubit] ❌ Error loading vehicles: $e');
      print('🚗 [ServiceVehicleSelectorCubit] Stack trace: $stackTrace');
      emit(
        ServiceVehicleSelectorError('Failed to load vehicles: ${e.toString()}'),
      );
      print('🚗 [ServiceVehicleSelectorCubit] State changed to Error');
    }
  }

  // Select a vehicle
  void selectVehicle(int? vehicleId) {
    print('🚗 [ServiceVehicleSelectorCubit] selectVehicle($vehicleId) called');
    print(
      '🚗 [ServiceVehicleSelectorCubit] Current state type: ${state.runtimeType}',
    );

    final currentState = state;
    if (currentState is! ServiceVehicleSelectorLoaded) {
      print(
        '🚗 [ServiceVehicleSelectorCubit] ❌ Cannot select vehicle - state is not Loaded (type: ${state.runtimeType})',
      );
      return;
    }

    print(
      '🚗 [ServiceVehicleSelectorCubit] Current selectedVehicleId in state: ${currentState.selectedVehicleId}',
    );
    print('🚗 [ServiceVehicleSelectorCubit] New selectedVehicleId: $vehicleId');

    if (vehicleId != null) {
      final selectedVehicle = currentState.vehicles.firstWhere(
        (v) => v.id == vehicleId,
        orElse: () {
          print(
            '🚗 [ServiceVehicleSelectorCubit] ⚠️ Vehicle with id=$vehicleId not found in vehicles list!',
          );
          return currentState.vehicles.first;
        },
      );
      print(
        '🚗 [ServiceVehicleSelectorCubit] Selected vehicle: id=${selectedVehicle.id}, name="${selectedVehicle.name}"',
      );
    }

    emit(currentState.copyWith(selectedVehicleId: vehicleId));
    print(
      '🚗 [ServiceVehicleSelectorCubit] State updated with new selectedVehicleId: $vehicleId',
    );
  }
}
