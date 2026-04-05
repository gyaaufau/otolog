import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otolog/cubit/currency_cubit.dart';
import 'package:otolog/cubit/vehicle_detail_cubit.dart';
import 'package:otolog/cubit/vehicle_detail_state.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/resources/colors.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

class ServiceStatisticsDetailScreen extends StatefulWidget {
  const ServiceStatisticsDetailScreen({super.key});

  @override
  State<ServiceStatisticsDetailScreen> createState() =>
      _ServiceStatisticsDetailScreenState();
}

class _ServiceStatisticsDetailScreenState
    extends State<ServiceStatisticsDetailScreen> {
  int? _vehicleId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_vehicleId == null) {
      final vehicleId = int.tryParse(
        GoRouterState.of(context).pathParameters['vehicleId'] ?? '',
      );
      if (vehicleId != null) {
        setState(() {
          _vehicleId = vehicleId;
        });
        context.read<VehicleDetailCubit>().loadVehicleWithServices(vehicleId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      appBar: AppBar(
        backgroundColor: AppColors.neutral[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.neutral[900],
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.l10n.serviceStatisticsDetail,
          style: TextStyle(
            color: AppColors.neutral[900],
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
        builder: (context, state) {
          if (state is VehicleDetailLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2,
              ),
            );
          }
          if (state is VehicleDetailError) {
            return _buildErrorState(state.message);
          }

          if (state is VehicleDetailLoaded) {
            if (state.serviceRecords.isEmpty) {
              return _buildEmptyState();
            }
            return _buildStatisticsContent(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatisticsContent(VehicleDetailLoaded state) {
    final currencySymbol = context.watch<CurrencyCubit>().currentCurrencySymbol;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(state, currencySymbol),
          SizedBox(height: 24.h),
          _buildMonthlySpendingChart(state, currencySymbol),
          SizedBox(height: 24.h),
          _buildServiceTypeDistributionChart(state),
          SizedBox(height: 24.h),
          _buildCostTrendChart(state, currencySymbol),
          SizedBox(height: 24.h),
          _buildServiceFrequencyChart(state),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(VehicleDetailLoaded state, String currencySymbol) {
    return Column(
      children: [
        _buildSummaryCard(
          context.l10n.totalServicesLabel,
          state.serviceCount.toString(),
          Icons.build_outlined,
          AppColors.primary,
        ),
        SizedBox(height: 12.h),
        _buildSummaryCard(
          context.l10n.totalCostLabel,
          '$currencySymbol${state.totalCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
          Icons.payments_outlined,
          AppColors.tertiary,
        ),
        SizedBox(height: 12.h),
        _buildSummaryCard(
          context.l10n.averageCostLabel,
          '$currencySymbol${state.averageCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
          Icons.trending_up_outlined,
          AppColors.secondary,
        ),
        SizedBox(height: 12.h),
        _buildSummaryCard(
          context.l10n.daysSinceLastServiceLabel,
          '${state.daysSinceLastService}',
          Icons.access_time_outlined,
          _getDaysSinceServiceColor(state.daysSinceLastService),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[500],
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral[900],
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySpendingChart(
    VehicleDetailLoaded state,
    String currencySymbol,
  ) {
    final monthlyData = _getMonthlySpendingData(state.serviceRecords);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.monthlySpending,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 250.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    monthlyData.isNotEmpty
                        ? (monthlyData
                                .map((e) => e.cost)
                                .reduce((a, b) => a > b ? a : b) *
                            1.2)
                        : 100,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '$currencySymbol${rod.toY.round()}',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyData[value.toInt()].month,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral[500],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      monthlyData.isNotEmpty
                          ? (monthlyData
                                      .map((e) => e.cost)
                                      .reduce((a, b) => a > b ? a : b) /
                                  4)
                              .ceilToDouble()
                          : 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.neutral[200],
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups:
                    monthlyData.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.cost,
                            color: AppColors.primary,
                            width: 16,
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withOpacity(0.8),
                                AppColors.primary.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeDistributionChart(VehicleDetailLoaded state) {
    final typeData = _getServiceTypeDistributionData(state.serviceRecords);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.serviceTypeDistribution,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 250.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections:
                    typeData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final color = _getPieChartColor(index);
                      return PieChartSectionData(
                        color: color,
                        value: data.count.toDouble(),
                        title: '${data.percentage}%',
                        radius: 80,
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children:
                typeData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final color = _getPieChartColor(index);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${data.type} (${data.count})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral[700],
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCostTrendChart(
    VehicleDetailLoaded state,
    String currencySymbol,
  ) {
    final trendData = _getCostTrendData(state.serviceRecords);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.costTrend,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 250.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      trendData.isNotEmpty
                          ? (trendData
                                      .map((e) => e.cost)
                                      .reduce((a, b) => a > b ? a : b) /
                                  4)
                              .ceilToDouble()
                          : 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.neutral[200],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < trendData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              trendData[value.toInt()].date,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral[500],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (trendData.length - 1).toDouble().clamp(
                  0,
                  double.infinity,
                ),
                minY: 0,
                maxY:
                    trendData.isNotEmpty
                        ? (trendData
                                .map((e) => e.cost)
                                .reduce((a, b) => a > b ? a : b) *
                            1.2)
                        : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        trendData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.cost);
                        }).toList(),
                    isCurved: true,
                    color: AppColors.tertiary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.tertiary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.tertiary.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '$currencySymbol${spot.y.round()}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceFrequencyChart(VehicleDetailLoaded state) {
    final frequencyData = _getServiceFrequencyData(state.serviceRecords);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.serviceFrequency,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 250.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    frequencyData.isNotEmpty
                        ? (frequencyData
                                .map((e) => e.count)
                                .reduce((a, b) => a > b ? a : b) *
                            1.2)
                        : 5,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} services',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < frequencyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              frequencyData[value.toInt()].month,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral[500],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.neutral[200],
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups:
                    frequencyData.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.count.toDouble(),
                            color: AppColors.secondary,
                            width: 16,
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.secondary.withOpacity(0.8),
                                AppColors.secondary.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.neutral[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bar_chart_outlined,
                size: 64,
                color: AppColors.neutral[400],
              ),
            ),
            SizedBox(height: 24),
            Text(
              context.l10n.noDataAvailable,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 12),
            Text(
              context.l10n.addServiceRecordsToSeeStatistics,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.neutral[600],
                height: 1.5,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.tertiary[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 56,
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.somethingWentWrong,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.neutral[600],
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_MonthlySpendingData> _getMonthlySpendingData(List<dynamic> services) {
    final Map<String, double> monthlyCosts = {};

    for (var service in services) {
      if (service.cost != null) {
        final monthKey = DateFormat('MMM yyyy').format(service.serviceDate);
        monthlyCosts[monthKey] = (monthlyCosts[monthKey] ?? 0) + service.cost!;
      }
    }

    final sortedKeys =
        monthlyCosts.keys.toList()..sort(
          (a, b) => DateFormat(
            'MMM yyyy',
          ).parse(a).compareTo(DateFormat('MMM yyyy').parse(b)),
        );

    return sortedKeys.map((key) {
      return _MonthlySpendingData(month: key, cost: monthlyCosts[key]!);
    }).toList();
  }

  List<_ServiceTypeData> _getServiceTypeDistributionData(
    List<dynamic> services,
  ) {
    final Map<String, int> typeCounts = {};

    for (var service in services) {
      final type = service.serviceType;
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;
    }

    final total = services.length;

    return typeCounts.entries.map((entry) {
        return _ServiceTypeData(
          type: entry.key,
          count: entry.value,
          percentage: ((entry.value / total) * 100).round(),
        );
      }).toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }

  List<_CostTrendData> _getCostTrendData(List<dynamic> services) {
    final sortedServices = List<dynamic>.from(services)
      ..sort((a, b) => a.serviceDate.compareTo(b.serviceDate));

    return sortedServices.map((service) {
      return _CostTrendData(
        date: DateFormat('dd MMM').format(service.serviceDate),
        cost: service.cost ?? 0,
      );
    }).toList();
  }

  List<_ServiceFrequencyData> _getServiceFrequencyData(List<dynamic> services) {
    final Map<String, int> monthlyFrequency = {};

    for (var service in services) {
      final monthKey = DateFormat('MMM yyyy').format(service.serviceDate);
      monthlyFrequency[monthKey] = (monthlyFrequency[monthKey] ?? 0) + 1;
    }

    final sortedKeys =
        monthlyFrequency.keys.toList()..sort(
          (a, b) => DateFormat(
            'MMM yyyy',
          ).parse(a).compareTo(DateFormat('MMM yyyy').parse(b)),
        );

    return sortedKeys.map((key) {
      return _ServiceFrequencyData(month: key, count: monthlyFrequency[key]!);
    }).toList();
  }

  Color _getDaysSinceServiceColor(int days) {
    if (days <= 30) {
      return AppColors.tertiary;
    } else if (days <= 90) {
      return AppColors.secondary;
    } else {
      return AppColors.error;
    }
  }

  Color _getPieChartColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.tertiary,
      AppColors.secondary,
      AppColors.error,
      AppColors.neutral[700]!,
      AppColors.neutral[500]!,
    ];
    return colors[index % colors.length];
  }
}

class _MonthlySpendingData {
  final String month;
  final double cost;

  _MonthlySpendingData({required this.month, required this.cost});
}

class _ServiceTypeData {
  final String type;
  final int count;
  final int percentage;

  _ServiceTypeData({
    required this.type,
    required this.count,
    required this.percentage,
  });
}

class _CostTrendData {
  final String date;
  final double cost;

  _CostTrendData({required this.date, required this.cost});
}

class _ServiceFrequencyData {
  final String month;
  final int count;

  _ServiceFrequencyData({required this.month, required this.count});
}
