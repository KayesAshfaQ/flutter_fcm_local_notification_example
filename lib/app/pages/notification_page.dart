import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  static const route = '/notification';

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notification Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the notification page',
            ),
            if (message.notification != null)
              Column(
                children: <Widget>[
                  Text(
                    'Title: ${message.notification!.title}',
                  ),
                  Text(
                    'Body: ${message.notification!.body}',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
