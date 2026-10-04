import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/customer_notifications_provider.dart';
import 'customer_home_dashboard.dart';
import 'customer_bookings_screen.dart';
import 'customer_alerts_screen.dart';
import 'customer_profile_screen.dart';

class CustomerShellScreen extends ConsumerWidget {
  const CustomerShellScreen({super.key});

  static const List<Widget> _screens = [
    CustomerHomeDashboard(),
    CustomerBookingsScreen(),
    CustomerAlertsScreen(),
    CustomerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = ref.watch(customerShellTabProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      body: SafeArea(
        child: _screens[currentIndex.clamp(0, _screens.length - 1)],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: 0.8,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, _screens.length - 1),
          onTap: (index) => ref.read(customerShellTabProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: context.tr('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              activeIcon: const Icon(Icons.receipt_long_rounded),
              label: context.tr('bookings'),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  unreadCount.toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  unreadCount.toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.notifications_rounded),
              ),
              label: context.tr('alerts'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: context.tr('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
