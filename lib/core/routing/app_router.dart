import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/screens/admin_shell_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/phone_login_screen.dart';
import '../../features/booking/screens/booking_confirmation_screen.dart';
import '../../features/booking/screens/booking_locations_screen.dart';
import '../../features/booking/screens/material_quantity_screen.dart';
import '../../features/booking/screens/vehicle_selection_screen.dart';
import '../../features/customer/screens/customer_bookings_screen.dart';
import '../../features/customer/screens/customer_shell_screen.dart';
import '../../features/driver/screens/driver_shell_screen.dart';
import '../../features/language/language_selection_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tracking/screens/live_tracking_screen.dart';
import '../../models/enums.dart';
import 'app_routes.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelection,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),

      // Customer Role Shell
      GoRoute(
        path: AppRoutes.customerHome,
        builder: (context, state) => const CustomerShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerBookings,
        builder: (context, state) {
          final tabStr = state.uri.queryParameters['tab'];
          final initialTab = (tabStr == 'history' || tabStr == 'past') ? 1 : 0;
          return CustomerBookingsScreen(
            initialTabIndex: initialTab,
            showBackButton: true,
          );
        },
      ),

      // Customer Booking Flow (Figma Flow)
      GoRoute(
        path: AppRoutes.customerMaterialQuantity,
        builder: (context, state) => const MaterialQuantityScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerLocations,
        builder: (context, state) => const BookingLocationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerVehicleSelection,
        builder: (context, state) => const VehicleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerBookingConfirmation,
        builder: (context, state) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerLiveTracking,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'BM-8492';
          return LiveTrackingScreen(bookingId: id);
        },
      ),

      // Driver Role
      GoRoute(
        path: AppRoutes.driverHome,
        builder: (context, state) => const DriverShellScreen(),
      ),

      // Admin Role
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminShellScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);
      final loc = state.matchedLocation;

      // Allow splash, language, login, and OTP routes freely
      final isPublicRoute = loc == AppRoutes.splash ||
          loc == AppRoutes.languageSelection ||
          loc == AppRoutes.login ||
          loc == AppRoutes.otpVerification;

      if (!authState.isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      // If authenticated, enforce proper role routes
      if (authState.isAuthenticated) {
        final role = authState.currentUser?.role ?? UserRole.customer;

        // Redirect from login/splash to respective role home
        if (loc == AppRoutes.login || loc == AppRoutes.splash) {
          switch (role) {
            case UserRole.customer:
              return AppRoutes.customerHome;
            case UserRole.driver:
              return AppRoutes.driverHome;
            case UserRole.admin:
              return AppRoutes.adminDashboard;
          }
        }

        // Strict role isolation: users cannot access routes of another role
        final isCustomerRoute = loc.startsWith('/customer');
        final isDriverRoute = loc.startsWith('/driver');
        final isAdminRoute = loc.startsWith('/admin');

        if (role == UserRole.customer && (isDriverRoute || isAdminRoute)) {
          return AppRoutes.customerHome;
        } else if (role == UserRole.driver && (isCustomerRoute || isAdminRoute)) {
          return AppRoutes.driverHome;
        } else if (role == UserRole.admin && (isCustomerRoute || isDriverRoute)) {
          return AppRoutes.adminDashboard;
        }
      }

      return null;
    },
  );
});
