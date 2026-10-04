import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/utils/navigation_launcher.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';
import 'package:flutter_application_1/features/driver/screens/driver_home_dashboard.dart';
import 'package:flutter_application_1/features/driver/screens/driver_trips_screen.dart';
import 'package:flutter_application_1/models/enums.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/services/booking/mock_booking_service.dart';

class _TestDriverAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState(
      currentUser: UserModel(
        id: 'usr_drv_002',
        phone: '+91 9840123456',
        name: 'VelMurugan S.',
        role: UserRole.driver,
        isVerified: true,
        createdAt: DateTime(2026, 1, 1),
      ),
      isLoading: false,
    );
  }
}

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    MockBookingService.resetSeedData();
  });

  Widget buildDriverApp({
    required Widget child,
    Locale locale = const Locale('en', ''),
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authProvider.overrideWith(() => _TestDriverAuthNotifier()),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          return MaterialApp(
            locale: locale,
            supportedLocales: const [Locale('en', ''), Locale('ta', '')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: child,
          );
        },
      ),
    );
  }

  Future<void> pumpScreen(WidgetTester tester) async {
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  group('Driver Flow & Google Maps Navigation Tests', () {
    testWidgets(
      '1. Scenario: Assigned trip shows Navigate to Pickup and Start Trip, but NOT Complete Delivery',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildDriverApp(child: const DriverHomeDashboard()),
        );
        await pumpScreen(tester);

        // Trip BM-8492 is assigned
        expect(find.text('Job #BM-8492'), findsOneWidget);
        expect(find.text('Fare: ₹1850'), findsOneWidget);
        expect(find.text('Driver Assigned'), findsOneWidget);

        // Actions for ASSIGNED status
        expect(
          find.byKey(const Key('driver_nav_pickup_button')),
          findsOneWidget,
        );
        expect(find.text('Navigate to Pickup'), findsOneWidget);
        expect(
          find.byKey(const Key('driver_start_trip_button')),
          findsOneWidget,
        );
        expect(find.text('Start Trip (Loaded)'), findsOneWidget);

        // Complete delivery must NOT be visible before starting trip
        expect(
          find.byKey(const Key('driver_complete_delivery_button')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('driver_nav_delivery_button')),
          findsNothing,
        );

        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      '2. Scenario: Start Trip updates status to In Transit (Loaded) and unlocks Navigate to Delivery',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildDriverApp(child: const DriverHomeDashboard()),
        );
        await pumpScreen(tester);

        // Tap Start Trip (Loaded)
        await tester.tap(find.byKey(const Key('driver_start_trip_button')));
        await pumpScreen(tester);

        // Status must now be In Transit
        expect(find.text('In Transit (Loaded)'), findsOneWidget);

        // Navigate to Pickup is gone; Navigate to Delivery & Complete Delivery are now available
        expect(find.byKey(const Key('driver_nav_pickup_button')), findsNothing);
        expect(
          find.byKey(const Key('driver_nav_delivery_button')),
          findsOneWidget,
        );
        expect(find.text('Navigate to Delivery'), findsOneWidget);
        expect(
          find.byKey(const Key('driver_complete_delivery_button')),
          findsOneWidget,
        );
        expect(find.text('Complete Delivery (Unloaded)'), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      '3. Scenario: Complete Delivery shows confirmation dialog first, then marks Delivered',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildDriverApp(child: const DriverHomeDashboard()),
        );
        await pumpScreen(tester);

        // 1. Transition to inProgress
        await tester.tap(find.byKey(const Key('driver_start_trip_button')));
        await pumpScreen(tester);

        // 2. Tap Complete Delivery (Unloaded)
        await tester.tap(
          find.byKey(const Key('driver_complete_delivery_button')),
        );
        await pumpScreen(tester);

        // 3. Confirmation dialog must appear
        expect(find.text('Confirm Delivery'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(
          find.byKey(const Key('confirm_complete_delivery_dialog_button')),
          findsOneWidget,
        );

        // 4. Confirm completion
        await tester.tap(
          find.byKey(const Key('confirm_complete_delivery_dialog_button')),
        );
        await pumpScreen(tester);

        // Trip is completed and no longer active in assigned card
        expect(
          find.text('Delivery Completed! Load moved to completed trips.'),
          findsOneWidget,
        );
        expect(find.text('No Active Assigned Load'), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
      },
    );

    test(
      '4. Scenario: Completed trip cannot be completed again & service enforces strict order',
      () async {
        final service = MockBookingService();

        // Attempting to complete unstarted trip BM-8492 (status: accepted)
        final prematureResult = await service.endTrip('BM-8492');
        expect(prematureResult.isFailure, isTrue);

        // Start trip
        final startResult = await service.startTrip('BM-8492');
        expect(startResult.isSuccess, isTrue);

        // Complete trip
        final endResult = await service.endTrip('BM-8492');
        expect(endResult.isSuccess, isTrue);

        // Attempting to complete already completed trip
        final doubleEndResult = await service.endTrip('BM-8492');
        expect(doubleEndResult.isFailure, isTrue);

        // Attempting to start already completed trip
        final restartResult = await service.startTrip('BM-8492');
        expect(restartResult.isFailure, isTrue);
      },
    );

    testWidgets(
      '5. Scenario: Trips screen and Dashboard show consistent statuses and fixed fares',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildDriverApp(child: const DriverTripsScreen()),
        );
        await pumpScreen(tester);

        // Active tab shows BM-8492 with exact fare ₹1850 and Driver Assigned status
        expect(find.text('Active Dispatches'), findsOneWidget);
        expect(find.text('Past Deliveries'), findsOneWidget);
        expect(find.text('Load #BM-8492'), findsOneWidget);
        expect(find.text('Fare: ₹1850'), findsOneWidget);
        expect(find.text('Driver Assigned'), findsOneWidget);

        // Tap Past Deliveries tab
        await tester.tap(find.text('Past Deliveries'));
        await pumpScreen(tester);

        // Completed seed trip BM-2026-079 has exact fare ₹1100
        expect(find.text('Load #BM-2026-079'), findsOneWidget);
        expect(find.text('Fare: ₹1100'), findsOneWidget);
        expect(find.text('Delivered Successfully'), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      '6. Scenario: Tamil localization isolates Tamil text on Driver screens',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildDriverApp(
            child: const DriverHomeDashboard(),
            locale: const Locale('ta', ''),
          ),
        );
        await pumpScreen(tester);

        // Tamil labels must be present
        expect(find.text('பணி #BM-8492'), findsOneWidget);
        expect(find.text('கட்டணம்: ₹1850'), findsOneWidget);
        expect(find.text('ஏற்றும் இடத்திற்கு வழி'), findsOneWidget);
        expect(
          find.text('பயணத்தை தொடங்கு (சரக்கு ஏற்றிய பின்)'),
          findsOneWidget,
        );
        expect(find.text('இன்றைய வருமானம்'), findsOneWidget);
        expect(find.text('புதிய சரக்கு கோரிக்கைகள்'), findsOneWidget);

        // English action text must NOT appear
        expect(find.text('Navigate to Pickup'), findsNothing);
        expect(find.text('Start Trip (Loaded)'), findsNothing);
        expect(find.text('Incoming Load Requests'), findsNothing);

        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      '7. Scenario: NavigationLauncher validates empty/null addresses gracefully',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        late BuildContext testContext;
        await tester.pumpWidget(
          buildDriverApp(
            child: Scaffold(
              body: Builder(
                builder: (ctx) {
                  testContext = ctx;
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
        await pumpScreen(tester);

        // Testing empty address validation
        final resultEmpty = await NavigationLauncher.openDirections(
          context: testContext,
          destinationAddress: '',
        );
        expect(resultEmpty, isFalse);
        await pumpScreen(tester);

        expect(
          find.text(
            'Address is missing or invalid. Unable to open navigation.',
          ),
          findsOneWidget,
        );

        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets('8. Scenario: Dark theme renders properly on Driver screens', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildDriverApp(
          child: const DriverHomeDashboard(),
          themeMode: ThemeMode.dark,
        ),
      );
      await pumpScreen(tester);

      // Verify dashboard elements render cleanly under dark theme
      expect(find.text('Job #BM-8492'), findsOneWidget);
      expect(find.text('Navigate to Pickup'), findsOneWidget);
      expect(find.text('Start Trip (Loaded)'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });
  });
}
