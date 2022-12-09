import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flyerapp/Screens/HomePage/Help/help.dart';
import 'package:get/get.dart';

class NotificationService {
  // static final NotificationService _notificationService =
  //     NotificationService._internal();

  // factory NotificationService() {
  //   return _notificationService;
  // }
  NotificationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/launch_background');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationDetails> notificationDetails() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'Channel_name',
          channelDescription: 'channel notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher'),
      iOS: IOSNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    return notificationDetails;
  }

  Future<void> showNotification(int id, String title, String body) async {
    final details = await notificationDetails();
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void onSelectNotification(String? payload) {}
}
