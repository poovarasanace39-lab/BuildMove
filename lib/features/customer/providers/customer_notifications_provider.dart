import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/review_model.dart';

import '../../../services/demo/demo_data_service.dart';

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
    if (DemoDataService.instance.isNotificationsEmpty) {
      return const [];
    }
    return DemoDataService.createInitialNotifications();
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

  /// Sets notifications to empty state for testing
  void clearAll() {
    DemoDataService.instance.setNotificationsEmpty(true);
    state = const [];
  }

  /// Resets notifications to populated demo state for testing
  void resetToDemo() {
    DemoDataService.instance.setNotificationsEmpty(false);
    state = DemoDataService.createInitialNotifications();
  }

  /// Toggles between empty and populated states
  void setEmpty(bool empty) {
    if (empty) {
      clearAll();
    } else {
      resetToDemo();
    }
  }
}

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(customerNotificationsProvider);
  return notifs.where((n) => !n.isRead).length;
});
