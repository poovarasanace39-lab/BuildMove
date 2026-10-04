import '../../core/errors/app_failure.dart';
import '../../core/network/api_result.dart';
import '../../models/booking_model.dart';
import '../../models/enums.dart';
import '../../models/location_model.dart';
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

  void _initializeSeedData() {
    _bookings.addAll([
      BookingModel(
        id: 'BM-8492',
        customerId: 'usr_cust_001',
        customerName: 'Rajesh',
        customerPhone: '+91 9876543210',
        driverId: 'usr_drv_002',
        driverName: 'Murugan K.',
        driverPhone: '+91 9840123456',
        vehicleType: VehicleType.tipper6Wheeler,
        materialType: ConstructionMaterial.cement,
        quantityTons: 5.0,
        pickupLocation: const LocationModel(
          latitude: 13.0827,
          longitude: 80.2707,
          address: 'Dalmia Cement Depot, Ambattur',
          siteLandmark: 'Opposite Gate 3 Wholesale Depot',
          city: 'Chennai',
          pincode: '600058',
        ),
        dropLocation: const LocationModel(
          latitude: 12.9716,
          longitude: 80.2435,
          address: 'Construction Site, OMR Thoraipakkam',
          siteLandmark: 'Site Phase 2, OMR Navalur',
          city: 'Chennai',
          pincode: '600097',
        ),
        status: BookingStatus.accepted,
        estimatedFare: 1850.0,
        actualFare: 1850.0,
        distanceKm: 14.5,
        scheduledAt: DateTime.now().subtract(const Duration(minutes: 20)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        otpForPickup: '4821',
      ),
      BookingModel(
        id: 'BM-2026-079',
        customerId: 'usr_cust_001',
        customerName: 'Ramesh Sundaram',
        customerPhone: '+91 9876543210',
        driverId: 'usr_drv_002',
        driverName: 'Murugan K.',
        driverPhone: '+91 9840123456',
        vehicleType: VehicleType.pickup8ft,
        materialType: ConstructionMaterial.sand,
        quantityTons: 1.5,
        pickupLocation: const LocationModel(
          latitude: 13.0405,
          longitude: 80.2337,
          address: 'Sri Ramana M-Sand Yard, Poonamallee High Rd',
          city: 'Chennai',
          pincode: '600056',
        ),
        dropLocation: const LocationModel(
          latitude: 13.0827,
          longitude: 80.2707,
          address: 'Commercial Tower Site, Anna Nagar West',
          city: 'Chennai',
          pincode: '600040',
        ),
        status: BookingStatus.completed,
        estimatedFare: 1100.0,
        actualFare: 1100.0,
        distanceKm: 18.5,
        scheduledAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        otpForPickup: '1903',
      ),
      BookingModel(
        id: 'BM-2026-083',
        customerId: 'usr_cust_001',
        customerName: 'Ramesh Sundaram',
        customerPhone: '+91 9876543210',
        driverId: null,
        vehicleType: VehicleType.pickup8ft,
        materialType: ConstructionMaterial.steel,
        quantityTons: 1.2,
        pickupLocation: const LocationModel(
          latitude: 13.0102,
          longitude: 80.2156,
          address: 'JSW Steel Stockyard, Guindy Industrial Estate',
          city: 'Chennai',
          pincode: '600032',
        ),
        dropLocation: const LocationModel(
          latitude: 12.9249,
          longitude: 80.1000,
          address: 'Residential Complex, Tambaram West',
          city: 'Chennai',
          pincode: '600045',
        ),
        status: BookingStatus.searching,
        estimatedFare: 980.0,
        distanceKm: 16.0,
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        otpForPickup: '8392',
      ),
      BookingModel(
        id: 'BM-2026-085',
        customerId: 'usr_cust_001',
        customerName: 'Rajesh',
        customerPhone: '+91 9876543210',
        driverId: null,
        vehicleType: VehicleType.tataAce,
        materialType: ConstructionMaterial.bricks,
        quantityTons: 3.0,
        pickupLocation: const LocationModel(
          latitude: 13.1991,
          longitude: 80.1963,
          address: 'Red Bricks Kiln Yard, Red Hills',
          city: 'Chennai',
          pincode: '600052',
        ),
        dropLocation: const LocationModel(
          latitude: 12.8996,
          longitude: 80.2458,
          address: 'Villa Site #42, ECR Akkarai',
          city: 'Chennai',
          pincode: '600119',
        ),
        status: BookingStatus.pending,
        estimatedFare: 1450.0,
        distanceKm: 28.0,
        scheduledAt: DateTime.now().add(const Duration(hours: 4)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        otpForPickup: '6219',
      ),
      BookingModel(
        id: 'BM-2026-071',
        customerId: 'usr_cust_001',
        customerName: 'Rajesh',
        customerPhone: '+91 9876543210',
        driverId: 'usr_drv_005',
        driverName: 'Senthil Nathan',
        driverPhone: '+91 9840998877',
        vehicleType: VehicleType.tipper6Wheeler,
        materialType: ConstructionMaterial.aggregates,
        quantityTons: 8.0,
        pickupLocation: const LocationModel(
          latitude: 12.8912,
          longitude: 80.0812,
          address: 'Blue Metal Quarry, Vandalur',
          city: 'Chennai',
          pincode: '600048',
        ),
        dropLocation: const LocationModel(
          latitude: 13.0067,
          longitude: 80.2024,
          address: 'Metro Rail Pier 118, Guindy',
          city: 'Chennai',
          pincode: '600032',
        ),
        status: BookingStatus.cancelled,
        estimatedFare: 3200.0,
        actualFare: 0.0,
        distanceKm: 22.0,
        scheduledAt: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
    ]);
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

    final newBooking = BookingModel(
      id: 'BM-8492',
      customerId: 'usr_cust_001',
      customerName: 'Rajesh',
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
