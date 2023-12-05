import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConstHelper
{
  ConstHelper._();

  static ConstHelper constHelper = ConstHelper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  //Initialize Notification
  void initializeNotification()
  {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('applogo');

    DarwinInitializationSettings iOSInitializationSettings = const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings,iOS: iOSInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: (details) {
      // if(message.data['page'] == "Attendance")
      //   {
      //     Get.to(const Report_Page());
      //   }},
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   if(message.data['page'] == "Attendance")
      //   {
      //     Get.to(const Report_Page());
      //   }
      // },
    );
  }

  //Show Simple Notification
  Future<void> showSimpleNotification({required String title, required String body})
  async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      "1",
      "Attendance",
      importance: Importance.high,
      priority: Priority.max,
    );

    DarwinNotificationDetails iOSNotificationDetails = const DarwinNotificationDetails(subtitle: "IOS",);

    NotificationDetails notificationDetails =  NotificationDetails(android: androidNotificationDetails, iOS: iOSNotificationDetails);

    await flutterLocalNotificationsPlugin.show(1, title, body, notificationDetails).then((value) => print("Successfully Message Sent")).catchError((error) => print("$error"));
  }


  int getDaysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29; // Leap year
      } else {
        return 28;
      }
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else {
      return 31;
    }
  }

  Future<bool> checkConnectivity()
  async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile);
  }
}