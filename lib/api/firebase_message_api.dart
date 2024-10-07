import 'dart:convert';

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

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for iOS devices to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the token for this device
    final token = await _firebaseMessaging.getToken();
    debugPrint('Token: $token');

    // Initialize local notifications
    initLocalNotifications();

    // Initialize push notifications
    initPushNotification();
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

  Future initLocalNotifications() async {
    // initialize the local notifications plugin
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitializationSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iOSInitializationSettings);
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload ?? '{}'));
        handleMessage(message);
      },
    );

    // platform-specific initialization
    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    // create the notification channel
    await platform?.createNotificationChannel(_androidNotificationChannel);
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

    // get calls, when the app is in the background or terminated state, and the message is received
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // listen for messages when the app is in the foreground state 
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      // if notification is null, return
      if (notification == null) {
        return;
      }

      // otherwise, show notification
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidNotificationChannel.id,
            _androidNotificationChannel.name,
            channelDescription: _androidNotificationChannel.description,
            importance: _androidNotificationChannel.importance,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }
}
