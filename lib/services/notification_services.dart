import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher.png');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     Mac9OSInitializationSettings();
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    tz.initializeTimeZones(); //
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (value) => selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails('Channel id', 'Channel name',
          channelDescription: 'Channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  // NotificationDetails platformChannelSpecifics =
  // NotificationDetails(
  //     android: _androidNotificationDetails,
  //     iOS: null  );

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
    // if (payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> showNotifications(
      int id, String title, String description) async {
    for (int i = 90; i <= 91; i++) {
      if (strings.langEng[i] == title) {
        title = strings.get(i);
        break;
      }
    }
    for (int j = 90; j <= 91; j++) {
      if (strings.langEng[j] == description) {
        description = strings.get(j);
        break;
      }
    }
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      NotificationDetails(android: _androidNotificationDetails),
      // payload: 'Notification Payload',
    );
  }

  Future<void> scheduleNotifications(
      int id, String title, String description) async {
    for (int i = 90; i <= 91; i++) {
      if (strings.langEng[i] == title) {
        title = strings.get(i);
        break;
      }
    }
    for (int j = 90; j <= 91; j++) {
      if (strings.langEng[j] == description) {
        description = strings.get(j);
        break;
      }
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        description,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
