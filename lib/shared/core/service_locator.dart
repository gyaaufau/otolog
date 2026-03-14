import 'package:get_it/get_it.dart';
import '../../repositories/isar_service.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/analytics_cubit.dart';

final getIt = GetIt.instance;

/// Initialize the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Initialize and register IsarService as a singleton
  // We initialize it synchronously to ensure it's ready before use
  final isarService = IsarService();
  await isarService.db; // Ensure database is initialized
  getIt.registerSingleton<IsarService>(isarService);

  // Register cubits
  getIt.registerFactory<VehicleCubit>(() => VehicleCubit(getIt<IsarService>()));
  getIt.registerFactory<AnalyticsCubit>(
    () => AnalyticsCubit(getIt<IsarService>()),
  );
}

/// Reset the service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
