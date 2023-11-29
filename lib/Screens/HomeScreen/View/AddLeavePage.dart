import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/main.dart';
class AddLeavePage extends StatefulWidget {
  const AddLeavePage({super.key});

  @override
  State<AddLeavePage> createState() => _AddLeavePageState();
}

class _AddLeavePageState extends State<AddLeavePage> {
  HomeController homeController = Get.put(HomeController());
  DateTime nowDateTime = DateTime.now();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    homeController.leaveUpdateId.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xfff0e5ff),
            iconTheme: IconThemeData(color: Color(0xFF5b1aa0)),
            title: Text("Add Leave",style: TextStyle(color:Color(0xFF5b1aa0),fontSize: 15),),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(Get.width/30),
            child: Obx(
                  () => SingleChildScrollView(
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        // height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // boxShadow: const [
                          //   BoxShadow(
                          //       color: Colors.grey,
                          //       spreadRadius: 0,
                          //       blurRadius: 2),
                          // ],
                          border: Border.all(color: Color(0xFF5b1aa0)),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: Get.width/30,vertical: Get.width/150),
                        child:DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: Color(0xfff0e5ff),
                            items: homeController.leaveReasonTypeList.map((e) => DropdownMenuItem(value: "${e.leaveTypeName}",child: Text("${e.leaveTypeName}",style: TextStyle(color: e.leaveTypeName == "Choose Type" ? Colors.grey : Color(0xFF5b1aa0)),),onTap: () async {
                              EasyLoading.show(status: "Please Wait...");
                              if(e.leaveTypeName! == "Choose Type")
                              {
                                homeController.dropDownLeaveType.value = e.leaveTypeName!;
                                homeController.leaveTypeOneData.value = e;
                                EasyLoading.dismiss();
                              }
                              else
                              {
                                await homeController.checkLeaveTypeDataAvailable(leaveTypeDataModel: e).then((value) async {
                                  print("=========== vvvvvvv ${homeController.vadhelaLeaveTypeDays.value} ${homeController.leaveTypeDataAvailableList.isNotEmpty} ? ${homeController.vadhelaLeaveTypeDays.value} : ${int.parse("${e.leaveNos}")}) - (${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays}) ${((homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse("${e.leaveNos}")) - DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays)}");
                                  if(((homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse("${e.leaveNos}")) - DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays) >= 0)
                                  {
                                    print("=============dateeeeee ${homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.leaveTypeDataAvailableList.last.endDate : "Not"}");
                                    homeController.leaveTypeOneData.value = e;
                                    homeController.dropDownLeaveType.value = e.leaveTypeName!;
                                    homeController.usedDaysLeaveTypeWise.value = 0;
                                    await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise2(leave_type_id: e.leaveTypeId!).then((value) async {
                                      homeController.usedDaysLeaveTypeWise.value = value!.fold(0, (previousValue, element) => (previousValue + int.parse(element.days!)));
                                      print("sssssssssssssss${homeController.usedDaysLeaveTypeWise}");
                                      EasyLoading.dismiss();
                                    });
                                  }
                                  else
                                  {
                                    EasyLoading.dismiss();
                                    Timer(const Duration(milliseconds: 200), () {
                                      EasyLoading.showError("Sorry  ${e.leaveTypeName} Leave quota is finished");
                                    });
                                  }
                                });
                              }

                            },)).toList(),
                            onChanged: (value) {
                              print("========hhhhhhhh");
                              // homeController.checkLeaveTypeDataAvailable();
                              // if(((homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse("${homeController.leaveTypeOneData.value.leaveNos}")) - DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays) >= 0)
                              // {
                              //   homeController.dropDownLeaveType.value = value!;
                              // }
                              // else
                              // {
                              //   EasyLoading.showError("Sorry  $value Leave quota is finished");
                              // }
                            },
                            value: homeController.dropDownLeaveType.value,
                          ),
                        ),
                      ),
                      SizedBox(height: Get.width/20,),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: Get.width/8,
                              child: TextFormField(
                                keyboardType: TextInputType.none,
                                readOnly: true,
                                showCursor: false,
                                controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.startDate.value))),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    labelText: "Start Date",
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                                onTap: () async {
                                  DateTime? dateTime = await showDatePicker(context: context, initialDate: DateTime.parse(homeController.startDate.value), firstDate: nowDateTime, lastDate: DateTime(2050));
                                  if(dateTime != null)
                                  {
                                    print("=============== ${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day)} == $dateTime : ${(DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).compareTo(dateTime))}");
                                    if((DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).compareTo(dateTime) == 1))
                                    {
                                      homeController.startDate.value = dateTime.toIso8601String();
                                    }
                                    else
                                    {
                                      EasyLoading.showError("Please Select Valid Date");
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width/45,),
                          Expanded(
                            child: SizedBox(
                              height: Get.width/8,
                              child: TextFormField(
                                keyboardType: TextInputType.none,
                                readOnly: true,
                                showCursor: false,
                                controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.endDate.value))),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    labelText: "End Date",
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                                onTap: () async {
                                  DateTime? dateTime = await showDatePicker(context: context, initialDate: DateTime.parse(homeController.endDate.value), firstDate: homeController.beforeEndDate, lastDate: DateTime(2050));
                                  if(dateTime != null)
                                  {
                                    if((dateTime.compareTo(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)) == 1))
                                    {
                                      print("wwwwwwwwwwwwwwwwwwwwwwww${homeController.leaveOneData.value.leaveTypeId}");
                                      print("dateeeeeeeeeeeeee ${(DateTime(dateTime.year,dateTime.month,dateTime.day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays)} <= ${(homeController.canAddEdit.value == 0 ? homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!) : (DateTime(DateTime.parse(homeController.leaveOneData.value.endDate!).year,DateTime.parse(homeController.leaveOneData.value.endDate!).month,DateTime.parse(homeController.leaveOneData.value.endDate!).day).difference(DateTime(DateTime.parse(homeController.leaveOneData.value.startDate!).year,DateTime.parse(homeController.leaveOneData.value.startDate!).month,DateTime.parse(homeController.leaveOneData.value.startDate!).day)).inDays) + (homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!)))}");
                                      if((DateTime(dateTime.year,dateTime.month,dateTime.day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays) <= (homeController.canAddEdit.value == 0 ? homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!) : (DateTime(DateTime.parse(homeController.leaveOneData.value.endDate!).year,DateTime.parse(homeController.leaveOneData.value.endDate!).month,DateTime.parse(homeController.leaveOneData.value.endDate!).day).difference(DateTime(DateTime.parse(homeController.leaveOneData.value.startDate!).year,DateTime.parse(homeController.leaveOneData.value.startDate!).month,DateTime.parse(homeController.leaveOneData.value.startDate!).day)).inDays) + (homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!))))
                                      {
                                        homeController.endDate.value = dateTime.toIso8601String();
                                      }
                                      else
                                      {
                                        EasyLoading.showError("Please Select Valid Date ${homeController.dropDownLeaveType.value} leave Max ${homeController.canAddEdit.value == 0 ? homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : homeController.leaveTypeOneData.value.leaveNos : (DateTime(DateTime.parse(homeController.leaveOneData.value.endDate!).year,DateTime.parse(homeController.leaveOneData.value.endDate!).month,DateTime.parse(homeController.leaveOneData.value.endDate!).day).difference(DateTime(DateTime.parse(homeController.leaveOneData.value.startDate!).year,DateTime.parse(homeController.leaveOneData.value.startDate!).month,DateTime.parse(homeController.leaveOneData.value.startDate!).day)).inDays) + (homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!))} Days Available");
                                      }
                                    }
                                    else
                                    {
                                      EasyLoading.showError("Please Select Valid Date");
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.width/45,),
                      // homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : Text(
                      //   "Total available ${homeController.dropDownLeaveType.value} leave quota ${homeController.canAddEdit.value == 0
                      //       ? homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : homeController.leaveTypeOneData.value.leaveNos
                      //       : (DateTime(DateTime.parse(homeController.leaveOneData.value.endDate!).year,DateTime.parse(homeController.leaveOneData.value.endDate!).month,DateTime.parse(homeController.leaveOneData.value.endDate!).day).difference(DateTime(DateTime.parse(homeController.leaveOneData.value.startDate!).year,DateTime.parse(homeController.leaveOneData.value.startDate!).month,DateTime.parse(homeController.leaveOneData.value.startDate!).day)).inDays) + (homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!))} days",
                      //   style: const TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600
                      //   ),
                      // ),
                      // // SizedBox(height: Get.width/45,),
                      // homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : Text(
                      //   "Selected ${homeController.dropDownLeaveType.value} leave ${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays} days",
                      //   style: const TextStyle(
                      //     color: Colors.red,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600
                      //   ),
                      // ),
                      // homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : Text(
                      //   "Total ${(homeController.canAddEdit.value == 0 ? homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!) : (DateTime(DateTime.parse(homeController.leaveOneData.value.endDate!).year,DateTime.parse(homeController.leaveOneData.value.endDate!).month,DateTime.parse(homeController.leaveOneData.value.endDate!).day).difference(DateTime(DateTime.parse(homeController.leaveOneData.value.startDate!).year,DateTime.parse(homeController.leaveOneData.value.startDate!).month,DateTime.parse(homeController.leaveOneData.value.startDate!).day)).inDays) + (homeController.leaveTypeDataAvailableList.isNotEmpty ? homeController.vadhelaLeaveTypeDays.value : int.parse(homeController.leaveTypeOneData.value.leaveNos!))) - (DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays)} Days left of ${homeController.dropDownLeaveType.value} leave quota",
                      //   style: const TextStyle(
                      //     color: Colors.red,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600
                      //   ),
                      // ),
                      // homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : SizedBox(height: Get.width/60,),
                      homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF5b1aa0),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: Get.width/45,vertical: Get.width/75),
                          // alignment: Alignment.center,
                          child: Text("${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1} Days",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11
                            ),
                          ),
                        ),
                      ),
                      homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : SizedBox(height: Get.width/60,),
                      homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : Table(
                        border: TableBorder.all(color: Color(0xFF5b1aa0)),
                        children: [
                          TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: const Center(
                                    child: Text(
                                      "Quota",
                                      style: TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: const Center(
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: const Center(
                                    child: Text(
                                      "Used",
                                      style: TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: const Center(
                                    child: Text(
                                      "Available",
                                      style: TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: Center(
                                    child: Text(
                                      "${homeController.leaveTypeOneData.value.leaveTypeName}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: Center(
                                    child: Text(
                                      "${homeController.leaveTypeOneData.value.leaveNos}",
                                      style: const TextStyle(
                                        color: Color(0xFF5b1aa0),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: Center(
                                    child: Text(
                                      "${homeController.usedDaysLeaveTypeWise.value == 0 ? "-" : homeController.usedDaysLeaveTypeWise}",
                                      style: const TextStyle(
                                        color: Color(0xFF5b1aa0),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Get.width/60),
                                  child: Center(
                                    child: Text(
                                      "${(int.parse(homeController.leaveTypeOneData.value.leaveNos!) - homeController.usedDaysLeaveTypeWise.value) == 0 ? "-" : int.parse(homeController.leaveTypeOneData.value.leaveNos!) - homeController.usedDaysLeaveTypeWise.value}",
                                      style: const TextStyle(
                                        color: Color(0xFF5b1aa0),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                      homeController.leaveTypeOneData.value.leaveTypeName == "Choose Type" ? Container() : SizedBox(height: Get.width/30,),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: homeController.txtReason,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Leave Reason",
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Fill Leave Reason...";
                          }
                        },
                      ),
                      SizedBox(height: Get.width/30,),
                      InkWell(
                        child: Container(
                          height: Get.width / 8,
                          decoration: BoxDecoration(
                              color: Color(0xFF5b1aa0),
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                              child: Text(
                                "Take Photo",
                                style: TextStyle(color: Color(0xfff0e5ff)),
                              )),
                        ),
                        onTap: () async {
                          ImagePicker picker = ImagePicker();
                          XFile? xFile = await picker.pickImage(
                              source: ImageSource.camera);
                          if(xFile != null)
                          {
                            homeController.imagePath.value = xFile.path;
                          }
                        },
                      ),
                      SizedBox(height: Get.width/30,),
                      Visibility(
                        visible: homeController.imagePath.isNotEmpty,
                        child: Center(
                          child: SizedBox(
                            height: Get.width / 1.5,
                            width: Get.width / 1.5,
                            child: InteractiveViewer(
                                child: Image.file(
                                  File(homeController.imagePath.value),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () async {
              if(homeController.dropDownLeaveType.value == "Choose Type")
              {
                EasyLoading.showError("Sorry Please Select Leave Type...");
              }
              else if(key.currentState!.validate())
              {
                if(homeController.imagePath.isEmpty)
                {
                  EasyLoading.showError("Sorry Please Take Photo...");
                }
                else
                {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: const Text("Save?"),
                      content: const Text("Are you sure want to save this Leave?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              if(homeController.canAddEdit.value == 0)
                              {
                              EasyLoading.show(status: 'Please Wait....');
                              var connectivityResult = await Connectivity().checkConnectivity();
                              if(connectivityResult != ConnectivityResult.none) {
                                homeController.filterOrNot.value = false;
                                await ApiHelper.apiHelper.insertLeaveData(
                                    leaveDataModel: LeaveDataModel(
                                      userId: loginController.UserLoginData.value.id,
                                      leaveStatus: "Pending",
                                      leaveStatusDateTime: DateTime.now(),
                                      aprovedId: "0",
                                      status: "Active",
                                      days: "${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1}",
                                      leaveTypeId: homeController.leaveTypeOneData.value.leaveTypeId,
                                      startDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(homeController.startDate.value)),
                                      endDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(homeController.endDate.value)),
                                      reason: homeController.txtReason.text,
                                      photo: homeController.imagePath.value,
                                      insDateTime: DateTime.now(),
                                    )
                                ).then((value) async {
                                  List notificationAllTokenList = await ApiHelper.apiHelper.getAllNotificationsTokenData() ?? [];
                                  List oneNotificationTokenData = notificationAllTokenList.where((element) => element['user_id'] == "121").toList();
                                  await ApiHelper.apiHelper.insertNotificationData(title: "Hello HR....", description: "${loginController.UserLoginData.value.name}\nLeave Date  :  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.startDate.value))}  To  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.endDate.value))}\nTotal Days  :  ${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1}    Leave Type  :  ${homeController.leaveTypeOneData.value.leaveTypeName}\nReason  :  ${homeController.txtReason.text}\nPlease Accept This Leave....", ins_date_time: DateTime.now(), user_id: loginController.UserLoginData.value.id!, seen: "false");
                                  if(oneNotificationTokenData.isNotEmpty)
                                  {
                                    await ApiHelper.apiHelper.sendNotifications(title: "Hello HR....", body: "${loginController.UserLoginData.value.name}\nLeave Date  :  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.startDate.value))}  To  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.endDate.value))}\nTotal Days  :  ${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1}    Leave Type  :  ${homeController.leaveTypeOneData.value.leaveTypeName}\nReason  :  ${homeController.txtReason.text}\nPlease Accept This Leave....", notification_token: oneNotificationTokenData.first['notification_token']);
                                  }
                                  Get.back();
                                  EasyLoading.dismiss();
                                  Get.back();
                                  homeController.leaveData.value = (await ApiHelper.apiHelper.getLeaveDatauserWise(user_id: loginController.UserLoginData.value.id!))!;
                                  EasyLoading.showSuccess('Insert Successfully');
                                });
                              }
                              else
                                {
                                  EasyLoading.dismiss();
                                  EasyLoading.showError('Please Check Your Internet');
                                }
                              }
                              else
                              {
                                EasyLoading.show(status: 'Please Wait....');
                                var connectivityResult = await Connectivity().checkConnectivity();
                                if(connectivityResult != ConnectivityResult.none)
                                {
                                  await ApiHelper.apiHelper.updateOneLeaveData(leaveDataModel: LeaveDataModel(
                                    leaveId: homeController.leaveUpdateId.value,
                                    leaveStatus: "Pending",
                                    leaveStatusDateTime: DateTime.now(),
                                    aprovedId: "0",
                                    status: "Active",
                                    days: "${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1}",
                                    leaveTypeId: homeController.leaveTypeOneData.value.leaveTypeId,
                                    startDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(homeController.startDate.value)),
                                    endDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(homeController.endDate.value)),
                                    reason: homeController.txtReason.text,
                                    photo: homeController.imagePath.value,
                                    updateDateTime: DateTime.now(),
                                  )).then((value) async {
                                    List notificationAllTokenList = await ApiHelper.apiHelper.getAllNotificationsTokenData() ?? [];
                                    List oneNotificationTokenData = notificationAllTokenList.where((element) => element['user_id'] == "121").toList();
                                    await ApiHelper.apiHelper.insertNotificationData(title: "Hello HR....", description: "Updated Leave ${loginController.UserLoginData.value.name}\nLeave Date  :  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.startDate.value))}  To  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.endDate.value))}\nTotal Days  :  ${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1}    Leave Type  :  ${homeController.leaveTypeOneData.value.leaveTypeName}\nReason  :  ${homeController.txtReason.text}\nPlease Accept This Leave....", ins_date_time: DateTime.now(), user_id: loginController.UserLoginData.value.id!, seen: "false");
                                    if(oneNotificationTokenData.isNotEmpty)
                                    {
                                      await ApiHelper.apiHelper.sendNotifications(title: "Hello HR....", body: "Updated Leave ${loginController.UserLoginData.value.name}\nLeave Date  :  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.startDate.value))}  To  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.endDate.value))}\nTotal Days  :  ${DateTime(DateTime.parse(homeController.endDate.value).year,DateTime.parse(homeController.endDate.value).month,DateTime.parse(homeController.endDate.value).day).difference(DateTime(DateTime.parse(homeController.startDate.value).year,DateTime.parse(homeController.startDate.value).month,DateTime.parse(homeController.startDate.value).day)).inDays + 1}    Leave Type  :  ${homeController.leaveTypeOneData.value.leaveTypeName}\nReason  :  ${homeController.txtReason.text}\nPlease Accept This Leave....", notification_token: oneNotificationTokenData.first['notification_token']);
                                    }
                                    Get.back();
                                    EasyLoading.dismiss();
                                    Get.back();
                                    homeController.leaveData.value = (await ApiHelper.apiHelper.getLeaveDatauserWise(user_id: loginController.UserLoginData.value.id!))!;
                                    EasyLoading.showSuccess('Updated Successfully');
                                  });
                                }
                                else
                                {
                                  EasyLoading.dismiss();
                                  EasyLoading.showError('Please Check Your Internet');
                                }
                              }
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
              }
            },
            child: IntrinsicHeight(
              child: Container(
                width: Get.width,
                color: Color(0xFF5b1aa0),
                padding: EdgeInsets.symmetric(vertical: Get.width/30),
                alignment: Alignment.center,
                child: Obx(
                      () => Text(
                    homeController.canAddEdit.value == 0 ? "Submit" : "Edit",
                    style: const TextStyle(
                        color: Color(0xfff0e5ff),
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
