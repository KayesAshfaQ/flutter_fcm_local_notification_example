import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('payload: ${message.data}');
}

class FirebaseMessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS devices to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the token for this device
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
