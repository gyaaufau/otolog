import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import '../constants/theme.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadVehicles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OtoLog'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vehicles...',
                hintStyle: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.secondaryText,
                  size: 20.sp,
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              style: TextStyle(color: AppColors.primaryText, fontSize: 14.sp),
              onChanged: (value) {
                context.read<VehicleCubit>().searchVehicles(value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<VehicleCubit, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VehicleLoaded) {
                  if (state.vehicles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: 64.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No vehicles yet',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap + to add your first vehicle',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = state.vehicles[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          leading: Container(
                            width: 48.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                vehicle.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            vehicle.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: AppColors.primaryText,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              vehicle.plateNumber,
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.secondaryText,
                            size: 20.sp,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => VehicleDetailScreen(
                                      vehicleId: vehicle.id,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is VehicleError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: AppColors.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        OutlinedButton(
                          onPressed: () {
                            context.read<VehicleCubit>().loadVehicles();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: BorderSide(color: AppColors.accent),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
          );
        },
        child: Icon(Icons.add, color: AppColors.background, size: 24.sp),
      ),
    );
  }
}
