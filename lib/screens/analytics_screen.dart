import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 64.sp, color: AppColors.secondaryText),
          SizedBox(height: 16.h),
          Text('Analytics', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 8.h),
          Text('Coming soon...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
