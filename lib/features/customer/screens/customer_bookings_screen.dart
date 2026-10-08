import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/booking_model.dart';
import '../../booking/providers/booking_flow_provider.dart';

class CustomerBookingsScreen extends ConsumerWidget {
  final int initialTabIndex;
  final bool showBackButton;

  const CustomerBookingsScreen({
    super.key,
    this.initialTabIndex = 0,
    this.showBackButton = false,
  });

  String _formatDate(DateTime dt, [String localeCode = 'en']) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute $period';

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return localeCode == 'ta' ? 'இன்று, $timeStr' : 'Today, $timeStr';
    } else if (diff.inDays <= 1 && (now.day - dt.day == 1)) {
      return localeCode == 'ta' ? 'நேற்று, $timeStr' : 'Yesterday, $timeStr';
    } else {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = months[dt.month - 1];
      return '$month ${dt.day}, ${dt.year} • $timeStr';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeAsync = ref.watch(activeBookingsProvider);
    final historyAsync = ref.watch(bookingHistoryProvider);
    final canPop = Navigator.of(context).canPop();

    return DefaultTabController(
      length: 2,
      initialIndex: (initialTabIndex >= 0 && initialTabIndex < 2) ? initialTabIndex : 0,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          elevation: 0,
          leading: (showBackButton || canPop)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  onPressed: () => context.pop(),
                )
              : null,
          title: Text(
            context.tr('bookings'),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: context.tr('active_dispatches')),
              Tab(text: context.tr('past_deliveries')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Active Tab
            activeAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.local_shipping_outlined,
                    title: context.tr('no_active_orders'),
                    message: context.tr('no_active_orders_msg'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: list.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _bookingListItem(context, list[i], isDark),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(
                child: Text(
                  '${context.tr('error')}: $err',
                  style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
              ),
            ),

            // History Tab
            historyAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.history_rounded,
                    title: context.tr('no_past_orders'),
                    message: context.tr('no_past_orders_msg'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: list.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _bookingListItem(context, list[i], isDark),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(
                child: Text(
                  '${context.tr('error')}: $err',
                  style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingListItem(BuildContext context, BookingModel booking, bool isDark) {
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textTertiary = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;

    return AppCard(
      padding: const EdgeInsets.all(14),
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
                      '${context.tr('order_label')} #${booking.id}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _formatDate(booking.scheduledAt, Localizations.maybeLocaleOf(context)?.languageCode ?? 'en'),
                            style: TextStyle(
                              fontSize: 11,
                              color: textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge.fromBookingStatus(booking.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${booking.quantityTons} ${(Localizations.maybeLocaleOf(context)?.languageCode == 'ta' ? 'டன்' : 'Tons')} • ${booking.materialType.localizedName(Localizations.maybeLocaleOf(context)?.languageCode ?? 'en')} (${booking.vehicleType.name})',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.pickupLocation.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 10, color: AppColors.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.dropLocation.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${context.tr('fare_label')}: ${AppConstants.currencySymbol}${booking.estimatedFare.toInt()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (booking.otpForPickup != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                    border: isDark
                        ? Border.all(color: AppColors.darkBorder, width: 0.8)
                        : null,
                  ),
                  child: Text(
                    'Pickup OTP: ${booking.otpForPickup}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
