import 'package:get_it/get_it.dart';
import '../../repositories/isar_service.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/analytics_cubit.dart';

final sl = GetIt.instance;

/// Initialize the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Initialize and register IsarService as a singleton
  // We initialize it synchronously to ensure it's ready before use
  final isarService = IsarService();
  await isarService.db; // Ensure database is initialized
  sl.registerSingleton<IsarService>(isarService);

  // Register cubits
  sl.registerFactory<VehicleCubit>(() => VehicleCubit(sl<IsarService>()));
  sl.registerFactory<AnalyticsCubit>(() => AnalyticsCubit(sl<IsarService>()));
}

/// Reset the service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await sl.reset();
}
