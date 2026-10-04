import 'dart:async';
import '../../models/location_model.dart';

abstract class ITrackingService {
  /// Stream of live driver location updates for an active booking.
  Stream<LocationModel> listenToDriverLocation(String bookingId);

  /// Driver client sends their current GPS coordinates to FastAPI backend.
  Future<void> sendDriverLocation({
    required String bookingId,
    required LocationModel location,
    required double heading,
    required double speedKmph,
  });

  /// Disconnect any active WebSocket connection.
  void disconnect();
}
