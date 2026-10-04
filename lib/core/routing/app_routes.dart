class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String languageSelection = '/language';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';

  // Customer Routes
  static const String customerShell = '/customer';
  static const String customerHome = '/customer/home';
  static const String customerBookings = '/customer/bookings';
  static const String customerProfile = '/customer/profile';
  static const String customerMaterialQuantity = '/customer/booking/material-quantity';
  static const String customerLocations = '/customer/booking/locations';
  static const String customerVehicleSelection = '/customer/booking/vehicle-selection';
  static const String customerBookingConfirmation = '/customer/booking/confirmation';
  static const String customerLiveTracking = '/customer/tracking/:id';

  static String customerLiveTrackingPath(String id) => '/customer/tracking/$id';

  // Driver Routes
  static const String driverShell = '/driver';
  static const String driverHome = '/driver/home';
  static const String driverTrips = '/driver/trips';
  static const String driverProfile = '/driver/profile';

  // Admin Routes
  static const String adminShell = '/admin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminVerifications = '/admin/verifications';
  static const String adminFleet = '/admin/fleet';
}
