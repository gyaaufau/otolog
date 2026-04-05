import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/cubit/currency_cubit.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import '../../cubit/vehicle_list_cubit.dart';
import '../../cubit/vehicle_list_state.dart';
import '../../resources/colors.dart';
import '../../widgets/search_bar_widget.dart';
import '../../router.dart';

class ServiceLogsScreen extends StatefulWidget {
  const ServiceLogsScreen({super.key});

  @override
  State<ServiceLogsScreen> createState() => _ServiceLogsScreenState();
}

class _ServiceLogsScreenState extends State<ServiceLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedVehicleId;
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Load vehicles when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VehicleListCubit>().loadVehicles();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilter(),
            Expanded(
              child: BlocBuilder<VehicleListCubit, VehicleListState>(
                builder: (context, state) {
                  if (state is VehicleListLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (state is VehicleListError) {
                    return _buildErrorState(state.message);
                  }

                  if (state is VehicleListLoaded) {
                    return _buildServiceLogsList(state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddServiceButton(),
    );
  }

  Widget _buildHeader() {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: AppColors.neutral[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.serviceLogs,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[900],
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final l10n = context.l10n;
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        final vehicles = state is VehicleListLoaded ? state.vehicles : [];
        final allServices =
            state is VehicleListLoaded ? (state.serviceRecords ?? []) : [];

        // Apply all filters
        final filteredServices = _applyFilters(allServices);

        // Calculate total cost
        final totalCost = filteredServices.fold<double>(0.0, (sum, service) {
          return sum + (service.cost ?? 0.0);
        });

        final hasActiveFilters = _hasActiveFilters();

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            children: [
              // Total Cost
              if (vehicles.isNotEmpty) ...[
                BlocBuilder<CurrencyCubit, CurrencyState>(
                  builder: (context, currencyState) {
                    final currencySymbol =
                        context.read<CurrencyCubit>().currentCurrencySymbol;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.totalCost,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$currencySymbol${totalCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              // Search and Filter Row
              if (vehicles.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: SearchBarWidget(
                        controller: _searchController,
                        hintText: l10n.searchServices,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onClear: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildFilterButton(hasActiveFilters),
                  ],
                ),
                // Active Filters Display
                if (hasActiveFilters) ...[
                  const SizedBox(height: 12),
                  _buildActiveFiltersChips(),
                ],
              ] else ...[
                SearchBarWidget(
                  controller: _searchController,
                  hintText: l10n.searchServices,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onClear: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<dynamic> _applyFilters(List<dynamic> services) {
    var filtered = services;

    // Filter by vehicle
    if (_selectedVehicleId != null) {
      filtered =
          filtered.where((s) => s.vehicleId == _selectedVehicleId).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered =
          filtered.where((s) {
            return s.serviceType.toLowerCase().contains(query) ||
                (s.mechanic != null &&
                    s.mechanic!.toLowerCase().contains(query));
          }).toList();
    }

    // Filter by date range
    if (_startDate != null) {
      filtered =
          filtered
              .where(
                (s) =>
                    s.serviceDate.isAfter(_startDate!) ||
                    s.serviceDate.isAtSameMomentAs(_startDate!),
              )
              .toList();
    }
    if (_endDate != null) {
      filtered =
          filtered
              .where(
                (s) =>
                    s.serviceDate.isBefore(_endDate!) ||
                    s.serviceDate.isAtSameMomentAs(_endDate!),
              )
              .toList();
    }

    return filtered;
  }

  bool _hasActiveFilters() {
    return _selectedVehicleId != null ||
        _startDate != null ||
        _endDate != null ||
        _searchQuery.isNotEmpty;
  }

  Widget _buildFilterButton(bool hasActiveFilters) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: hasActiveFilters ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  hasActiveFilters
                      ? AppColors.primary
                      : AppColors.neutral[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neutral[900]!.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showFilterBottomSheet(),
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.tune,
                color: hasActiveFilters ? Colors.white : AppColors.neutral[700],
                size: 24,
              ),
            ),
          ),
        ),
        if (hasActiveFilters)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.tertiary[600],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveFiltersChips() {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        final vehicles = state is VehicleListLoaded ? state.vehicles : [];
        dynamic? selectedVehicle;
        if (_selectedVehicleId != null) {
          try {
            selectedVehicle = vehicles.firstWhere(
              (v) => v.id == _selectedVehicleId,
            );
          } catch (e) {
            selectedVehicle = null;
          }
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (selectedVehicle != null)
              _buildFilterChip(
                label: selectedVehicle.name,
                onRemove: () {
                  setState(() {
                    _selectedVehicleId = null;
                  });
                },
              ),
            if (_startDate != null || _endDate != null)
              _buildFilterChip(
                label: _formatDateRange(),
                onRemove: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  String _formatDateRange() {
    if (_startDate != null && _endDate != null) {
      return '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}';
    } else if (_startDate != null) {
      return 'From ${_formatDate(_startDate!)}';
    } else if (_endDate != null) {
      return 'Until ${_formatDate(_endDate!)}';
    }
    return '';
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheetContent(),
    );
  }

  Widget _buildFilterBottomSheetContent() {
    final l10n = context.l10n;
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        final vehicles = state is VehicleListLoaded ? state.vehicles : [];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.neutral[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.filters,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral[900],
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearAllFilters,
                        child: Text(
                          l10n.clearAll,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tertiary[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Filter Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Filter
                      _buildFilterSection(
                        title: l10n.vehicle,
                        child: _buildVehicleFilter(vehicles),
                      ),
                      const SizedBox(height: 24),
                      // Date Range Filter
                      _buildFilterSection(
                        title: l10n.dateRange,
                        child: _buildDateRangeFilter(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Apply Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.applyFilters,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral[600],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildVehicleFilter(List<dynamic> vehicles) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedVehicleId,
          hint: Text(
            l10n.allVehicles,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral[700],
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.neutral[500]),
          isExpanded: true,
          items: [
            DropdownMenuItem<int>(
              value: null,
              child: Text(
                l10n.allVehicles,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral[700],
                ),
              ),
            ),
            ...vehicles.map((vehicle) {
              return DropdownMenuItem<int>(
                value: vehicle.id,
                child: Text(
                  vehicle.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutral[900],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _selectedVehicleId = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    final l10n = context.l10n;
    return Column(
      children: [
        // Start Date
        GestureDetector(
          onTap: () => _selectDate(context, isStartDate: true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.neutral[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.neutral[500],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _startDate != null
                        ? _formatDate(_startDate!)
                        : l10n.startDate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color:
                          _startDate != null
                              ? AppColors.neutral[900]
                              : AppColors.neutral[500],
                    ),
                  ),
                ),
                if (_startDate != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _startDate = null;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.neutral[400],
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // End Date
        GestureDetector(
          onTap: () => _selectDate(context, isStartDate: false),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.neutral[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.neutral[500],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _endDate != null ? _formatDate(_endDate!) : l10n.endDate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color:
                          _endDate != null
                              ? AppColors.neutral[900]
                              : AppColors.neutral[500],
                    ),
                  ),
                ),
                if (_endDate != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _endDate = null;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.neutral[400],
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStartDate
              ? (_startDate ?? DateTime.now())
              : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.neutral[900]!,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedVehicleId = null;
      _startDate = null;
      _endDate = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Widget _buildServiceLogsList(VehicleListLoaded state) {
    final allServices = state.serviceRecords ?? [];
    final vehicles = state.vehicles;

    // Apply all filters
    final filteredServices = _applyFilters(allServices);

    if (filteredServices.isEmpty) {
      final l10n = context.l10n;
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<VehicleListCubit>().loadVehicles();
        },
        color: AppColors.primary,
        backgroundColor: AppColors.neutral[50],
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    Icons.build_outlined,
                    size: 56,
                    color: AppColors.neutral[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noServiceRecords,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral[900],
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  vehicles.isEmpty
                      ? l10n.addVehicleFirstToStartTracking
                      : _selectedVehicleId != null
                      ? '${l10n.noServiceRecordsFor} ${(() {
                        try {
                          return vehicles.firstWhere((v) => v.id == _selectedVehicleId).name;
                        } catch (e) {
                          return '';
                        }
                      })()}'
                      : l10n.addFirstServiceRecordToGetStarted,
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
        ),
      );
    }

    // Group services by date
    final groupedServices = _groupServicesByDate(filteredServices);
    final dateGroups = groupedServices.entries.toList();

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VehicleListCubit>().loadVehicles();
      },
      color: AppColors.primary,
      backgroundColor: AppColors.neutral[50],
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        itemCount: dateGroups.length,
        itemBuilder: (context, index) {
          final dateGroup = dateGroups[index];
          return _buildDateGroup(dateGroup, vehicles);
        },
      ),
    );
  }

  Map<String, List<dynamic>> _groupServicesByDate(List<dynamic> services) {
    final Map<String, List<dynamic>> grouped = {};

    for (final service in services) {
      final dateKey = _formatDateKey(service.serviceDate);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(service);
    }

    // Sort dates in descending order (newest first)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final Map<String, List<dynamic>> sortedGrouped = {};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildDateGroup(
    MapEntry<String, List<dynamic>> dateGroup,
    List<dynamic> vehicles,
  ) {
    final date = DateTime.parse(dateGroup.key);
    final services = dateGroup.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(date, services.length),
        const SizedBox(height: 12),
        ...services.map((service) {
          dynamic? vehicle;
          try {
            vehicle = vehicles.firstWhere((v) => v.id == service.vehicleId);
          } catch (e) {
            if (vehicles.isNotEmpty) {
              vehicle = vehicles.first;
            }
          }
          if (vehicle == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildServiceCard(service, vehicle),
          );
        }),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildDateHeader(DateTime date, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Text(
            _formatDateHeader(date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral[600],
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final serviceDate = DateTime(date.year, date.month, date.day);

    if (serviceDate == today) {
      return l10n.today;
    } else if (serviceDate == yesterday) {
      return l10n.yesterday;
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getMonthName(int month) {
    final l10n = context.l10n;
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
    ];
    return months[month - 1];
  }

  Widget _buildServiceCard(dynamic service, dynamic vehicle) {
    return GestureDetector(
      onTap:
          () => context.push(
            AppRoutes.serviceDetail
                .replaceFirst(':vehicleId', service.vehicleId.toString())
                .replaceFirst(':serviceId', service.id.toString()),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceTypeIcon(service.serviceType),
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
                        service.serviceType,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral[900],
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral[600],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showServiceOptionsSheet(service, vehicle),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.neutral[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: AppColors.neutral[500],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppColors.neutral[100]),
            const SizedBox(height: 12),
            Row(
              children: [
                if (service.cost != null) ...[
                  BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, currencyState) {
                      final currencySymbol =
                          context.read<CurrencyCubit>().currentCurrencySymbol;
                      return _buildInfoItem(
                        Icons.payments_outlined,
                        '$currencySymbol${service.cost!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        context.l10n.cost,
                      );
                    },
                  ),
                ],
                if (service.mechanic != null &&
                    service.mechanic!.isNotEmpty) ...[
                  const SizedBox(width: 28),
                  _buildInfoItem(
                    Icons.person_outline,
                    service.mechanic!,
                    context.l10n.mechanic,
                    isFlexible: true,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String value,
    String label, {
    bool isFlexible = false,
  }) {
    return Expanded(
      flex: isFlexible ? 2 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[400],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[800],
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getServiceTypeIcon(String serviceType) {
    final type = serviceType.toLowerCase();
    if (type.contains('oil')) return Icons.oil_barrel;
    if (type.contains('tire') || type.contains('wheel'))
      return Icons.tire_repair;
    if (type.contains('brake')) return Icons.disc_full;
    if (type.contains('battery')) return Icons.battery_charging_full;
    if (type.contains('engine')) return Icons.settings;
    if (type.contains('air') || type.contains('filter')) return Icons.air;
    if (type.contains('transmission')) return Icons.sync;
    if (type.contains('inspection') || type.contains('check'))
      return Icons.fact_check;
    return Icons.build;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double cost) {
    final currencySymbol = context.read<CurrencyCubit>().currentCurrencySymbol;
    return '$currencySymbol${cost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Widget _buildAddServiceButton() {
    return BlocBuilder<VehicleListCubit, VehicleListState>(
      builder: (context, state) {
        final vehicles = state is VehicleListLoaded ? state.vehicles : [];

        if (vehicles.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 24, right: 24),
          child: FloatingActionButton.extended(
            heroTag: 'add_service_fab',
            onPressed: () {
              // Navigate directly to add service screen
              context.push(AppRoutes.addServiceGeneral);
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: const Icon(Icons.add, size: 20),
            label: Text(
              context.l10n.addService,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    final l10n = context.l10n;
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
              l10n.somethingWentWrong,
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
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary[700]!],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<VehicleListCubit>().loadVehicles();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.retry,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceOptionsSheet(dynamic service, dynamic vehicle) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.neutral[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.serviceOptions,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral[900],
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildOptionButton(
                    icon: Icons.visibility_outlined,
                    label: l10n.viewDetails,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.serviceDetail
                            .replaceFirst(
                              ':vehicleId',
                              service.vehicleId.toString(),
                            )
                            .replaceFirst(':serviceId', service.id.toString()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    icon: Icons.edit_outlined,
                    label: l10n.editService,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.editService
                            .replaceFirst(
                              ':vehicleId',
                              service.vehicleId.toString(),
                            )
                            .replaceFirst(':serviceId', service.id.toString()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    icon: Icons.delete_outline,
                    label: l10n.deleteService,
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmationDialog(service, vehicle);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDestructive ? AppColors.tertiary[50]! : AppColors.neutral[50]!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDestructive
                  ? AppColors.tertiary[200]!
                  : AppColors.neutral[200]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      isDestructive
                          ? AppColors.tertiary[600]
                          : AppColors.neutral[700],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive
                              ? AppColors.tertiary[600]
                              : AppColors.neutral[900],
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(dynamic service, dynamic vehicle) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              l10n.deleteService,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral[900],
                letterSpacing: -0.3,
              ),
            ),
            content: Text(
              l10n.deleteServiceConfirmation(service.serviceType, vehicle.name),
              style: TextStyle(
                fontSize: 15,
                color: AppColors.neutral[700],
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral[600],
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<VehicleListCubit>().deleteServiceRecord(
                    service.id,
                    service.vehicleId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  l10n.delete,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
