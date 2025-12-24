import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    try {
      // اجازه دسترسی به نوتیفیکیشن‌ها
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission for notifications');

        // دریافت توکن FCM
        String? token = await _messaging.getToken();
        debugPrint('FCM Token: $token');

        // دریافت پیام در foreground
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Received a message: ${message.notification?.title}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Notification: ${message.notification?.body ?? ''}',
              ),
            ),
          );
        });
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    } catch (e) {
      debugPrint('Push Notification Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Push Notification Error: $e')));
    }
  }
}
