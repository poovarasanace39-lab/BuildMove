import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/navigation_launcher.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/booking_model.dart';
import '../../../models/enums.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_flow_provider.dart';
import '../../tracking/widgets/map_placeholder_widget.dart';

class DriverHomeDashboard extends ConsumerStatefulWidget {
  const DriverHomeDashboard({super.key});

  @override
  ConsumerState<DriverHomeDashboard> createState() => _DriverHomeDashboardState();
}

class _DriverHomeDashboardState extends ConsumerState<DriverHomeDashboard> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final activeBookingsAsync = ref.watch(activeBookingsProvider);
    final incomingRequestsAsync = ref.watch(driverIncomingRequestsProvider);
    final historyAsync = ref.watch(bookingHistoryProvider);

    // Calculate actual confirmed earnings from finished trips in mock database
    final completedTrips = (historyAsync.asData?.value ?? [])
        .where((b) => b.status == BookingStatus.completed)
        .toList();
    final todayEarnings = completedTrips.fold<double>(
      0.0,
      (sum, b) => sum + (b.actualFare ?? b.estimatedFare),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(activeBookingsProvider);
          ref.invalidate(driverIncomingRequestsProvider);
          ref.invalidate(bookingHistoryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Header & Duty Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Murugan K. (Driver)',
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '6-Wheeler Tipper (10T) • TN-02-AL-8921',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge.fromRole(UserRole.driver),
                ],
              ),
              const SizedBox(height: 16),

              // Duty Status Switch Card
              AppCard(
                color: _isOnline
                    ? (isDark ? const Color(0xFF14532D).withAlpha(80) : AppColors.successLight.withAlpha(120))
                    : (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            _isOnline ? Icons.check_circle : Icons.pause_circle_filled,
                            color: _isOnline ? AppColors.success : (isDark ? AppColors.darkTextTertiary : AppColors.slateMuted),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isOnline
                                      ? context.tr('duty_status_online')
                                      : context.tr('duty_status_offline'),
                                  style: AppTypography.titleSmall.copyWith(
                                    color: _isOnline
                                        ? AppColors.success
                                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _isOnline
                                      ? context.tr('ready_for_dispatches')
                                      : context.tr('tap_switch_on_duty'),
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isOnline,
                      activeTrackColor: AppColors.success,
                      activeThumbColor: Colors.white,
                      onChanged: (val) {
                        setState(() => _isOnline = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Earnings Summary Cards (Dynamic from actual completed bookings)
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('today_earnings'),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${AppConstants.currencySymbol}${todayEarnings.toInt()}',
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${completedTrips.length} ${completedTrips.length == 1 ? context.tr('trip_completed_single') : context.tr('trips_completed_plural')}',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('driver_rating_label'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.accent, size: 22),
                              const SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: AppTypography.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '148 ${context.tr('total_reviews_label')}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Active Assigned Trip Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('current_assigned_trip'),
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              activeBookingsAsync.when(
                data: (activeList) {
                  final activeDriverTrips = activeList.where(
                    (b) => b.status == BookingStatus.accepted ||
                           b.status == BookingStatus.arriving ||
                           b.status == BookingStatus.inProgress,
                  ).toList();

                  if (activeDriverTrips.isEmpty) {
                    return AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 40,
                              color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              context.tr('no_active_assigned_trip'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.tr('no_active_assigned_trip_msg'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _activeDriverTripCard(context, ref, activeDriverTrips.first, isDark);
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (error, _) => Text(
                  '${context.tr('error')}: $error',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),

              const SizedBox(height: 24),

              // Incoming Dispatch Requests
              Text(
                context.tr('incoming_requests'),
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              incomingRequestsAsync.when(
                data: (requests) {
                  if (requests.isEmpty || !_isOnline) {
                    return EmptyStateView(
                      icon: Icons.local_shipping_outlined,
                      title: _isOnline ? context.tr('searching_for_loads') : context.tr('currently_offline'),
                      message: _isOnline
                          ? context.tr('no_incoming_requests')
                          : context.tr('turn_on_duty_hint'),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _incomingRequestCard(context, ref, requests[i], isDark),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (err, _) => Text(
                  '${context.tr('error')}: $err',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activeDriverTripCard(
    BuildContext context,
    WidgetRef ref,
    BookingModel trip,
    bool isDark,
  ) {
    final isInProgress = trip.status == BookingStatus.inProgress;
    final isAssigned = trip.status == BookingStatus.accepted || trip.status == BookingStatus.arriving;
    final fareText = trip.estimatedFare > 0
        ? '${AppConstants.currencySymbol}${trip.estimatedFare.toInt()}'
        : context.tr('fare_unavailable');

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${context.tr('job_label')} #${trip.id}',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${context.tr('fare_label')}: $fareText',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge.fromBookingStatus(trip.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // In-app route illustration (Disclaimed demo)
          MapPlaceholderWidget(
            pickup: trip.pickupLocation,
            drop: trip.dropLocation,
            distanceKm: trip.distanceKm,
            isLiveTracking: isInProgress,
          ),
          const SizedBox(height: 12),

          Text(
            '${context.tr('load_label')}: ${trip.quantityTons} ${(Localizations.maybeLocaleOf(context)?.languageCode == 'ta' ? 'டன்' : 'Tons')} • ${trip.materialType.localizedName(Localizations.maybeLocaleOf(context)?.languageCode ?? 'en')}',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
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
          const Divider(height: 24),

          // Action Buttons strictly governed by current trip status
          if (isAssigned) ...[
            // Status: ASSIGNED -> Navigate to Pickup & Start Trip (Loaded)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    key: const Key('driver_nav_pickup_button'),
                    text: context.tr('nav_to_pickup'),
                    variant: AppButtonVariant.outline,
                    icon: Icons.navigation_rounded,
                    height: 44,
                    onPressed: () {
                      NavigationLauncher.openDirections(
                        context: context,
                        destinationAddress: trip.pickupLocation.address,
                        latitude: trip.pickupLocation.latitude,
                        longitude: trip.pickupLocation.longitude,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    key: const Key('driver_start_trip_button'),
                    text: context.tr('start_trip'),
                    icon: Icons.play_arrow_rounded,
                    height: 44,
                    onPressed: () async {
                      final result = await ref.read(bookingServiceProvider).startTrip(trip.id);
                      ref.invalidate(activeBookingsProvider);
                      ref.invalidate(bookingHistoryProvider);

                      if (context.mounted) {
                        result.fold(
                          onSuccess: (_) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(context.tr('trip_started_success')),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                          onFailure: (err) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(err.message),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ] else if (isInProgress) ...[
            // Status: IN PROGRESS / LOADED -> Navigate to Delivery & Complete Delivery (Unloaded)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    key: const Key('driver_nav_delivery_button'),
                    text: context.tr('nav_to_delivery'),
                    variant: AppButtonVariant.outline,
                    icon: Icons.navigation_rounded,
                    height: 44,
                    onPressed: () {
                      NavigationLauncher.openDirections(
                        context: context,
                        destinationAddress: trip.dropLocation.address,
                        latitude: trip.dropLocation.latitude,
                        longitude: trip.dropLocation.longitude,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    key: const Key('driver_complete_delivery_button'),
                    text: context.tr('end_trip'),
                    variant: AppButtonVariant.primary,
                    icon: Icons.check_circle_rounded,
                    height: 44,
                    onPressed: () => _confirmCompleteDelivery(context, ref, trip),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _confirmCompleteDelivery(BuildContext context, WidgetRef ref, BookingModel trip) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.success, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                context.tr('confirm_delivery_title'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          context.tr('confirm_delivery_msg'),
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              context.tr('cancel'),
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            key: const Key('confirm_complete_delivery_dialog_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final result = await ref.read(bookingServiceProvider).endTrip(trip.id);
              ref.invalidate(activeBookingsProvider);
              ref.invalidate(bookingHistoryProvider);

              if (context.mounted) {
                result.fold(
                  onSuccess: (_) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(context.tr('delivery_completed_success')),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                  onFailure: (err) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(err.message),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                );
              }
            },
            child: Text(context.tr('confirm_delivery_action')),
          ),
        ],
      ),
    );
  }

  Widget _incomingRequestCard(
    BuildContext context,
    WidgetRef ref,
    BookingModel req,
    bool isDark,
  ) {
    final fareText = req.estimatedFare > 0
        ? '${AppConstants.currencySymbol}${req.estimatedFare.toInt()}'
        : context.tr('fare_unavailable');

    return AppCard(
      padding: const EdgeInsets.all(14),
      border: Border.all(color: AppColors.primary, width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.tr('new_dispatch_request'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              Text(
                fareText,
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${req.quantityTons} ${(Localizations.maybeLocaleOf(context)?.languageCode == 'ta' ? 'டன்' : 'Tons')} • ${req.materialType.localizedName(Localizations.maybeLocaleOf(context)?.languageCode ?? 'en')}',
            style: AppTypography.titleSmall.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.circle, color: AppColors.success, size: 8),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  req.pickupLocation.address,
                  maxLines: 1,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.error, size: 10),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  req.dropLocation.address,
                  maxLines: 1,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: context.tr('reject_job'),
                  variant: AppButtonVariant.outline,
                  height: 40,
                  onPressed: () async {
                    await ref.read(bookingServiceProvider).rejectBooking(req.id);
                    ref.invalidate(driverIncomingRequestsProvider);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: context.tr('accept_job'),
                  height: 40,
                  onPressed: () async {
                    await ref.read(bookingServiceProvider).acceptBooking(req.id);
                    ref.invalidate(driverIncomingRequestsProvider);
                    ref.invalidate(activeBookingsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('load_accepted_success')),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
