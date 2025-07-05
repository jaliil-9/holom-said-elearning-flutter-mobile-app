import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:holom_said/core/utils/permission_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../utils/helper_methods/error.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static late SupabaseClient _supabase;
  static bool _initialized = false;

  static Future<void> init(SupabaseClient supabase) async {
    if (_initialized) return;
    _supabase = supabase;

    // Initialize local notifications first
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    if (Platform.isAndroid) {
      final androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.createNotificationChannel(
        const AndroidNotificationChannel(
          'default_channel',
          'Default Channel',
          description: 'Used for app notifications',
          importance: Importance.high,
        ),
      );
    }

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Now request permissions
    await requestPermissions(ErrorUtils.navigatorKey.currentContext!);

    if (_supabase.auth.currentUser != null) {
      // Get user role
      final isAdmin = await checkIfUserIsAdmin(_supabase.auth.currentUser!.id);

      // Set up notification subscriptions
      await NotificationService.setupSubscriptions(isAdmin);
    }

    _initialized = true;
  }

  static Future<bool> requestPermissions(BuildContext context) async {
    if (Platform.isAndroid) {
      return await PermissionManager.requestPermissionWithDialog(
        context,
        permission: Permission.notification,
        title: S.of(context).notificationPermissionTitle,
        content: S.of(context).notificationPermissionBody,
      );
    } else if (Platform.isIOS) {
      // On iOS, the requestPermissions method from flutter_local_notifications shows its own dialog.
      // You can customize the explanation in the Info.plist file.
      final bool? result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return false;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static Future<bool> checkIfUserIsAdmin(String userId) async {
    final response = await _supabase.from('admins').select().eq('id', userId);

    if (response.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      return await Permission.notification.status.isGranted;
    } else if (Platform.isIOS) {
      return await _notifications
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions() ??
          false;
    }
    return false;
  }

  static Future<void> setupSubscriptions(bool isAdmin) async {
    final channel = _supabase.channel('public:notifications');

    // Listen only to the notifications table
    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          callback: (payload) async {
            final notification = payload.newRecord;
            if (notification['user_id'] == _supabase.auth.currentUser?.id) {
              await showNotification(
                notification['title'],
                notification['body'],
              );
            }
          },
        )
        .subscribe();
  }

  static Future<void> showNotification(String title, String body) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@drawable/ic_stat_notification', // Status bar icon
        largeIcon:
            DrawableResourceAndroidBitmap('ic_notification'), // Popup icon
        color: Colors.blueAccent,
      );
      const iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      final details =
          NotificationDetails(android: androidDetails, iOS: iOSDetails);

      await _notifications.show(
        DateTime.now().millisecond, // Consider using a more unique ID
        title,
        body,
        details,
      );
    } catch (e) {}
  }

  // Add method to mark notification as read
  static Future<void> markNotificationAsRead(String notificationId) async {
    await _supabase.rpc('mark_notification_read',
        params: {'p_notification_id': notificationId});
  }

  // Add method to mark all notifications as read
  static Future<void> markAllNotificationsAsRead() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      await _supabase
          .rpc('mark_all_notifications_read', params: {'p_user_id': userId});
    }
  }
}
