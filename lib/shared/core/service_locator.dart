import 'package:get_it/get_it.dart';
import '../../repositories/drift_service.dart';
import '../../repositories/language_repository.dart';
import '../../database/database.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/service_vehicle_selector_cubit.dart';
import '../../cubit/language_cubit.dart';

final sl = GetIt.instance;

/// Initialize the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Register database as a singleton
  sl.registerSingleton<AppDatabase>(database);

  // Register DriftService as a singleton
  sl.registerSingleton<DriftService>(DriftService(database));

  // Register LanguageRepository as a singleton
  sl.registerSingleton<LanguageRepository>(LanguageRepository());

  // Register cubits
  sl.registerFactory<VehicleCubit>(() => VehicleCubit(sl<DriftService>()));
  sl.registerFactory<ServiceVehicleSelectorCubit>(
    () => ServiceVehicleSelectorCubit(sl<DriftService>()),
  );
  sl.registerFactory<LanguageCubit>(
    () => LanguageCubit(sl<LanguageRepository>()),
  );
}

/// Reset the service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await sl.reset();
}
