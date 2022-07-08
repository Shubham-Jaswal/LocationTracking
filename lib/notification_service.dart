import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService{
  static final NotificationService _notificationService= NotificationService._internal();


  factory NotificationService()
  {
    return _notificationService;
  }



  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
  NotificationService._internal();

  Future <void> initNotification() async{
    final AndroidInitializationSettings initializationSettingsandroid=AndroidInitializationSettings('@drawable/notify');


    final InitializationSettings initializationSettings= InitializationSettings(android: initializationSettingsandroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotifications(int id,String title,String body,int seconds) async{

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
        const NotificationDetails(
          android: AndroidNotificationDetails('main_channel', 'Main Channel',importance: Importance.max,
              priority:Priority.max,icon: '@drawable/notify' )
        ),

        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
    );

}
}

