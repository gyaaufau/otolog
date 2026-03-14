import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../resources/theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          } else if (state is AnalyticsLoaded) {
            return _buildAnalyticsContent(context, state);
          } else if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(color: AppColors.error, fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed:
                        () => context.read<AnalyticsCubit>().loadAnalytics(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAnalyticsContent(BuildContext context, AnalyticsLoaded state) {
    final cubit = context.read<AnalyticsCubit>();
    final mostExpensiveService = cubit.getMostExpensiveService(
      state.allServiceRecords,
    );
    final mostCommonServiceType = cubit.getMostCommonServiceType(
      state.serviceTypeDistribution,
    );
    final averageCostPerService = cubit.getAverageCostPerService(
      state.totalCostAllVehicles,
      state.totalServiceCount,
    );

    return RefreshIndicator(
      onRefresh: () => context.read<AnalyticsCubit>().loadAnalytics(),
      color: AppColors.accent,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Cost',
                    '\$${state.totalCostAllVehicles.toStringAsFixed(2)}',
                    Icons.attach_money,
                    AppColors.accent,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Services',
                    '${state.totalServiceCount}',
                    Icons.build,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Avg Cost',
                    '\$${averageCostPerService.toStringAsFixed(2)}',
                    Icons.trending_up,
                    AppColors.warning,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildSummaryCard(
                    'Vehicles',
                    '${state.vehicles.length}',
                    Icons.directions_car,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Monthly Spending Chart
            _buildSectionTitle('Monthly Spending'),
            SizedBox(height: 12.h),
            _buildMonthlySpendingChart(state.monthlySpending),
            SizedBox(height: 24.h),

            // Service Type Distribution
            _buildSectionTitle('Service Types'),
            SizedBox(height: 12.h),
            _buildServiceTypeDistribution(state.serviceTypeDistribution),
            SizedBox(height: 24.h),

            // Cost Per Vehicle
            _buildSectionTitle('Cost Per Vehicle'),
            SizedBox(height: 12.h),
            _buildCostPerVehicleChart(state.vehicles, state.costPerVehicle),
            SizedBox(height: 24.h),

            // Insights
            _buildSectionTitle('Insights'),
            SizedBox(height: 12.h),
            _buildInsightsCard(mostExpensiveService, mostCommonServiceType),
            SizedBox(height: 24.h),

            // Recent Services
            _buildSectionTitle('Recent Services'),
            SizedBox(height: 12.h),
            _buildRecentServicesList(state.recentServices),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18.sp),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.primaryText,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMonthlySpendingChart(Map<String, double> monthlySpending) {
    if (monthlySpending.isEmpty) {
      return _buildEmptyState('No spending data available');
    }

    final maxValue = monthlySpending.values.reduce((a, b) => a > b ? a : b);
    final months = monthlySpending.keys.toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  months.map((month) {
                    final value = monthlySpending[month] ?? 0;
                    final barHeight =
                        maxValue > 0 ? (value / maxValue) * 140.h : 0.0;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 28.w,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '\$${value.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          month,
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeDistribution(Map<String, int> distribution) {
    if (distribution.isEmpty) {
      return _buildEmptyState('No service type data available');
    }

    final totalServices = distribution.values.reduce((a, b) => a + b);
    final colors = [
      AppColors.accent,
      AppColors.success,
      AppColors.warning,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Simple pie chart representation
          SizedBox(
            height: 140.h,
            width: 140.h,
            child: CustomPaint(
              painter: PieChartPainter(
                distribution: distribution,
                colors: colors,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Simple legend
          ...distribution.entries.map((entry) {
            final index = distribution.keys.toList().indexOf(entry.key);
            final percentage = (entry.value / totalServices * 100)
                .toStringAsFixed(1);
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      '${entry.key} ($percentage%)',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 11.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCostPerVehicleChart(
    List<dynamic> vehicles,
    Map<int, double> costPerVehicle,
  ) {
    if (vehicles.isEmpty) {
      return _buildEmptyState('No vehicle data available');
    }

    final maxValue = costPerVehicle.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ...vehicles.map((vehicle) {
            final cost = costPerVehicle[vehicle.id] ?? 0;
            final barWidth = maxValue > 0 ? (cost / maxValue) * 0.8 : 0.0;
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 13.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '\$${cost.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: barWidth,
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(
    dynamic mostExpensiveService,
    String? mostCommonServiceType,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mostExpensiveService != null) ...[
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.warning, size: 18.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    'Most Expensive: ${mostExpensiveService.serviceType} - \$${mostExpensiveService.cost?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 13.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
          if (mostCommonServiceType != null) ...[
            Row(
              children: [
                Icon(Icons.repeat, color: AppColors.success, size: 18.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    'Most Common: $mostCommonServiceType',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 13.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentServicesList(List<dynamic> recentServices) {
    if (recentServices.isEmpty) {
      return _buildEmptyState('No recent services');
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentServices.length,
        separatorBuilder:
            (context, index) => Divider(color: AppColors.border, height: 1.h),
        itemBuilder: (context, index) {
          final service = recentServices[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 6.h,
            ),
            title: Text(
              service.serviceType,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              DateFormat('MMM dd, yyyy').format(service.serviceDate),
              style: TextStyle(color: AppColors.secondaryText, fontSize: 11.sp),
            ),
            trailing: Text(
              '\$${service.cost?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox, size: 40.sp, color: AppColors.secondaryText),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyle(color: AppColors.secondaryText, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, int> distribution;
  final List<Color> colors;

  PieChartPainter({required this.distribution, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (distribution.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final total = distribution.values.reduce((a, b) => a + b);

    if (total == 0) return;

    double startAngle = -math.pi / 2;

    distribution.entries.forEach((entry) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;
      final paint =
          Paint()
            ..color =
                colors[distribution.keys.toList().indexOf(entry.key) %
                    colors.length]
            ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
