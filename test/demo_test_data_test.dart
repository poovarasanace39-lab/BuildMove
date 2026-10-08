import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';
import 'package:flutter_application_1/features/customer/providers/customer_notifications_provider.dart';
import 'package:flutter_application_1/features/customer/screens/customer_alerts_screen.dart';
import 'package:flutter_application_1/features/customer/screens/customer_bookings_screen.dart';
import 'package:flutter_application_1/features/driver/screens/driver_home_dashboard.dart';
import 'package:flutter_application_1/features/driver/screens/driver_trips_screen.dart';
import 'package:flutter_application_1/features/admin/screens/admin_dashboard_screen.dart';
import 'package:flutter_application_1/features/tracking/screens/live_tracking_screen.dart';
import 'package:flutter_application_1/features/booking/screens/booking_confirmation_screen.dart';
import 'package:flutter_application_1/models/enums.dart';
import 'package:flutter_application_1/models/location_model.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/services/auth/dev_auth_service.dart';
import 'package:flutter_application_1/services/booking/mock_booking_service.dart';
import 'package:flutter_application_1/services/demo/demo_data_service.dart';
import 'package:flutter_application_1/services/fleet/mock_fleet_service.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    DemoDataService.instance.resetToInitialState();
    MockBookingService.resetSeedData();
    MockFleetService.resetSeedData();
  });

  group('BuildMove Controlled Demo/Test Data Layer Tests', () {
    test('1. Customer fixture exists and is deterministic', () {
      final customer = DemoDataService.customerUser;
      expect(customer.name, 'Ramesh Sundaram');
      expect(customer.phone, '+91 9876543210');
      expect(customer.role, UserRole.customer);
      expect(DemoDataService.customerCompany, 'BuildCon Infra Pvt Ltd');

      final authCustomer = DevAuthService.mockUsers[UserRole.customer];
      expect(authCustomer?.name, 'Ramesh Sundaram');
      expect(authCustomer?.phone, '9876543210');
    });

    test('2. Driver fixture exists and is deterministic', () {
      final driver = DemoDataService.driverUser;
      expect(driver.name, 'Murugan K.');
      expect(driver.phone, '+91 9840123456');
      expect(driver.role, UserRole.driver);

      final profile = DemoDataService.driverProfile;
      expect(profile.userId, 'usr_drv_002');
      expect(profile.isOnline, true);
      expect(profile.rating, 4.9);
      expect(profile.activeVehicleId, 'veh_001');
    });

    test('3. Admin fixture exists and has correct email and name', () {
      final admin = DemoDataService.adminUser;
      expect(admin.name, 'Priya Sharma');
      expect(admin.email, 'admin@buildmove.in');
      expect(admin.role, UserRole.admin);

      final authAdmin = DevAuthService.mockUsers[UserRole.admin];
      expect(authAdmin?.name, 'Priya Sharma');
      expect(authAdmin?.email, 'admin@buildmove.in');
    });

    test('4. Primary booking fixture (BM-8492) has 5.5T Timber & Plywood load and 10T Tipper', () {
      final booking = DemoDataService.createPrimaryBooking();
      expect(booking.id, 'BM-8492');
      expect(booking.materialType, ConstructionMaterial.timber);
      expect(booking.materialType.cleanEnglishTitle, 'Timber & Plywood');
      expect(booking.quantityTons, 5.5);
      expect(booking.estimatedFare, 1850.0);
      expect(booking.pickupLocation.address, 'Dalmia Cement Depot, Ambattur');
      expect(booking.dropLocation.address, 'Construction Site, OMR Thoraipakkam');
      expect(booking.driverName, 'Murugan K.');
      expect(booking.driverPhone, '+91 9840123456');
      expect(booking.vehicleType, VehicleType.tipper6Wheeler);
      expect(booking.vehicleType.capacityTons, 10.0);
    });

    test('5. Vehicle capacity rules reject 2-ton vehicle for 5.5-ton load', () async {
      final bookingService = MockBookingService();

      // Estimate test: 2-ton Bolero should NOT be capacity sufficient for 5.5 tons
      final estResult = await bookingService.calculateEstimate(
        material: ConstructionMaterial.cement,
        quantityTons: 5.5,
        pickup: const LocationModel(latitude: 13.08, longitude: 80.27, address: 'Ambattur'),
        drop: const LocationModel(latitude: 12.97, longitude: 80.24, address: 'OMR'),
      );

      expect(estResult.isSuccess, true);
      final est = estResult.dataOrNull!;

      final boleroOption = est.vehicleOptions.firstWhere((o) => o.type == VehicleType.pickup8ft);
      expect(boleroOption.isCapacitySufficient, false);
      expect(boleroOption.isRecommended, false);

      final tipperOption = est.vehicleOptions.firstWhere((o) => o.type == VehicleType.tipper6Wheeler);
      expect(tipperOption.isCapacitySufficient, true);
      expect(tipperOption.isRecommended, true);

      // Attempting to create a booking with a 2-ton vehicle for a 5.5-ton load must FAIL
      final createResult = await bookingService.createBooking(
        material: ConstructionMaterial.cement,
        quantityTons: 5.5,
        pickup: const LocationModel(latitude: 13.08, longitude: 80.27, address: 'Ambattur'),
        drop: const LocationModel(latitude: 12.97, longitude: 80.24, address: 'OMR'),
        vehicleType: VehicleType.pickup8ft, // 2-ton vehicle
        estimatedFare: 850.0,
        distanceKm: 14.5,
      );

      expect(createResult.isFailure, true);
      expect(createResult.failureOrNull?.message.contains('capacity'), true);
    });

    test('6. Notification empty state works and renders properly', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      // Clear notifications
      container.read(customerNotificationsProvider.notifier).clearAll();

      final notifs = container.read(customerNotificationsProvider);
      final unread = container.read(unreadNotificationCountProvider);

      expect(notifs, isEmpty);
      expect(unread, 0);
    });

    test('7. Notification populated state works with read and unread items', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final notifs = container.read(customerNotificationsProvider);
      final unread = container.read(unreadNotificationCountProvider);

      expect(notifs.length, greaterThanOrEqualTo(3));
      expect(unread, 2);

      // Verify specific notification content
      expect(notifs[0].title, 'Booking BM-8492 Accepted');
      expect(notifs[0].isRead, false);
      expect(notifs[0].metadata?['bookingId'], 'BM-8492');

      expect(notifs[1].title, 'Driver has started the trip');
      expect(notifs[1].isRead, false);
      expect(notifs[1].metadata?['bookingId'], 'BM-8492');

      expect(notifs[2].title, 'Delivery Completed');
      expect(notifs[2].isRead, true);

      // Marking all as read
      container.read(customerNotificationsProvider.notifier).markAllAsRead();
      final afterUnread = container.read(unreadNotificationCountProvider);
      expect(afterUnread, 0);
    });

    test('8. Booking states are consistent and transitionable', () async {
      final service = MockBookingService();

      // Primary booking starts as accepted
      final activeRes = await service.getActiveBookings();
      expect(activeRes.isSuccess, true);
      final bm8492 = activeRes.dataOrNull!.firstWhere((b) => b.id == 'BM-8492');
      expect(bm8492.status, BookingStatus.accepted);

      // Transition: Start trip -> inProgress
      final startRes = await service.startTrip('BM-8492');
      expect(startRes.isSuccess, true);
      expect(startRes.dataOrNull!.status, BookingStatus.inProgress);

      // Transition: End trip -> completed
      final endRes = await service.endTrip('BM-8492');
      expect(endRes.isSuccess, true);
      expect(endRes.dataOrNull!.status, BookingStatus.completed);

      // Now it appears in history
      final historyRes = await service.getBookingHistory();
      expect(historyRes.isSuccess, true);
      expect(historyRes.dataOrNull!.any((b) => b.id == 'BM-8492' && b.status == BookingStatus.completed), true);
    });

    test('9. KYC and Fleet states enforce compliance rules', () async {
      final fleetService = MockFleetService();

      final vehicles = await fleetService.getVehicles();
      final pendingVeh = vehicles.firstWhere((v) => v.id == 'veh_006');
      expect(pendingVeh.documents.first.status, DocumentStatus.pending);
      expect(pendingVeh.isAvailable, false);

      // Pending vehicle cannot be set available online
      await fleetService.setVehicleAvailability('veh_006', true);
      final updatedVeh = await fleetService.getVehicleById('veh_006');
      expect(updatedVeh?.isAvailable, false);

      // Busy vehicle (veh_005) is unavailable
      final busyVeh = vehicles.firstWhere((v) => v.id == 'veh_005');
      expect(busyVeh.isAvailable, false);
    });

    test('10. Reset mechanism restores initial deterministic state', () async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      // Mutate state: empty notifications and set bookings empty
      container.read(customerNotificationsProvider.notifier).clearAll();
      MockBookingService.setBookingsEmpty(true);
      MockFleetService.setFleetEmpty(true);

      expect(container.read(customerNotificationsProvider), isEmpty);
      expect(MockBookingService.currentBookings, isEmpty);

      // Reset
      DemoDataService.instance.resetToInitialState();
      container.read(customerNotificationsProvider.notifier).resetToDemo();
      MockBookingService.resetSeedData();
      MockFleetService.resetSeedData();

      expect(container.read(customerNotificationsProvider).length, greaterThanOrEqualTo(3));
      final active = await MockBookingService().getActiveBookings();
      expect(active.dataOrNull!.length, greaterThan(0));
      final vehicles = await MockFleetService().getVehicles();
      expect(vehicles.length, 8);
    });

    testWidgets('11. CustomerAlertsScreen displays empty state when notifications empty', (tester) async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      container.read(customerNotificationsProvider.notifier).clearAll();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerAlertsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_off_outlined), findsOneWidget);
    });

    testWidgets('12. CustomerBookingsScreen displays empty state when bookings empty', (tester) async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      MockBookingService.setBookingsEmpty(true);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerBookingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    });

    testWidgets('13. T01 Material Consistency: Driver Dashboard, Trips & Admin render shared booking material (Timber & Plywood, not Cement)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      Future<void> pumpFrames() async {
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 300));
        }
      }

      // Verify source of truth booking has Timber & Plywood
      final primary = DemoDataService.createPrimaryBooking();
      expect(primary.materialType, ConstructionMaterial.timber);
      expect(primary.materialType.name, 'Timber & Plywood');

      // 1. Test Driver Home Dashboard
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: DriverHomeDashboard()),
          ),
        ),
      );
      await pumpFrames();

      // Driver Dashboard MUST show Timber & Plywood and MUST NOT show Cement
      expect(find.textContaining('Timber & Plywood'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Load: 5.5 Tons • Cement'), findsNothing);

      // 2. Test Driver Trips Screen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: DriverTripsScreen()),
          ),
        ),
      );
      await pumpFrames();

      // Driver Trips MUST show Timber & Plywood
      expect(find.textContaining('Timber & Plywood'), findsAtLeastNWidgets(1));
      expect(find.textContaining('5.5 Tons • Cement'), findsNothing);

      // 3. Test Admin Dashboard Screen Active Logistics Dispatches
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: AdminDashboardScreen()),
          ),
        ),
      );
      await pumpFrames();

      // Admin Dashboard Active Dispatches MUST show Order #BM-8492 • Timber & Plywood
      expect(find.textContaining('Order #BM-8492 • Timber & Plywood'), findsOneWidget);
      expect(find.textContaining('Order #BM-8492 • Cement'), findsNothing);

      // 4. Test Customer Confirmation Screen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: BookingConfirmationScreen()),
          ),
        ),
      );
      await pumpFrames();

      expect(find.textContaining('Timber & Plywood'), findsAtLeastNWidgets(1));

      // 5. Test Customer Live Tracking Screen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: LiveTrackingScreen(bookingId: 'BM-8492')),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Timber & Plywood'), findsAtLeastNWidgets(1));
    });
  });
}
