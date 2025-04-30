import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    await _requestPermissions();

    if (_supabase.auth.currentUser != null) {
      // Get user role
      final isAdmin = await checkIfUserIsAdmin(_supabase.auth.currentUser!.id);

      // Set up notification subscriptions
      await NotificationService.setupSubscriptions(isAdmin);
    }

    _initialized = true;
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.status;
      if (notificationStatus.isDenied) {
        final result = await Permission.notification.request();
        if (result.isDenied) {
          ErrorUtils.showErrorSnackBar(S.current.notificationsPermissionDenied);
        }
      }
    } else if (Platform.isIOS) {
      final notificationSettings = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (notificationSettings == false) {
        ErrorUtils.showErrorSnackBar(S.current.notificationsPermissionDenied);
      }
    }
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      return await Permission.notification
          .request()
          .then((status) => status.isGranted);
    } else if (Platform.isIOS) {
      return await _notifications
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
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
    print('Attempting to show notification: $title - $body');

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
      print('Notification shown successfully');
    } catch (e) {
      print('Error showing notification: $e');
    }
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
