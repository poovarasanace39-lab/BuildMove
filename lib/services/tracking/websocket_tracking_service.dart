import 'dart:async';
import '../../models/location_model.dart';
import 'tracking_service_interface.dart';

/// Live tracking service communicating via WebSockets with FastAPI backend.
///
/// REQUIRED SETUP FOR PRODUCTION:
/// 1. Run FastAPI backend with `/ws/tracking/{booking_id}` WebSocket endpoint.
/// 2. Request user location permissions (`geolocator` or `location` package).
/// 3. Provide valid Google Maps API Key in AndroidManifest.xml.
class WebSocketTrackingService implements ITrackingService {
  final bool isDevSimulation;
  StreamController<LocationModel>? _locationStreamController;
  Timer? _simulationTimer;

  WebSocketTrackingService({this.isDevSimulation = true});

  @override
  Stream<LocationModel> listenToDriverLocation(String bookingId) {
    _locationStreamController = StreamController<LocationModel>.broadcast();

    if (isDevSimulation) {
      // Smooth mock progression between Koyambedu and OMR
      double lat = 13.0827;
      double lng = 80.2707;
      const targetLat = 12.9716;
      const targetLng = 80.2435;

      _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        lat += (targetLat - lat) * 0.05;
        lng += (targetLng - lng) * 0.05;

        _locationStreamController?.add(LocationModel(
          latitude: lat,
          longitude: lng,
          address: 'Approaching Site via Chennai Outer Ring Rd',
        ));
      });
    }

    return _locationStreamController!.stream;
  }

  @override
  Future<void> sendDriverLocation({
    required String bookingId,
    required LocationModel location,
    required double heading,
    required double speedKmph,
  }) async {
    // In production: send JSON payload through active WebSocket connection
    // _channel.sink.add(jsonEncode({
    //   'booking_id': bookingId,
    //   'latitude': location.latitude,
    //   'longitude': location.longitude,
    //   'heading': heading,
    //   'speed': speedKmph,
    // }));
  }

  @override
  void disconnect() {
    _simulationTimer?.cancel();
    _locationStreamController?.close();
    _locationStreamController = null;
  }
}
