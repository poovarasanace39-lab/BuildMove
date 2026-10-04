import 'dart:async';
import '../../models/review_model.dart';

abstract class INotificationService {
  /// Initialize push notifications and obtain FCM device token
  Future<void> initialize();

  /// Stream of foreground incoming push notifications
  Stream<AppNotificationModel> get onNotificationReceived;

  /// Register FCM token with FastAPI backend
  Future<void> registerDeviceToken(String token);
}
