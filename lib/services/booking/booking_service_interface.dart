import '../../core/network/api_result.dart';
import '../../models/booking_model.dart';
import '../../models/enums.dart';
import '../../models/location_model.dart';

abstract class IBookingService {
  /// Request vehicle availability and estimated price from backend
  Future<ApiResult<BookingEstimate>> calculateEstimate({
    required ConstructionMaterial material,
    required double quantityTons,
    required LocationModel pickup,
    required LocationModel drop,
  });

  /// Create a new booking request
  Future<ApiResult<BookingModel>> createBooking({
    required ConstructionMaterial material,
    required double quantityTons,
    required LocationModel pickup,
    required LocationModel drop,
    required VehicleType vehicleType,
    required double estimatedFare,
    required double distanceKm,
    DateTime? scheduledAt,
  });

  /// Get active bookings for customer or driver
  Future<ApiResult<List<BookingModel>>> getActiveBookings();

  /// Get completed trip history
  Future<ApiResult<List<BookingModel>>> getBookingHistory();

  /// Driver incoming requests (orders waiting for match)
  Future<ApiResult<List<BookingModel>>> getIncomingDriverRequests();

  /// Driver accepts a booking request
  Future<ApiResult<BookingModel>> acceptBooking(String bookingId);

  /// Driver rejects a booking request
  Future<ApiResult<void>> rejectBooking(String bookingId);

  /// Driver starts trip after loading material at site
  Future<ApiResult<BookingModel>> startTrip(String bookingId);

  /// Driver completes trip and unloads material
  Future<ApiResult<BookingModel>> endTrip(String bookingId);
}

class BookingEstimate {
  final double distanceKm;
  final int etaMinutes;
  final List<VehicleEstimateOption> vehicleOptions;

  const BookingEstimate({
    required this.distanceKm,
    required this.etaMinutes,
    required this.vehicleOptions,
  });
}

class VehicleEstimateOption {
  final VehicleType type;
  final double estimatedFare;
  final bool isRecommended;
  final bool isCapacitySufficient;
  final int availableNearbyCount;

  const VehicleEstimateOption({
    required this.type,
    required this.estimatedFare,
    required this.isRecommended,
    required this.isCapacitySufficient,
    required this.availableNearbyCount,
  });
}
