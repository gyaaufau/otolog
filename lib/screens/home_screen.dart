import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../resources/colors.dart';
import '../router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      body: SafeArea(
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              );
            }

            if (state is VehicleError) {
              return _buildErrorState(state.message);
            }

            if (state is VehicleLoaded) {
              return _buildContent(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.neutral[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<VehicleCubit>().loadHomeData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(VehicleLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VehicleCubit>().loadHomeData();
      },
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(child: _buildHeader(state)),

          // Statistics Section
          SliverToBoxAdapter(child: _buildStatistics(state)),

          // Quick Actions
          SliverToBoxAdapter(child: _buildQuickActions(state)),

          // Vehicles Section
          SliverToBoxAdapter(child: _buildVehiclesSection(state)),

          // Recent Services Section
          SliverToBoxAdapter(child: _buildRecentServices(state)),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader(VehicleLoaded state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      color: AppColors.neutral[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutral[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your Garage',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral[900],
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${state.vehicles.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Track your vehicle maintenance and service history',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutral[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(VehicleLoaded state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total Vehicles',
              '${state.vehicles.length}',
              Icons.directions_car_outlined,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: _buildStatItem(
              'Services',
              '${state.serviceCount ?? 0}',
              Icons.build_outlined,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: _buildStatItem(
              'Total Cost',
              '\$${(state.totalCost ?? 0).toStringAsFixed(0)}',
              Icons.payments_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white.withOpacity(0.9)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(VehicleLoaded state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Add Vehicle',
                    Icons.add_circle_outline,
                    AppColors.primary,
                    () => context.push(AppRoutes.addVehicle),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Add Service',
                    Icons.construction,
                    AppColors.tertiary,
                    () => context.push(AppRoutes.addService),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclesSection(VehicleLoaded state) {
    if (state.vehicles.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.neutral[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary[500]!.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 32,
                color: AppColors.secondary[500],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No Vehicles Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first vehicle to start tracking maintenance',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.neutral[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.addVehicle),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Add Vehicle'),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Vehicles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral[900],
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.vehicles),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...state.vehicles
              .take(3)
              .map((vehicle) => _buildVehicleCard(vehicle)),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(dynamic vehicle) {
    return GestureDetector(
      onTap:
          () => context.push(
            AppRoutes.vehicleDetail.replaceFirst(
              ':vehicleId',
              vehicle.id.toString(),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.neutral[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.directions_car,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.brand ?? ''} ${vehicle.model ?? ''}'.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 12,
                        color: AppColors.neutral[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vehicle.plateNumber,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.neutral[500],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.neutral[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentServices(VehicleLoaded state) {
    final recentServices = state.serviceRecords ?? [];

    if (recentServices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          ...recentServices
              .take(3)
              .map((service) => _buildServiceCard(service, state.vehicles)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(dynamic service, List<dynamic> vehicles) {
    final vehicle = vehicles.firstWhere(
      (v) => v.id == service.vehicleId,
      orElse: () => null,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary[500]!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.build_outlined,
              size: 24,
              color: AppColors.secondary[500],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.serviceType,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[900],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 11,
                      color: AppColors.neutral[400],
                    ),
                    const SizedBox(width: 3),
                    Text(
                      vehicle?.name ?? 'Unknown Vehicle',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.neutral[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${service.cost?.toStringAsFixed(0) ?? '0'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(service.serviceDate),
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.neutral[500],
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
