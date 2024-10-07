import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_fcm_local_notification_example/app/services/fcm_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // set up local notifications settings
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // initialize the local notifications plugin
    await flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload ?? '{}'));
        FCMService.handleMessage(message);
      },
    );
  }

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }

  Future<void> showNotification(RemoteMessage message) async {
    String? bigPicturePath;
    final notification = message.notification;

    // if notification is null, return
    if (notification == null) {
      log('Notification is null');
      return;
    }

    if (notification.android?.imageUrl != null) {
      bigPicturePath = await _downloadAndSaveImage(
        notification.android!.imageUrl!,
        'notification_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    }

    final bigPictureStyleInformation = bigPicturePath != null
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(bigPicturePath),
            contentTitle: notification.title,
            htmlFormatContentTitle: true,
            summaryText: notification.body,
            htmlFormatSummaryText: true,
          )
        : null;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fcm_default_channel',
      'fcm_default_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      attachments: bigPicturePath != null ? [DarwinNotificationAttachment(bigPicturePath)] : null,
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: message.data['payload'],
    );
  }
}
