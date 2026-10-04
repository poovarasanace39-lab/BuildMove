import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/dev_mode_banner.dart';
import 'driver_home_dashboard.dart';
import 'driver_trips_screen.dart';
import 'driver_profile_screen.dart';

class DriverShellScreen extends StatefulWidget {
  const DriverShellScreen({super.key});

  @override
  State<DriverShellScreen> createState() => _DriverShellScreenState();
}

class _DriverShellScreenState extends State<DriverShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DriverHomeDashboard(),
    DriverTripsScreen(),
    DriverProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DevModeBanner(),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_rounded),
            label: context.tr('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.route_outlined),
            activeIcon: const Icon(Icons.route_rounded),
            label: context.tr('trips'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: context.tr('profile'),
          ),
        ],
      ),
    );
  }
}
