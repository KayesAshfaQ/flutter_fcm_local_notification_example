import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'my_app.dart';

void main() {
  // ensure flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // run the app
  runApp(const MyApp());
}
