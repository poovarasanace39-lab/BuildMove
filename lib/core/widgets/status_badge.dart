import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final BookingStatus? bookingStatus;
  final UserRole? userRole;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.bookingStatus,
    this.userRole,
  });

  factory StatusBadge.fromBookingStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
      case BookingStatus.searching:
        return StatusBadge(
          label: status.displayName,
          bookingStatus: status,
          backgroundColor: AppColors.warningLight,
          textColor: AppColors.warning,
          icon: Icons.hourglass_top_rounded,
        );
      case BookingStatus.accepted:
        return StatusBadge(
          label: status.displayName,
          bookingStatus: status,
          backgroundColor: AppColors.infoLight,
          textColor: AppColors.info,
          icon: Icons.assignment_turned_in_rounded,
        );
      case BookingStatus.arriving:
      case BookingStatus.inProgress:
        return StatusBadge(
          label: status.displayName,
          bookingStatus: status,
          backgroundColor: AppColors.primaryContainer,
          textColor: AppColors.primaryDark,
          icon: Icons.local_shipping_rounded,
        );
      case BookingStatus.completed:
        return StatusBadge(
          label: status.displayName,
          bookingStatus: status,
          backgroundColor: AppColors.successLight,
          textColor: AppColors.success,
          icon: Icons.check_circle_rounded,
        );
      case BookingStatus.cancelled:
        return StatusBadge(
          label: status.displayName,
          bookingStatus: status,
          backgroundColor: AppColors.errorLight,
          textColor: AppColors.error,
          icon: Icons.cancel_rounded,
        );
    }
  }

  factory StatusBadge.fromRole(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return const StatusBadge(
          label: 'Site Engineer',
          userRole: UserRole.customer,
          backgroundColor: AppColors.infoLight,
          textColor: AppColors.customerRole,
          icon: Icons.engineering_rounded,
        );
      case UserRole.driver:
        return const StatusBadge(
          label: 'Driver / Fleet',
          userRole: UserRole.driver,
          backgroundColor: AppColors.primaryContainer,
          textColor: AppColors.driverRole,
          icon: Icons.local_shipping_rounded,
        );
      case UserRole.admin:
        return const StatusBadge(
          label: 'Platform Admin',
          userRole: UserRole.admin,
          backgroundColor: Color(0xFFF3E8FF),
          textColor: AppColors.adminRole,
          icon: Icons.admin_panel_settings_rounded,
        );
    }
  }

  String _getLocalizedLabel(BuildContext context) {
    if (bookingStatus != null) {
      switch (bookingStatus!) {
        case BookingStatus.pending:
          return context.tr('status_pending');
        case BookingStatus.searching:
          return context.tr('status_searching');
        case BookingStatus.accepted:
          return context.tr('status_accepted');
        case BookingStatus.arriving:
          return context.tr('status_arriving');
        case BookingStatus.inProgress:
          return context.tr('status_in_progress');
        case BookingStatus.completed:
          return context.tr('status_completed');
        case BookingStatus.cancelled:
          return context.tr('status_cancelled');
      }
    }
    if (userRole != null) {
      switch (userRole!) {
        case UserRole.customer:
          return context.tr('role_customer');
        case UserRole.driver:
          return context.tr('role_driver');
        case UserRole.admin:
          return context.tr('role_admin');
      }
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            _getLocalizedLabel(context),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
