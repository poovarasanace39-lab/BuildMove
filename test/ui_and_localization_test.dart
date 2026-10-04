import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/localization/app_localizations.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';
import 'package:flutter_application_1/features/customer/screens/customer_home_dashboard.dart';
import 'package:flutter_application_1/features/customer/screens/customer_profile_screen.dart';
import 'package:flutter_application_1/features/customer/screens/customer_shell_screen.dart';
import 'package:flutter_application_1/models/enums.dart';
import 'package:flutter_application_1/models/user_model.dart';

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

  Widget buildAppWithProviders({
    required Widget child,
    Locale? initialLocale,
  }) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authProvider.overrideWith(() => _TestAuthNotifier()),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final locale = initialLocale ?? ref.watch(appLocaleProvider);
          return MaterialApp(
            locale: locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ta', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: child,
          );
        },
      ),
    );
  }

  group('Phase UI & Localization Tests', () {
    testWidgets('1. Language Isolation: English mode displays English only without dual subtitles', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerHomeDashboard(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // English titles should be present
      expect(find.text('Cement'), findsWidgets);
      expect(find.text('M-Sand'), findsWidgets);
      expect(find.text('BOOK A VEHICLE'), findsOneWidget);
      expect(find.text('What are you moving?'), findsOneWidget);

      // Tamil subtitle text should NOT be rendered underneath or in titles
      expect(find.text('சிமெண்ட்'), findsNothing);
      expect(find.text('மணல்'), findsNothing);
      expect(find.text('வாகனம் முன்பதிவு செய்'), findsNothing);
      expect(find.text('என்ன நகர்த்த வேண்டும்?'), findsNothing);
    });

    testWidgets('2. Language Isolation: Tamil mode displays Tamil only without English subtitles', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerHomeDashboard(),
          initialLocale: const Locale('ta', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Tamil titles should be present
      expect(find.text('சிமெண்ட்'), findsWidgets);
      expect(find.text('மணல்'), findsWidgets);
      expect(find.text('வாகனம் முன்பதிவு செய்'), findsOneWidget);
      expect(find.text('என்ன நகர்த்த வேண்டும்?'), findsOneWidget);

      // English material labels and action titles should NOT be rendered
      expect(find.text('Cement'), findsNothing);
      expect(find.text('M-Sand'), findsNothing);
      expect(find.text('BOOK A VEHICLE'), findsNothing);
      expect(find.text('What are you moving?'), findsNothing);
    });

    testWidgets('3. Notification bell exists with unread count and switches to Alerts tab', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerShellScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Check notification bell icon exists in Home
      final bellFinder = find.byKey(const Key('home_notification_bell'));
      expect(bellFinder, findsOneWidget);

      // Tap the notification bell
      await tester.tap(bellFinder);
      await tester.pumpAndSettle();

      // Should now be on Alerts screen (one in header, one in bottom nav)
      expect(find.text('Alerts'), findsNWidgets(2));
      expect(find.text('Mark All as Read'), findsOneWidget);

      // Verify mock notifications are shown
      expect(find.text('Driver Murugan K. Assigned'), findsOneWidget);
      expect(find.text('Material In Transit'), findsOneWidget);

      // Tap 'Mark All as Read'
      await tester.tap(find.text('Mark All as Read'));
      await tester.pumpAndSettle();

      // All unread badges should disappear
      expect(find.text('UNREAD'), findsNothing);
    });

    testWidgets('4. Profile: Language selector changes locale immediately and persists', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerProfileScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Language tile
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Sheet with English and Tamil should appear
      expect(find.text('Select Your Preferred Language'), findsOneWidget);
      expect(find.text('தமிழ்'), findsOneWidget);

      // Select Tamil
      await tester.tap(find.text('தமிழ்'));
      await tester.pumpAndSettle();

      // Locale in SharedPreferences should now be 'ta'
      expect(prefs.getString(AppConstants.keyAppLocale), equals('ta'));
    });

    testWidgets('5. Profile: Company / GST Details modal opens and validates input', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerProfileScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Open Company / GST Details
      await tester.tap(find.text('Company / GST Details'));
      await tester.pumpAndSettle();

      expect(find.text('Company & Tax Information'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      // Entering invalid GST (<15 chars)
      final gstField = find.byType(TextFormField).at(1);
      await tester.enterText(gstField, 'INVALID123');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Error message should appear
      expect(find.text('Please enter a valid 15-character GSTIN'), findsOneWidget);

      // Enter valid GST (15 chars)
      await tester.enterText(gstField, '33AABCK1234F1Z5');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Modal closed and success message shown
      expect(find.text('Company & Tax Information'), findsNothing);
    });

    testWidgets('6. Profile: Saved Construction Sites displays registered work locations', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerProfileScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Open Saved Sites
      await tester.tap(find.text('Saved Construction Sites'));
      await tester.pumpAndSettle();

      expect(find.text('Registered Construction Sites'), findsOneWidget);
      expect(find.text('Site Phase 2, OMR Navalur'), findsOneWidget);
      expect(find.text('Commercial Tower Block C, Ambattur'), findsOneWidget);
    });

    testWidgets('7. Profile: Site Manager Contacts opens sheet with Call and Message actions', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerProfileScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Open Site Manager Contacts
      await tester.tap(find.text('Site Manager Contact Information'));
      await tester.pumpAndSettle();

      expect(find.text('Site Contact Information'), findsOneWidget);
      expect(find.text('Sundaram M.'), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsWidgets);
      expect(find.byIcon(Icons.chat), findsWidgets);

      // Tap phone icon on first item
      await tester.tap(find.byIcon(Icons.phone).first);
      await tester.pumpAndSettle();

      // Should open simulated call dialog with demo disclosure
      expect(find.text('Simulated Phone Call'), findsOneWidget);
      expect(find.text('Copy Phone Number'), findsOneWidget);
    });

    testWidgets('8. Profile: Help & Site Logistics Support opens FAQ sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerProfileScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Open Help & Logistics Support
      await tester.tap(find.text('Help & Site Logistics Support'));
      await tester.pumpAndSettle();

      expect(find.text('Help & Site Logistics Support'), findsWidgets);
      expect(find.text('Frequently Asked Questions'), findsOneWidget);
    });

    testWidgets('9. Profile: Logout displays confirmation dialog before exiting', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerProfileScreen(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to bottom and tap Logout
      final logoutFinder = find.text('Logout');
      await tester.ensureVisible(logoutFinder);
      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text('Are you sure you want to log out of BuildMove?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tapping cancel dismisses dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to log out of BuildMove?'), findsNothing);
    });

    testWidgets('10. Home: GPS Auto and Recent location chips show simulated demo dialog', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildAppWithProviders(
          child: const CustomerHomeDashboard(),
          initialLocale: const Locale('en', ''),
        ),
      );
      await tester.pumpAndSettle();

      // Tap GPS Auto chip
      await tester.tap(find.text('GPS Auto'));
      await tester.pumpAndSettle();

      expect(find.text('Simulated GPS Location'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Tap Recent chip
      await tester.tap(find.text('Recent'));
      await tester.pumpAndSettle();

      expect(find.text('Recent Construction Site'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
    });
  });
}
