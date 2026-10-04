import 'dart:async';
import '../../core/network/api_client.dart';
import '../../models/review_model.dart';
import 'notification_service_interface.dart';

/// Firebase Cloud Messaging (FCM) Service.
///
/// REQUIRED SETUP FOR PRODUCTION:
/// 1. Configure Firebase in the app (`firebase_core` & `firebase_messaging`).
/// 2. Request user notification permissions.
/// 3. Upload APNs key in Firebase Console for iOS / enable Cloud Messaging for Android.
class FcmNotificationService implements INotificationService {
  final ApiClient _apiClient;
  final StreamController<AppNotificationModel> _controller =
      StreamController<AppNotificationModel>.broadcast();

  FcmNotificationService({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> initialize() async {
    // When Firebase Messaging is configured:
    // final messaging = FirebaseMessaging.instance;
    // await messaging.requestPermission();
    // final token = await messaging.getToken();
    // if (token != null) await registerDeviceToken(token);
  }

  @override
  Stream<AppNotificationModel> get onNotificationReceived => _controller.stream;

  @override
  Future<void> registerDeviceToken(String token) async {
    try {
      await _apiClient.post('/users/device-token', body: {'fcm_token': token});
    } catch (_) {}
  }
}
