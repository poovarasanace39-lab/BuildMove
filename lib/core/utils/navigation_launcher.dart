import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/app_localizations.dart';

/// Free URL-based Google Maps navigation utility for BuildMove drivers.
///
/// Automatically uses the driver's current location as the origin in Google Maps.
/// Attempts native Google Maps navigation intent first, with graceful fallback to
/// browser-based Google Maps directions if the native app is unavailable.
class NavigationLauncher {
  NavigationLauncher._();

  /// Opens Google Maps directions to [destinationAddress] (or [latitude], [longitude]).
  ///
  /// Returns `true` if navigation was successfully launched, or `false` otherwise.
  /// Displays a localized error message in [context] when the address is empty
  /// or when navigation cannot be launched.
  static Future<bool> openDirections({
    required BuildContext context,
    required String? destinationAddress,
    double? latitude,
    double? longitude,
  }) async {
    final query = destinationAddress?.trim() ?? '';
    if (query.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.tr('nav_error_empty')),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
      return false;
    }

    // Google Maps query string: coordinates if available, otherwise encoded address string.
    final destinationParam = (latitude != null && longitude != null && latitude != 0 && longitude != 0)
        ? '$latitude,$longitude'
        : Uri.encodeComponent(query);

    // 1. Primary: Native Google Maps navigation intent on Android/iOS
    // google.navigation:q=destination&mode=d automatically uses current GPS location as origin
    final nativeNavigationUri = Uri.parse('google.navigation:q=$destinationParam&mode=d');
    try {
      if (await canLaunchUrl(nativeNavigationUri)) {
        final launched = await launchUrl(
          nativeNavigationUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return true;
      }
    } catch (_) {
      // Proceed to fallback
    }

    // 2. Secondary Native fallback: geo: URI
    final geoUri = Uri.parse('geo:0,0?q=$destinationParam');
    try {
      if (await canLaunchUrl(geoUri)) {
        final launched = await launchUrl(
          geoUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return true;
      }
    } catch (_) {
      // Proceed to web fallback
    }

    // 3. Web Fallback: Google Maps web URL directions
    // https://www.google.com/maps/dir/?api=1&destination=...
    final webDirectionsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationParam&travelmode=driving',
    );
    try {
      if (await canLaunchUrl(webDirectionsUri)) {
        final launched = await launchUrl(
          webDirectionsUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return true;
      }

      // Final attempt: platformDefault mode
      final fallbackLaunched = await launchUrl(
        webDirectionsUri,
        mode: LaunchMode.platformDefault,
      );
      if (fallbackLaunched) return true;
    } catch (_) {
      // Failed to launch web URL
    }

    // 4. If all launch mechanisms failed, show a friendly localized error message
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.tr('nav_error_cannot_open')),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
    return false;
  }
}
