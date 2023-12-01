import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hr_we_attendance/Screens/HRStaffAttendance/Controller/HrStaffAttendanceController.dart';
import 'package:hr_we_attendance/Screens/HRStaffAttendance/View/HRStaffAttendanceDataShowPage.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ChartData.dart';
class HrStaffAttendancePage extends StatefulWidget {
  const HrStaffAttendancePage({super.key});

  @override
  State<HrStaffAttendancePage> createState() => _HrStaffAttendancePageState();
}

class _HrStaffAttendancePageState extends State<HrStaffAttendancePage> {
  HRStaffAttendanceController hrController = Get.put(HRStaffAttendanceController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "${'staff'.tr} ${'attendance'.tr}",
            style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 13),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () async {
              EasyLoading.showError("Sorry Working Progress");

              // List? schoolNotList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Not");
              // List? schoolDoneList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Done");
              // // ignore: use_build_context_synchronously
              // showDialog(
              //   context: context,
              //   barrierDismissible: false,
              //   builder: (context) {
              //     return BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
              //       child: AlertDialog(
              //         backgroundColor: Colors.purple.shade800.withOpacity(0.3),
              //         content: Column(
              //           crossAxisAlignment: CrossAxisAlignment.end,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             IconButton(
              //               onPressed: () {
              //                 Get.back();
              //               },
              //               style: IconButton.styleFrom(backgroundColor: Colors.white),
              //               icon: const Icon(Icons.close,color: Color(0xFF2C2C50),),
              //             ),
              //             SizedBox(height: Get.width/75,),
              //             Container(
              //               width: Get.width,
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(15),
              //               ),
              //               padding: EdgeInsets.all(Get.width/45),
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   ElevatedButton(
              //                     onPressed: () async {
              //                       List? schoolList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Not");
              //                       if(schoolList!.isNotEmpty)
              //                       {
              //                         EasyLoading.show(status: "Please Wait...");
              //                         List attendanceList = [];
              //                         for(var school in schoolList!)
              //                         {
              //                           attendanceList.add({'Schools':school['Schools'],'Contact': school['Contact No']});
              //                         }
              //                         await Sharedpref.sharedpref.schoolsDataPDFDownload(title: "Attendance Not Done", fileName: "${DateFormat('dd_MM_yyyy').format(DateTime.now())}_Attendance_Not_Done", yourDataList: attendanceList,dateTime: DateTime.now()).then((path) {
              //                           EasyLoading.dismiss();
              //                           print("=============pathhhhhhhhhhhhhhhhhhh notttttttt $path");
              //                           EasyLoading.showSuccess("Download Successfully");
              //                           Get.to(PDFViewPage(pdfPath: path));
              //                         });
              //                       }
              //                       else
              //                       {
              //                         EasyLoading.showError("Sorry... No Record Found");
              //                       }
              //                     },
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: const Color(0xFF2C2C50),
              //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //                     ),
              //                     child: Center(child: Text("Attendance Not Done Schools (${schoolNotList!.length})",style: TextStyle(color: Colors.white,fontSize: 10),)),
              //                   ),
              //                   ElevatedButton(
              //                     onPressed: () async {
              //                       List? schoolList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Done");
              //                       if(schoolList!.isNotEmpty)
              //                       {
              //                         EasyLoading.show(status: "Please Wait...");
              //                         List attendanceList = [];
              //                         print("===================ssssssssssss= $schoolList");
              //                         for(var school in schoolList!)
              //                         {
              //                           attendanceList.add({'Schools':school['Schools'],'Contact': school['Contact No']});
              //                         }
              //                         await Sharedpref.sharedpref.schoolsDataPDFDownload(title: "Attendance Done", fileName: "${DateFormat('dd_MM_yyyy').format(DateTime.now())}_Attendance_Done", yourDataList: attendanceList,dateTime: DateTime.now()).then((path) {
              //                           EasyLoading.dismiss();
              //                           print("=============pathhhhhhhhhhhhhhhhhhh $attendanceList doneeeeeeee $path");
              //                           EasyLoading.showSuccess("Download Successfully");
              //                           Get.to(PDFViewPage(pdfPath: path));
              //                         });
              //                       }
              //                       else
              //                       {
              //                         EasyLoading.showError("Sorry... No Record Found");
              //                       }
              //                     },
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: const Color(0xFF2C2C50),
              //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //                     ),
              //                     child: Center(child: Text("Attendance Done Schools (${schoolDoneList!.length})", style: TextStyle(color: Colors.white,fontSize: 10),)),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // );
            }, icon: const Icon(Icons.download,color: Color(0xFF5b1aa0),))
          ],
          // backgroundColor: const Color(0xFF2C2C50),
        ),
        // backgroundColor: const Color(0xFF2C2C50),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width/18,vertical: Get.width/30),
          child: Obx(
                () => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // "0",
                            DateFormat('EEEE').format(DateTime.parse(hrController.selectedDate.value)),
                            style: const TextStyle(
                                color: Color(0xFF5b1aa0),
                                fontSize: 12,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(
                                      text: DateFormat('dd').format(DateTime.parse(hrController.selectedDate.value)),
                                      style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${DateFormat('MMM yyyy').format(DateTime.parse(hrController.selectedDate.value))}",
                                      style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          await showDatePicker(context: context, initialDate: DateTime.parse(hrController.selectedDate.value), firstDate: DateTime(2020), lastDate: DateTime.now()).then((value) async {
                            if(value != null)
                            {
                              EasyLoading.show(status: "${'please_wait'.tr}...");
                              hrController.siteDataList.value = (await ApiHelper.apiHelper.getAllSiteData()) ?? [];
                              hrController.selectedDate.value = value.toIso8601String();
                              hrController.allAttendanceData.value = (await ApiHelper.apiHelper.getAllStaffAttendance(dateTime: DateTime.parse(hrController.selectedDate.value))) ?? [];
                              EasyLoading.dismiss();
                            }
                          });
                        },
                        child: const Icon(Icons.calendar_month,color: Color(0xFF5b1aa0),),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.width/30,),
                  Text(
                    "${'overall'.tr} ${'attendance'.tr}",
                    style: TextStyle(
                      color: Color(0xFF5b1aa0),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: Get.width/80,),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xfff0e5ff)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: Get.width/1.8,
                          height: Get.width/1.8,
                          child: SfCircularChart(
                            palette: [Colors.green, Colors.red.shade600],
                            series: <DoughnutSeries>[
                              DoughnutSeries<ChartData, String>(
                                dataSource: [
                                  ChartData(
                                      'Present',
                                      hrController.allAttendanceData['total'] == 0 ? 0 : ((hrController.allAttendanceData['present'] * 100) / hrController.allAttendanceData['total']),null),
                                  ChartData(
                                      'Absent',
                                      hrController.allAttendanceData['total'] == 0 ? 0 : ((hrController.allAttendanceData['absent'] * 100) / hrController.allAttendanceData['total']),null),
                                ],
                                onPointTap: (pointInteractionDetails) {
                                  // ignore: avoid_print
                                  print("=============== ${pointInteractionDetails.pointIndex}");
                                },
                                xValueMapper: (ChartData data, _) => data.category,
                                yValueMapper: (ChartData data, _) => data.value,innerRadius: "50",
                              )
                            ],
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${hrController.allAttendanceData['total'] == 0 ? 0 : ((hrController.allAttendanceData['present'] * 100) / hrController.allAttendanceData['total']).toStringAsFixed(0)}%",
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5b1aa0),
                                        ),
                                      ),
                                      Text(
                                        'present'.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(onPressed: () async {
                                  EasyLoading.show(status: "${'please_wait'.tr}...");
                                  hrController.siteDataList.value = (await ApiHelper.apiHelper.getAllSiteData()) ?? [];
                                  hrController.allAttendanceData.value = (await ApiHelper.apiHelper.getAllStaffAttendance(dateTime: DateTime.parse(hrController.selectedDate.value))) ?? [];
                                  EasyLoading.dismiss();
                                }, icon: const Icon(Icons.refresh,color: Colors.white,),style: IconButton.styleFrom(backgroundColor: const Color(
                                    0xFF5b1aa0)),),
                                SizedBox(width: Get.width/45,),
                                IconButton(onPressed: () async {
                                  EasyLoading.showError("Sorry Working Progress");

                                  // EasyLoading.show(status: "Please Wait...");
                                  // await Api_Helper.api_helper.getPOClusterAttendance(dateTime: DateTime.parse(poAttendanceController.selectedDataTime.value)).then((poAllClustersAttendance) async {
                                  //   await Sharedpref.sharedpref.clusterOrSchoolsStudentsAttendanceListDataPDFDownload(clusterOrSchools: true, dateTime: DateTime.parse(poAttendanceController.selectedDataTime.value), fileName: "All_Clusters_Students_Attendance".toUpperCase(), yourDataList: poAllClustersAttendance!).then((pdfPath) {
                                  //     EasyLoading.dismiss();
                                  //     EasyLoading.showSuccess("Download Successfully");
                                  //     Get.to(PDFViewPage(pdfPath: pdfPath));
                                  //   });
                                  // });
                                }, icon: const Icon(Icons.download,color: Colors.white,),style: IconButton.styleFrom(backgroundColor: const Color(
                                    0xFF5b1aa0)),),
                              ],
                            ),
                            SizedBox(height: Get.width/15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: Get.width / 40,
                                  width: Get.width / 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width / 45,
                                ),
                                Text(
                                  "present".tr,
                                  style: const TextStyle(
                                      color: Color(0xFF5b1aa0),
                                      fontSize: 12
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: Get.width/45,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: Get.width / 40,
                                  width: Get.width / 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width / 45,
                                ),
                                Text(
                                  "absent".tr,
                                  style: const TextStyle(
                                      color: Color(0xFF5b1aa0),
                                      fontSize: 12
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Get.width/30,),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xfff0e5ff),
                        border: Border.all(color: const Color(0xFF5b1aa0),width: 2)
                    ),
                    padding: EdgeInsets.symmetric(vertical: Get.width/45),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "${hrController.allAttendanceData['present']}",
                                      // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController
                                      //     .poAttendanceAPCount.first['Present'])),
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                    Text(
                                      "present".tr,
                                      style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: Get.width/8,
                              width: 1.5,
                              color: const Color(0xFF5b1aa0),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "${hrController.allAttendanceData['total']}",
                                      style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                    Text(
                                      "total".tr,
                                      style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: Get.width/8,
                              width: 1.5,
                              color: const Color(0xFF5b1aa0),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "${hrController.allAttendanceData['absent']}",
                                      style: TextStyle(
                                          color: Colors.red.shade600,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                    Text(
                                      "absent".tr,
                                      style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.width/90,),
                        hrController.allAttendanceData['absent'] == 0 ? Container() : Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: "no_data_found".tr,
                                    style: TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${hrController.allAttendanceData['absent']}",
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${'staff'.tr} ${'out'.tr.toLowerCase()} ${'of'.tr.toLowerCase()}",
                                    style: TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${hrController.allAttendanceData['total']}.",
                                    style: const TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.width/30,),
                  Text(
                    "sites".tr,
                    style: const TextStyle(
                      color: Color(0xFF5b1aa0),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: Get.width/30,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: hrController.siteDataList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: Get.width/30),
                        child: FutureBuilder(
                          future: ApiHelper.apiHelper.getAllStaffAttendanceSiteWise(dateTime: DateTime.parse(hrController.selectedDate.value), site_id: hrController.siteDataList[index].id!),
                          builder: (context, snapshot) {
                            if(snapshot.hasData)
                            {
                              Map siteWiseData = snapshot.data;
                              return InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  // poAttendanceController.clusterOneData.value = poAttendanceController.poClusterAttendance[index];
                                  EasyLoading.show(status: "${'please_wait'.tr}...");
                                  hrController.selectedSiteData.value = hrController.siteDataList[index];
                                  hrController.selectedSiteAllAttendanceData.value = siteWiseData;
                                  hrController.subSiteDataList.value = await ApiHelper.apiHelper.getAllSubSiteData(company_id: hrController.siteDataList[index].id!) ?? [];
                                  Get.to(const HRStaffAttendanceDataShowPage(),transition: Transition.fadeIn);
                                  EasyLoading.dismiss();
                                },
                                child: Container(
                                  width: Get.width,
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
                                  padding: EdgeInsets.all(Get.width/30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          // "${poAttendanceController.poClusterAttendance[index]['Cluster']}",
                                          "${hrController.siteDataList[index].name}",
                                          style: const TextStyle(
                                            color: Color(0xFF5b1aa0),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${siteWiseData['total'] == 0 ? 0 : ((siteWiseData['present'] * 100) / siteWiseData['total']).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                              color: Colors.green.shade400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: Get.width/60,),
                                          Expanded(child: LinearProgressIndicator(color: Colors.green.shade400,value: siteWiseData['total'] == 0 ? 0 : ((siteWiseData['present']) / siteWiseData['total']),backgroundColor: Colors.red.shade600,minHeight: 8,borderRadius: BorderRadius.circular(6),)),
                                          SizedBox(width: Get.width/60,),
                                          Text(
                                            "${siteWiseData['total'] == 0 ? 0 : ((siteWiseData['absent'] * 100) / siteWiseData['total']).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                              color: Colors.red.shade600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Get.width/60,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${siteWiseData['present']}",
                                                    style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                  Text(
                                                    "present".tr,
                                                    style: TextStyle(
                                                        color: Color(0xFF5b1aa0),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: Get.width/8,
                                            width: 1.5,
                                            color: const Color(0xFF2C2C50),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${siteWiseData['total']}",
                                                    style: const TextStyle(
                                                        color: Color(0xFF5b1aa0),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17
                                                    ),
                                                  ),
                                                  Text(
                                                    "total".tr,
                                                    style: const TextStyle(
                                                        color: Color(0xFF5b1aa0),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: Get.width/8,
                                            width: 1.5,
                                            color: const Color(0xFF2C2C50),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${siteWiseData['absent']}",
                                                    style: TextStyle(
                                                        color: Colors.red.shade600,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                  Text(
                                                    "absent".tr,
                                                    style: const TextStyle(
                                                        color: Color(0xFF5b1aa0),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))) == 0 ? const Center() : SizedBox(height: Get.width/90,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 :double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))) == 0 ? const Center() :
                                          siteWiseData['absent'] == 0 ? Container() : Center(
                                            child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "no_data_found".tr,
                                                        style: const TextStyle(
                                                            color: Color(0xFF5b1aa0),
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w300
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " ${siteWiseData['absent']}",
                                                        style: const TextStyle(
                                                            color: Colors.orange,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " ${'staff'.tr} ${'out'.tr.toLowerCase()} ${'of'.tr.toLowerCase()}",
                                                        style: TextStyle(
                                                            color: Color(0xFF5b1aa0),
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w300
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " ${siteWiseData['total']}.",
                                                        style: const TextStyle(
                                                            color: Color(0xFF5b1aa0),
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ]
                                                )
                                            ),
                                          ),
                                          SizedBox(width: Get.width/30,),
                                          IconButton(
                                            onPressed: () async {
                                              EasyLoading.showError("Sorry Working Progress");

                                              // EasyLoading.show(status: "Please Wait...");
                                              // await Sharedpref.sharedpref.clusterOrSchoolsStudentsAttendanceDataPDFDownload(clusterOrSchools: true, clusterOrSchoolsName: "${poAttendanceController.poClusterAttendance[index]['Cluster']}".toUpperCase(), dateTime: DateTime.parse(poAttendanceController.selectedDataTime.value), fileName: "${poAttendanceController.poClusterAttendance[index]['Cluster']}_Cluster_Students_Attendance".toUpperCase(), yourData: poAttendanceController.poClusterAttendance[index],yourTotalData: {}).then((pdfPath) {
                                              //   EasyLoading.dismiss();
                                              //   EasyLoading.showSuccess("Download Successfully");
                                              //   Get.to(PDFViewPage(pdfPath: pdfPath));
                                              // });
                                            },
                                            style: IconButton.styleFrom(backgroundColor: const Color(0xFF5b1aa0)),
                                            icon: const Icon(Icons.download,color: Colors.white,),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                // poAttendanceController.clusterOneData.value = poAttendanceController.poClusterAttendance[index];
                                Get.to(const HRStaffAttendanceDataShowPage(),transition: Transition.fadeIn);
                              },
                              child: Container(
                                width: Get.width,
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
                                padding: EdgeInsets.all(Get.width/30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        // "${poAttendanceController.poClusterAttendance[index]['Cluster']}",
                                        "${hrController.siteDataList[index].name}",
                                        style: const TextStyle(
                                          color: Color(0xFF5b1aa0),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${hrController.allAttendanceData['total'] == 0 ? 0 : ((hrController.allAttendanceData['present'] * 100) / hrController.allAttendanceData['total']).toStringAsFixed(0)}%",
                                          style: TextStyle(
                                            color: Colors.green.shade400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: Get.width/60,),
                                        Expanded(child: LinearProgressIndicator(color: Colors.green.shade400,value: hrController.allAttendanceData['total'] == 0 ? 0 : ((hrController.allAttendanceData['present']) / hrController.allAttendanceData['total']),backgroundColor: Colors.red.shade600,minHeight: 8,borderRadius: BorderRadius.circular(6),)),
                                        SizedBox(width: Get.width/60,),
                                        Text(
                                          "${hrController.allAttendanceData['total'] == 0 ? 0 : ((hrController.allAttendanceData['absent'] * 100) / hrController.allAttendanceData['total']).toStringAsFixed(0)}%",
                                          style: TextStyle(
                                            color: Colors.red.shade600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.width/60,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${hrController.allAttendanceData['present']}",
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 15
                                                  ),
                                                ),
                                                Text(
                                                  "present".tr,
                                                  style: const TextStyle(
                                                      color: Color(0xFF5b1aa0),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: Get.width/8,
                                          width: 1.5,
                                          color: const Color(0xFF2C2C50),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${hrController.allAttendanceData['total']}",
                                                  style: const TextStyle(
                                                      color: Color(0xFF5b1aa0),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17
                                                  ),
                                                ),
                                                Text(
                                                  "total".tr,
                                                  style: const TextStyle(
                                                      color: Color(0xFF5b1aa0),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: Get.width/8,
                                          width: 1.5,
                                          color: const Color(0xFF2C2C50),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${hrController.allAttendanceData['absent']}",
                                                  style: TextStyle(
                                                      color: Colors.red.shade600,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 15
                                                  ),
                                                ),
                                                Text(
                                                  "absent".tr,
                                                  style: const TextStyle(
                                                      color: Color(0xFF5b1aa0),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))) == 0 ? const Center() : SizedBox(height: Get.width/90,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 :double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))) == 0 ? const Center() :
                                        hrController.allAttendanceData['absent'] == 0 ? Container() : Center(
                                          child: Text.rich(
                                              TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "no_data_found".tr,
                                                      style: const TextStyle(
                                                          color: Color(0xFF5b1aa0),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w300
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " ${hrController.allAttendanceData['absent']}",
                                                      style: const TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " ${'staff'.tr} ${'out'.tr.toLowerCase()} ${'of'.tr.toLowerCase()}",
                                                      style: const TextStyle(
                                                          color: Color(0xFF5b1aa0),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w300
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " ${hrController.allAttendanceData['total']}.",
                                                      style: const TextStyle(
                                                          color: Color(0xFF5b1aa0),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ]
                                              )
                                          ),
                                        ),
                                        SizedBox(width: Get.width/30,),
                                        IconButton(
                                          onPressed: () async {
                                            EasyLoading.showError("Sorry Working Progress");

                                            // EasyLoading.show(status: "Please Wait...");
                                            // await Sharedpref.sharedpref.clusterOrSchoolsStudentsAttendanceDataPDFDownload(clusterOrSchools: true, clusterOrSchoolsName: "${poAttendanceController.poClusterAttendance[index]['Cluster']}".toUpperCase(), dateTime: DateTime.parse(poAttendanceController.selectedDataTime.value), fileName: "${poAttendanceController.poClusterAttendance[index]['Cluster']}_Cluster_Students_Attendance".toUpperCase(), yourData: poAttendanceController.poClusterAttendance[index],yourTotalData: {}).then((pdfPath) {
                                            //   EasyLoading.dismiss();
                                            //   EasyLoading.showSuccess("Download Successfully");
                                            //   Get.to(PDFViewPage(pdfPath: pdfPath));
                                            // });
                                          },
                                          style: IconButton.styleFrom(backgroundColor: const Color(0xFF5b1aa0)),
                                          icon: const Icon(Icons.download,color: Colors.white,),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );;
  }
}
