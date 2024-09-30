
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageApi {

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {

    // Request permission for iOS devices to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the token for this device
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');



  }


}