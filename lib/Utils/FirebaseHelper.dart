import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';

class FirebaseHelper
{
  FirebaseHelper._();

  static FirebaseHelper firebaseHelper = FirebaseHelper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //Set Notification With Firebase Messaging
  Future<void> firebaseMessaging()
  async {
    UserLoginModel? userData = await SharedPref.sharedpref.readUserLoginData();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    var token = await firebaseMessaging.getToken();
    // print("============= topiccccccccc ${userData!.schoolId}_${userData.standardId}_${userData.hostelId}_${userData.clusterId}_${userData.uid}_${userData.centralKitchanId}_${userData.civilId}_${userData.deptId}_${userData.lipikId}_${userData.officerId}_${userData.apoId}");
    await firebaseMessaging.subscribeToTopic('${userData!.id}');
    // ignore: avoid_print
    print("=== TOKEN === $token,,,,,  ");
    // RemoteMessage? msg = await firebaseMessaging.getInitialMessage();
    // initializeNotification(message: msg!);


    List? notificationTokenDataList = await ApiHelper.apiHelper.getAllNotificationsTokenData();

    List dataAvailable = notificationTokenDataList!.where((element) {
      print("===========cccccccc ${userData.id}");
      return (element['user_id'] == userData.id);
    }).toList();
    
    print("========== ");

    if(dataAvailable.isEmpty)
      {
        ApiHelper.apiHelper.insertNotificationsTokenData(notification_token: token!, user_id: userData.id!,);
      }

    else
      {
        print("=============tokkkkk ${dataAvailable.first['notification_token_id']} $token != ${dataAvailable.first['notification_token']} == ${token != dataAvailable.first['notification_token']}");
        if(token != dataAvailable.first['notification_token'])
          {
            ApiHelper.apiHelper.updateNotificationsTokenData(notification_token_id: dataAvailable.first['notification_token_id'], notification_token: token!,);
          }
      }

    NotificationSettings notificationSettings = await firebaseMessaging.requestPermission(
        alert: true,
        sound: true,
        badge: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true
    );


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.data['page'] == "Attendance")
      {
        // Get.to(const Report_Page());
      }
    });

    FirebaseMessaging.onMessage.listen((msg) {
      if(msg.notification != null)
      {
        var body = msg.notification!.body.toString();
        var title = msg.notification!.title.toString();
        print("============== data : ${msg.data}  cate : ${msg.category} android click action : ${msg.notification!.android!.clickAction}");
        initializeNotification(message: msg);
        showFirebaseNotification(title: title, body: body);
      }
    });

  }

  //Initialize Notification
  void initializeNotification({required RemoteMessage message})
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
  Future<void> showFirebaseNotification({required String title, required String body})
  async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      "1",
      "Android",
      importance: Importance.high,
      priority: Priority.max,
    );

    DarwinNotificationDetails iOSNotificationDetails = const DarwinNotificationDetails(subtitle: "IOS",);

    NotificationDetails notificationDetails =  NotificationDetails(android: androidNotificationDetails, iOS: iOSNotificationDetails);

    await flutterLocalNotificationsPlugin.show(1, title, body, notificationDetails).then((value) => print("Successfully Message Sent")).catchError((error) => print("$error"));
  }
}