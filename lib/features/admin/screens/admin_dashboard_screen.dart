import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/enums.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_flow_provider.dart';
import '../providers/admin_dashboard_provider.dart';
import '../providers/fleet_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToDispatches() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        280.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final activeBookingsAsync = ref.watch(activeBookingsProvider);
    final metrics = ref.watch(adminDashboardMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('admin_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Metrics',
            onPressed: () async {
              ref.invalidate(activeBookingsProvider);
              ref.invalidate(bookingHistoryProvider);
              await ref.read(fleetNotifierProvider.notifier).loadFleetData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: context.tr('logout'),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Operator Banner
            AppCard(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFBF8FF),
              border: Border.all(color: AppColors.adminRole.withAlpha(50)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.adminRole.withAlpha(30),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.adminRole),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'BuildMove Ops Admin',
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          'Operations & Logistics Dispatch Controller',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge.fromRole(UserRole.admin),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Platform High-Level KPI Metrics Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Platform Live Metrics', style: AppTypography.titleMedium),
                Text(
                  'Live Reactive Data',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Primary 2x2 Operations KPI Grid
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    title: context.tr('active_trips_count'),
                    value: '${metrics.activeTripsCount}',
                    subtitle: metrics.awaitingDriverCount > 0
                        ? '${metrics.awaitingDriverCount} awaiting driver'
                        : 'All trips assigned',
                    icon: Icons.alt_route_rounded,
                    color: AppColors.primary,
                    onTap: _scrollToDispatches,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    title: context.tr('total_vehicles'),
                    value: '${metrics.registeredVehiclesCount}',
                    subtitle: '${metrics.onlineAvailableVehiclesCount} on duty online',
                    icon: Icons.local_shipping_rounded,
                    color: AppColors.info,
                    onTap: () {
                      ref.read(adminShellTabProvider.notifier).state = 2;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    title: context.tr('pending_verifications'),
                    value: '${metrics.pendingVerificationsCount}',
                    subtitle: metrics.pendingVerificationsCount > 0
                        ? 'Driver RC & DL queue'
                        : 'All verifications clear',
                    icon: Icons.pending_actions_rounded,
                    color: metrics.pendingVerificationsCount > 0 ? AppColors.warning : AppColors.success,
                    onTap: () {
                      ref.read(adminShellTabProvider.notifier).state = 1;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    title: context.tr('total_revenue'),
                    value: metrics.todayRevenue > 0
                        ? '₹${metrics.todayRevenue.toStringAsFixed(0)}'
                        : '₹0',
                    subtitle: metrics.completedTodayCount > 0
                        ? '${metrics.completedTodayCount} delivered today'
                        : 'All-time: ₹${metrics.allTimeCompletedRevenue.toStringAsFixed(0)}',
                    icon: Icons.currency_rupee_rounded,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Secondary Operations Summary Bar (Total Bookings, Completed Deliveries, Registered Drivers)
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: AppColors.surfaceVariant,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _miniStat(
                    label: 'Total Bookings',
                    value: '${metrics.totalBookingsCount}',
                    icon: Icons.assignment_outlined,
                  ),
                  Container(width: 1, height: 28, color: AppColors.border),
                  _miniStat(
                    label: 'Completed Loads',
                    value: '${metrics.completedDeliveriesCount}',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  Container(width: 1, height: 28, color: AppColors.border),
                  _miniStat(
                    label: 'Registered Drivers',
                    value: '${metrics.registeredDriversCount}',
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Live Dispatches Under Management
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Logistics Dispatches', style: AppTypography.titleMedium),
                Text(
                  'Automated Dispatch Engine',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.slateMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),

            activeBookingsAsync.when(
              data: (bookings) {
                if (bookings.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No active dispatches currently',
                        style: TextStyle(color: AppColors.textTertiary),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final b = bookings[i];
                    return AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Order #${b.id} • ${b.materialType.localizedName(Localizations.maybeLocaleOf(context)?.languageCode ?? 'en')}',
                                  style: AppTypography.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusBadge.fromBookingStatus(b.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Client: ${b.customerName ?? 'Civil Engineer'} • Driver: ${b.driverName ?? 'Awaiting match'}',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${b.pickupLocation.address} → ${b.dropLocation.address}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading bookings: $err'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, size: 18, color: color),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}
