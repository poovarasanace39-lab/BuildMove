import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/booking_model.dart';
import '../../../models/enums.dart';
import '../../booking/providers/booking_flow_provider.dart';

class DriverTripsScreen extends ConsumerWidget {
  const DriverTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeAsync = ref.watch(activeBookingsProvider);
    final historyAsync = ref.watch(bookingHistoryProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          title: Text(
            context.tr('trips'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.darkTextTertiary : AppColors.textSecondary,
            tabs: [
              Tab(text: context.tr('active_dispatches')),
              Tab(text: context.tr('past_deliveries')),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeBookingsProvider);
            ref.invalidate(bookingHistoryProvider);
          },
          child: TabBarView(
            children: [
              // Active Dispatches Tab
              activeAsync.when(
                data: (activeList) {
                  final activeDriverTrips = activeList.where(
                    (b) => b.status == BookingStatus.accepted ||
                           b.status == BookingStatus.arriving ||
                           b.status == BookingStatus.inProgress,
                  ).toList();

                  if (activeDriverTrips.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.local_shipping_outlined,
                      title: context.tr('no_active_orders'),
                      message: context.tr('no_active_assigned_trip_msg'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeDriverTrips.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _driverTripItem(context, activeDriverTrips[i], isDark, isActive: true),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, _) => Center(
                  child: Text(
                    '${context.tr('error')}: $err',
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ),

              // Past Deliveries Tab
              historyAsync.when(
                data: (trips) {
                  final finishedTrips = trips.where(
                    (b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled,
                  ).toList();

                  if (finishedTrips.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.history_rounded,
                      title: context.tr('no_completed_trips'),
                      message: context.tr('no_completed_trips_msg'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: finishedTrips.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _driverTripItem(context, finishedTrips[i], isDark, isActive: false),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, _) => Center(
                  child: Text(
                    '${context.tr('error')}: $err',
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _driverTripItem(
    BuildContext context,
    BookingModel trip,
    bool isDark, {
    required bool isActive,
  }) {
    final fare = trip.actualFare ?? trip.estimatedFare;
    final fareText = fare > 0
        ? '${context.tr('fare_label')}: ${AppConstants.currencySymbol}${fare.toInt()}'
        : context.tr('fare_unavailable');

    final langCode = Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${context.tr('load_label')} #${trip.id}',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  fareText,
                  style: AppTypography.titleSmall.copyWith(
                    color: isActive ? AppColors.primaryDark : AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${trip.quantityTons} ${(langCode == 'ta' ? 'டன்' : 'Tons')} • ${trip.materialType.localizedName(langCode)}',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.circle, color: AppColors.success, size: 8),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${context.tr('pickup_label')}: ${trip.pickupLocation.address}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: AppColors.error, size: 10),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${context.tr('drop_label')}: ${trip.dropLocation.address}',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${trip.distanceKm} km',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                ),
              ),
              StatusBadge.fromBookingStatus(trip.status),
            ],
          ),
        ],
      ),
    );
  }
}
