import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/customer/screens/customer_home_dashboard.dart';
import 'package:flutter_application_1/features/booking/screens/material_quantity_screen.dart';
import 'package:flutter_application_1/features/booking/screens/vehicle_selection_screen.dart';
import 'package:flutter_application_1/features/booking/screens/booking_confirmation_screen.dart';
import 'package:flutter_application_1/features/customer/screens/customer_profile_screen.dart';
import 'package:flutter_application_1/features/tracking/screens/live_tracking_screen.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';
import 'package:flutter_application_1/features/customer/screens/customer_bookings_screen.dart';
import 'package:flutter_application_1/core/routing/app_router.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/enums.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

class _TestAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState(
      currentUser: UserModel(
        id: 'usr_cust_001',
        phone: '+91 9876543210',
        name: 'Rajesh',
        role: UserRole.customer,
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
  });

  Widget createTestWidget({
    required Widget child,
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en', ''),
  }) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          return MaterialApp(
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: locale,
            home: child,
          );
        },
      ),
    );
  }

  Widget createRouterTestWidget({
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authProvider.overrideWith(() => _TestAuthNotifier()),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(appRouterProvider);
          return MaterialApp.router(
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }

  group('BuildMove UI Reference Match Tests', () {
    testWidgets('CustomerHomeDashboard renders reference elements in Light Theme', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const CustomerHomeDashboard()),
      );
      await tester.pumpAndSettle();

      // Check top branding and customer home subtitle
      expect(find.text('Build'), findsOneWidget);
      expect(find.text('Move'), findsOneWidget);
      expect(find.text('Customer Home'), findsOneWidget);

      // Check contractor greeting and badge
      expect(find.text('Hi, Rajesh'), findsOneWidget);
      expect(find.text('Kavitha Constructions'), findsOneWidget);
      expect(find.text('TN'), findsOneWidget);
      expect(find.text('Fleet'), findsOneWidget);

      // Check hero booking card
      expect(find.text('Where are you moving materials?'), findsOneWidget);
      expect(find.text('LOADING POINT'), findsOneWidget);
      expect(find.text('UNLOADING SITE'), findsOneWidget);
      expect(find.text('GPS Auto'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('BOOK A VEHICLE'), findsOneWidget);
      expect(find.text('3 min dispatch'), findsOneWidget);
      expect(find.text('Digital Weigh-Slip'), findsOneWidget);

      // Check 6-item materials grid
      expect(find.text('Cement'), findsOneWidget);
      expect(find.text('M-Sand'), findsOneWidget);
      expect(find.text('TMT Steel'), findsOneWidget);
      expect(find.text('Bricks'), findsOneWidget);
      expect(find.text('Blue Metal'), findsOneWidget);
      expect(find.text('Tiles & Granite'), findsOneWidget);

      // Check recent booking card
      expect(find.text('Recent Deliveries'), findsOneWidget);
      expect(find.text('Cement (5 Tons)'), findsOneWidget);
      expect(find.text('Reorder'), findsOneWidget);
    });

    testWidgets('CustomerHomeDashboard renders reference elements in Dark Theme', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const CustomerHomeDashboard(), themeMode: ThemeMode.dark),
      );
      await tester.pumpAndSettle();

      expect(find.text('Build'), findsOneWidget);
      expect(find.text('Where are you moving materials?'), findsOneWidget);
      expect(find.text('Reorder'), findsOneWidget);
    });

    testWidgets('MaterialQuantityScreen renders Step 1 of 3 elements', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const MaterialQuantityScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('Material & Load'), findsOneWidget);
      expect(find.text('What are you transporting?'), findsOneWidget);
      expect(find.text('How much do you need to move?'), findsOneWidget);
      expect(find.text('TONS (Metric)'), findsOneWidget);
      expect(find.text('BAGS (50kg)'), findsOneWidget);
      expect(find.text('LOADS (CFT)'), findsOneWidget);
      expect(find.text('- 0.5 T'), findsOneWidget);
      expect(find.text('+ 0.5 T'), findsOneWidget);
      expect(find.text('5 Tons'), findsOneWidget);
      expect(find.text('Continue to Select Vehicle'), findsOneWidget);
    });

    testWidgets('VehicleSelectionScreen renders Step 2 of 3 elements', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const VehicleSelectionScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('STEP 2 OF 3'), findsOneWidget);
      expect(find.text('GPS Live Radar Active'), findsOneWidget);
      expect(find.text('Choose Vehicle'), findsOneWidget);
      expect(find.text('6-Wheeler Tipper'), findsNWidgets(2)); // Selection card + sticky bottom summary
      expect(find.text('Best match'), findsOneWidget);
      expect(find.text('Bolero Maxi / Ace Mega'), findsOneWidget);
      expect(find.text('10-Wheeler Heavy Dumper'), findsOneWidget);
      expect(find.text('BuildMove Price Guarantee'), findsOneWidget);
      expect(find.text('Proceed to Review Booking'), findsOneWidget);
    });

    testWidgets('BookingConfirmationScreen renders confirmation details', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const BookingConfirmationScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Review & Confirm'), findsNWidgets(2)); // AppBar + body title
      expect(find.text('VERIFIED TRIP   #BM-8492'), findsOneWidget);
      expect(find.text('Haulage Summary'), findsOneWidget);
      expect(find.text('Ready to Dispatch'), findsOneWidget);
      expect(find.text('Murugan K.'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('Total Fare'), findsOneWidget);
      expect(find.text('Base Transport (up to 10 km)'), findsOneWidget);
      expect(find.text('60 mins Free'), findsOneWidget);
      expect(find.text('Settlement Method'), findsOneWidget);
      expect(find.text('Cash after Unloading'), findsOneWidget);
      expect(find.text('Confirm Booking'), findsOneWidget);
    });

    testWidgets('LiveTrackingScreen renders tracking canvas and driver card', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const LiveTrackingScreen(bookingId: 'BM-8492')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Live Tracking'), findsOneWidget);
      expect(find.text('GPS Live Radar • 2.4 km away'), findsOneWidget);
      expect(find.text('SOS HELP'), findsOneWidget);
      expect(find.text('Vehicle arriving'), findsOneWidget);
      expect(find.text('11:42 AM'), findsOneWidget);
      expect(find.text('TARGET ETA'), findsOneWidget);
      expect(find.text('CLEARED'), findsOneWidget);
      expect(find.text('Murugan K.'), findsOneWidget);
      expect(find.text('Call Driver'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
      expect(find.text('Gate Pass'), findsOneWidget);
    });

    testWidgets('CustomerProfileScreen renders properly in Light Theme with high-contrast elements', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const CustomerProfileScreen(), themeMode: ThemeMode.light),
      );
      await tester.pumpAndSettle();

      // Check header info
      expect(find.text('Profile'), findsOneWidget);
      expect(find.textContaining('Site Engineer'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);
      expect(find.text('Customer'), findsOneWidget);

      // Check settings card items
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Company / GST Details'), findsOneWidget);
      expect(find.text('BuildCon Infra Pvt Ltd • 33AAAAA0000A1Z5'), findsOneWidget);
      expect(find.text('Saved Construction Sites'), findsOneWidget);
      expect(find.text('2 Registered Work Sites'), findsOneWidget);
      expect(find.text('Help & Site Logistics Support'), findsOneWidget);
      expect(find.text('24x7 Porter & Dispatch Assistance'), findsOneWidget);

      // Check logout button
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('CustomerProfileScreen renders properly in Dark Theme with high-contrast text and dark cards', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const CustomerProfileScreen(), themeMode: ThemeMode.dark),
      );
      await tester.pumpAndSettle();

      // Check header info
      expect(find.text('Profile'), findsOneWidget);
      expect(find.textContaining('Site Engineer'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);
      expect(find.text('Customer'), findsOneWidget);

      // Check settings card items in dark mode
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Company / GST Details'), findsOneWidget);
      expect(find.text('Saved Construction Sites'), findsOneWidget);
      expect(find.text('Help & Site Logistics Support'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('CustomerProfileScreen theme toggle switches theme smoothly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const CustomerProfileScreen(), themeMode: ThemeMode.light),
      );
      await tester.pumpAndSettle();

      final themeToggle = find.byTooltip('Switch to Dark Mode');
      expect(themeToggle, findsOneWidget);
      await tester.tap(themeToggle);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('CustomerBookingsScreen renders active and past booking records with required fields', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(
        createTestWidget(child: const CustomerBookingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bookings'), findsOneWidget);
      expect(find.text('Active Dispatches'), findsOneWidget);
      expect(find.text('Past Deliveries'), findsOneWidget);

      // Verify active bookings contain Order #, pickup, drop, and fare
      expect(find.textContaining('Order #'), findsWidgets);
      expect(find.textContaining('Dalmia Cement Depot'), findsWidgets);
      expect(find.textContaining('Construction Site, OMR'), findsWidgets);
      expect(find.textContaining('₹'), findsWidgets);

      // Switch to Past Deliveries tab
      await tester.tap(find.text('Past Deliveries'));
      await tester.pumpAndSettle();

      // Check past deliveries
      expect(find.textContaining('Order #'), findsWidgets);
      expect(find.textContaining('₹'), findsWidgets);
    });

    testWidgets('Customer Home screen View all navigates to customer Bookings/Order History', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createRouterTestWidget());
      await tester.pumpAndSettle();

      // Tap View all in Recent Deliveries
      final viewAllFinder = find.text('View all');
      expect(viewAllFinder, findsOneWidget);
      await tester.ensureVisible(viewAllFinder);
      await tester.tap(viewAllFinder);
      await tester.pumpAndSettle();

      // Must be on Bookings screen, NOT on Material & Quantity
      expect(find.text('Bookings'), findsOneWidget);
      expect(find.text('Past Deliveries'), findsOneWidget);
      expect(find.text('Material & Quantity'), findsNothing);
    });

    testWidgets('Customer Home screen BOOK A VEHICLE navigates to Material & Quantity (Step 1 of 3)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createRouterTestWidget());
      await tester.pumpAndSettle();

      // Tap BOOK A VEHICLE
      final bookVehicleFinder = find.text('BOOK A VEHICLE');
      expect(bookVehicleFinder, findsOneWidget);
      await tester.tap(bookVehicleFinder);
      await tester.pumpAndSettle();

      // Must be on Material & Quantity screen
      expect(find.text('Material & Quantity'), findsOneWidget);
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
    });
  });
}
