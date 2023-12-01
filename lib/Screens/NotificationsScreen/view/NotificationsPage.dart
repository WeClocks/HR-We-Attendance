import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hr_we_attendance/Screens/NotificationsScreen/controller/NotificationsController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  NotificationsController notificationsController =
  Get.put(NotificationsController());

  Future<void> updateNotSeenToSeenNotifications()
  async {
    for(int i=0; i<notificationsController.notificationsList.length;)
    {
      print("=============idddddddddddddddd $i = ${notificationsController.notificationsList[i]['notification_id']} seennnnnnnn ${notificationsController.notificationsList[i]['seen']}");
      if(notificationsController.notificationsList[i]['seen'] == "false")
      {
        await ApiHelper.apiHelper.updateNotSeenToSeenNotificationsData(notification_id: notificationsController.notificationsList[i]['notification_id'], seen: "true").then((value) {
          i++;
        });
      }
      else
      {
        i++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    updateNotSeenToSeenNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "notifications".tr,
            style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: notificationsController.notificationsList.isEmpty ? Padding(
          padding: EdgeInsets.all(Get.width / 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/animation/cce.json'),
              Center(child: Text("${'sorry'.tr}... ${'record_not_found'.tr}",style: const TextStyle(color: Colors.black,fontSize: 16,),),),
            ],
          ),
        ) : ListView.builder(
          itemCount: notificationsController.notificationsList.length,
          // reverse: true,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: Get.width/30, left: Get.width/30,top: Get.width/30, bottom: index == 0 ? Get.width/30 : 0),
              child: Container(
                width: Get.width,
                padding: EdgeInsets.all(Get.width / 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0,
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(18)),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${notificationsController.notificationsList[index]['title']}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          // fontSize: 16,
                        ),
                      ),
                      // SizedBox(
                      //   height: Get.width / 80,
                      // ),
                      Text(
                        "${notificationsController.notificationsList[index]['description']}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

