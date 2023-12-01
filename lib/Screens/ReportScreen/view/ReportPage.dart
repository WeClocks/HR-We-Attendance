import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/ReportScreen/controller/ReportController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ConstHelper.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  ReportController reportController = Get.put(ReportController());
  LoginController loginController = Get.put(LoginController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "${'attendance'.tr} ${'report'.tr}",
            style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(Get.width/30),
          child: Obx(
                () => Column(
              children: [
                InkWell(
                  onTap: () {
                    showDatePicker(context: context, initialDate: DateTime.parse(reportController.selectedMonth.value), firstDate: DateTime(DateTime.now().year), lastDate: DateTime(2099)).then((value) async {
                      if(value != null)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        reportController.selectedMonth.value = value.toIso8601String();
                        reportController.totalPresent.value = 0;
                        reportController.totalAbsent.value = 0;
                        reportController.reportsList.value = [];
                        reportController.totalPresent.value = await ApiHelper.apiHelper.getPresent(staff_id: loginController.UserLoginData.value.id!, dateTime: value);
                        List<PunchInOutDataModel> reportsList = await ApiHelper.apiHelper.getReport(staff_id: loginController.UserLoginData.value.id!, dateTime: value) ?? [];
                        reportController.reportsList.value = List.from(reportsList.reversed);
                        reportController.totalAbsent.value = ConstHelper.constHelper.getDaysInMonth(value.year, value.month) - reportController.totalPresent.value;
                        // Get.to(const ReportPage(),transition: Transition.rightToLeft);
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
                        Text(
                          // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                          DateFormat('MMM yyyy').format(DateTime.parse(reportController.selectedMonth.value)),
                          style: const TextStyle(
                            fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                        ),
                        const Icon(Icons.calendar_month,color: Color(0xFF5b1aa0),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.width/30,),
                Container(
                  width: Get.width,
                  // height: Get.width / 4,
                  decoration: BoxDecoration(
                      color: Color(0xfff0e5ff),
                      borderRadius: BorderRadius.circular(100)),
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 45,vertical: Get.width/15),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // homeController.weAttendanceOneData.value.punchIn == false ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.inDateTime!),
                              "${reportController.totalPresent.value}",
                              style: const TextStyle(
                                fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              "present".tr,
                              style: const TextStyle(
                                fontSize: 13, color: Colors.grey,),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // (homeController.weAttendanceOneData.value.punchOut == null || homeController.weAttendanceOneData.value.punchOut == false) ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.outDateTime!),
                              "${reportController.totalPresent.value + reportController.totalAbsent.value}",
                              style: const TextStyle(
                                fontSize: 18, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              "total".tr,
                              style: const TextStyle(
                                fontSize: 15, color: Colors.grey,),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // homeController.weAttendanceOneData.value.punchIn == false && (homeController.weAttendanceOneData.value.punchOut == null || homeController.weAttendanceOneData.value.punchOut == false) ? "-" : homeController.weAttendanceOneData.value.punchOut! ? "${DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours <= 0 ? "${DateFormat('mm').format(DateTime(0,0,0,0,DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes % 60))} Min." : "${DateFormat('hh').format(DateTime(0,0,0,DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours))} Hrs."}" : "${DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours <= 0 ? "${DateFormat('mm').format(DateTime(0,0,0,0,DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes % 60))} Min." : "${DateFormat('hh').format(DateTime(0,0,0,DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours))} Hrs."}",
                              "${reportController.totalAbsent.value}",
                              style: const TextStyle(
                                fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              "absent".tr,
                              style: const TextStyle(
                                fontSize: 13, color: Colors.grey,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.width/30,),
                Container(
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: Color(0xfff0e5ff),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(300),
                        topLeft: Radius.circular(300)
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: Get.width/30,horizontal: Get.width/20),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: () {
                        _scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 500), // Adjust duration as needed
                          curve: Curves.easeOut, // Adjust curve as needed
                        );
                      },child: Icon(Icons.arrow_back_ios_new_outlined,size: Get.width/20,)),
                      Text(
                        "${'monthly'.tr} ${'report'.tr}",
                        style: TextStyle(
                          fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                      ),
                      InkWell(
                        onTap: () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500), // Adjust duration as needed
                            curve: Curves.easeOut, // Adjust curve as needed
                          );
                        },
                        child: Icon(Icons.arrow_forward_ios_rounded,size: Get.width/20,),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      width: Get.width,
                      // height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xfff0e5ff),
                        // border: Border.all(color: Color(0xFF5b1aa0),)
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: DataTable(
                            border: TableBorder.all(color: const Color(0xFF5b1aa0)),
                            rows: [
                              for(int i=0; i<reportController.reportsList.length; i++)
                                DataRow(
                                    cells: [
                                      DataCell(
                                        Center(
                                          child: Text(
                                            "${i+1}",
                                            style: const TextStyle(
                                              fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            "${reportController.reportsList[i].type}",
                                            style: const TextStyle(
                                              fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            DateFormat('dd-MM-yyyy hh:mm:ss a').format(reportController.reportsList[i].clockIn!),
                                            style: const TextStyle(
                                              fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            reportController.reportsList[i].clockOut == null ? "-" : DateFormat('dd-MM-yyyy hh:mm:ss a').format(reportController.reportsList[i].clockOut!),
                                            style: const TextStyle(
                                              fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            reportController.reportsList[i].clockOut == null ? "-" : "${reportController.reportsList[i].clockOutType}",
                                            style: const TextStyle(
                                              fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            "${reportController.reportsList[i].hours!.split('.').first}:${reportController.reportsList[i].hours!.split('.').last} hrs",
                                            style: const TextStyle(
                                              fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ],
                            columns: [
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "numb".tr,
                                    style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "type".tr,
                                    style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "${'punch'.tr} ${'in'.tr}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "${'punch'.tr} ${'out'.tr}",
                                    style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "${'punch'.tr} ${'out'.tr} ${'type'.tr}",
                                    style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "working_hours".tr,
                                    style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
