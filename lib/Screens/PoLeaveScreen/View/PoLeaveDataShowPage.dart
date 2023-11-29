import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveTypeDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffModel.dart';
import 'package:hr_we_attendance/Screens/PoLeaveScreen/Controller/PoLeaveController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/PhotoViewPage.dart';
class PoLeaveDataShowPage extends StatefulWidget {
  const PoLeaveDataShowPage({super.key});

  @override
  State<PoLeaveDataShowPage> createState() => _PoLeaveDataShowPageState();
}

class _PoLeaveDataShowPageState extends State<PoLeaveDataShowPage> {
  PoLeaveController poLeaveController = Get.put(PoLeaveController());
  LoginController loginController = Get.put(LoginController());
  Rx<StaffModel> staffModelData = StaffModel().obs;
  Rx<LeaveTypeDataModel> leaveTypeData = LeaveTypeDataModel().obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "Leave Details",
            style: TextStyle(color: Color(0xFF5b1aa0), fontSize: 13),
          ),
          centerTitle: true,
          // backgroundColor: const Color(0xFF2C2C50),
          actions: [
            GestureDetector(
              onTap: () async {
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
                                EasyLoading.show(status: "Please Wait...");
                                final String dir = (await getApplicationDocumentsDirectory()).path;
                                final ByteData data = await NetworkAssetBundle(Uri.parse(poLeaveController.leaveOneData.value.photo!)).load('');
                                final Uint8List bytes = data.buffer.asUint8List();
                                final String filePath = '$dir/${poLeaveController.leaveOneData.value.photo!.toString().split('/').last}';
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
                                    child: Image.network(poLeaveController.leaveOneData.value.photo!,fit: BoxFit.cover,)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },);
              },
              child: Container(
                height: Get.width/10,
                width: Get.width/10,
                margin: EdgeInsets.only(right: Get.width/30),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5b1aa0),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.photo_library_outlined,color: Colors.white,size: Get.width/21,),
              ),
            ),
          ],
        ),
        // backgroundColor: const Color(0xFF2C2C50),
        body: Padding(
          padding: EdgeInsets.all(Get.width/30),
          child: Container(
            width: Get.width,
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
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}   To   ${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}",
                        style: TextStyle(
                          color: Color(0xFF5b1aa0),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF5b1aa0),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: Get.width/45,vertical: Get.width/75),
                        alignment: Alignment.center,
                        child: Text(
                          "${poLeaveController.leaveOneData.value.days} days",
                          style: TextStyle(
                              color: Color(0xfff0e5ff),
                              fontSize: 11
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: ApiHelper.apiHelper.getStaffDataIdWish(id: poLeaveController.leaveOneData.value.userId!),
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        StaffModel stafData =snapshot.data!.first;
                        staffModelData.value = stafData;
                        return Text(
                          "Name : ${stafData.name}",
                          style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                          ),
                        );
                      }
                      return Text(
                        "",
                        style: const TextStyle(
                            color: Color(0xFF5b1aa0),
                        ),
                      );
                    },
                  ),
                  FutureBuilder(
                    future: ApiHelper.apiHelper.getStaffData(staff_id: poLeaveController.leaveOneData.value.userId!),
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        StaffDataModel siteData = snapshot.data!;
                        return Text(
                          "Site Name : ${siteData.companyName}",
                          style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                          ),
                        );
                      }
                      return Text(
                        "Site Name : ",
                        style: const TextStyle(
                            color: Color(0xFF5b1aa0),
                        ),
                      );
                    },
                  ),
                  FutureBuilder(
                    future: ApiHelper.apiHelper.getAllSubSiteData(company_id: poLeaveController.staffOneData.value.companyId!),
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        SubSiteDataModel siteData = snapshot.data!.first;
                        return Text(
                          "Site Name : ${siteData.name}",
                          style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                          ),
                        );
                      }
                      return Text(
                        "Site Name : ",
                        style: const TextStyle(
                            color: Color(0xFF5b1aa0),
                        ),
                      );
                    },
                  ),
                  FutureBuilder(
                    future: ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: poLeaveController.leaveOneData.value.leaveTypeId!),
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        LeaveTypeDataModel leaveTypeOneData = snapshot.data!.first;
                        return Text(
                          "${leaveTypeOneData.leaveTypeName} Leave",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5b1aa0),
                          ),
                        );
                      }
                      return Text(
                        "${poLeaveController.leaveOneData.value.leaveTypeId} Leave",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5b1aa0),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Get.width/90,),
                  Text(
                    "Reason: ${poLeaveController.leaveOneData.value.reason}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5b1aa0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: Get.width/30,vertical: Get.width/150),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if(poLeaveController.filterName.value.toLowerCase() == "Accept".toLowerCase())
                      {
                        EasyLoading.showError("Sorry this leave already accepted");
                      }
                    else
                      {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text("Accept?"),
                            content: const Text("Are you sure want to accept this Leave?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    EasyLoading.show(status: "Please Wait...");
                                    await ApiHelper.apiHelper.updateOneLeaveAcceptRejectData(leaveDataModel: LeaveDataModel(
                                        leaveId: poLeaveController.leaveOneData.value.leaveId,
                                        leaveStatus: "Accept",
                                        leaveStatusReason: "",
                                        leaveStatusDateTime: DateTime.now(),
                                        aprovedId: "${loginController.UserLoginData.value.id}"
                                    )).then((value) async {
                                      List notificationAllTokenList = await ApiHelper.apiHelper.getAllNotificationsTokenData() ?? [];
                                      List oneNotificationTokenData = notificationAllTokenList.where((element) => element['user_id'] == poLeaveController.leaveOneData.value.userId!).toList();
                                      await ApiHelper.apiHelper.insertNotificationData(title: "Hello ${staffModelData.value.name}...", description: "Your leave accepted successfully\n${leaveTypeData.value.leaveTypeName} leave from   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}''   to   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}''\nFor ''${poLeaveController.leaveOneData.value.days}'' Days...", ins_date_time: DateTime.now(), user_id: loginController.UserLoginData.value.id!, seen: "false");
                                      if(oneNotificationTokenData.isNotEmpty)
                                      {
                                        await ApiHelper.apiHelper.sendNotifications(title: "Hello ${staffModelData.value.name}...", body: "Your leave accepted successfully\n${leaveTypeData.value.leaveTypeName} leave from   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}''   to   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}''\nFor ''${poLeaveController.leaveOneData.value.days}'' Days...", notification_token: oneNotificationTokenData.first['notification_token']);
                                      }
                                      await ApiHelper.apiHelper.getPoAllLeaveData().then((value) {
                                        poLeaveController.leaveDataList.value = value!.where((element) => element.leaveStatus!.toLowerCase() == poLeaveController.filterName.toLowerCase()).toList();
                                        EasyLoading.dismiss();
                                        Timer(const Duration(milliseconds: 500), () {
                                          EasyLoading.showSuccess("Leave Status Update Successfully");
                                          Get.back();
                                          Get.back();
                                        });
                                      });
                                    });

                                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text("Yes",style: TextStyle(color: Colors.white),)),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("No",style: TextStyle(color: Colors.white),),)
                            ],
                          );
                        },);
                      }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5b1aa0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9)
                      )
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              SizedBox(width: Get.width/30,),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if(poLeaveController.filterName.value.toLowerCase() == "Reject".toLowerCase())
                    {
                      EasyLoading.showError("Sorry this leave already rejected");
                    }
                    else
                    {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text("Reject?"),
                          content: const Text("Are you sure want to reject this Leave?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  Get.back();
                                  TextEditingController txtReason = TextEditingController();
                                  GlobalKey<FormState> key = GlobalKey<FormState>();
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: const Text.rich(
                                          TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "Why?\n"
                                                ),
                                                TextSpan(
                                                    text: "Why reject this leave?",
                                                    style: TextStyle(
                                                        fontSize: 14
                                                    )
                                                )
                                              ]
                                          )
                                      ),
                                      content: Form(
                                        key: key,
                                        child: TextFormField(
                                          controller: txtReason,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            label: Text("Reason"),
                                            contentPadding: EdgeInsets.all(Get.width/45),

                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if(value!.isEmpty)
                                            {
                                              return "Please Enter Reason....";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            if(key.currentState!.validate())
                                              {
                                                    EasyLoading.show(status: "Please Wait...");
                                                    await ApiHelper.apiHelper.updateOneLeaveAcceptRejectData(leaveDataModel: LeaveDataModel(
                                                        leaveId: poLeaveController.leaveOneData.value.leaveId,
                                                        leaveStatus: "Reject",
                                                        leaveStatusReason: txtReason.text,
                                                        leaveStatusDateTime: DateTime.now(),
                                                        aprovedId: "${loginController.UserLoginData.value.id}"
                                                    )).then((value) async {
                                                      List notificationAllTokenList = await ApiHelper.apiHelper.getAllNotificationsTokenData() ?? [];
                                                      List oneNotificationTokenData = notificationAllTokenList.where((element) => element['user_id'] == poLeaveController.leaveOneData.value.userId!).toList();
                                                      await ApiHelper.apiHelper.insertNotificationData(title: "Hello ${staffModelData.value.name}...", description: "Your leave rejected\n${leaveTypeData.value.leaveTypeName} leave from   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}''   to   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}''\nFor ''${poLeaveController.leaveOneData.value.days}'' Days\nReason   :   ${txtReason.text}...", ins_date_time: DateTime.now(), user_id: loginController.UserLoginData.value.id!, seen: "false");
                                                      if(oneNotificationTokenData.isNotEmpty)
                                                      {
                                                        await ApiHelper.apiHelper.sendNotifications(title: "Hello ${staffModelData.value.name}...", body: "Your leave rejected\n${leaveTypeData.value.leaveTypeName} leave from   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}''   to   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}''\nFor ''${poLeaveController.leaveOneData.value.days}'' Days\nReason   :   ${txtReason.text}...", notification_token: oneNotificationTokenData.first['notification_token']);
                                                      }
                                                      await ApiHelper.apiHelper.getPoAllLeaveData().then((value) {
                                                        poLeaveController.leaveDataList.value = value!.where((element) => element.leaveStatus!.toLowerCase() == poLeaveController.filterName.toLowerCase()).toList();
                                                        EasyLoading.dismiss();
                                                        Timer(const Duration(milliseconds: 500), () {
                                                          EasyLoading.showSuccess("Leave Status Update Successfully");
                                                          Get.back();
                                                          Get.back();
                                                        });
                                                      });
                                                    });
                                              }
                                          },
                                            // onPressed: () async {
                                            //   if(key.currentState!.validate())
                                            //   {
                                            //     EasyLoading.show(status: "Please Wait...");
                                            //     LeaveTypeDataModel leaveTypeOneData = await Db_Helper.db_helper.readLeaveReasonTypeDataLeaveIdWise(leave_type_id: poLeaveController.leaveOneData.value.leaveTypeId!);
                                            //     List<LoginModel>? allUsersDataList = await Api_Helper.api_helper.GetLogin();
                                            //     List? notificationTokenDataList = await Api_Helper.api_helper.getAllNotificationsTokenData();
                                            //
                                            //     LoginModel oneUser = allUsersDataList!.where((element) {
                                            //       return (element.uid == poLeaveController.leaveOneData.value.userId);
                                            //     }).toList().first;
                                            //
                                            //     List dataAvailable = notificationTokenDataList!.where((element) {
                                            //       // return ((element['school_id'] == oneUser.schoolId!) && (element['standard_id'] == oneUser.standardId) && (element['hostel_id'] == oneUser.hostelId) && (element['cluster_id'] == oneUser.clusterId) && (element['user_id'] == oneUser.uid) && (element['central_kitchan_id'] == oneUser.centralKitchanId) && (element['civil_id'] == oneUser.civilId) && (element['dept_id'] == oneUser.deptId) && (element['lipik_id'] == oneUser.lipikId) && (element['officer_id'] == oneUser.officerId) && (element['apo_id'] == oneUser.apoId));
                                            //       return (element['user_id'] == oneUser.uid);
                                            //     }).toList();
                                            //     print("=====================dataAvailableeeeeeeeeeeeeeeee ${dataAvailable.length}");
                                            //     await Api_Helper.api_helper.updateOneLeaveAcceptRejectData(leaveDataModel: LeaveDataModel(
                                            //         leaveId: poLeaveController.leaveOneData.value.leaveId,
                                            //         leaveStatus: "Reject",
                                            //         leaveStatusReason: txtReason.text,
                                            //         leaveStatusDateTime: DateTime.now(),
                                            //         aprovedId: "${home_controller.UserData.value.uid}"
                                            //     )).then((value) async {
                                            //       if(poLeaveController.filterName.toLowerCase() == "Accept".toLowerCase())
                                            //       {
                                            //         DateTime startDate = DateTime.parse(poLeaveController.leaveOneData.value.startDate!);
                                            //
                                            //         List<KarmchariAttendanceModel>? allKarmachariList = await  Api_Helper.api_helper.GetTeacherAttendance(school_id: poLeaveController.leaveOneData.value.schoolId!,user_id: poLeaveController.leaveOneData.value.userId!,);
                                            //         for (int j = 0; j < int.parse(poLeaveController.leaveOneData.value.days!);)
                                            //         {
                                            //           List<KarmchariAttendanceModel> dataAvailable = allKarmachariList!.where((element) {
                                            //             print("============== dayyyyyyyyyy (${element.day} == ${startDate.day + j}) : ${(element.day == "${startDate.day + j}")} monthhhhhh (${element.month} == ${startDate.month}) : ${(element.month == "${startDate.month}")} yearrrrr (${element.year} == ${startDate.year}) : ${(element.year == "${startDate.year}")} atttttttttt (${element.attendance!.toLowerCase()} == ${"Leave".toLowerCase()}) : ${element.attendance!.toLowerCase() == "Leave".toLowerCase()} lastttttttttttt ${(element.day == "${startDate.day + j}") && (element.month == "${startDate.month}") && (element.year == "${startDate.year}") && (element.attendance!.toLowerCase() == "Leave".toLowerCase())}");
                                            //             return ((element.day == "${startDate.day + j}") && (element.month == "${startDate.month}") && (element.year == "${startDate.year}") && (element.attendance!.toLowerCase() == "Leave".toLowerCase()));
                                            //           }).toList();
                                            //           await Api_Helper.api_helper.deleteOneTeacherAttendanceData(
                                            //             teacher_report_id: "${dataAvailable.isEmpty ? 0 : dataAvailable.first.teacherreportId}",).then((value) {
                                            //             j++;
                                            //           });
                                            //         }
                                            //       }
                                            //       if(dataAvailable.isNotEmpty)
                                            //       {
                                            //         Api_Helper.api_helper.insertNotificationData(title:"Hello ${oneUser.name}", description: "Your leave rejected\n${leaveTypeOneData.leaveTypeName} leave from   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}''   to   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}''\nFor ''${poLeaveController.leaveOneData.value.days}'' Days\nReason   :   ${txtReason.text}...", ins_date_time: DateTime.now(), school_id: oneUser.schoolId!, standard_id: oneUser.standardId!, hostel_id: oneUser.hostelId!, cluster_id: oneUser.clusterId!, user_id: oneUser.uid!,central_kitchan_id: oneUser.centralKitchanId!, civil_id: oneUser.civilId!, dept_id: oneUser.deptId!, lipik_id: oneUser.lipikId!, officer_id: oneUser.officerId!, apo_id: oneUser.apoId!,seen: "false");
                                            //         Api_Helper.api_helper.sendNotifications(title: "Hello ${oneUser.name}", body: "Your leave rejected\n${leaveTypeOneData.leaveTypeName} leave from   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.startDate!))}''   to   ''${DateFormat('dd-MM-yyyy').format(DateTime.parse(poLeaveController.leaveOneData.value.endDate!))}''\nFor ''${poLeaveController.leaveOneData.value.days}'' Days\nReason   :   ${txtReason.text}...", notification_token: dataAvailable.first['notification_token']);
                                            //       }
                                            //       await Api_Helper.api_helper.getAllLeaveData().then((value) {
                                            //         poLeaveController.leaveDataList.value = value!.where((element) => element.leaveStatus!.toLowerCase() == poLeaveController.filterName.toLowerCase()).toList();
                                            //         EasyLoading.dismiss();
                                            //         Timer(const Duration(milliseconds: 500), () {
                                            //           EasyLoading.showSuccess("Leave Status Update Successfully");
                                            //           Get.back();
                                            //           Get.back();
                                            //           Get.back();
                                            //         });
                                            //       });
                                            //     });
                                            //   }
                                            // },
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                            child: const Text("Yes",style: TextStyle(color: Colors.white),)),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            Get.back();
                                          },
                                          child: Text("No",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                                      ],
                                    );
                                  },);
                                },style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Yes",style: TextStyle(color: Colors.white),)),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("No",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                          ],
                        );
                      },);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff0e5ff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9)
                      )
                  ),
                  child: const Text(
                    "Reject",
                    style: TextStyle(
                        color: Color(0xFF5b1aa0),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
