import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/review_model.dart';
import '../providers/customer_notifications_provider.dart';

class CustomerAlertsScreen extends ConsumerWidget {
  const CustomerAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final notifications = ref.watch(customerNotificationsProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          context.tr('alerts'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: () {
                ref.read(customerNotificationsProvider.notifier).markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.tr('all_read_success')),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.primary),
              label: Text(
                context.tr('mark_all_read'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 52,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tr('no_alerts_title'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      context.tr('no_alerts_msg'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Demo Local Mock Notice Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('demo_notifications_badge'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.tr('demo_notifications_notice'),
                              style: TextStyle(
                                fontSize: 10.5,
                                height: 1.35,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Notifications List
                for (final item in notifications) ...[
                  _NotificationTile(
                    item: item,
                    localeCode: locale.languageCode,
                    isDark: isDark,
                    onTap: () {
                      ref.read(customerNotificationsProvider.notifier).markAsRead(item.id);
                      final bookingId = item.metadata?['bookingId'] as String?;
                      if (bookingId != null && bookingId.isNotEmpty) {
                        context.push(AppRoutes.customerLiveTrackingPath(bookingId));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationModel item;
  final String localeCode;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.localeCode,
    required this.isDark,
    required this.onTap,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case 'driver_assigned':
        return Icons.person_pin_circle_rounded;
      case 'in_transit':
        return Icons.local_shipping_rounded;
      case 'trip_completed':
        return Icons.check_circle_rounded;
      case 'gate_pass':
        return Icons.verified_user_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'driver_assigned':
        return AppColors.primary;
      case 'in_transit':
        return const Color(0xFF0284C7);
      case 'trip_completed':
        return const Color(0xFF16A34A);
      case 'gate_pass':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor(item.type);
    final bookingId = item.metadata?['bookingId'] as String?;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead
              ? (isDark ? AppColors.darkSurfaceCard : Colors.white)
              : (isDark ? const Color(0xFF1E2433) : const Color(0xFFFFF7ED)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isRead
                ? (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0))
                : AppColors.primary.withAlpha(90),
            width: item.isRead ? 1 : 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(isDark ? 45 : 25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIcon(item.type),
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.getDisplayTitle(localeCode),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.getDisplayBody(localeCode),
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(item.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                        ),
                      ),
                      if (bookingId != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              bookingId,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 9,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
