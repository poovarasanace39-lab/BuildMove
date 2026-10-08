import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/admin/screens/admin_fleet_screen.dart';
import 'package:flutter_application_1/features/admin/screens/admin_verifications_screen.dart';
import 'package:flutter_application_1/models/enums.dart';
import 'package:flutter_application_1/models/vehicle_model.dart';
import 'package:flutter_application_1/services/fleet/mock_fleet_service.dart';

void main() {
  setUp(() {
    MockFleetService.resetSeedData();
  });

  group('MockFleetService Unit Tests', () {
    test('1. Loads seeded drivers, driver users, and vehicles correctly', () async {
      final service = MockFleetService();

      final vehicles = await service.getVehicles();
      final drivers = await service.getDrivers();
      final users = await service.getDriverUsers();
      final pendingQueue = await service.getPendingVerifications();

      expect(vehicles.length, 8);
      expect(drivers.length, 8);
      expect(users.length, 8);
      expect(pendingQueue.length, 3);

      // Verify specific driver persona
      final murugan = await service.getDriverUser('usr_drv_002');
      expect(murugan?.name, 'Murugan K.');
      expect(murugan?.phone, '+91 9840123456');

      final muruganProfile = await service.getDriverById('usr_drv_002');
      expect(muruganProfile?.isApproved, true);
      expect(muruganProfile?.isOnline, true);
      expect(muruganProfile?.totalTrips, 148);

      final muruganVehicle = await service.getVehicleByDriverId('usr_drv_002');
      expect(muruganVehicle?.plateNumber, 'TN-02-AL-8921');
      expect(muruganVehicle?.isAvailable, true);
    });

    test('2. Updating driver approval activates driver and verifies vehicle documents', () async {
      final service = MockFleetService();

      // Before approval: usr_drv_009 (K. Anbalagan) is not approved
      final beforeDriver = await service.getDriverById('usr_drv_009');
      expect(beforeDriver?.isApproved, false);

      // Approve driver
      await service.updateDriverApproval('usr_drv_009', isApproved: true);

      final afterDriver = await service.getDriverById('usr_drv_009');
      expect(afterDriver?.isApproved, true);
      expect(afterDriver?.isOnline, true);

      final afterVehicle = await service.getVehicleByDriverId('usr_drv_009');
      expect(afterVehicle?.isAvailable, true);
      expect(afterVehicle?.documents.first.status, DocumentStatus.approved);

      // Verification queue should now have 2 items remaining
      final pendingQueue = await service.getPendingVerifications();
      expect(pendingQueue.length, 2);
      expect(pendingQueue.any((item) => item.id == 'DOC-9021'), false);
    });

    test('3. Updating driver rejection marks driver rejected with reason', () async {
      final service = MockFleetService();

      await service.updateDriverApproval(
        'usr_drv_010',
        isApproved: false,
        rejectionReason: 'Invalid Commercial License image',
      );

      final driver = await service.getDriverById('usr_drv_010');
      expect(driver?.isApproved, false);
      expect(driver?.rejectionReason, 'Invalid Commercial License image');

      final vehicle = await service.getVehicleByDriverId('usr_drv_010');
      expect(vehicle?.documents.first.status, DocumentStatus.rejected);

      // Pending queue drops from 3 to 2
      final pendingQueue = await service.getPendingVerifications();
      expect(pendingQueue.length, 2);
      expect(pendingQueue.any((item) => item.id == 'DOC-9022'), false);
    });

    test('4. Updating driver online status toggles isOnline flag', () async {
      final service = MockFleetService();

      // Murugan is online initially
      var driver = await service.getDriverById('usr_drv_002');
      expect(driver?.isOnline, true);

      await service.updateDriverOnlineStatus('usr_drv_002', false);
      driver = await service.getDriverById('usr_drv_002');
      expect(driver?.isOnline, false);

      await service.updateDriverOnlineStatus('usr_drv_002', true);
      driver = await service.getDriverById('usr_drv_002');
      expect(driver?.isOnline, true);
    });

    test('5. Updating vehicle availability toggles isAvailable flag', () async {
      final service = MockFleetService();

      var vehicle = await service.getVehicleById('veh_001');
      expect(vehicle?.isAvailable, true);

      await service.setVehicleAvailability('veh_001', false);
      vehicle = await service.getVehicleById('veh_001');
      expect(vehicle?.isAvailable, false);

      await service.setVehicleAvailability('veh_001', true);
      vehicle = await service.getVehicleById('veh_001');
      expect(vehicle?.isAvailable, true);
    });

    test('6. Adding and updating vehicles works as expected', () async {
      final service = MockFleetService();

      const newVehicle = VehicleModel(
        id: 'veh_test_999',
        driverId: 'usr_drv_002',
        type: VehicleType.tataAce,
        modelName: 'Tata Ace Super (1.0T)',
        plateNumber: 'TN-01-AB-1234',
        capacityTons: 1.0,
        isAvailable: true,
      );

      await service.addVehicle(newVehicle);
      var fetched = await service.getVehicleById('veh_test_999');
      expect(fetched?.modelName, 'Tata Ace Super (1.0T)');

      // Update vehicle
      final updated = newVehicle.copyWith(modelName: 'Tata Ace Super Max (1.2T)');
      await service.updateVehicle(updated);
      fetched = await service.getVehicleById('veh_test_999');
      expect(fetched?.modelName, 'Tata Ace Super Max (1.2T)');
    });
  });

  group('Admin Screen Fleet & Verifications Integration Tests', () {
    Widget buildTestApp({required Widget child}) {
      return ProviderScope(
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

    testWidgets('7. AdminFleetScreen displays typed seeded vehicles and allows availability toggling',
        (tester) async {
      await tester.pumpWidget(buildTestApp(child: const AdminFleetScreen()));
      await tester.pumpAndSettle();

      // Verify plate numbers from typed collection render
      expect(find.text('TN-02-AL-8921'), findsOneWidget);
      expect(find.text('TN-14-BD-2311'), findsOneWidget);
      expect(find.text('TN-09-PQ-9081'), findsOneWidget);

      // Verify driver association and vehicle model
      expect(find.textContaining('Murugan K.'), findsOneWidget);
      expect(find.textContaining('6-Wheeler Tipper'), findsWidgets);

      // Verify operational status
      expect(find.text('Available Online'), findsWidgets);

      // Toggle availability of first vehicle
      final toggleButton = find.text('Toggle Off').first;
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      // Should show SnackBar feedback
      expect(find.textContaining('set to Unavailable'), findsOneWidget);
    });

    testWidgets('8. AdminVerificationsScreen displays pending KYC queue and approves driver reactively',
        (tester) async {
      await tester.pumpWidget(buildTestApp(child: const AdminVerificationsScreen()));
      await tester.pumpAndSettle();

      // Check initial 3 verification items
      expect(find.text('DOC-9021'), findsOneWidget);
      expect(find.text('DOC-9022'), findsOneWidget);
      expect(find.text('DOC-9023'), findsOneWidget);
      expect(find.text('K. Anbalagan'), findsOneWidget);

      // Tap Approve on the first item (DOC-9021)
      final approveButtons = find.text('Approve');
      expect(approveButtons, findsNWidgets(3));

      await tester.tap(approveButtons.first);
      await tester.pumpAndSettle();

      // SnackBar confirmation should appear
      expect(find.textContaining('K. Anbalagan documents APPROVED. Driver activated.'), findsOneWidget);

      // DOC-9021 should now be removed from the pending queue
      expect(find.text('DOC-9021'), findsNothing);
      expect(find.text('DOC-9022'), findsOneWidget);
      expect(find.text('DOC-9023'), findsOneWidget);
    });

    testWidgets('9. AdminVerificationsScreen rejects item and shows clear state when queue empty',
        (tester) async {
      await tester.pumpWidget(buildTestApp(child: const AdminVerificationsScreen()));
      await tester.pumpAndSettle();

      // Reject all 3 items sequentially
      for (var i = 0; i < 3; i++) {
        final rejectButton = find.text('Reject').first;
        await tester.tap(rejectButton);
        await tester.pumpAndSettle();
      }

      // SnackBar should confirm rejection
      expect(find.textContaining('documents REJECTED.'), findsOneWidget);

      // When queue is empty, the empty state message appears
      expect(find.text('All Verification Queue Clear'), findsOneWidget);
      expect(find.text('No pending driver documents awaiting approval.'), findsOneWidget);
    });
  });
}
