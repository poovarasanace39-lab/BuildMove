import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking_model.dart';
import '../../../models/enums.dart';
import '../../../models/location_model.dart';
import '../../../services/booking/booking_service_interface.dart';
import '../../../services/booking/mock_booking_service.dart';

final bookingServiceProvider = Provider<IBookingService>((ref) {
  return MockBookingService();
});

class BookingFlowState {
  final ConstructionMaterial selectedMaterial;
  final double quantityTons;
  final String loadUnit; // 'tons', 'bags', 'loads'
  final LocationModel? pickupLocation;
  final LocationModel? dropLocation;
  final String siteLandmark;
  final String siteReceiverPhone;
  final String paymentMethod; // 'cash_on_site', 'razorpay', 'credit'
  final VehicleType? selectedVehicleType;
  final BookingEstimate? estimate;
  final bool isCalculating;
  final bool isSubmitting;
  final String? errorMessage;
  final BookingModel? lastCreatedBooking;

  const BookingFlowState({
    this.selectedMaterial = ConstructionMaterial.cement,
    this.quantityTons = 5.0,
    this.loadUnit = 'tons',
    this.pickupLocation,
    this.dropLocation,
    this.siteLandmark = 'GPS Auto',
    this.siteReceiverPhone = '9876543210',
    this.paymentMethod = 'cash_on_site',
    this.selectedVehicleType = VehicleType.tipper6Wheeler,
    this.estimate,
    this.isCalculating = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.lastCreatedBooking,
  });

  BookingFlowState copyWith({
    ConstructionMaterial? selectedMaterial,
    double? quantityTons,
    String? loadUnit,
    LocationModel? pickupLocation,
    LocationModel? dropLocation,
    String? siteLandmark,
    String? siteReceiverPhone,
    String? paymentMethod,
    VehicleType? selectedVehicleType,
    BookingEstimate? estimate,
    bool? isCalculating,
    bool? isSubmitting,
    String? errorMessage,
    BookingModel? lastCreatedBooking,
  }) {
    return BookingFlowState(
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      quantityTons: quantityTons ?? this.quantityTons,
      loadUnit: loadUnit ?? this.loadUnit,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      siteLandmark: siteLandmark ?? this.siteLandmark,
      siteReceiverPhone: siteReceiverPhone ?? this.siteReceiverPhone,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      estimate: estimate ?? this.estimate,
      isCalculating: isCalculating ?? this.isCalculating,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      lastCreatedBooking: lastCreatedBooking ?? this.lastCreatedBooking,
    );
  }
}

final bookingFlowProvider = NotifierProvider<BookingFlowNotifier, BookingFlowState>(() {
  return BookingFlowNotifier();
});

class BookingFlowNotifier extends Notifier<BookingFlowState> {
  @override
  BookingFlowState build() {
    return const BookingFlowState(
      selectedMaterial: ConstructionMaterial.cement,
      quantityTons: 5.0,
      loadUnit: 'tons',
      selectedVehicleType: VehicleType.tipper6Wheeler,
      pickupLocation: LocationModel(
        latitude: 13.0827,
        longitude: 80.2707,
        address: 'Dalmia Cement Depot, Ambattur',
        siteLandmark: 'GPS Auto',
        city: 'Chennai',
        pincode: '600058',
      ),
      dropLocation: LocationModel(
        latitude: 12.9716,
        longitude: 80.2435,
        address: 'Construction Site, OMR Thoraipakkam',
        siteLandmark: 'Site Phase 2, OMR Navalur',
        city: 'Chennai',
        pincode: '600097',
      ),
    );
  }

  void setMaterial(ConstructionMaterial material) {
    state = state.copyWith(selectedMaterial: material);
    calculateEstimate();
  }

  void setQuantity(double quantity) {
    state = state.copyWith(quantityTons: quantity);
    calculateEstimate();
  }

  void setLoadUnit(String unit) {
    state = state.copyWith(loadUnit: unit);
  }

  void setLocations({
    required LocationModel pickup,
    required LocationModel drop,
    String? landmark,
    String? receiverPhone,
  }) {
    state = state.copyWith(
      pickupLocation: pickup,
      dropLocation: drop,
      siteLandmark: landmark ?? state.siteLandmark,
      siteReceiverPhone: receiverPhone ?? state.siteReceiverPhone,
    );
    calculateEstimate();
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void selectVehicle(VehicleType type) {
    state = state.copyWith(selectedVehicleType: type);
  }

  Future<void> calculateEstimate() async {
    final pickup = state.pickupLocation;
    final drop = state.dropLocation;
    if (pickup == null || drop == null) return;

    state = state.copyWith(isCalculating: true, errorMessage: null);
    final bookingService = ref.read(bookingServiceProvider);

    final result = await bookingService.calculateEstimate(
      material: state.selectedMaterial,
      quantityTons: state.quantityTons,
      pickup: pickup,
      drop: drop,
    );

    result.fold(
      onSuccess: (est) {
        // Auto-select first recommended or available vehicle
        final recommended = est.vehicleOptions.firstWhere(
          (v) => v.isRecommended,
          orElse: () => est.vehicleOptions.first,
        );
        state = state.copyWith(
          estimate: est,
          selectedVehicleType: state.selectedVehicleType ?? recommended.type,
          isCalculating: false,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(isCalculating: false, errorMessage: failure.message);
      },
    );
  }

  Future<BookingModel?> confirmBooking() async {
    if (state.pickupLocation == null ||
        state.dropLocation == null ||
        state.selectedVehicleType == null ||
        state.estimate == null) {
      state = state.copyWith(errorMessage: 'Please select vehicle and locations before confirming');
      return null;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final bookingService = ref.read(bookingServiceProvider);

    final selectedOption = state.estimate!.vehicleOptions.firstWhere(
      (opt) => opt.type == state.selectedVehicleType,
      orElse: () => state.estimate!.vehicleOptions.first,
    );

    final res = await bookingService.createBooking(
      material: state.selectedMaterial,
      quantityTons: state.quantityTons,
      pickup: state.pickupLocation!,
      drop: state.dropLocation!,
      vehicleType: state.selectedVehicleType!,
      estimatedFare: selectedOption.estimatedFare,
      distanceKm: state.estimate!.distanceKm,
    );

    return res.fold(
      onSuccess: (booking) {
        state = state.copyWith(isSubmitting: false, lastCreatedBooking: booking);
        // Refresh bookings lists
        ref.invalidate(activeBookingsProvider);
        return booking;
      },
      onFailure: (failure) {
        state = state.copyWith(isSubmitting: false, errorMessage: failure.message);
        return null;
      },
    );
  }
}

// Active bookings provider
final activeBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final service = ref.watch(bookingServiceProvider);
  final res = await service.getActiveBookings();
  return res.fold(
    onSuccess: (list) => list,
    onFailure: (_) => [],
  );
});

// History bookings provider
final bookingHistoryProvider = FutureProvider<List<BookingModel>>((ref) async {
  final service = ref.watch(bookingServiceProvider);
  final res = await service.getBookingHistory();
  return res.fold(
    onSuccess: (list) => list,
    onFailure: (_) => [],
  );
});

// Incoming driver requests provider
final driverIncomingRequestsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final service = ref.watch(bookingServiceProvider);
  final res = await service.getIncomingDriverRequests();
  return res.fold(
    onSuccess: (list) => list,
    onFailure: (_) => [],
  );
});
