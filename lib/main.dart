import 'dart:isolate';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled2/home.dart';
import 'package:untitled2/notification_service.dart';
import 'package:untitled2/sharedinlist.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  NotificationService().initNotification();
  runApp(const MaterialApp(
    home: Home(),
  ));


}
