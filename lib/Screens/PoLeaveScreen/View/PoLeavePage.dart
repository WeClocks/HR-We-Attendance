import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffModel.dart';
import 'package:hr_we_attendance/Screens/PoLeaveScreen/Controller/PoLeaveController.dart';
import 'package:hr_we_attendance/Screens/PoLeaveScreen/View/PoLeaveDataShowPage.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:path/path.dart';
import 'package:hr_we_attendance/Utils/PhotoViewPage.dart';
import 'package:hr_we_attendance/main.dart';
class PoLeavePage extends StatefulWidget {
  const PoLeavePage({super.key});

  @override
  State<PoLeavePage> createState() => _PoLeavePageState();
}

class _PoLeavePageState extends State<PoLeavePage> {
  PoLeaveController poLeaveController = Get.put(PoLeaveController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Color(0xFF5b1aa0)),
            title: Text(
              "leave".tr,
              style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 13),
            ),
            centerTitle: true,
            // backgroundColor: const Color(0xfff0e5ff),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: Get.width/60),
                child: IconButton(onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                        child: AlertDialog(
                          backgroundColor: const Color(0xFF2C2C50),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ["Pending","Accept","Reject"]
                                .map((e) => ElevatedButton(
                                onPressed: () async {
                                  EasyLoading.show(status: "Please Wait....");
                                  poLeaveController.filterName.value = e;
                                  await ApiHelper.apiHelper.getPoAllLeaveData().then((value) {
                                    poLeaveController.leaveDataList.value = value!.where((element) => element.leaveStatus!.toLowerCase() == e.toLowerCase()).toList();
                                    Get.back();
                                    EasyLoading.dismiss();
                                  });

                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                child: Center(
                                  child: Text(e.toLowerCase() == 'pending'.toLowerCase() ? 'pending'.tr : e.toLowerCase() == 'accept'.toLowerCase() ? 'accept'.tr : 'reject'.tr,style: const TextStyle(
                                    color: Color(0xFF2C2C50),
                                  ),),
                                )))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  );
                }, icon: const Icon(Icons.filter_alt_rounded,color: Color(0xFF5b1aa0),)),
              )
            ],
          ),
          // backgroundColor: const Color(0xFF2C2C50),
          body: Obx(
                () => poLeaveController.leaveDataList.isEmpty ? Column(
              children: [
                SizedBox(height: Get.width/15,),
                Lottie.asset('assets/animation/cce.json'),
                Text(
                  "${'sorry'.tr}... ${poLeaveController.filterName.toLowerCase() == 'pending'.toLowerCase() ? 'pending'.tr : poLeaveController.filterName.toLowerCase() == 'accept'.toLowerCase() ? 'accept'.tr : 'reject'.tr}${homeController.selectedLanguage['lang'] != 'en'? '' : poLeaveController.filterName.value.toLowerCase() == "Pending".toLowerCase() ? "" : "ed"} ${'leave'.tr} ${'data_not_available'.tr}",
                  style: const TextStyle(
                      color: Color(0xFF5b1aa0),
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                  ),
                ),
              ],
            ) :
            ListView.builder(
              itemCount: poLeaveController.leaveDataList.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder(
                  curve: Curves.easeInOutQuart,
                  tween: Tween<double>(begin: 1, end: 0),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(value * 200,0),
                      child: child,
                    );
                  },
                  child: FutureBuilder(future: ApiHelper.apiHelper.getStaffData(staff_id: poLeaveController.leaveDataList[index].userId!), builder: (context, snapshot) {
                    if(snapshot.hasData)
                    {
                      StaffDataModel staffaData = snapshot.data!;
                      return InkWell(
                        onTap: () {
                          poLeaveController.leaveOneData.value = poLeaveController.leaveDataList[index];
                          poLeaveController.staffOneData.value = staffaData;
                          Get.to(const PoLeaveDataShowPage(),transition: Transition.fadeIn);
                        },
                        child: Container(
                          // height: 100,
                          width: Get.width,
                          margin: EdgeInsets.only(top: Get.width/30,left: Get.width/30,right: Get.width/30),
                          padding: EdgeInsets.all(Get.width/30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xfff0e5ff),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xFF5b1aa0),
                                    offset: Offset(0,1.5)
                                )
                              ]
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: FutureBuilder(future: ApiHelper.apiHelper.getStaffData(staff_id: poLeaveController.leaveDataList[index].userId!), builder:  (context, snapshot) {
                                  if(snapshot.hasData)
                                  {
                                    StaffDataModel staffData = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(future: ApiHelper.apiHelper.getStaffDataIdWise(id: poLeaveController.leaveDataList[index].userId!), builder: (context, snapshot) {
                                          if(snapshot.hasData)
                                          {
                                            StaffModel staff = snapshot.data!.first;
                                            return Row(children: [
                                              Text("${'name'.tr} : ",style: TextStyle(color: Color(0xFF5b1aa0)),),
                                              Text("${staff.name}",style: TextStyle(color: Color(0xFF5b1aa0)),)
                                            ]);
                                          }
                                          return Text("");
                                        },),
                                        FutureBuilder(
                                          future: ApiHelper.apiHelper.getStaffData(staff_id: poLeaveController.leaveDataList[index].userId!),
                                          builder: (context, snapshot) {
                                            if(snapshot.hasData)
                                            {
                                              StaffDataModel schoolData = snapshot.data!;
                                              return Text(
                                                "${'site'.tr} ${'name'.tr} : ${schoolData.companyName}",
                                                style: const TextStyle(
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                              );
                                            }
                                            return Text(
                                              "${'site'.tr} ${'name'.tr} : ${poLeaveController.leaveDataList[index].days}",
                                              style: const TextStyle(
                                                color: Color(0xFF5b1aa0),
                                              ),
                                            );
                                          },
                                        ),
                                        FutureBuilder(future: ApiHelper.apiHelper.getAllSubSiteData(company_id: staffData.companyId!), builder: (context, snapshot) {
                                          if(snapshot.hasData)
                                          {
                                            SubSiteDataModel companiData = snapshot.data!.first!;
                                            return Row(
                                              children: [
                                                Text("${'sub'.tr} ${'site'.tr} ${'name'.tr} : ",style: TextStyle(color: Color(0xFF5b1aa0))),
                                                Text("${companiData.name}",style: TextStyle(color: Color(0xFF5b1aa0))),
                                              ],
                                            );
                                          }
                                          return Text("");
                                        },),
                                        Text(
                                          "${'apply_date'.tr} : ${DateFormat('dd-MM-yyyy').format(poLeaveController.leaveDataList[index].insDateTime!)}",
                                          style: const TextStyle(
                                              color: Color(0xFF5b1aa0)
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${'name'.tr} : ${loginController.UserLoginData.value.name}",
                                          style: const TextStyle(
                                              color: Color(0xFF5b1aa0)
                                          )),
                                      FutureBuilder(
                                        future: ApiHelper.apiHelper.getStaffData(staff_id: poLeaveController.leaveDataList[index].userId!),
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData)
                                          {
                                            StaffDataModel schoolData = snapshot.data!;
                                            return Text(
                                              "${'site'.tr} ${'name'.tr} : ${schoolData.companyName}",
                                              style: const TextStyle(
                                                  color: Color(0xFF5b1aa0)
                                              ),
                                            );
                                          }
                                          return Text(
                                            "${'site'.tr} ${'name'.tr} : ${poLeaveController.leaveDataList[index].schoolId}",
                                            style: const TextStyle(
                                                color: Color(0xFF5b1aa0)
                                            ),
                                          );
                                        },
                                      ),
                                      Text(
                                        "${'apply_date'.tr} : ${DateFormat('dd-MM-yyyy').format(poLeaveController.leaveDataList[index].insDateTime!)}",
                                        style: const TextStyle(
                                            color: Color(0xFF5b1aa0)
                                        ),
                                      ),
                                      // Text(
                                      //     "Start Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveDataList[index].startDate!))}",
                                      //   style: const TextStyle(
                                      //     color: Colors.white
                                      //   ),
                                      // ),
                                      // Text(
                                      //     "End Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveDataList[index].endDate!))}",
                                      //   style: const TextStyle(
                                      //       color: Colors.white
                                      //   ),
                                      // ),
                                      // Text(
                                      //     "Days : ${poLeaveController.leaveDataList[index].days}",
                                      //   style: const TextStyle(
                                      //       color: Colors.white
                                      //   ),
                                      // ),
                                      // FutureBuilder(
                                      //   future: Db_Helper.db_helper.readLeaveReasonTypeDataLeaveIdWise(leave_type_id: poLeaveController.leaveDataList[index].leaveTypeId!),
                                      //   builder: (context, snapshot) {
                                      //     if(snapshot.hasData)
                                      //     {
                                      //       LeaveTypeDataModel leaveTypeOneData = snapshot.data!;
                                      //       return Text(
                                      //           "Leave Type : ${leaveTypeOneData.leaveTypeName}",
                                      //         style: const TextStyle(
                                      //             color: Colors.white
                                      //         ),
                                      //       );
                                      //     }
                                      //     return Text(
                                      //         "Leave Type : ${poLeaveController.leaveDataList[index].leaveTypeId}",
                                      //       style: const TextStyle(
                                      //           color: Colors.white
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      // Text(
                                      //     "Reason: ${poLeaveController.leaveDataList[index].leaveStatus}",
                                      //   style: const TextStyle(
                                      //       color: Colors.white
                                      //   ),
                                      // ),
                                    ],
                                  );
                                },),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    File file = File(poLeaveController.leaveDataList[index].photo!);
                                    print("================== $file imggggggggg ${poLeaveController.leaveDataList[index].photo!}");
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            Padding(
                                              padding:  const EdgeInsets.only(top: 25),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () async {
                                                    EasyLoading.show(status: "${'please_wait'.tr}...");
                                                    final String dir = (await getApplicationDocumentsDirectory()).path;
                                                    final ByteData data = await NetworkAssetBundle(Uri.parse(poLeaveController.leaveDataList[index].photo!)).load('');
                                                    final Uint8List bytes = data.buffer.asUint8List();
                                                    final String filePath = '$dir/${poLeaveController.leaveDataList[index].photo!.toString().split('/').last}';
                                                    final File file = File(filePath);
                                                    await file.writeAsBytes(bytes, flush: true);
                                                    Get.to(PhotoViewPage(imagePath: file.path),transition: Transition.fadeIn);
                                                    EasyLoading.dismiss();
                                                  },
                                                  child: SizedBox(
                                                    height: Get.width/1.5,
                                                    width: Get.width/1.5,
                                                    child: InteractiveViewer(
                                                        maxScale: 3.0,
                                                        minScale: 0.5,
                                                        child: Image.network(poLeaveController.leaveDataList[index].photo!,fit: BoxFit.cover,)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },);
                                  },
                                  child: Container(
                                    height: Get.width/13,
                                    width: Get.width/13,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF5b1aa0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.photo_library_outlined,color: Colors.white,size: Get.width/21,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return Text("");
                  },),
                );
              },
            ),
          )
      ),
    );
  }
}
