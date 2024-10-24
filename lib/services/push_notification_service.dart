import 'dart:io';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class FirebaseApi {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request permission for iOS
    await fcm.requestPermission();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create a notification channel (for Android 8.0 and above)
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'your_channel_id', // Channel ID
        'Your Notification Channel', // Channel Name
        description: 'Your channel description',
        importance: Importance.max,
        playSound: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Get the FCM token
    final fcmToken = await fcm.getToken();
    updateFcmToken(fcmToken!);
    print('FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while in foreground: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');

      print('Payload: ${message.data["body"]}');
      showNotification(
        title: message.data["title"],
        body: message.data["body"],
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Message clicked! Navigate to appropriate screen based on the message.');
    });
  }

  Future<void> updateFcmToken(String fcmToken) async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    Response response =
        await RemoteServices.updateFcmToken(fcmToken, authToken!);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to update fcm token');
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // Show a local notification
    if (message.notification != null) {
      await FirebaseApi().showNotification(
        title: message.notification!.title,
        body: message.notification!.body,
      );
    }
  }

  Future<void> showNotification({String? title, String? body}) async {
    if (title == null || body == null) {
      print('Notification title or body is null.');
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Enovatek', // Channel ID
      ' Notification Channel', // Channel Name
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Generate a unique ID for each notification (using the current timestamp)
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await flutterLocalNotificationsPlugin.show(
      notificationId, // Use a unique ID for each notification
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );

    print('Notification shown: $title - $body');
  }
}
