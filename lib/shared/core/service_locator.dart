import 'package:get_it/get_it.dart';
import '../../repositories/drift_service.dart';
import '../../database/database.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/analytics_cubit.dart';

final sl = GetIt.instance;

/// Initialize the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Register database as a singleton
  sl.registerSingleton<AppDatabase>(database);

  // Register DriftService as a singleton
  sl.registerSingleton<DriftService>(DriftService(database));

  // Register cubits
  sl.registerFactory<VehicleCubit>(() => VehicleCubit(sl<DriftService>()));
  sl.registerFactory<AnalyticsCubit>(() => AnalyticsCubit(sl<DriftService>()));
}

/// Reset the service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await sl.reset();
}
