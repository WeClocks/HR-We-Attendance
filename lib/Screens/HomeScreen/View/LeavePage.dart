import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveTypeDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/AddLeavePage.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/PhotoViewPage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfff0e5ff),
            iconTheme: const IconThemeData(color: Color(0xFF5b1aa0),),
            title: Text("leave".tr,style: const TextStyle(color: Color(0xFF5b1aa0),fontSize: 15),),
            centerTitle: true,
            actions: [
              Padding(
                padding:  EdgeInsets.only(right: 10),
                child: InkWell(onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                        child: AlertDialog(
                          backgroundColor: const Color(0xFF5b1aa0),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: homeController.leaveReasonTypeFilterList
                                .map((element) => ElevatedButton(
                                onPressed: () async {
                                  EasyLoading.show(
                                      status: "${'please_wait'.tr}...");
                                  Get.back();
                                  homeController.leaveTypeFilterOneData.value = element;
                                  if(element.leaveTypeName == "All")
                                  {
                                    homeController.filterOrNot.value = false;
                                    List<LeaveDataModel> leaveList = (await ApiHelper.apiHelper.getAllLeaveData()) ?? [];
                                    homeController.leaveData.value = leaveList.where((element) => element.userId == loginController.UserLoginData.value.id).toList();
                                    EasyLoading.dismiss();
                                  }
                                  else
                                  {
                                    homeController.filterOrNot.value = true;
                                    await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise2(leave_type_id: element.leaveTypeId!).then((value) async {
                                      homeController.leaveDataFilterList.value = value!;
                                      EasyLoading.dismiss();
                                    });
                                  }
                                  // EasyLoading.dismiss();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xfff0e5ff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                child: Center(
                                  child: Text("${element.leaveTypeName}",style: const TextStyle(
                                    color: Color(0xFF5b1aa0),
                                  ),),
                                )))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  );
                }, child: Icon(Icons.filter_alt_rounded,color: Color(0xFF5b1aa0),size: Get.width/16,)),
              ),
            ],
          ),
          body: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: Get.width/30,top: Get.width/45),
                    child: InkWell(
                      onTap: () async {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        List<int> usedLeaveQuota = [0,];

                        for(int x=1; x<homeController.leaveReasonTypeFilterList.length;)
                        {
                          await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise2(leave_type_id: homeController.leaveReasonTypeFilterList[x].leaveTypeId!).then((value) async {
                            int count = value!.fold(0, (previousValue, element) => (previousValue + int.parse(element.days!)));
                            usedLeaveQuota.add(count);
                            x++;
                            print("============== ${usedLeaveQuota.length} $x");
                          });
                        }
                        EasyLoading.dismiss();
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                              child: IntrinsicHeight(
                                child: Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    width: Get.width,
                                    // color: Colors.red,
                                    padding: EdgeInsets.all(Get.width/90),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: Get.width/60,),
                                        Text(
                                          "${'my'.tr} ${'leave'.tr} ${'quota'.tr} - ${DateTime.now().year}",
                                          style: const TextStyle(
                                            color: Color(0xFF5b1aa0),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: Get.width/60,),
                                        Table(
                                          // border: TableBorder.all(color: const Color(0xFF2C2C50)),
                                          children: [
                                            TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(Get.width/60),
                                                    child: Center(
                                                      child: Text(
                                                        "type".tr,
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
                                                        "total".tr,
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
                                                        "used".tr,
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
                                                        "available".tr,
                                                        style: const TextStyle(
                                                          color: Color(0xFF5b1aa0),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                            ),
                                            for(int i=1; i<homeController.leaveReasonTypeFilterList.length; i++)
                                              TableRow(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(Get.width/60),
                                                      child: Center(
                                                        child: Text(
                                                          "${homeController.leaveReasonTypeFilterList[i].leaveTypeName}",
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
                                                          "${homeController.leaveReasonTypeFilterList[i].leaveNos}",
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
                                                          "${usedLeaveQuota[i] == 0 ? "-" : usedLeaveQuota[i]}",
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
                                                          "${(int.parse(homeController.leaveReasonTypeFilterList[i].leaveNos!) - usedLeaveQuota[i] ) == 0 ? "-" : int.parse(homeController.leaveReasonTypeFilterList[i].leaveNos!) - usedLeaveQuota[i]}",
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text("${'my'.tr} ${'leave'.tr} ${'quota'.tr}",style: const TextStyle(
                          color: Color(0xFF5b1aa0),
                          decoration: TextDecoration.underline
                      ),),
                    ),
                  ),
                ),
                Expanded(
                    child: Obx(() => homeController.leaveData.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Lottie.asset('assets/animation/cce.json',height: Get.width/1,width: Get.width/1,fit: BoxFit.fill)),
                        Center(child: Text("${'once_you_start'.tr} ${'leave'.tr}, ${'you_ll'.tr}")),
                        Center(child: Text("see_it_listen_here".tr))
                      ],
                    ):
                    Obx(
                          () => homeController.filterOrNot.value == false ? ListView.builder(
                        itemCount: homeController.leaveData.length,
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
                            child: Obx(() => Container(
                              // height: 100,
                              width: Get.width,
                              margin: EdgeInsets.only(top: Get.width/30,left: Get.width/30,right: Get.width/30),
                              padding: EdgeInsets.symmetric(horizontal: Get.width/30,vertical: Get.width/60),
                              decoration: BoxDecoration(
                                  color: Color(0xfff0e5ff),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.leaveData[index].startDate!))}   ${'to'.tr}   ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.leaveData[index].endDate!))}",style: const TextStyle(color: Color(0xFF5b1aa0)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF5b1aa0),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: Get.width/45,vertical: Get.width/75),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${homeController.leaveData[index].days} ${'days'.tr.toLowerCase()}",
                                          style: const TextStyle(
                                              color: Color(0xfff0e5ff),
                                              fontSize: 11
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Leave status : ",
                                                  style: TextStyle(color: Color(0xFF5b1aa0),
                                                    // fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: homeController.leaveData[index].leaveStatus!.toLowerCase() != "rejected".toLowerCase() ? null : () {
                                                    showDialog(context: context, builder: (context) {
                                                      return BackdropFilter(
                                                        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                                        child: AlertDialog(
                                                          title: const Text("Reason"),
                                                          content: Text("${homeController.leaveData[index].leaveStatusReason}",style: TextStyle(fontSize: 18),),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () async {
                                                                  Get.back();
                                                                },style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5b1aa0)),
                                                                child: const Text("Close",style: TextStyle(color: Colors.white),)),
                                                          ],
                                                        ),
                                                      );
                                                    },);
                                                  },
                                                  child: Text(
                                                    "${homeController.leaveData[index].leaveStatus}",
                                                    style: TextStyle(
                                                        color: homeController.leaveData[index].leaveStatus!.toLowerCase() == "pending".toLowerCase() ? Color(0xFF5b1aa0) : homeController.leaveData[index].leaveStatus!.toLowerCase() == "accepted".toLowerCase() ? Colors.green : Colors.red,
                                                        fontWeight: FontWeight.bold,
                                                        decoration: homeController.leaveData[index].leaveStatus!.toLowerCase() == "rejected".toLowerCase() ? TextDecoration.underline : TextDecoration.none,
                                                        decorationColor: Colors.red
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            FutureBuilder(
                                              future: ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: homeController.leaveData[index].leaveTypeId!),
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData)
                                                {
                                                  List<LeaveTypeDataModel> leaveTypeOneData = snapshot.data!;
                                                  return Text(
                                                    "${leaveTypeOneData.first.leaveTypeName} ${'leave'.tr}",
                                                    style: const TextStyle(color: Color(0xFF5b1aa0),
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  );
                                                }
                                                return Text(
                                                  "${homeController.leaveData[index].leaveTypeId} ${'leave'.tr}",
                                                  style: const TextStyle(
                                                      color: Color(0xFF5b1aa0),
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              "${'reason'.tr}: ${homeController.leaveData[index].reason}",
                                              style: const TextStyle(
                                                  color: Color(0xFF5b1aa0),
                                                  fontSize: 12
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                var connectivityResult = await Connectivity().checkConnectivity();
                                                if(connectivityResult != ConnectivityResult.none)
                                                {
                                                  // ignore: use_build_context_synchronously
                                                  showDialog(context: context, builder: (context) {
                                                    return AlertDialog(
                                                      title:  Text("${'delete'.tr}?"),
                                                      content: Text("${'are_you_sure_want_to'.tr} ${'delete'.tr.toLowerCase()} ${'this'.tr.toLowerCase()} ${'leave'.tr.toLowerCase()}?"),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () async {
                                                              Get.back();
                                                              EasyLoading.show(status: "${'please_wait'.tr}...");
                                                              List<LeaveDataModel>? beforeServerleaveData = await ApiHelper.apiHelper.getAllLeaveData();
                                                              List<LeaveDataModel>? serverleaveData = beforeServerleaveData!.where((element) => (element.userId! == homeController.leaveData[index].userId)).toList();
                                                              List<LeaveDataModel> updateServerLeaveOneData = serverleaveData!.where((element) {
                                                                return ((element.userId! == homeController.leaveData[index].userId) && (element.leaveTypeId! == homeController.leaveData[index].leaveTypeId) && (element.startDate! == homeController.leaveData[index].startDate) && (element.endDate! == homeController.leaveData[index].endDate) && (element.days! == homeController.leaveData[index].days) && (element.reason! == homeController.leaveData[index].reason) && (element.photo!.split('/').last == homeController.leaveData[index].photo!.split('/').last));
                                                              }).toList();
                                                              homeController.leaveUpdateId.value = updateServerLeaveOneData.first.leaveId!;
                                                              ApiHelper.apiHelper.deleteLeaveDataIdWise(leave_id: homeController.leaveUpdateId.value.toString()).then((value) async {
                                                                homeController.leaveData.value = (await ApiHelper.apiHelper.getLeaveDatauserWise(user_id: loginController.UserLoginData.value.id!))!;
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
                                                else
                                                {
                                                  EasyLoading.showError('please_check_your_internet'.tr);
                                                }
                                              },
                                              child: Container(
                                                height: Get.width/13,
                                                width: Get.width/13,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.delete,color: const Color(0xfff0e5ff),size: Get.width/21,),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                var connectivityResult = await Connectivity().checkConnectivity();
                                                if(connectivityResult != ConnectivityResult.none)
                                                {
                                                  // ignore: use_build_context_synchronously
                                                  showDialog(context: context, builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("${'edit'.tr}?"),
                                                      content: Text("${'are_you_sure_want_to'.tr} ${'edit'.tr.toLowerCase()} ${'this'.tr.toLowerCase()} ${'leave'.tr.toLowerCase()}?"),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () async {
                                                              Get.back();
                                                              EasyLoading.show(status: "${'please_wait'.tr}...");
                                                              List<LeaveDataModel>? beforeServerleaveData = await ApiHelper.apiHelper.getAllLeaveData();
                                                              List<LeaveDataModel>? serverleaveData = beforeServerleaveData!.where((element) => (element.userId! == homeController.leaveData[index].userId)).toList();
                                                              List<LeaveDataModel> updateServerLeaveOneData = serverleaveData!.where((element) {
                                                                return ((element.userId! == homeController.leaveData[index].userId) && (element.leaveTypeId! == homeController.leaveData[index].leaveTypeId) && (element.startDate! == homeController.leaveData[index].startDate) && (element.endDate! == homeController.leaveData[index].endDate) && (element.days! == homeController.leaveData[index].days) && (element.reason! == homeController.leaveData[index].reason) && (element.photo!.split('/').last == homeController.leaveData[index].photo!.split('/').last));
                                                              }).toList();
                                                              homeController.leaveOneData.value = updateServerLeaveOneData.first;
                                                              homeController.leaveUpdateId.value = updateServerLeaveOneData.first.leaveId!;
                                                              print("iidiidiidididi${homeController.leaveUpdateId.value}");
                                                              String networkImagePath = homeController.leaveData[index].photo!;
                                                              final response = await http.get(Uri.parse(networkImagePath));
                                                              final documentDirectory = await getTemporaryDirectory();
                                                              String imageName = networkImagePath.split('/').last;
                                                              String path = join(documentDirectory.path, imageName);
                                                              final filePath = File(path);
                                                              filePath.writeAsBytesSync(response.bodyBytes);
                                                              homeController.canAddEdit.value = 1;
                                                              homeController.vadhelaLeaveTypeDays.value = int.parse(homeController.leaveData[index].days!);
                                                              List<LeaveTypeDataModel>? leaveTypeOneData = await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: homeController.leaveData[index].leaveTypeId!);
                                                              homeController.txtReason = TextEditingController(text: homeController.leaveData[index].reason);
                                                              homeController.imagePath.value = filePath.path;
                                                              homeController.startDate.value = DateTime.parse(homeController.leaveData[index].startDate!).toIso8601String();
                                                              homeController.endDate.value = DateTime.parse(homeController.leaveData[index].endDate!).toIso8601String();
                                                              homeController.beforeEndDate = DateTime.parse(homeController.leaveData[index].endDate!);
                                                              homeController.dropDownLeaveType.value = leaveTypeOneData!.first.leaveTypeName!;
                                                              homeController.leaveReasonTypeList.value = [LeaveTypeDataModel(leaveTypeName: "Choose Type")];
                                                              homeController.leaveTypeOneData.value = leaveTypeOneData.first;
                                                              List<LeaveTypeDataModel>? reasonList = await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: leaveTypeOneData.first.leaveTypeId!);
                                                              homeController.leaveReasonTypeList.addAll(reasonList!);
                                                              homeController.checkLeaveTypeDataAvailable(leaveTypeDataModel: homeController.leaveTypeOneData.value);
                                                              homeController.usedDaysLeaveTypeWise.value = 0;
                                                              print("yyyyyyyyyyyyyyy${homeController.leaveOneData.value.leaveTypeId!}");
                                                              await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: homeController.leaveOneData.value.leaveTypeId!).then((value) async {
                                                                homeController.usedDaysLeaveTypeWise.value = value!.fold(0, (previousValue, element) => (previousValue + int.parse(element.leaveNos!)));
                                                              });
                                                              Get.to(const AddLeavePage(),transition: Transition.fadeIn);
                                                              EasyLoading.dismiss();
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
                                                else
                                                {
                                                  EasyLoading.showError('please_check_your_internet'.tr);
                                                }
                                              },
                                              child: Container(
                                                height: Get.width/13,
                                                width: Get.width/13,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.edit,color: Color(0xfff0e5ff),size: Get.width/21,),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                EasyLoading.show(status: "${'please_wait'.tr}...");
                                                String networkImagePath = homeController.leaveData[index].photo!;
                                                final response = await http.get(Uri.parse(networkImagePath));
                                                final documentDirectory = await getTemporaryDirectory();
                                                String imageName = networkImagePath.split('/').last;
                                                String path = join(documentDirectory.path, imageName);
                                                final filePath = File(path);
                                                filePath.writeAsBytesSync(response.bodyBytes);
                                                // ignore: use_build_context_synchronously
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
                                                              onTap: () {
                                                                Get.to(PhotoViewPage(imagePath: filePath.path),transition: Transition.fadeIn);
                                                              },
                                                              child: SizedBox(
                                                                height: Get.width/1.5,
                                                                width: Get.width/1.5,
                                                                child: InteractiveViewer(
                                                                    maxScale: 3.0,
                                                                    minScale: 0.5,
                                                                    child: Image.file(filePath,fit: BoxFit.cover,)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },);
                                                EasyLoading.dismiss();
                                              },
                                              child: Container(
                                                height: Get.width/13,
                                                width: Get.width/13,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.photo_library_outlined,color: Color(0xfff0e5ff),size: Get.width/21,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          );
                        },
                      ):Obx(() => homeController.leaveDataFilterList.isEmpty ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: Lottie.asset('assets/animation/cce.json',height: Get.width/1,width: Get.width/1,fit: BoxFit.fill)),
                          Center(child: Text("${'once_you_start'.tr} ${'leave'.tr}, ${'you_ll'.tr}")),
                          Center(child: Text("see_it_listen_here".tr)),
                        ],
                      ):ListView.builder(
                        itemCount: homeController.leaveDataFilterList.length,
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
                            child: Obx(() => Container(
                              // height: 100,
                              width: Get.width,
                              margin: EdgeInsets.only(top: Get.width/30,left: Get.width/30,right: Get.width/30),
                              padding: EdgeInsets.symmetric(horizontal: Get.width/30,vertical: Get.width/60),
                              decoration: BoxDecoration(
                                  color: Color(0xfff0e5ff),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.leaveDataFilterList[index].startDate!))}   To   ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeController.leaveData[index].endDate!))}",style: TextStyle(color: Color(0xFF5b1aa0)),),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF5b1aa0),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: Get.width/45,vertical: Get.width/75),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${homeController.leaveData[index].days} ${'days'.tr.toLowerCase()}",
                                          style: const TextStyle(
                                              color: Color(0xfff0e5ff),
                                              fontSize: 11
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder(
                                              future: ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: homeController.leaveData[index].leaveTypeId!),
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData)
                                                {
                                                  List<LeaveTypeDataModel> leaveTypeOneData = snapshot.data!;
                                                  return Text(
                                                    "${leaveTypeOneData.first.leaveTypeName} ${'leave'.tr}",
                                                    style: const TextStyle(color: Color(0xFF5b1aa0),
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  );
                                                }
                                                return Text(
                                                  "${homeController.leaveData[index].leaveTypeId} ${'leave'.tr}",
                                                  style: const TextStyle(color: Color(0xFF5b1aa0),
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              "${'reason'.tr}: ${homeController.leaveData[index].reason}",
                                              style: const TextStyle(
                                                  color: Color(0xFF5b1aa0),
                                                  fontSize: 12
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                var connectivityResult = await Connectivity().checkConnectivity();
                                                if(connectivityResult != ConnectivityResult.none)
                                                {
                                                  // ignore: use_build_context_synchronously
                                                  showDialog(context: context, builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("${'delete'.tr}?"),
                                                      content: Text("${'are_you_sure_want_to'.tr} ${'delete'.tr.toLowerCase()} ${'this'.tr.toLowerCase()} ${'leave'.tr.toLowerCase()}?"),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () async {
                                                              Get.back();
                                                              EasyLoading.show(status: "${'please_wait'.tr}...");
                                                              List<LeaveDataModel>? beforeServerleaveData = await ApiHelper.apiHelper.getAllLeaveData();
                                                              List<LeaveDataModel>? serverleaveData = beforeServerleaveData!.where((element) => (element.userId! == homeController.leaveData[index].userId)).toList();
                                                              List<LeaveDataModel> updateServerLeaveOneData = serverleaveData!.where((element) {
                                                                return ((element.userId! == homeController.leaveData[index].userId) && (element.leaveTypeId! == homeController.leaveData[index].leaveTypeId) && (element.startDate! == homeController.leaveData[index].startDate) && (element.endDate! == homeController.leaveData[index].endDate) && (element.days! == homeController.leaveData[index].days) && (element.reason! == homeController.leaveData[index].reason) && (element.photo!.split('/').last == homeController.leaveData[index].photo!.split('/').last));
                                                              }).toList();
                                                              homeController.leaveUpdateId.value = updateServerLeaveOneData.first.leaveId!;
                                                              ApiHelper.apiHelper.deleteLeaveDataIdWise(leave_id: homeController.leaveUpdateId.value.toString()).then((value) async {
                                                                homeController.leaveData.value = (await ApiHelper.apiHelper.getLeaveDatauserWise(user_id: loginController.UserLoginData.value.id!))!;
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
                                                else
                                                {
                                                  EasyLoading.showError('please_check_your_internet'.tr);
                                                }
                                              },
                                              child: Container(
                                                height: Get.width/13,
                                                width: Get.width/13,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.delete,color: Color(0xfff0e5ff),size: Get.width/21,),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                var connectivityResult = await Connectivity().checkConnectivity();
                                                if(connectivityResult != ConnectivityResult.none)
                                                {
                                                  // ignore: use_build_context_synchronously
                                                  showDialog(context: context, builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("${'edit'.tr}?"),
                                                      content: Text("${'are_you_sure_want_to'.tr} ${'edit'.tr.toLowerCase()} ${'this'.tr.toLowerCase()} ${'leave'.tr.toLowerCase()}?"),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () async {
                                                              Get.back();
                                                              EasyLoading.show(status: "${'please_wait'.tr}...");
                                                              List<LeaveDataModel>? beforeServerleaveData = await ApiHelper.apiHelper.getAllLeaveData();
                                                              List<LeaveDataModel>? serverleaveData = beforeServerleaveData!.where((element) => (element.userId! == homeController.leaveData[index].userId)).toList();
                                                              List<LeaveDataModel> updateServerLeaveOneData = serverleaveData!.where((element) {
                                                                return ((element.userId! == homeController.leaveData[index].userId) && (element.leaveTypeId! == homeController.leaveData[index].leaveTypeId) && (element.startDate! == homeController.leaveData[index].startDate) && (element.endDate! == homeController.leaveData[index].endDate) && (element.days! == homeController.leaveData[index].days) && (element.reason! == homeController.leaveData[index].reason) && (element.photo!.split('/').last == homeController.leaveData[index].photo!.split('/').last));
                                                              }).toList();
                                                              homeController.leaveOneData.value = updateServerLeaveOneData.first;
                                                              homeController.leaveUpdateId.value = updateServerLeaveOneData.first.leaveId!;
                                                              print("iidiidiidididi${homeController.leaveUpdateId.value}");
                                                              String networkImagePath = homeController.leaveData[index].photo!;
                                                              final response = await http.get(Uri.parse(networkImagePath));
                                                              final documentDirectory = await getTemporaryDirectory();
                                                              String imageName = networkImagePath.split('/').last;
                                                              String path = join(documentDirectory.path, imageName);
                                                              final filePath = File(path);
                                                              filePath.writeAsBytesSync(response.bodyBytes);
                                                              homeController.canAddEdit.value = 1;
                                                              homeController.vadhelaLeaveTypeDays.value = int.parse(homeController.leaveData[index].days!);
                                                              List<LeaveTypeDataModel>? leaveTypeOneData = await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: homeController.leaveData[index].leaveTypeId!);
                                                              homeController.txtReason = TextEditingController(text: homeController.leaveData[index].reason);
                                                              homeController.imagePath.value = filePath.path;
                                                              homeController.startDate.value = DateTime.parse(homeController.leaveData[index].startDate!).toIso8601String();
                                                              homeController.endDate.value = DateTime.parse(homeController.leaveData[index].endDate!).toIso8601String();
                                                              homeController.beforeEndDate = DateTime.parse(homeController.leaveData[index].endDate!);
                                                              homeController.dropDownLeaveType.value = leaveTypeOneData!.first.leaveTypeName!;
                                                              homeController.leaveReasonTypeList.value = [LeaveTypeDataModel(leaveTypeName: "Choose Type")];
                                                              homeController.leaveTypeOneData.value = leaveTypeOneData.first;
                                                              List<LeaveTypeDataModel>? reasonList = await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: leaveTypeOneData.first.leaveTypeId!);
                                                              homeController.leaveReasonTypeList.addAll(reasonList!);
                                                              homeController.checkLeaveTypeDataAvailable(leaveTypeDataModel: homeController.leaveTypeOneData.value);
                                                              homeController.usedDaysLeaveTypeWise.value = 0;
                                                              print("yyyyyyyyyyyyyyy${homeController.leaveOneData.value.leaveTypeId!}");
                                                              await ApiHelper.apiHelper.getLeaveDataLeaveTypeIdWise(leave_type_id: homeController.leaveOneData.value.leaveTypeId!).then((value) async {
                                                                homeController.usedDaysLeaveTypeWise.value = value!.fold(0, (previousValue, element) => (previousValue + int.parse(element.leaveNos!)));
                                                              });
                                                              Get.to(const AddLeavePage(),transition: Transition.fadeIn);
                                                              EasyLoading.dismiss();
                                                            },style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                            child: Text("yes".tr,style: TextStyle(color: Colors.white),)),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                          child: Text("no".tr,style: TextStyle(color: Colors.white),),)
                                                      ],
                                                    );
                                                  },);
                                                }
                                                else
                                                {
                                                  EasyLoading.showError('please_check_your_internet'.tr);
                                                }
                                              },
                                              child: Container(
                                                height: Get.width/13,
                                                width: Get.width/13,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.edit,color: Color(0xfff0e5ff),size: Get.width/21,),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                EasyLoading.show(status: "${'please_wait'.tr}...");
                                                String networkImagePath = homeController.leaveData[index].photo!;
                                                final response = await http.get(Uri.parse(networkImagePath));
                                                final documentDirectory = await getTemporaryDirectory();
                                                String imageName = networkImagePath.split('/').last;
                                                String path = join(documentDirectory.path, imageName);
                                                final filePath = File(path);
                                                filePath.writeAsBytesSync(response.bodyBytes);
                                                // ignore: use_build_context_synchronously
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
                                                              onTap: () {
                                                                Get.to(PhotoViewPage(imagePath: filePath.path),transition: Transition.fadeIn);
                                                              },
                                                              child: SizedBox(
                                                                height: Get.width/1.5,
                                                                width: Get.width/1.5,
                                                                child: InteractiveViewer(
                                                                    maxScale: 3.0,
                                                                    minScale: 0.5,
                                                                    child: Image.file(filePath,fit: BoxFit.cover,)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },);
                                                EasyLoading.dismiss();
                                              },
                                              child: Container(
                                                height: Get.width/13,
                                                width: Get.width/13,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF5b1aa0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.photo_library_outlined,color: Color(0xfff0e5ff),size: Get.width/21,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          );
                        },
                      )),
                    )
                    )
                ),
              ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF5b1aa0),
            shape: CircleBorder(),
            onPressed: () async {
              homeController.canAddEdit.value = 0;
              homeController.txtReason.clear();
              homeController.imagePath.value = "";
              List<LeaveDataModel>? checkData = await ApiHelper.apiHelper.getAllLeaveData();
              if(checkData!.isNotEmpty)
              {
                homeController.startDate.value = DateTime.now().compareTo(DateTime.parse(checkData.last.endDate!)) == 1 ? DateTime.now().toIso8601String() : checkData.last.endDate!;
                homeController.endDate.value = homeController.startDate.value;
                homeController.beforeEndDate = DateTime.parse(homeController.startDate.value);
              }
              else
              {
                homeController.startDate.value = DateTime.now().toIso8601String();
                homeController.endDate.value = DateTime.now().toIso8601String();
                homeController.beforeEndDate = DateTime.now();
              }
              homeController.dropDownLeaveType.value = "Choose Type";
              homeController.leaveReasonTypeList.value = [LeaveTypeDataModel(leaveTypeName: "Choose Type")];
              homeController.leaveTypeOneData.value = LeaveTypeDataModel(leaveTypeName: "Choose Type");
              List<LeaveTypeDataModel>? reasonList = await ApiHelper.apiHelper.getAllLeaveReason();
              homeController.leaveReasonTypeList.addAll(reasonList!);
              Get.to(AddLeavePage(),transition: Transition.fadeIn);
            },
            child: const Icon(
              Icons.add,
              color: Color(0xfff0e5ff),
            ),
          ),
        )
    );
  }
}