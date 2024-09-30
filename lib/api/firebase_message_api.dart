import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('title: ${message.notification?.title}');
  debugPrint('body: ${message.notification?.body}');
  debugPrint('payload: ${message.data}');
}

class FirebaseMessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS devices to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the token for this device
    final token = await _firebaseMessaging.getToken();
    debugPrint('Token: $token');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
