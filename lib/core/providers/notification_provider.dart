import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(false) {
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    state = await NotificationService.areNotificationsEnabled();
  }

  Future<void> toggleNotifications(BuildContext context) async {
    await NotificationService.requestPermissions(context);
    await Future.delayed(const Duration(milliseconds: 500));
    state = await NotificationService.areNotificationsEnabled();
  }
}
