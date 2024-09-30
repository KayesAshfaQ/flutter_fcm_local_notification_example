import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fcm_local_notification_example/main.dart';
import 'package:flutter_fcm_local_notification_example/pages/notification_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('title: ${message.notification?.title}');
  debugPrint('body: ${message.notification?.body}');
  debugPrint('payload: ${message.data}');
}

class FirebaseMessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidNotificationChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  Future<void> initialize() async {
    // Request permission for iOS devices to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the token for this device
    final token = await _firebaseMessaging.getToken();
    debugPrint('Token: $token');

    // Initialize push notifications
    await initPushNotification();
  }

  /// handles message actions
  void handleMessage(RemoteMessage? message) {
    debugPrint('Handling a message: ${message?.messageId}');

    if (message == null) {
      debugPrint('Message is null');
      return;
    }

    navigatorKey.currentState?.pushNamed(
      NotificationPage.route,
      arguments: message,
    );
  }

  Future initPushNotification() async {
    // set presentation options for foreground notifications on iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // perform actions when app is open from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // perform actions when app is open from a background state
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // get calls, when the app is in the background or terminated state
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
