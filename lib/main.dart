import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/firebase_options.dart';
import 'app/my_app.dart';
import 'app/services/firebase_message_api.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // ensure flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final notificationService = NotificationService();
  // await notificationService.init();

  // final fcmService = FCMService();
  // await fcmService.init();

  // initialize firebase messaging service
  await FirebaseMessageApi().initialize();

  // run the app
  runApp(const MyApp());
}
