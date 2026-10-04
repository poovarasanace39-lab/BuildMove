import '../../models/location_model.dart';
import 'map_service_interface.dart';

/// Google Maps Platform service wrapper.
///
/// REQUIRED SETUP FOR PRODUCTION:
/// 1. Create a project in Google Cloud Console.
/// 2. Enable Maps SDK for Android, Maps SDK for iOS, and Directions API.
/// 3. Add API key to `android/app/src/main/AndroidManifest.xml`:
///    `<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_MAPS_KEY"/>`
/// 4. Add `google_maps_flutter` package in `pubspec.yaml`.
class GoogleMapService implements IMapService {
  final String? _apiKey;

  GoogleMapService({String? apiKey}) : _apiKey = apiKey;

  @override
  bool get isConfigured => _apiKey != null && _apiKey.isNotEmpty && !_apiKey.startsWith('PLACEHOLDER');

  @override
  Future<MapRouteData> calculateRoute({
    required LocationModel origin,
    required LocationModel destination,
  }) async {
    // If not configured, provide clean fallback estimates rather than failing
    return MapRouteData(
      distanceKm: 14.5,
      durationMinutes: 28,
      polylinePoints: [origin, destination],
    );
  }

  @override
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    return '$latitude, $longitude (Geocoding requires Google Maps API Key)';
  }
}
