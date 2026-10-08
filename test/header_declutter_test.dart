import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/localization/app_localizations.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';
import 'package:flutter_application_1/features/booking/screens/material_quantity_screen.dart';
import 'package:flutter_application_1/features/booking/screens/vehicle_selection_screen.dart';
import 'package:flutter_application_1/features/booking/screens/booking_confirmation_screen.dart';
import 'package:flutter_application_1/features/tracking/screens/live_tracking_screen.dart';
import 'package:flutter_application_1/features/customer/screens/customer_home_dashboard.dart';
import 'package:flutter_application_1/features/customer/screens/customer_profile_screen.dart';
import 'package:flutter_application_1/features/customer/screens/customer_shell_screen.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/enums.dart';

class _TestAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState(
      currentUser: UserModel(
        id: 'usr_cust_001',
        phone: '+91 9876543210',
        name: 'Ramesh Sundaram',
        role: UserRole.customer,
        isVerified: true,
        createdAt: DateTime(2026, 1, 1),
      ),
      isLoading: false,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Widget createTestWidget({
    required Widget child,
    Locale? locale,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authProvider.overrideWith(() => _TestAuthNotifier()),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final effectiveLocale = locale ?? ref.watch(appLocaleProvider);
          return MaterialApp(
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: effectiveLocale,
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
          );
        },
      ),
    );
  }

  group('T04 Header Decluttering & Navigation Consistency Tests', () {
    testWidgets('1. Material & Quantity wizard header contains only back & title, no settings/profile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const MaterialQuantityScreen()));
      await tester.pumpAndSettle();

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      // Back navigation & Title present
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.arrow_back)), findsOneWidget);
      expect(find.descendant(of: appBarFinder, matching: find.text('Material & Quantity')), findsOneWidget);

      // Theme toggle, language capsule, and profile avatar absent from header
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.wb_sunny_rounded)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.nightlight_round)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.person)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('EN')), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('TA')), findsNothing);
    });

    testWidgets('2. Available Vehicles wizard header contains only back & title, no settings/profile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const VehicleSelectionScreen()));
      await tester.pumpAndSettle();

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      // Back navigation & Title present
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.arrow_back)), findsOneWidget);
      expect(find.descendant(of: appBarFinder, matching: find.text('Available Vehicles')), findsOneWidget);

      // Settings/profile absent
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.wb_sunny_rounded)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.nightlight_round)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.person)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('EN')), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('TA')), findsNothing);
    });

    testWidgets('3. Review & Confirm wizard header contains only back & title, no settings/profile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const BookingConfirmationScreen()));
      await tester.pumpAndSettle();

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      // Back navigation & Title present
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.arrow_back)), findsOneWidget);
      expect(find.descendant(of: appBarFinder, matching: find.text('Review & Confirm')), findsOneWidget);

      // Settings/profile absent
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.wb_sunny_rounded)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.nightlight_round)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.person)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('EN')), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('TA')), findsNothing);
    });

    testWidgets('4. Live Tracking header contains only navigation, live indicator & title', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const LiveTrackingScreen(bookingId: 'BM-8492')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.arrow_back)), findsOneWidget);
      expect(find.descendant(of: appBarFinder, matching: find.text('Live Tracking')), findsOneWidget);

      // No theme/language/profile controls in tracking header
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.wb_sunny_rounded)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.nightlight_round)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.byIcon(Icons.person)), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('EN')), findsNothing);
      expect(find.descendant(of: appBarFinder, matching: find.text('TA')), findsNothing);
    });

    testWidgets('5. Customer Home: TN Fleet badge is removed and decorative waveforms are removed', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const CustomerHomeDashboard()));
      await tester.pumpAndSettle();

      // TN Fleet badge is removed
      expect(find.text('TN'), findsNothing);

      // Decorative waveform icons next to Loading Point and Unloading Site are removed
      expect(find.byIcon(Icons.graphic_eq_rounded), findsNothing);
      expect(find.byIcon(Icons.waves_rounded), findsNothing);

      // Clean, essential content remains
      expect(find.text('Build'), findsOneWidget);
      expect(find.text('Move'), findsOneWidget);
      expect(find.text('Hi, Ramesh'), findsOneWidget);
      expect(find.text('LOADING POINT'), findsOneWidget);
      expect(find.text('UNLOADING SITE'), findsOneWidget);
    });

    testWidgets('6. Notifications: Single clear notification entry point in Home, no competing badge', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const CustomerShellScreen()));
      await tester.pumpAndSettle();

      // Home notification bell exists as a clean entry point
      final bellFinder = find.byKey(const Key('home_notification_bell'));
      expect(bellFinder, findsOneWidget);

      // Tap navigates to Alerts tab
      await tester.tap(bellFinder);
      await tester.pumpAndSettle();

      expect(find.text('Alerts'), findsNWidgets(2)); // Header + bottom nav
    });

    testWidgets('7. Profile Settings: Theme & Language are accessible and functional', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(child: const CustomerProfileScreen()));
      await tester.pumpAndSettle();

      // Theme tile is accessible in Settings
      expect(find.byKey(const Key('profile_theme_tile')), findsOneWidget);
      expect(find.text('Appearance Theme'), findsOneWidget);

      // Language tile is accessible in Settings
      expect(find.byKey(const Key('profile_language_tile')), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);

      // Tap Language tile opens selection sheet
      await tester.tap(find.byKey(const Key('profile_language_tile')));
      await tester.pumpAndSettle();

      expect(find.text('Select Your Preferred Language'), findsOneWidget);
      expect(find.text('தமிழ்'), findsOneWidget);
    });

    testWidgets('8. Tamil localization: Wizard and Profile headers translate cleanly', (tester) async {
      await prefs.setString(AppConstants.keyAppLocale, 'ta');
      await tester.binding.setSurfaceSize(const Size(400, 900));
      await tester.pumpWidget(createTestWidget(
        child: const MaterialQuantityScreen(),
        locale: const Locale('ta', ''),
      ));
      await tester.pumpAndSettle();

      // Step 1 title in Tamil
      expect(find.text('பொருள் & அளவு'), findsOneWidget);

      // Switch to Profile in Tamil
      await tester.pumpWidget(createTestWidget(
        child: const CustomerProfileScreen(),
        locale: const Locale('ta', ''),
      ));
      await tester.pumpAndSettle();

      expect(find.text('சுயவிவரம்'), findsOneWidget);
      expect(find.text('வடிவமைப்பு தோற்றம்'), findsOneWidget); // Appearance Theme in Tamil
      expect(find.text('மொழி'), findsOneWidget); // Language in Tamil
    });
  });
}
