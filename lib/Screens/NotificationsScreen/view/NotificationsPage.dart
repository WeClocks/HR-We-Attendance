import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
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
  LoginController loginController =
  Get.put(LoginController());

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
        body: Padding(
          padding: EdgeInsets.all(Get.width/30),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showDatePicker(context: context, initialDate: DateTime.parse(notificationsController.selectedDate.value), firstDate: DateTime(DateTime.now().year), lastDate: DateTime.now()).then((value) async {
                    if(value != null)
                    {
                      EasyLoading.show(status: "${'please_wait'.tr}...");
                      notificationsController.selectedDate.value = value.toIso8601String();
                      List notificationsList = (await ApiHelper.apiHelper.getAllNotificationsData())!;
                      DateTime selectedDate = DateTime(value.year,value.month,value.day);
                      List notificationDataList = notificationsList.where((element) {
                        DateTime notificationInsertDate = DateTime.parse(element['ins_date_time']);
                        DateTime notificationDate = DateTime(notificationInsertDate.year,notificationInsertDate.month,notificationInsertDate.day);
                        return ((element['user_id'] == loginController.UserLoginData.value.id) && (selectedDate.compareTo(notificationDate) == 0));
                      }).toList();
                      notificationsController.notificationsList.value = List.from(notificationDataList.reversed);
                      // Get.to(const NotificationsPage(),transition: Transition.fadeIn);
                      EasyLoading.dismiss();
                    }
                  });
                },
                child: Container(
                  width: Get.width,
                  // height: Get.width / 4,
                  decoration: BoxDecoration(
                      color: const Color(0xfff0e5ff),
                      borderRadius: BorderRadius.circular(100)),
                  padding: EdgeInsets.all(Get.width/30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                          DateFormat('dd MMM yyyy').format(DateTime.parse(notificationsController.selectedDate.value)),
                          style: const TextStyle(
                            fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                        ),
                      ),
                      const Icon(Icons.calendar_month,color: Color(0xFF5b1aa0),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.width/30,),
              notificationsController.notificationsList.isEmpty
                  ? Expanded(
                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset('assets/animation/cce.json'),
                                        Center(child: Text("${'sorry'.tr}... ${'record_not_found'.tr}",style: const TextStyle(color: Colors.black,fontSize: 16,),),),
                                      ],
                    ),
                  )
                  : Expanded(
                    child: ListView.builder(
                                  itemCount: notificationsController.notificationsList.length,
                                  // reverse: true,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                    return Container(
                      width: Get.width,
                      padding: EdgeInsets.all(Get.width / 30),
                      margin: EdgeInsets.only(top: index == 0 ? 0 : Get.width/30),
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
                    );
                                  },
                                ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

