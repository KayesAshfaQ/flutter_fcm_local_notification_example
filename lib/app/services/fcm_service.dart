import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
  log('title: ${message.notification?.title}');
  log('body: ${message.notification?.body}');
  log('payload: ${message.data}');
}

class FCMService {
  final NotificationService _notificationService;

  FCMService(this._notificationService);

  /// handles message actions when the app is in the foreground or background state
  static void handleMessage(RemoteMessage? message) {
    log('Handling a message: ${message?.messageId}');

    if (message == null) {
      log('Message is null');
    } else if (message.data['action'] == null) {
      log('No action found');
    } else {
      // handle the message
      switch (message.data['action']) {
        case 'OPEN':
          log('Opening the app');
          break;
        case 'CLOSE':
          log('Closing the app');
          break;
        default:
          log('No action defined for ${message.data['action']}');
      }
    }
  }

  Future<void> init() async {
    // request permission to receive notifications
    await requestPermission();

    // set the foreground notification presentation options
    await setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _setupFirebaseMessaging();
  }

  /// sets up Firebase Messaging to listen for messages and handle them accordingly
  /// based on the app's state (foreground, background, or terminated)
  void _setupFirebaseMessaging() {
    // listen for messages when the app is in the foreground state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        _notificationService.showNotification(message);
      }
    });

    // get calls, when the app is in the background or terminated state, and the message is received
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // perform an action when the user taps on a notification, when the app is in the background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log('Message data: ${message.data}');
      handleMessage(message);
    });

    // perform an action when the user taps on a notification, when the app is in the terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App was opened by a notification!');
        log('Message data: ${message.data}');
        handleMessage(message);
      }
    });
  }

  Future<void> requestPermission({
    bool alert = true,
    bool badge = true,
    bool sound = true,
    bool provisional = false,
  }) async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: alert,
      badge: badge,
      sound: sound,
      provisional: provisional,
    );
    log('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> setForegroundNotificationPresentationOptions({
    required bool alert,
    required bool badge,
    required bool sound,
  }) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> setAutoInitEnabled(bool enabled) async {
    await FirebaseMessaging.instance.setAutoInitEnabled(enabled);
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    log('Subscribed to $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    log('Unsubscribed from $topic');
  }
}
