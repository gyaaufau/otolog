import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/vehicle_detail_screen.dart';
import 'screens/add_vehicle_screen.dart';
import 'screens/add_service_screen.dart';
import 'screens/analytics_screen.dart';
import 'widgets/main_shell.dart';

/// Route names for type-safe navigation
class AppRoutes {
  static const String home = '/';
  static const String vehicleDetail = '/vehicle/:vehicleId';
  static const String addVehicle = '/add-vehicle';
  static const String addService = '/vehicle/:vehicleId/add-service';
  static const String analytics = '/analytics';
}

/// GoRouter configuration for the app
final goRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: AppRoutes.analytics,
          name: 'analytics',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: AnalyticsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.vehicleDetail,
      name: 'vehicleDetail',
      builder: (context, state) {
        final vehicleId = int.parse(state.pathParameters['vehicleId']!);
        return VehicleDetailScreen(vehicleId: vehicleId);
      },
    ),
    GoRoute(
      path: AppRoutes.addVehicle,
      name: 'addVehicle',
      builder: (context, state) => const AddVehicleScreen(),
    ),
    GoRoute(
      path: AppRoutes.addService,
      name: 'addService',
      builder: (context, state) {
        final vehicleId = int.parse(state.pathParameters['vehicleId']!);
        return AddServiceScreen(vehicleId: vehicleId);
      },
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
