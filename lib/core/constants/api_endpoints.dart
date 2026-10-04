/// API Endpoints for FastAPI backend communication.
/// Note: Never store backend secrets in Flutter. Base URLs are configurable per environment.
class ApiEndpoints {
  ApiEndpoints._();

  // Local development default (Android Emulator uses 10.0.2.2, Physical device uses LAN IP)
  static const String devBaseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String devWsUrl = 'ws://10.0.2.2:8000/ws/tracking';

  // Production base URL placeholder (will be injected via dart-define in CI/CD)
  static const String prodBaseUrl = 'https://api.buildmove.in/api/v1';
  static const String prodWsUrl = 'wss://api.buildmove.in/ws/tracking';

  // Auth endpoints
  static const String authSendOtp = '/auth/send-otp';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String authVerifyFirebaseToken = '/auth/verify-firebase-token';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authMe = '/auth/me';

  // Users & Profiles
  static const String userProfile = '/users/profile';
  static const String driverDocuments = '/users/driver/documents';
  static const String driverDutyToggle = '/users/driver/duty-status';

  // Vehicles
  static const String vehicleTypes = '/vehicles/types';
  static const String driverVehicles = '/vehicles/my-vehicles';

  // Bookings & Estimation
  static const String calculateEstimate = '/bookings/estimate';
  static const String findAvailableVehicles = '/bookings/find-vehicles';
  static const String createBooking = '/bookings';
  static const String bookingDetails = '/bookings/{id}';
  static const String cancelBooking = '/bookings/{id}/cancel';
  static const String activeBookings = '/bookings/active';
  static const String bookingHistory = '/bookings/history';

  // Driver Booking Actions
  static const String incomingRequests = '/driver/requests';
  static const String acceptRequest = '/driver/requests/{id}/accept';
  static const String rejectRequest = '/driver/requests/{id}/reject';
  static const String startTrip = '/driver/bookings/{id}/start-trip';
  static const String endTrip = '/driver/bookings/{id}/end-trip';

  // Admin Endpoints (Require Admin JWT)
  static const String adminMetrics = '/admin/metrics';
  static const String adminPendingVerifications = '/admin/verifications/pending';
  static const String adminApproveVerification = '/admin/verifications/{id}/approve';
  static const String adminRejectVerification = '/admin/verifications/{id}/reject';
  static const String adminFleetOverview = '/admin/fleet';
  static const String adminBookings = '/admin/bookings';

  // Payments (Razorpay Order creation)
  static const String createPaymentOrder = '/payments/create-order';
  static const String verifyPaymentSignature = '/payments/verify-signature';
}
