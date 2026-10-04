import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';
import 'package:flutter_application_1/features/admin/providers/admin_dashboard_provider.dart';
import 'package:flutter_application_1/features/admin/providers/fleet_provider.dart';
import 'package:flutter_application_1/features/admin/screens/admin_dashboard_screen.dart';
import 'package:flutter_application_1/features/admin/screens/admin_shell_screen.dart';
import 'package:flutter_application_1/features/booking/providers/booking_flow_provider.dart';
import 'package:flutter_application_1/services/booking/mock_booking_service.dart';
import 'package:flutter_application_1/services/fleet/mock_fleet_service.dart';

void main() {
  setUp(() {
    MockBookingService.resetSeedData();
    MockFleetService.resetSeedData();
  });

  group('Admin Dashboard Dynamic Metrics Unit Tests', () {
    test('1. KPI counts accurately reflect seeded booking and fleet data', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Trigger initial loads
      await container.read(activeBookingsProvider.future);
      await container.read(bookingHistoryProvider.future);
      await container.read(fleetNotifierProvider.notifier).loadFleetData();

      final metrics = container.read(adminDashboardMetricsProvider);

      // Verify active bookings: BM-8492, BM-2026-083, BM-2026-085 = 3
      expect(metrics.activeTripsCount, 3);
      // Awaiting driver: BM-2026-083 (searching), BM-2026-085 (pending) = 2
      expect(metrics.awaitingDriverCount, 2);

      // Fleet vehicles = 8, Drivers = 8
      expect(metrics.registeredVehiclesCount, 8);
      expect(metrics.registeredDriversCount, 8);

      // Online & available vehicles = 4 (veh_001, veh_002, veh_003, veh_004)
      expect(metrics.onlineAvailableVehiclesCount, 4);

      // Pending KYC verifications queue = 3
      expect(metrics.pendingVerificationsCount, 3);

      // Total bookings = 3 active + 2 history = 5
      expect(metrics.totalBookingsCount, 5);

      // Completed deliveries = 1 (BM-2026-079)
      expect(metrics.completedDeliveriesCount, 1);

      // Revenue: BM-2026-079 was completed yesterday, so today's revenue is 0
      expect(metrics.todayRevenue, 0.0);
      // All-time completed revenue = 1100.0 (BM-2026-079)
      expect(metrics.allTimeCompletedRevenue, 1100.0);
    });

    test('2. Revenue does NOT count estimated fares or cancelled trips', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(activeBookingsProvider.future);
      await container.read(bookingHistoryProvider.future);

      final metrics = container.read(adminDashboardMetricsProvider);

      // Active bookings have estimated fares: 1850 + 980 + 1450 = 4280.
      // Cancelled booking has estimated fare: 3200.
      // None of these estimated fares must be counted as revenue!
      expect(metrics.allTimeCompletedRevenue, 1100.0);
      expect(metrics.allTimeCompletedRevenue, isNot(1100.0 + 4280.0));
    });

    test('3. Approving a driver updates pending verification and online fleet count', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(activeBookingsProvider.future);
      await container.read(bookingHistoryProvider.future);
      await container.read(fleetNotifierProvider.notifier).loadFleetData();

      var metrics = container.read(adminDashboardMetricsProvider);
      expect(metrics.pendingVerificationsCount, 3);
      expect(metrics.onlineAvailableVehiclesCount, 4);

      // Approve K. Anbalagan (DOC-9021)
      await container.read(fleetNotifierProvider.notifier).approveVerification('DOC-9021');

      metrics = container.read(adminDashboardMetricsProvider);
      expect(metrics.pendingVerificationsCount, 2);
      expect(metrics.onlineAvailableVehiclesCount, 5);
    });

    test('4. Toggling vehicle availability updates online available vehicle count', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(activeBookingsProvider.future);
      await container.read(bookingHistoryProvider.future);
      await container.read(fleetNotifierProvider.notifier).loadFleetData();

      var metrics = container.read(adminDashboardMetricsProvider);
      expect(metrics.onlineAvailableVehiclesCount, 4);

      // Toggle off veh_001
      await container.read(fleetNotifierProvider.notifier).toggleVehicleAvailability('veh_001');

      metrics = container.read(adminDashboardMetricsProvider);
      expect(metrics.onlineAvailableVehiclesCount, 3);

      // Toggle on veh_001
      await container.read(fleetNotifierProvider.notifier).toggleVehicleAvailability('veh_001');

      metrics = container.read(adminDashboardMetricsProvider);
      expect(metrics.onlineAvailableVehiclesCount, 4);
    });

    test('5. Empty booking and fleet lists evaluate cleanly without error', () {
      final container = ProviderContainer(
        overrides: [
          activeBookingsProvider.overrideWith((ref) => []),
          bookingHistoryProvider.overrideWith((ref) => []),
        ],
      );
      addTearDown(container.dispose);

      final metrics = container.read(adminDashboardMetricsProvider);
      expect(metrics.activeTripsCount, 0);
      expect(metrics.awaitingDriverCount, 0);
      expect(metrics.totalBookingsCount, 0);
      expect(metrics.completedDeliveriesCount, 0);
      expect(metrics.todayRevenue, 0.0);
    });
  });

  group('Admin Dashboard UI Widget Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    Widget buildTestApp({required Widget child}) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          locale: const Locale('en', ''),
          supportedLocales: const [
            Locale('en', ''),
            Locale('ta', ''),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: child,
        ),
      );
    }

    testWidgets('6. Dashboard renders dynamic KPI counts and dispatches without pixel overflow',
        (tester) async {
      await tester.pumpWidget(buildTestApp(child: const AdminDashboardScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify dynamic values from seed
      expect(find.text('3'), findsNWidgets(2)); // Active Trips (3) and Pending Verifications (3)
      expect(find.text('2 awaiting driver'), findsOneWidget);
      expect(find.text('8'), findsNWidgets(2)); // 8 vehicles, 8 drivers
      expect(find.text('5'), findsOneWidget); // 5 total bookings (3 active + 2 history)
      expect(find.text('4 on duty online'), findsOneWidget);
      expect(find.text('Driver RC & DL queue'), findsOneWidget);
      expect(find.text('₹0'), findsOneWidget); // Today's revenue

      // Secondary summary stats
      expect(find.text('Total Bookings'), findsOneWidget);
      expect(find.text('Completed Loads'), findsOneWidget);
      expect(find.text('Registered Drivers'), findsOneWidget);

      // Active dispatches
      expect(find.textContaining('Order #BM-8492'), findsOneWidget);
      expect(find.textContaining('Order #BM-2026-083'), findsOneWidget);
    });

    testWidgets('7. Tapping Pending Verifications KPI navigates to Verifications tab via Shell',
        (tester) async {
      await tester.pumpWidget(buildTestApp(child: const AdminShellScreen()));
      await tester.pumpAndSettle();

      // Initially on Dashboard tab
      expect(find.text('Platform Live Metrics'), findsOneWidget);

      // Tap on Pending Verifications card
      final pendingCard = find.text('Pending KYC / RC Documents');
      await tester.tap(pendingCard);
      await tester.pumpAndSettle();

      // Should now be on Verifications screen
      expect(find.text('DOC-9021'), findsOneWidget);
      expect(find.text('DOC-9022'), findsOneWidget);
    });

    testWidgets('8. Tapping Registered Fleet KPI navigates to Fleet tab via Shell',
        (tester) async {
      await tester.pumpWidget(buildTestApp(child: const AdminShellScreen()));
      await tester.pumpAndSettle();

      // Tap on Registered Fleet card
      final fleetCard = find.text('Registered Fleet');
      await tester.tap(fleetCard);
      await tester.pumpAndSettle();

      // Should now be on Fleet screen showing plate numbers
      expect(find.text('TN-02-AL-8921'), findsOneWidget);
      expect(find.text('TN-14-BD-2311'), findsOneWidget);
    });
  });
}
