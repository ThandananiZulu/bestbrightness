import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Noti {

  static Future initialize(
      FlutterLocalNotificationsPlugin FlutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    await FlutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails());

    await fln.show(0,title,body,not);
  }
}
