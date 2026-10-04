import '../../models/location_model.dart';

abstract class IMapService {
  /// Check whether Google Maps API Key has been configured
  bool get isConfigured;

  /// Calculate route polylines and estimated road distance between two points
  Future<MapRouteData> calculateRoute({
    required LocationModel origin,
    required LocationModel destination,
  });

  /// Reverse geocode coordinates to a street address
  Future<String> getAddressFromCoordinates(double latitude, double longitude);
}

class MapRouteData {
  final double distanceKm;
  final int durationMinutes;
  final List<LocationModel> polylinePoints;

  const MapRouteData({
    required this.distanceKm,
    required this.durationMinutes,
    required this.polylinePoints,
  });
}
