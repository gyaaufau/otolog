import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import 'screens/garage/vehicle_detail_screen.dart';
import 'screens/logs/service_detail_screen.dart';
import 'screens/garage/add_vehicle_screen.dart';
import 'screens/garage/edit_vehicle_screen.dart';
import 'screens/logs/add_service_screen.dart';
import 'screens/logs/edit_service_screen.dart';
import 'screens/logs/service_logs_screen.dart';
import 'screens/garage/vehicles_screen.dart';
import 'screens/garage/service_statistics_detail_screen.dart';
import 'screens/settings/settings_screen.dart';
import '../widgets/main_shell.dart';
import '../screens/database_viewer_screen.dart';

/// Route names for type-safe navigation
class AppRoutes {
  static const String home = '/';
  static const String vehicles = '/vehicles';
  static const String vehicleDetail = '/vehicle/:vehicleId';
  static const String serviceDetail = '/vehicle/:vehicleId/service/:serviceId';
  static const String addVehicle = '/add-vehicle';
  static const String editVehicle = '/vehicle/:vehicleId/edit';
  static const String addService = '/vehicle/:vehicleId/add-service';
  static const String addServiceGeneral = '/add-service';
  static const String editService =
      '/vehicle/:vehicleId/service/:serviceId/edit';
  static const String serviceLogs = '/service-logs';
  static const String settings = '/settings';
  static const String databaseViewer = '/database-viewer';
  static const String serviceStatisticsDetail =
      '/vehicle/:vehicleId/service-statistics';
}

/// GoRouter configuration for the app
final goRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              MainShell(navigationShell: navigationShell),
      branches: [
        // Home branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        // Vehicles branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.vehicles,
              name: 'vehicles',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: VehiclesScreen()),
            ),
          ],
        ),
        // Service Logs branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.serviceLogs,
              name: 'serviceLogs',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: ServiceLogsScreen()),
            ),
          ],
        ),
        // Settings branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
    // Detail screens (accessible from anywhere)
    GoRoute(
      path: AppRoutes.vehicleDetail,
      name: 'vehicleDetail',
      builder: (context, state) => const VehicleDetailScreen(),
      routes: [
        GoRoute(
          path: 'edit',
          name: 'editVehicle',
          builder: (context, state) => const EditVehicleScreen(),
        ),
        GoRoute(
          path: 'add-service',
          name: 'addService',
          builder: (context, state) => const AddServiceScreen(),
        ),
        GoRoute(
          path: 'service/:serviceId',
          name: 'serviceDetail',
          builder: (context, state) => const ServiceDetailScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              name: 'editService',
              builder: (context, state) => const EditServiceScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'service-statistics',
          name: 'serviceStatisticsDetail',
          builder: (context, state) => const ServiceStatisticsDetailScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.addVehicle,
      name: 'addVehicle',
      builder: (context, state) => const AddVehicleScreen(),
    ),
    GoRoute(
      path: AppRoutes.addServiceGeneral,
      name: 'addServiceGeneral',
      builder: (context, state) => const AddServiceScreen(),
    ),
    GoRoute(
      path: AppRoutes.databaseViewer,
      name: 'databaseViewer',
      builder: (context, state) => const DatabaseViewerScreen(),
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The requested page does not exist.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
);
