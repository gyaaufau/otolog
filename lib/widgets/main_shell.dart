import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../constants/theme.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern is to use the current location to determine whether
      // to navigate to the initial location of the branch or not.
      initialLocation: navigationShell.currentIndex == index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                  isActive: navigationShell.currentIndex == 0,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.directions_car_outlined,
                  activeIcon: Icons.directions_car,
                  label: 'Vehicles',
                  route: AppRoutes.vehicles,
                  isActive: location == AppRoutes.vehicles,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  label: 'Analytics',
                  index: 1,
                  isActive: navigationShell.currentIndex == 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _goBranch(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppColors.accent : AppColors.secondaryText,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.accent : AppColors.secondaryText,
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
