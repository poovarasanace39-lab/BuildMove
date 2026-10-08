import '../../core/errors/app_failure.dart';
import '../../core/network/api_result.dart';
import '../../models/booking_model.dart';
import '../../models/enums.dart';
import '../../models/location_model.dart';
import '../demo/demo_data_service.dart';
import 'booking_service_interface.dart';

class MockBookingService implements IBookingService {
  static final List<BookingModel> _bookings = [];
  static bool _seeded = false;

  MockBookingService() {
    if (!_seeded) {
      _initializeSeedData();
      _seeded = true;
    }
  }

  /// Resets mock database for test isolation
  static void resetSeedData() {
    _bookings.clear();
    _seeded = false;
  }

  /// Sets bookings to empty or populated for deterministic test states
  static void setBookingsEmpty(bool empty) {
    _bookings.clear();
    if (!empty) {
      _bookings.addAll(DemoDataService.createInitialBookings());
    }
    _seeded = true;
  }

  /// Sets status of a specific booking for testing state transitions
  static void setBookingStatus(String bookingId, BookingStatus status) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: status);
    }
  }

  /// Read-only snapshot of current bookings
  static List<BookingModel> get currentBookings => List.unmodifiable(_bookings);

  void _initializeSeedData() {
    if (DemoDataService.instance.isBookingsEmpty) {
      return;
    }
    _bookings.addAll(DemoDataService.createInitialBookings());
  }

  @override
  Future<ApiResult<BookingEstimate>> calculateEstimate({
    required ConstructionMaterial material,
    required double quantityTons,
    required LocationModel pickup,
    required LocationModel drop,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    const distanceKm = 14.5;
    const etaMinutes = 25;

    final options = VehicleType.values.map((v) {
      final isSufficient = v.capacityTons >= quantityTons;
      final fare = v.baseFare + (distanceKm * v.perKm);
      final isRec = isSufficient && (v.capacityTons <= quantityTons * 2.0);

      return VehicleEstimateOption(
        type: v,
        estimatedFare: fare.roundToDouble(),
        isRecommended: isRec,
        isCapacitySufficient: isSufficient,
        availableNearbyCount: isSufficient ? 3 : 1,
      );
    }).toList();

    return const Success(BookingEstimate(
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      vehicleOptions: [],
    )).mapOverride(options, distanceKm, etaMinutes);
  }

  @override
  Future<ApiResult<BookingModel>> createBooking({
    required ConstructionMaterial material,
    required double quantityTons,
    required LocationModel pickup,
    required LocationModel drop,
    required VehicleType vehicleType,
    required double estimatedFare,
    required double distanceKm,
    DateTime? scheduledAt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Strict Capacity Validation: A vehicle cannot be assigned to an overweight load
    if (vehicleType.capacityTons < quantityTons) {
      return Failure(ValidationFailure(
        'Selected vehicle (${vehicleType.name}) has capacity ${vehicleType.capacityTons}T which cannot carry $quantityTons tons.',
      ));
    }

    final newBooking = BookingModel(
      id: 'BM-8492',
      customerId: 'usr_cust_001',
      customerName: 'Ramesh Sundaram',
      customerPhone: '+91 9876543210',
      driverId: 'usr_drv_002',
      driverName: 'Murugan K.',
      driverPhone: '+91 9840123456',
      vehicleType: vehicleType,
      materialType: material,
      quantityTons: quantityTons,
      pickupLocation: pickup,
      dropLocation: drop,
      status: BookingStatus.inProgress,
      estimatedFare: estimatedFare,
      distanceKm: distanceKm,
      scheduledAt: scheduledAt ?? DateTime.now(),
      createdAt: DateTime.now(),
      otpForPickup: '4821',
    );

    _bookings.insert(0, newBooking);
    return Success(newBooking);
  }

  @override
  Future<ApiResult<List<BookingModel>>> getActiveBookings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final active = _bookings
        .where((b) => b.status != BookingStatus.completed && b.status != BookingStatus.cancelled)
        .toList();
    return Success(active);
  }

  @override
  Future<ApiResult<List<BookingModel>>> getBookingHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final history = _bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled)
        .toList();
    return Success(history);
  }

  @override
  Future<ApiResult<List<BookingModel>>> getIncomingDriverRequests() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final incoming = _bookings.where((b) => b.status == BookingStatus.searching).toList();
    return Success(incoming);
  }

  @override
  Future<ApiResult<BookingModel>> acceptBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final updated = _bookings[index].copyWith(
        status: BookingStatus.accepted,
        driverId: 'usr_drv_002',
        driverName: 'Murugan K.',
        driverPhone: '+91 9840123456',
      );
      _bookings[index] = updated;
      return Success(updated);
    }
    return Success(_bookings.first);
  }

  @override
  Future<ApiResult<void>> rejectBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(null);
  }

  @override
  Future<ApiResult<BookingModel>> startTrip(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      if (_bookings[index].status == BookingStatus.completed) {
        return const Failure(ValidationFailure('Cannot start an already completed trip'));
      }
      final updated = _bookings[index].copyWith(status: BookingStatus.inProgress);
      _bookings[index] = updated;
      return Success(updated);
    }
    return const Failure(ValidationFailure('Booking not found'));
  }

  @override
  Future<ApiResult<BookingModel>> endTrip(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      if (_bookings[index].status == BookingStatus.completed) {
        return const Failure(ValidationFailure('Trip has already been completed'));
      }
      if (_bookings[index].status != BookingStatus.inProgress) {
        return const Failure(ValidationFailure('Cannot complete an unstarted trip'));
      }
      final updated = _bookings[index].copyWith(
        status: BookingStatus.completed,
        actualFare: _bookings[index].estimatedFare,
      );
      _bookings[index] = updated;
      return Success(updated);
    }
    return const Failure(ValidationFailure('Booking not found'));
  }
}

extension on Success<BookingEstimate> {
  ApiResult<BookingEstimate> mapOverride(
      List<VehicleEstimateOption> options, double distanceKm, int etaMinutes) {
    return Success(BookingEstimate(
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      vehicleOptions: options,
    ));
  }
}
