import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/review_model.dart';

/// Provider managing active tab index in CustomerShellScreen
final customerShellTabProvider = StateProvider<int>((ref) => 0);

/// Provider for list of notifications
final customerNotificationsProvider =
    NotifierProvider<CustomerNotificationsNotifier, List<AppNotificationModel>>(() {
  return CustomerNotificationsNotifier();
});

class CustomerNotificationsNotifier extends Notifier<List<AppNotificationModel>> {
  @override
  List<AppNotificationModel> build() {
    final now = DateTime.now();
    return [
      AppNotificationModel(
        id: 'notif_001',
        title: 'Driver Murugan K. Assigned',
        titleTa: 'ஓட்டுநர் முருகன் கே. ஒதுக்கப்பட்டார்',
        body: 'Vehicle TN-09-CB-4821 is dispatched for 5T Cement to Site Phase 2, OMR.',
        bodyTa: 'TN-09-CB-4821 வாகனம் தளம் ஃபேஸ் 2, OMR-க்கு 5 டன் சிமெண்ட்டுடன் புறப்பட்டது.',
        type: 'driver_assigned',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 12)),
        metadata: const {'bookingId': 'BM-2026-081'},
      ),
      AppNotificationModel(
        id: 'notif_002',
        title: 'Material In Transit',
        titleTa: 'சரக்கு பயணத்தில் உள்ளது',
        body: 'Load BM-2026-081 is en route. Estimated arrival in 28 mins.',
        bodyTa: 'முன்பதிவு BM-2026-081 பயணத்தில் உள்ளது. 28 நிமிடங்களில் வந்தடையும்.',
        type: 'in_transit',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 25)),
        metadata: const {'bookingId': 'BM-2026-081'},
      ),
      AppNotificationModel(
        id: 'notif_003',
        title: 'Delivery Completed',
        titleTa: 'டெலிவரி முடிந்தது',
        body: 'Order #BM-8490 (M-Sand 10T) unloaded and verified with digital slip.',
        bodyTa: 'ஆர்டர் #BM-8490 (மணல் 10T) தளத்தில் இறக்கப்பட்டு சரிபார்க்கப்பட்டது.',
        type: 'trip_completed',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 18)),
        metadata: const {'bookingId': 'BM-8490'},
      ),
      AppNotificationModel(
        id: 'notif_004',
        title: 'Site Gate Pass Cleared',
        titleTa: 'தள நுழைவு அனுமதி வழங்கப்பட்டது',
        body: 'Security gate pass for Gate 2 approved for incoming Tipper.',
        bodyTa: 'கேட் 2-க்கான பாதுகாப்பு அனுமதி வழங்கப்பட்டது.',
        type: 'gate_pass',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        metadata: const {'bookingId': 'BM-8492'},
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true),
    ];
  }
}

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(customerNotificationsProvider);
  return notifs.where((n) => !n.isRead).length;
});
