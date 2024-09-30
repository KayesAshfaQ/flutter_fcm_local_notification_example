import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'api/firebase_message_api.dart';
import 'firebase_options.dart';
import 'my_app.dart';

void main() async {
  // ensure flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize firebase messaging service
  await FirebaseMessageApi().initialize();

  // run the app
  runApp(const MyApp());
}
