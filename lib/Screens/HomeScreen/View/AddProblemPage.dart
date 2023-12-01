import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:intl/intl.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/ProblemModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/PhotoViewPage.dart';

class AddProblemPage extends StatefulWidget {
  const AddProblemPage({super.key});

  @override
  State<AddProblemPage> createState() => _AddProblemPageState();
}

class _AddProblemPageState extends State<AddProblemPage> {
  LoginController loginController = Get.put(LoginController());
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF5b1aa0),),
        backgroundColor: Color(0xfff0e5ff),
        title: Text("${'add'.tr} ${'problem'.tr}",style: TextStyle(color: Color(0xFF5b1aa0),fontSize: 15,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top: 10,right: 5,left: 5,bottom: 10),
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  controller: loginController.txtRemark.value,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF5b1aa0)),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red.shade900)
                      ),
                      labelText: "remark".tr,
                      labelStyle: TextStyle(color: Color(0xFF5b1aa0))
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return "${'please'.tr} ${'enter_the'.tr} ${'remark'.tr}";
                    }
                  },
                ),
                SizedBox(height: Get.width/20,),
                Center(
                  child: InkWell(
                    onTap: () {
                      loginController.pickProblemImage(context);
                    },
                    child: Container(
                      height: Get.width/10,
                      width: Get.width/3,
                      decoration: BoxDecoration(
                          color: Color(0xFF5b1aa0),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      child: Text("take_photo".tr,style: const TextStyle(color: Color(0xfff0e5ff)),),
                    ),
                  ),
                ),
                SizedBox(height: Get.width/20,),
                Obx(() => loginController.imagepath2.isEmpty?Container(
                  height: Get.width/1.5,
                  width: Get.width/1,
                ):InkWell(
                  onTap: () {
                    Get.to(PhotoViewPage(imagePath: loginController.imagepath2.value),transition: Transition.fadeIn);
                  },
                  child: Container(
                    height: Get.width/1.5,
                    width: Get.width/1,
                    child: Image.file(File(loginController.imagepath2.value.toString()),fit: BoxFit.cover,),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        child: Container(
          height: Get.width/7,
          color: Color(0xFF5b1aa0),
          alignment: Alignment.center,
          child: Text("submit".tr,style: TextStyle(color: Color(0xfff0e5ff)),),
        ),
        onTap: () async {
          var connectivityResult = await Connectivity().checkConnectivity();
          if(connectivityResult != ConnectivityResult.none)
          {
            if(key.currentState!.validate())
            {
              if(loginController.imagepath2.isEmpty)
              {
                EasyLoading.showError("${'please'.tr} ${'first'.tr} ${'take_photo'.tr}");
              }
              else
              {
                // ignore: use_build_context_synchronously
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    backgroundColor: Color(0xfff0e5ff),
                    title: Text("${'submit'.tr}?",style: TextStyle(color: Color(0xFF5b1aa0)),),
                    content: Text("${'are_you_sure_want_to'.tr} ${'submit'.tr.toLowerCase()} ${'this'.tr.toLowerCase()} ${'problem'.tr.toLowerCase()}?",style: TextStyle(color: Color(0xFF5b1aa0)),),
                    actions: [
                      ElevatedButton(
                          onPressed: () async {
                            EasyLoading.show(status: "${'please_wait'.tr}...");
                            Get.back();
                            Get.back();
                            await ApiHelper.apiHelper.insertProblem(problemModel: ProblemModel(
                              problem: loginController.txtRemark.value.text,
                              prob_img: loginController.imagepath2.value,
                              userId: loginController.UserLoginData.value.id,
                              status: "Active",
                              insDateTime: DateTime.now(),
                            )).then((value) async {
                              List notificationAllTokenList = await ApiHelper.apiHelper.getAllNotificationsTokenData() ?? [];
                              StaffDataModel? hrData = await ApiHelper.apiHelper.getUserDesignationWise(designation_id: '121');
                              List oneNotificationTokenData = notificationAllTokenList.where((element) => element['user_id'] == hrData!.staffId!).toList();
                              await ApiHelper.apiHelper.insertNotificationData(title: "Hello HR....", description: "Date  :  ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}\nMy Today's Problem ${loginController.txtRemark.value.text}...", ins_date_time: DateTime.now(), user_id: hrData!.staffId!, seen: "false");
                              if(oneNotificationTokenData.isNotEmpty)
                              {
                                await ApiHelper.apiHelper.sendNotifications(title: "Hello HR....", body: "Date  :  ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}\nMy Today's Problem ${loginController.txtRemark.value.text}...", notification_token: oneNotificationTokenData.first['notification_token']);
                              }
                              loginController.problemData.value = (await ApiHelper.apiHelper.getProblem(user_id: loginController.UserLoginData.value.id!))!;
                              print("qqqqqqqqqqqqqqqq${loginController.problemData.length}");
                              EasyLoading.dismiss();
                            });
                          },style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: Text("yes".tr,style: const TextStyle(color: Colors.white),)),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("no".tr,style: const TextStyle(color: Colors.white),),)
                    ],
                  );
                },);
              }
            }
          }
          else
          {
            EasyLoading.showError("please_check_your_internet".tr);
          }
        },
      ),
    ));
  }
}