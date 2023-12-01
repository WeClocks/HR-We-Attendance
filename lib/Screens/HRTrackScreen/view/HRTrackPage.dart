import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hr_we_attendance/Screens/HRTrackScreen/controller/HRTrackController.dart';
import 'package:hr_we_attendance/Screens/MapsScreen/view/MapsPage.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';

class HRTrackPage extends StatefulWidget {
  const HRTrackPage({super.key});

  @override
  State<HRTrackPage> createState() => _HRTrackPageState();
}

class _HRTrackPageState extends State<HRTrackPage> {

  HRTrackController hrTrackController = Get.put(HRTrackController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "${'staff'.tr} ${'tracking'.tr}",
            style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                      child: AlertDialog(
                        backgroundColor: const Color(0xFF2C2C50),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: hrTrackController.siteList
                                .map((element) => ElevatedButton(
                                onPressed: () async {
                                  EasyLoading.show(
                                      status: "${'please_wait'.tr}...");
                                  Get.back();
                                  if(element.name == "All")
                                  {
                                    await ApiHelper.apiHelper.getHRAttendanceData(date: DateTime.parse(hrTrackController.selectedDate.value)).then((value) {
                                      hrTrackController.hrAttendanceDataList.value = value == null ? [] : List.from(value.reversed);
                                      // Get.to(const HRTrackPage(),transition: Transition.fadeIn);
                                      EasyLoading.dismiss();
                                    });
                                  }
                                  else
                                  {
                                    await ApiHelper.apiHelper.getHRAttendanceData(date: DateTime.parse(hrTrackController.selectedDate.value)).then((value) {
                                      List hrAttendanceList = value == null ? [] : List.from(value.reversed);
                                      hrTrackController.hrAttendanceDataList.value = hrAttendanceList.where((e) => e['company_id'] == element.id).toList();
                                      // Get.to(const HRTrackPage(),transition: Transition.fadeIn);
                                      EasyLoading.dismiss();
                                    });
                                  }
                                  // EasyLoading.dismiss();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                child: Center(
                                  child: Text("${element.name}",style: const TextStyle(
                                    color: Color(0xFF2C2C50),
                                  ),),
                                )))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.filter_list_alt,color: Color(0xFF5b1aa0),),
            )
          ],
        ),
        body: Obx(
              () => Padding(
            padding: EdgeInsets.all(Get.width/30),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showDatePicker(context: context, initialDate: DateTime.parse(hrTrackController.selectedDate.value), firstDate: DateTime(DateTime.now().year), lastDate: DateTime.now()).then((value) async {
                      if(value != null)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        hrTrackController.selectedDate.value = value.toIso8601String();
                        await ApiHelper.apiHelper.getHRAttendanceData(date: DateTime.parse(hrTrackController.selectedDate.value)).then((value) {
                          hrTrackController.hrAttendanceDataList.value = value == null ? [] : List.from(value.reversed);
                          // Get.to(const HRTrackPage(),transition: Transition.fadeIn);
                          EasyLoading.dismiss();
                        });
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
                        Text(
                          // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                          DateFormat('dd MMM yyyy').format(DateTime.parse(hrTrackController.selectedDate.value)),
                          style: const TextStyle(
                            fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                        ),
                        const Icon(Icons.calendar_month,color: Color(0xFF5b1aa0),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.width/30,),
                Expanded(
                    child: hrTrackController.hrAttendanceDataList.isEmpty ? Center(child: Lottie.asset('assets/animation/cce.json',height: Get.width/1,width: Get.width/1,fit: BoxFit.fill)) : ListView.builder(
                      itemCount: hrTrackController.hrAttendanceDataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 0 : Get.width/30),
                          child: InkWell(
                            onTap: () async {
                              hrTrackController.hrAttendanceOneData.value = hrTrackController.hrAttendanceDataList[index];
                              List<SubSiteDataModel> subSiteList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: hrTrackController.hrAttendanceOneData['company_id']) ?? [];
                              print("=====~~~~~~~~subbbbbbbbbbbbbbb $subSiteList ${hrTrackController.hrAttendanceOneData.value}");
                              hrTrackController.userSubSiteData.value = subSiteList.where((element) => element.id == hrTrackController.hrAttendanceOneData['sub_company_id']).toList().isEmpty ? SubSiteDataModel() : subSiteList.where((element) => element.id == hrTrackController.hrAttendanceOneData['sub_company_id']).toList().first;
                              Get.to(const MapsPage(),transition: Transition.rightToLeft);
                            },
                            child: Container(
                              width: Get.width,
                              // height: Get.width / 4,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF5b1aa0),
                                  borderRadius: BorderRadius.circular(100)),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  // SizedBox(width: Get.width/90,),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF5b1aa0),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(Get.width/60),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${index+1}".padLeft(3, '0'),
                                      style: const TextStyle(
                                        fontSize: 16, color: Color(0xfff0e5ff),fontWeight: FontWeight.bold,),
                                    ),
                                  ),
                                  // SizedBox(width: Get.width/60,),
                                  Expanded(
                                    child: Container(
                                      // width: Get.width/1.2,
                                      // height: Get.width / 4,
                                      decoration: BoxDecoration(
                                          color: const Color(0xfff0e5ff),
                                          borderRadius: BorderRadius.circular(100)),
                                      padding: EdgeInsets.symmetric(vertical: Get.width/60,horizontal: 0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: Get.width/20,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                                                        "${hrTrackController.hrAttendanceDataList[index]['staff_name']}".toUpperCase(),
                                                        style: const TextStyle(
                                                          fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        Uri uri = Uri(path: '${hrTrackController.hrAttendanceDataList[index]['mobile']}',scheme: 'tel');
                                                        if(await canLaunchUrl(uri))
                                                        {
                                                          await launchUrl(uri);
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: Get.width/75,),
                                                          Icon(Icons.phone_in_talk_sharp,color: Color(0xFF5b1aa0)),
                                                          SizedBox(width: Get.width/75,),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                                                  "${'punch'.tr} ${'in'.tr} : ${DateFormat('hh:mm a').format(DateTime.parse(hrTrackController.hrAttendanceDataList[index]['clock_in']))} | ${'punch'.tr} ${'out'.tr} : ${hrTrackController.hrAttendanceDataList[index]['clock_out'] == null ? "-" : DateFormat('hh:mm a').format(DateTime.parse(hrTrackController.hrAttendanceDataList[index]['clock_out']))}",
                                                  style: const TextStyle(
                                                    fontSize: 13, color: Color(0xFF5b1aa0),),
                                                ),
                                                Text(
                                                  // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                                                  "${hrTrackController.hrAttendanceDataList[index]['company_name']}",
                                                  style: const TextStyle(
                                                    fontSize: 13, color: Color(0xFF5b1aa0),),
                                                ),
                                                Text(
                                                  // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                                                  "${hrTrackController.hrAttendanceDataList[index]['sub_company_name']}",
                                                  style: const TextStyle(
                                                    fontSize: 13, color: Color(0xFF5b1aa0),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              hrTrackController.hrAttendanceOneData.value = hrTrackController.hrAttendanceDataList[index];
                                              List<SubSiteDataModel> subSiteList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: hrTrackController.hrAttendanceOneData['company_id']) ?? [];
                                              print("=====~~~~~~~~subbbbbbbbbbbbbbb $subSiteList ${hrTrackController.hrAttendanceOneData.value}");
                                              hrTrackController.userSubSiteData.value = subSiteList.where((element) => element.id == hrTrackController.hrAttendanceOneData['sub_company_id']).toList().isEmpty ? SubSiteDataModel() : subSiteList.where((element) => element.id == hrTrackController.hrAttendanceOneData['sub_company_id']).toList().first;
                                              Get.to(const MapsPage(),transition: Transition.rightToLeft);
                                            },
                                            child: Row(
                                              children: [
                                                // SizedBox(width: Get.width/75,),
                                                Icon(Icons.double_arrow_rounded,color: Color(0xFF5b1aa0),size: Get.width/13,),
                                                SizedBox(width: Get.width/75,),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

