import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/dev_mode_banner.dart';
import '../providers/admin_dashboard_provider.dart';
import 'admin_dashboard_screen.dart';
import 'admin_verifications_screen.dart';
import 'admin_fleet_screen.dart';

class AdminShellScreen extends ConsumerWidget {
  const AdminShellScreen({super.key});

  final List<Widget> _screens = const [
    AdminDashboardScreen(),
    AdminVerificationsScreen(),
    AdminFleetScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminShellTabProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DevModeBanner(),
            Expanded(child: _screens[currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(adminShellTabProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined),
            activeIcon: const Icon(Icons.analytics_rounded),
            label: context.tr('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fact_check_outlined),
            activeIcon: const Icon(Icons.fact_check_rounded),
            label: context.tr('verifications'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping_outlined),
            activeIcon: const Icon(Icons.local_shipping_rounded),
            label: context.tr('fleet'),
          ),
        ],
      ),
    );
  }
}
