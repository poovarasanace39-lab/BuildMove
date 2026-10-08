import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking_model.dart';
import '../../../models/enums.dart';
import '../../booking/providers/booking_flow_provider.dart';
import 'fleet_provider.dart';

/// Provider managing the active tab index of the AdminShellScreen (0: Dashboard, 1: Verifications, 2: Fleet).
final adminShellTabProvider = StateProvider<int>((ref) => 0);

/// Data class holding calculated, non-hardcoded Admin operational KPIs.
class AdminDashboardMetrics {
  final int activeTripsCount;
  final int awaitingDriverCount;
  final int totalBookingsCount;
  final int completedDeliveriesCount;
  final int registeredDriversCount;
  final int registeredVehiclesCount;
  final int onlineAvailableVehiclesCount;
  final int pendingVerificationsCount;
  final double todayRevenue;
  final double allTimeCompletedRevenue;
  final int completedTodayCount;

  const AdminDashboardMetrics({
    required this.activeTripsCount,
    required this.awaitingDriverCount,
    required this.totalBookingsCount,
    required this.completedDeliveriesCount,
    required this.registeredDriversCount,
    required this.registeredVehiclesCount,
    required this.onlineAvailableVehiclesCount,
    required this.pendingVerificationsCount,
    required this.todayRevenue,
    required this.allTimeCompletedRevenue,
    required this.completedTodayCount,
  });

  factory AdminDashboardMetrics.empty() {
    return const AdminDashboardMetrics(
      activeTripsCount: 0,
      awaitingDriverCount: 0,
      totalBookingsCount: 0,
      completedDeliveriesCount: 0,
      registeredDriversCount: 0,
      registeredVehiclesCount: 0,
      onlineAvailableVehiclesCount: 0,
      pendingVerificationsCount: 0,
      todayRevenue: 0.0,
      allTimeCompletedRevenue: 0.0,
      completedTodayCount: 0,
    );
  }
}

/// Reactive provider deriving real metrics from booking, fleet, and verification states.
final adminDashboardMetricsProvider = Provider<AdminDashboardMetrics>((ref) {
  final activeBookingsAsync = ref.watch(activeBookingsProvider);
  final bookingHistoryAsync = ref.watch(bookingHistoryProvider);
  final fleetState = ref.watch(fleetNotifierProvider);

  final List<BookingModel> activeBookings = activeBookingsAsync.valueOrNull ?? [];
  final List<BookingModel> historyBookings = bookingHistoryAsync.valueOrNull ?? [];

  // Active trips & trips awaiting driver match
  final int activeCount = activeBookings.length;
  final int awaitingDriverCount = activeBookings.where((b) {
    return b.driverId == null ||
        b.status == BookingStatus.searching ||
        b.status == BookingStatus.pending;
  }).length;

  // Completed & Total Bookings
  final List<BookingModel> completedDeliveries =
      historyBookings.where((b) => b.status == BookingStatus.completed).toList();
  final int completedCount = completedDeliveries.length;
  final int totalBookings = activeCount + historyBookings.length;

  // Registered Vehicles & Drivers
  final int registeredVehicles = fleetState.vehicles.length;
  final int registeredDrivers = fleetState.drivers.length;

  // Vehicles currently online & available
  final int onlineAvailableCount = fleetState.vehicles.where((v) {
    if (!v.isAvailable) return false;
    final hasPendingOrRejected = v.documents.any((d) => d.status != DocumentStatus.approved);
    if (hasPendingOrRejected) return false;
    final driver = fleetState.getDriverProfile(v.driverId);
    return (driver?.isOnline ?? false) && (driver?.isApproved ?? false);
  }).length;

  // Pending Verifications Queue
  final int pendingVerifications = fleetState.verificationQueue.length;

  // Revenue Calculation:
  // Rule: Do NOT treat estimated fares as earned revenue.
  // Rule: Calculate only from records with reliable completion and date information.
  final now = DateTime.now();
  double todayRevenue = 0.0;
  int completedTodayCount = 0;
  double allTimeCompletedRevenue = 0.0;

  for (final b in completedDeliveries) {
    final fare = b.actualFare;
    if (fare != null && fare > 0) {
      allTimeCompletedRevenue += fare;
      // Compare calendar date of scheduled/delivery date
      if (b.scheduledAt.year == now.year &&
          b.scheduledAt.month == now.month &&
          b.scheduledAt.day == now.day) {
        todayRevenue += fare;
        completedTodayCount++;
      }
    }
  }

  return AdminDashboardMetrics(
    activeTripsCount: activeCount,
    awaitingDriverCount: awaitingDriverCount,
    totalBookingsCount: totalBookings,
    completedDeliveriesCount: completedCount,
    registeredDriversCount: registeredDrivers,
    registeredVehiclesCount: registeredVehicles,
    onlineAvailableVehiclesCount: onlineAvailableCount,
    pendingVerificationsCount: pendingVerifications,
    todayRevenue: todayRevenue,
    allTimeCompletedRevenue: allTimeCompletedRevenue,
    completedTodayCount: completedTodayCount,
  );
});
