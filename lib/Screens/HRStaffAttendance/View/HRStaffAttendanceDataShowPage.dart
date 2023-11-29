import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hr_we_attendance/Screens/HRStaffAttendance/Controller/HrStaffAttendanceController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ChartData.dart';
class HRStaffAttendanceDataShowPage extends StatefulWidget {
  const HRStaffAttendanceDataShowPage({super.key});

  @override
  State<HRStaffAttendanceDataShowPage> createState() => _HRStaffAttendanceDataShowPageState();
}

class _HRStaffAttendanceDataShowPageState extends State<HRStaffAttendanceDataShowPage> {
  HRStaffAttendanceController hrController = Get.put(HRStaffAttendanceController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "Staff Attendance",
            style: TextStyle(color: Color(0xFF5b1aa0), fontSize: 13),
          ),
          centerTitle: true,
          // actions: [
          //   IconButton(onPressed: () async {
          //     // List? schoolNotList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Not");
          //     // List? schoolDoneList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Done");
          //     // // ignore: use_build_context_synchronously
          //     // showDialog(
          //     //   context: context,
          //     //   barrierDismissible: false,
          //     //   builder: (context) {
          //     //     return BackdropFilter(
          //     //       filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
          //     //       child: AlertDialog(
          //     //         backgroundColor: Colors.purple.shade800.withOpacity(0.3),
          //     //         content: Column(
          //     //           crossAxisAlignment: CrossAxisAlignment.end,
          //     //           mainAxisSize: MainAxisSize.min,
          //     //           children: [
          //     //             IconButton(
          //     //               onPressed: () {
          //     //                 Get.back();
          //     //               },
          //     //               style: IconButton.styleFrom(backgroundColor: Colors.white),
          //     //               icon: const Icon(Icons.close,color: Color(0xFF2C2C50),),
          //     //             ),
          //     //             SizedBox(height: Get.width/75,),
          //     //             Container(
          //     //               width: Get.width,
          //     //               decoration: BoxDecoration(
          //     //                 color: Colors.white,
          //     //                 borderRadius: BorderRadius.circular(15),
          //     //               ),
          //     //               padding: EdgeInsets.all(Get.width/45),
          //     //               child: Column(
          //     //                 mainAxisSize: MainAxisSize.min,
          //     //                 crossAxisAlignment: CrossAxisAlignment.start,
          //     //                 children: [
          //     //                   ElevatedButton(
          //     //                     onPressed: () async {
          //     //                       List? schoolList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Not");
          //     //                       if(schoolList!.isNotEmpty)
          //     //                       {
          //     //                         EasyLoading.show(status: "Please Wait...");
          //     //                         List attendanceList = [];
          //     //                         for(var school in schoolList!)
          //     //                         {
          //     //                           attendanceList.add({'Schools':school['Schools'],'Contact': school['Contact No']});
          //     //                         }
          //     //                         await Sharedpref.sharedpref.schoolsDataPDFDownload(title: "Attendance Not Done", fileName: "${DateFormat('dd_MM_yyyy').format(DateTime.now())}_Attendance_Not_Done", yourDataList: attendanceList,dateTime: DateTime.now()).then((path) {
          //     //                           EasyLoading.dismiss();
          //     //                           print("=============pathhhhhhhhhhhhhhhhhhh notttttttt $path");
          //     //                           EasyLoading.showSuccess("Download Successfully");
          //     //                           Get.to(PDFViewPage(pdfPath: path));
          //     //                         });
          //     //                       }
          //     //                       else
          //     //                       {
          //     //                         EasyLoading.showError("Sorry... No Record Found");
          //     //                       }
          //     //                     },
          //     //                     style: ElevatedButton.styleFrom(
          //     //                       backgroundColor: const Color(0xFF2C2C50),
          //     //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //     //                     ),
          //     //                     child: Center(child: Text("Attendance Not Done Schools (${schoolNotList!.length})",style: TextStyle(color: Colors.white,fontSize: 10),)),
          //     //                   ),
          //     //                   ElevatedButton(
          //     //                     onPressed: () async {
          //     //                       List? schoolList = await Api_Helper.api_helper.getPOSchoolAttendanceDoneOrNotDone(selOption: "Done");
          //     //                       if(schoolList!.isNotEmpty)
          //     //                       {
          //     //                         EasyLoading.show(status: "Please Wait...");
          //     //                         List attendanceList = [];
          //     //                         print("===================ssssssssssss= $schoolList");
          //     //                         for(var school in schoolList!)
          //     //                         {
          //     //                           attendanceList.add({'Schools':school['Schools'],'Contact': school['Contact No']});
          //     //                         }
          //     //                         await Sharedpref.sharedpref.schoolsDataPDFDownload(title: "Attendance Done", fileName: "${DateFormat('dd_MM_yyyy').format(DateTime.now())}_Attendance_Done", yourDataList: attendanceList,dateTime: DateTime.now()).then((path) {
          //     //                           EasyLoading.dismiss();
          //     //                           print("=============pathhhhhhhhhhhhhhhhhhh $attendanceList doneeeeeeee $path");
          //     //                           EasyLoading.showSuccess("Download Successfully");
          //     //                           Get.to(PDFViewPage(pdfPath: path));
          //     //                         });
          //     //                       }
          //     //                       else
          //     //                       {
          //     //                         EasyLoading.showError("Sorry... No Record Found");
          //     //                       }
          //     //                     },
          //     //                     style: ElevatedButton.styleFrom(
          //     //                       backgroundColor: const Color(0xFF2C2C50),
          //     //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //     //                     ),
          //     //                     child: Center(child: Text("Attendance Done Schools (${schoolDoneList!.length})", style: TextStyle(color: Colors.white,fontSize: 10),)),
          //     //                   ),
          //     //                 ],
          //     //               ),
          //     //             ),
          //     //           ],
          //     //         ),
          //     //       ),
          //     //     );
          //     //   },
          //     // );
          //   }, icon: const Icon(Icons.download,color: Color(0xFF5b1aa0),))
          // ],
          // backgroundColor: const Color(0xFF2C2C50),
        ),
        // backgroundColor: const Color(0xFF2C2C50),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width/18,vertical: Get.width/30),
          child: SingleChildScrollView(
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
                          "Site",
                          style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                              fontSize: 12,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        Text(
                          "${hrController.selectedSiteData.value.name}",
                          style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                  ],
                ),
                SizedBox(height: Get.width/30,),
                const Text(
                  "Overall Attendance",
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
                                    hrController.selectedSiteAllAttendanceData['total'] == 0 ? 0 : ((hrController.selectedSiteAllAttendanceData['present'] * 100) / hrController.selectedSiteAllAttendanceData['total']),null),
                                ChartData(
                                    'Absent',
                                    hrController.selectedSiteAllAttendanceData['total'] == 0 ? 0 : ((hrController.selectedSiteAllAttendanceData['absent'] * 100) / hrController.selectedSiteAllAttendanceData['total']),null),
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
                                      "${hrController.selectedSiteAllAttendanceData['total'] == 0 ? 0 : ((hrController.selectedSiteAllAttendanceData['present'] * 100) / hrController.selectedSiteAllAttendanceData['total']).toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5b1aa0),
                                      ),
                                    ),
                                    Text(
                                      'Present',
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
                                EasyLoading.show(status: "Please Wait...");
                                hrController.subSiteDataList.value = await ApiHelper.apiHelper.getAllSubSiteData(company_id: hrController.selectedSiteData.value.id!) ?? [];
                                EasyLoading.dismiss();
                              }, icon: const Icon(Icons.refresh,color: Colors.white,),style: IconButton.styleFrom(backgroundColor: const Color(
                                  0xFF5b1aa0)),),
                              SizedBox(width: Get.width/45,),
                              IconButton(onPressed: () async {
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
                              const Text(
                                "Present",
                                style: TextStyle(
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
                              const Text(
                                "Absent",
                                style: TextStyle(
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
                                    "${hrController.selectedSiteAllAttendanceData['present']}",
                                    // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController
                                    //     .poAttendanceAPCount.first['Present'])),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                  const Text(
                                    "Present",
                                    style: TextStyle(
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
                                    "${hrController.selectedSiteAllAttendanceData['total']}",
                                    // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController
                                    //     .poAttendanceAPCount.first['Present']) + double.parse(poAttendanceController
                                    //     .poAttendanceAPCount.first['Absent'])),
                                    style: const TextStyle(
                                        color: Color(0xFF5b1aa0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                  const Text(
                                    "Total",
                                    style: TextStyle(
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
                                    "${hrController.selectedSiteAllAttendanceData['absent']}",
                                    // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController
                                    //     .poAttendanceAPCount.first['Absent'])),
                                    style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                  const Text(
                                    "Absent",
                                    style: TextStyle(
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
                      Text.rich(
                          TextSpan(
                              children: [
                                const TextSpan(
                                  text: "No data found ",
                                  style: TextStyle(
                                      color: Color(0xFF5b1aa0),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                TextSpan(
                                  // text: Sharedpref.sharedpref.numberFormat(amount: double.parse((poAttendanceController
                                  //     .poAttendanceAPCount.first['Total Students'] == "0" ? 0 : double.parse(poAttendanceController
                                  //     .poAttendanceAPCount.first['Total Students']) - ((poAttendanceController
                                  //     .poAttendanceAPCount.first['Present'] == "0" ? 0 : double.parse(poAttendanceController
                                  //     .poAttendanceAPCount.first['Present'])) + (poAttendanceController
                                  //     .poAttendanceAPCount.first['Absent'] == "0" ? 0 : double.parse(poAttendanceController
                                  //     .poAttendanceAPCount.first['Absent'])))).toStringAsFixed(0))),
                                  text: " ${hrController.selectedSiteAllAttendanceData['absent']}",
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const TextSpan(
                                  text: " Staff out of",
                                  style: TextStyle(
                                      color: Color(0xFF5b1aa0),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                TextSpan(
                                  // text: " ${Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController.poAttendanceAPCount.first['Total Students']))}.",
                                  text: " ${hrController.selectedSiteAllAttendanceData['total']}",
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
                const Text(
                  "Sub Sites",
                  style: TextStyle(
                    color: Color(0xFF5b1aa0),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: Get.width/30,),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: hrController.subSiteDataList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: Get.width/30),
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
                                "${hrController.subSiteDataList[index].name}",
                                style: const TextStyle(
                                  color: Color(0xFF5b1aa0),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  // "${poAttendanceController.poClusterAttendance[index]['Present'] == "0" && poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : ((double.parse(poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? "0" : poAttendanceController.poClusterAttendance[index]['Present']) / (double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']))) * 100).toStringAsFixed(1)}%",
                                  "10",
                                  style: TextStyle(
                                    color: Colors.green.shade400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: Get.width/60,),
                                // Expanded(child: LinearProgressIndicator(color: Colors.green.shade400,value: poAttendanceController.poClusterAttendance[index]['Present'] == "0" && poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : (double.parse(poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? "0" : poAttendanceController.poClusterAttendance[index]['Present']) / (double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']))),backgroundColor: Colors.red.shade600,minHeight: 8,borderRadius: BorderRadius.circular(6),)),
                                SizedBox(width: Get.width/60,),
                                Text(
                                  // "${poAttendanceController.poClusterAttendance[index]['Present'] == "0" && poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : ((100 - (double.parse(poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? "0" : poAttendanceController.poClusterAttendance[index]['Present']) / (double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']))) * 100)).toStringAsFixed(1)}%",
                                  "10",
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
                                          // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController.poClusterAttendance[index]['Present'])),
                                          "0",
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        const Text(
                                          "Present",
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
                                          // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController.poClusterAttendance[index]['Present']) + double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])),
                                          "0",
                                          style: const TextStyle(
                                              color: Color(0xFF5b1aa0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),
                                        ),
                                        const Text(
                                          "Total",
                                          style: TextStyle(
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
                                          // Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])),
                                          "0",
                                          style: TextStyle(
                                              color: Colors.red.shade600,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        const Text(
                                          "Absent",
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
                              ],
                            ),
                            // (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))) == 0 ? const Center() : SizedBox(height: Get.width/90,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 :double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))) == 0 ? const Center() :
                                Center(
                                  child: Text.rich(
                                      TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "No data found",
                                              style: TextStyle(
                                                  color: Color(0xFF5b1aa0),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                            TextSpan(
                                              // text: " ${Sharedpref.sharedpref.numberFormat(amount: (poAttendanceController.poClusterAttendance[index]['Total Students'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']) - ((poAttendanceController.poClusterAttendance[index]['Present'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Present'])) + (poAttendanceController.poClusterAttendance[index]['Absent'] == "0" ? 0 : double.parse(poAttendanceController.poClusterAttendance[index]['Absent'])))))}",
                                              text: " 0",
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const TextSpan(
                                              text: " Staff out of",
                                              style: TextStyle(
                                                  color: Color(0xFF5b1aa0),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                            TextSpan(
                                              // text: " ${Sharedpref.sharedpref.numberFormat(amount: double.parse(poAttendanceController.poClusterAttendance[index]['Total Students']))}",
                                              text: " 0",
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
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
