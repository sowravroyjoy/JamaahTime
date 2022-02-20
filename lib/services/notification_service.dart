import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {

    final sound = 'ringtune.mp3';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: false,

      ),
      iOS: IOSNotificationDetails(
        sound: sound,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/logo_three');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    //when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );

    if(initScheduled){
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showSimpleNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,

  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );


  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required Time time,
    required List<int> days,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(time, days: days),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}){
    tz.TZDateTime scheduleDate = _scheduleDaily(time);

    while (!days.contains(scheduleDate.weekday)){
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }

    return scheduleDate;
  }

  static void cancelAll() => _notifications.cancelAll();
}
