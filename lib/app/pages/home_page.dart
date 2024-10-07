import 'package:flutter/material.dart';
import 'package:flutter_fcm_local_notification_example/app/services/fcm_service.dart';

class HomePage extends StatefulWidget {
  static const route = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onInitState() {
    super.initState();

    // check if the app was opened from a notification
    // FCMService.onOpenAppFromTerminatedState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the home page',
            ),
          ],
        ),
      ),
    );
  }
}
