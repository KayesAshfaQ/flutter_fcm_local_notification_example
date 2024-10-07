import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'pages/home_page.dart';
import 'pages/notification_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void onInitState() {
    super.initState();

    // check if the app was opened from a notification
    // perform an action when the user taps on a notification, when the app is in the terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App was opened by a notification!');
        log('Message data: ${message.data}');

        navigatorKey.currentState?.pushNamed(
          NotificationPage.route,
          arguments: message,
        );
      } else {
        log('No message was found');
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => const HomePage(),
        NotificationPage.route: (context) => const NotificationPage(),
      },
    );
  }
}
