import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../models/enums.dart';
import '../routing/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class DevModeBanner extends ConsumerWidget {
  const DevModeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFFFEF3C7), // Light Amber
      child: Row(
        children: [
          const Icon(Icons.code_rounded, size: 16, color: Color(0xFFB45309)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'DEMO MODE • Role: ${authState.currentUser?.role.name.toUpperCase() ?? 'NONE'}',
              style: AppTypography.labelSmall.copyWith(
                color: const Color(0xFFB45309),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          InkWell(
            onTap: () => _showQuickRoleSwitchSheet(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFB45309),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Switch Role',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickRoleSwitchSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Switch Demo Role', style: AppTypography.titleLarge),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Switch between roles to preview customer, driver, and admin consoles with instant mock data.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 16),
                _roleTile(
                  context: ctx,
                  ref: ref,
                  role: UserRole.customer,
                  title: 'Customer / Site Engineer',
                  subtitle: 'Book vehicles, specify materials, track live deliveries',
                  icon: Icons.engineering_rounded,
                  color: AppColors.customerRole,
                ),
                const Divider(),
                _roleTile(
                  context: ctx,
                  ref: ref,
                  role: UserRole.driver,
                  title: 'Driver / Fleet Owner',
                  subtitle: 'Duty toggle, accept load orders, navigate to site, trips',
                  icon: Icons.local_shipping_rounded,
                  color: AppColors.driverRole,
                ),
                const Divider(),
                _roleTile(
                  context: ctx,
                  ref: ref,
                  role: UserRole.admin,
                  title: 'Platform Admin',
                  subtitle: 'Verify RC documents, fleet overview, dispatches, metrics',
                  icon: Icons.admin_panel_settings_rounded,
                  color: AppColors.adminRole,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _roleTile({
    required BuildContext context,
    required WidgetRef ref,
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title, style: AppTypography.titleSmall),
      subtitle: Text(subtitle, style: AppTypography.bodySmall),
      contentPadding: EdgeInsets.zero,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.slateMuted),
      onTap: () async {
        Navigator.pop(context);
        await ref.read(authProvider.notifier).devSwitchRole(role);
        if (context.mounted) {
          switch (role) {
            case UserRole.customer:
              context.go(AppRoutes.customerHome);
              break;
            case UserRole.driver:
              context.go(AppRoutes.driverHome);
              break;
            case UserRole.admin:
              context.go(AppRoutes.adminDashboard);
              break;
          }
        }
      },
    );
  }
}
