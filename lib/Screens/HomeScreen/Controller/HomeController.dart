import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveTypeDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/DBHelper.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';

class HomeController extends GetxController {
  final navigatorKey = GlobalKey<NavigatorState>();
  RxString nowTime = DateTime.now().toIso8601String().obs;
  Rx<PunchInOutDataModel> weAttendanceOneData = PunchInOutDataModel().obs;
  RxBool officeInOrOut = false.obs;
  RxBool gpsOn = false.obs;
  RxBool gpsAvailable = false.obs;
  RxInt batteryPercentage = 0.obs;
  RxDouble totalDestinations = 0.0.obs;
  bool officeIn = false;
  RxBool mapType = false.obs;
  StreamController<GeofenceStatus> geofenceStreamController =
  StreamController<GeofenceStatus>.broadcast();
  RxList<SiteDataModel> siteDropDownList = <SiteDataModel>[].obs;
  Rx<SiteDataModel> siteOneDropDownItem = SiteDataModel().obs;
  RxList<SubSiteDataModel> subSiteDropDownList = <SubSiteDataModel>[].obs;
  Rx<SubSiteDataModel> subSiteOneDropDownItem = SubSiteDataModel().obs;
  Stream<GeofenceStatus>? geofenceStreamData = Stream.empty();
  RxList<LeaveTypeDataModel> leaveReasonTypeList = <LeaveTypeDataModel>[].obs;
  RxString dropDownLeaveType = "Choose Type".obs;
  Rx<LeaveTypeDataModel> leaveTypeOneData = LeaveTypeDataModel().obs;
  RxList<LeaveDataModel> leaveTypeDataAvailableList = <LeaveDataModel>[].obs;
  RxInt vadhelaLeaveTypeDays = 0.obs;
  RxString endDate = DateTime.now().add(const Duration(days: 1)).toIso8601String().obs;
  RxString startDate = DateTime.now().toIso8601String().obs;
  RxInt usedDaysLeaveTypeWise = 0.obs;
  DateTime beforeEndDate = DateTime.now().add(const Duration(days: 1));
  RxInt canAddEdit = 0.obs;
  Rx<LeaveDataModel> leaveOneData = LeaveDataModel().obs;
  TextEditingController txtReason = TextEditingController();
  RxString imagePath = "".obs;
  RxBool onlineOffline = false.obs;
  RxInt leaveUpdateId = 0.obs;
  RxBool filterOrNot = false.obs;
  RxList<LeaveDataModel> leaveData = <LeaveDataModel>[].obs;
  RxList<LeaveTypeDataModel> leaveReasonTypeFilterList = <LeaveTypeDataModel>[].obs;
  Rx<LeaveTypeDataModel> leaveTypeFilterOneData = LeaveTypeDataModel().obs;
  RxList<LeaveDataModel> leaveDataList = <LeaveDataModel>[].obs;
  RxList<LeaveDataModel> leaveDataFilterList = <LeaveDataModel>[].obs;






  Future<void> readUserSiteAndSubSiteData() async {
    try {
      LoginController loginController = Get.put(LoginController());
      loginController.getUserData();
      var connectivityResult = await Connectivity().checkConnectivity();
      DateTime dateTime = connectivityResult == ConnectivityResult.none ? DateTime.now() : await NTP.now();
      print("=======7333333333333siteeeeeeeeEEEIIII ${loginController.UserLoginData.value.id}");
      if(loginController.UserLoginData.value.id != null)
      {
        List<PunchInOutDataModel> attendanceDataList = await ApiHelper.apiHelper.getAttendanceUserIdWise(staff_id: loginController.UserLoginData.value.id!) ?? [];
        print("================77777777777777777777siteeeeeeeeEEEIIII ${attendanceDataList.isNotEmpty}");
        if(attendanceDataList.isNotEmpty)
        {
          List<PunchInOutDataModel> weAttendanceOne = attendanceDataList.where((element) {
            return ((DateTime(element.clockIn!.year,element.clockIn!.month,element.clockIn!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0));
          }).toList();
          print("================== 8333333333333333333siteeeeeeeeEEEIIII ${weAttendanceOne.isNotEmpty}");
          if (weAttendanceOne.isNotEmpty)
          {
            // await SharedPref.sharedpref.insertSync(check: true,key: 'punchIn');
            // bool? punchIn = await SharedPref.sharedpref.readSync(key: 'punchIn');
            // print("=================== 866666666pppppppppppiiiiiiiiiiiiii $punchIn");
            weAttendanceOneData.value = weAttendanceOne.first;
            print("==============87777777777777777777siteeeeeeeeEEEIIII ${weAttendanceOneData.value.clockIn} $subSiteDropDownList");
            SharedPref.sharedpref.setUserTodayPunchInOutData(punchInOutDataModel: weAttendanceOneData.value);
            subSiteDropDownList.value = await ApiHelper.apiHelper.getAllSubSiteData(company_id: siteOneDropDownItem.value.id ?? "0") ?? [];
            List<SubSiteDataModel> subSiteDataList = subSiteDropDownList.where((p0) => p0.id == weAttendanceOneData.value.subCompanyId!).toList();
            if(subSiteDataList.isNotEmpty)
            {
              subSiteOneDropDownItem.value = subSiteDataList.first;
              bool gpsEnable = await Geolocator.isLocationServiceEnabled();
              if(gpsEnable)
              {
                try {
                  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((position) {
                    double distance = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(subSiteOneDropDownItem.value.lat!), double.parse(subSiteOneDropDownItem.value.longs!));
                    officeInOrOut.value = (distance <= double.parse(subSiteOneDropDownItem.value.ranges!));
                    print("========== distanceeeeeeeeeeeeesiteeeeeeeeEEEIII $distance");
                  });
                } catch(e) {
                  return;

                  // print("ERRORRRRRRRRRRRR 11111111 $e");
                  // Position positions = await Geolocator.getCurrentPosition(
                  //   desiredAccuracy: LocationAccuracy.lowest,
                  // );
                  // print("============pppppppppppppppp $positions");
                  List<TrackingModel>? trackingDataList = await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!);
                  List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0).toList();
                  if(dateWiseTrackingData.isNotEmpty)
                  {
                    print("isNotEmptyyyyyyyyyyyyy ${dateWiseTrackingData.last.gpsActive!}");
                    if(dateWiseTrackingData.last.gpsActive!.toLowerCase() == "On".toLowerCase())
                    {
                      await Geolocator.getLastKnownPosition().then((position) async {
                        print("================= positionnnnnnnnnn1111111111 $position");
                        if(position != null)
                        {
                          await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString()));
                          // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: weAttendanceOneData.value.inDateTime == null ? DateTime.now() : weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
                          // await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!).then((trackingDataList) async
                          // {
                          //   print("==========trackingggggggggggggggListtttttttttt ${trackingDataList!.length}");
                          //   List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList!.where((element) => DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0).toList();
                          //   TrackingModel? trackingOneData = dateWiseTrackingData.isEmpty ? null : dateWiseTrackingData.last;
                          //   double distance = trackingOneData == null ? 0 : Geolocator.distanceBetween(
                          //     position.latitude,
                          //     position.longitude,
                          //     double.parse(trackingOneData.lat!),
                          //     double.parse(trackingOneData.long!),
                          //   );
                          //   print("==========ttttttttttttttttttt ${dateWiseTrackingData.length} $trackingOneData ");
                          //   // print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.inDateTime!.year,weAttendanceOneData.value.inDateTime!.month,weAttendanceOneData.value.inDateTime!.day,weAttendanceOneData.value.inDateTime!.hour,weAttendanceOneData.value.inDateTime!.minute)).inMinutes}");
                          //   print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.clockIn!.year,weAttendanceOneData.value.clockIn!.month,weAttendanceOneData.value.clockIn!.day,weAttendanceOneData.value.clockIn!.hour,weAttendanceOneData.value.clockIn!.minute)).inMinutes}");
                          //
                          //   // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.inDateTime!.year,weAttendanceOneData.value.inDateTime!.month,weAttendanceOneData.value.inDateTime!.day,weAttendanceOneData.value.inDateTime!.hour,weAttendanceOneData.value.inDateTime!.minute)).inHours) >= 12)
                          //   if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.clockIn!.year,weAttendanceOneData.value.clockIn!.month,weAttendanceOneData.value.clockIn!.day,weAttendanceOneData.value.clockIn!.hour,weAttendanceOneData.value.clockIn!.minute)).inHours) >= 12)
                          //   {
                          //     await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
                          //       DateTime dateTime = DateTime.now();
                          //       Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.clockIn!.year,weAttendanceOneData.value.clockIn!.month,weAttendanceOneData.value.clockIn!.day,weAttendanceOneData.value.clockIn!.hour,weAttendanceOneData.value.clockIn!.minute));
                          //       double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
                          //       int min = diff.inMinutes.remainder(60);
                          //       print("============autooooooooooooooooooooo");
                          //       await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
                          //         // inDateTime: weAttendanceOneData.value.inDateTime,
                          //         // outDateTime: DateTime.now(),
                          //         // punchIn: true,
                          //         // punchOut: true,
                          //         // lag: "${position.longitude}",
                          //         // lat: "${position.latitude}",
                          //         id: weAttendanceOneData.value.id,
                          //         staffId: loginController.staffLoginData.value.staffId,
                          //         hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
                          //         salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                          //         clockOut: dateTime,
                          //         clockOutLat: "${position.longitude}",
                          //         clockOutLong: "${position.latitude}",
                          //         clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
                          //         updatedAt: dateTime,
                          //       )).then((value) {
                          //         readWeAttendanceOneData();
                          //         EasyLoading.showSuccess("Punch Out Successfully");
                          //         print("================= atoooooooooo succccccccccccc");
                          //       });
                          //       // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
                          //       //     // inDateTime: weAttendanceOneData.value.inDateTime,
                          //       //     // outDateTime: DateTime.now(),
                          //       //     // punchIn: true,
                          //       //     // punchOut: true,
                          //       //     // lag: "${position.longitude}",
                          //       //     // lat: "${position.latitude}",
                          //       //   id: weAttendanceOneData.value.id,
                          //       //   staffId: loginController.staffLoginData.value.staffId,
                          //       //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
                          //       //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                          //       //   clockOut: dateTime,
                          //       //   clockOutLat: "${position.longitude}",
                          //       //   clockOutLong: "${position.latitude}",
                          //       //   clockOutAddress: "",
                          //       //   updatedAt: dateTime,
                          //       // )).then((value) async {
                          //       //   readWeAttendanceOneData();
                          //       //   EasyLoading.showSuccess("Punch Out Successfully");
                          //       //   print("================= atoooooooooo succccccccccccc");
                          //       // });
                          //     });
                          //   }
                          //
                          //   // ConstHelper.constHelper.showSimpleNotification(title: "Distance : ${distance.toStringAsFixed(1)}", body: "Time :  ${DateFormat('hh:mm:ss a  |  dd MMM yyyy').format(DateTime.now())}");
                          //   // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.lag}\ndiiiiii $distance ${weAttendanceOneData.value.punchIn} ${weAttendanceOneData.value.punchOut} ${distance >= 30}");
                          //   // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.long}\ndiiiiii $distance ${weAttendanceOneData.value.clockIn} ${weAttendanceOneData.value.clockOut} ${distance >= 30}");
                          //   // List<SubSiteDataModel> subCompanySiteList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: loginController.staffLoginData.value.companyId!) ?? [];
                          //   // double range = subCompanySiteList.isEmpty ? 0 : subCompanySiteList.where((element) => element.id == weAttendanceOneData.value.subCompanyId!).toList().isEmpty ? 0 : double.parse(subCompanySiteList.where((element) => element.id == weAttendanceOneData.value.subCompanyId!).toList().first.range!);
                          //   // print("=============== rangeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $range");
                          //   // if(distance >= 30)
                          //   await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString()));
                          //
                          // });
                        }
                        else
                        {
                          await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: "00.000000",lat: "00.000000"));
                        }
                      });
                    }
                  }
                  print("ERRORRRRRRRRRRRR 11111111 $e ${trackingDataList!.length} ${dateWiseTrackingData.length}");
                }
              }
              else
              {
                officeInOrOut.value = false;
              }
            }
          }
          else
          {
            weAttendanceOneData.value = PunchInOutDataModel(
              // inDateTime: null,
              // outDateTime: null,
              // punchIn: false,
              // punchOut: null,
              // lag: "",
              // lat: "",
              clockIn: null,
              clockOut: null,
              clockInLat: "",
              clockInLong: "",
              clockOutLat: "",
              clockOutLong: "",
            );
          }
        }
        else {
          weAttendanceOneData.value = PunchInOutDataModel(
            // inDateTime: null,
            // outDateTime: null,
            // punchIn: false,
            // punchOut: null,
            // lag: "",
            // lat: "",
            clockIn: null,
            clockOut: null,
            clockInLat: "",
            clockInLong: "",
            clockOutLat: "",
            clockOutLong: "",
          );
        }
      }
      else
      {
        weAttendanceOneData.value = PunchInOutDataModel(
          // inDateTime: null,
          // outDateTime: null,
          // punchIn: false,
          // punchOut: null,
          // lag: "",
          // lat: "",
          clockIn: null,
          clockOut: null,
          clockInLat: "",
          clockInLong: "",
          clockOutLat: "",
          clockOutLong: "",
        );
        return;
      }
    } catch (e) {
      print("errorrrrrrrrrrrr $e");
      return;
    }
  }

  Future<void> readWeAttendanceOneOnlineData() async {
    try {
      LoginController loginController = Get.put(LoginController());
      loginController.getUserData();
      var connectivityResult = await Connectivity().checkConnectivity();
      DateTime dateTime = connectivityResult == ConnectivityResult.none ? DateTime.now() : await NTP.now();
      print("=======7333333333333 ${loginController.UserLoginData.value.id}");
      if(loginController.UserLoginData.value.id != null)
      {
        List<PunchInOutDataModel> attendanceDataList = await ApiHelper.apiHelper.getAttendanceUserIdWise(staff_id: loginController.UserLoginData.value.id!) ?? [];
        print("================77777777777777777777 ${attendanceDataList.isNotEmpty}");
        if(attendanceDataList.isNotEmpty)
        {
          List<PunchInOutDataModel> weAttendanceOne = attendanceDataList.where((element) {
            return ((DateTime(element.clockIn!.year,element.clockIn!.month,element.clockIn!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0));
          }).toList();
          print("================== 8333333333333333333 ${weAttendanceOne.isNotEmpty}");
          if (weAttendanceOne.isNotEmpty)
          {
            // await SharedPref.sharedpref.insertSync(check: true,key: 'punchIn');
            // bool? punchIn = await SharedPref.sharedpref.readSync(key: 'punchIn');
            // print("=================== 866666666pppppppppppiiiiiiiiiiiiii $punchIn");
            weAttendanceOneData.value = weAttendanceOne.first;
            // print("==============87777777777777777777 ${weAttendanceOneData.value.clockIn}");
            // SharedPref.sharedpref.setUserTodayPunchInOutData(punchInOutDataModel: weAttendanceOneData.value);
            // List<SubSiteDataModel> subSiteDataList = subSiteDropDownList.where((p0) => p0.id == weAttendanceOneData.value.subCompanyId!).toList();
            // if(subSiteDataList.isNotEmpty)
            // {
            //   subSiteOneDropDownItem.value = subSiteDataList.first;
            //   bool gpsEnable = await Geolocator.isLocationServiceEnabled();
            //   if(gpsEnable)
            //   {
            //     try {
            //       await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((position) {
            //         double distance = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(subSiteOneDropDownItem.value.lat!), double.parse(subSiteOneDropDownItem.value.longs!));
            //         officeInOrOut.value = (distance <= double.parse(subSiteOneDropDownItem.value.ranges!));
            //         print("========== distanceeeeeeeeeeeee $distance");
            //       });
            //     } catch(e) {
            //       return;
            //
            //       // print("ERRORRRRRRRRRRRR 11111111 $e");
            //       // Position positions = await Geolocator.getCurrentPosition(
            //       //   desiredAccuracy: LocationAccuracy.lowest,
            //       // );
            //       // print("============pppppppppppppppp $positions");
            //       List<TrackingModel>? trackingDataList = await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!);
            //       List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0).toList();
            //       if(dateWiseTrackingData.isNotEmpty)
            //       {
            //         print("isNotEmptyyyyyyyyyyyyy ${dateWiseTrackingData.last.gpsActive!}");
            //         if(dateWiseTrackingData.last.gpsActive!.toLowerCase() == "On".toLowerCase())
            //         {
            //           await Geolocator.getLastKnownPosition().then((position) async {
            //             print("================= positionnnnnnnnnn1111111111 $position");
            //             if(position != null)
            //             {
            //               await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString()));
            //               // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: weAttendanceOneData.value.inDateTime == null ? DateTime.now() : weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
            //               // await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!).then((trackingDataList) async
            //               // {
            //               //   print("==========trackingggggggggggggggListtttttttttt ${trackingDataList!.length}");
            //               //   List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList!.where((element) => DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0).toList();
            //               //   TrackingModel? trackingOneData = dateWiseTrackingData.isEmpty ? null : dateWiseTrackingData.last;
            //               //   double distance = trackingOneData == null ? 0 : Geolocator.distanceBetween(
            //               //     position.latitude,
            //               //     position.longitude,
            //               //     double.parse(trackingOneData.lat!),
            //               //     double.parse(trackingOneData.long!),
            //               //   );
            //               //   print("==========ttttttttttttttttttt ${dateWiseTrackingData.length} $trackingOneData ");
            //               //   // print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.inDateTime!.year,weAttendanceOneData.value.inDateTime!.month,weAttendanceOneData.value.inDateTime!.day,weAttendanceOneData.value.inDateTime!.hour,weAttendanceOneData.value.inDateTime!.minute)).inMinutes}");
            //               //   print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.clockIn!.year,weAttendanceOneData.value.clockIn!.month,weAttendanceOneData.value.clockIn!.day,weAttendanceOneData.value.clockIn!.hour,weAttendanceOneData.value.clockIn!.minute)).inMinutes}");
            //               //
            //               //   // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.inDateTime!.year,weAttendanceOneData.value.inDateTime!.month,weAttendanceOneData.value.inDateTime!.day,weAttendanceOneData.value.inDateTime!.hour,weAttendanceOneData.value.inDateTime!.minute)).inHours) >= 12)
            //               //   if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.clockIn!.year,weAttendanceOneData.value.clockIn!.month,weAttendanceOneData.value.clockIn!.day,weAttendanceOneData.value.clockIn!.hour,weAttendanceOneData.value.clockIn!.minute)).inHours) >= 12)
            //               //   {
            //               //     await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
            //               //       DateTime dateTime = DateTime.now();
            //               //       Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(weAttendanceOneData.value.clockIn!.year,weAttendanceOneData.value.clockIn!.month,weAttendanceOneData.value.clockIn!.day,weAttendanceOneData.value.clockIn!.hour,weAttendanceOneData.value.clockIn!.minute));
            //               //       double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
            //               //       int min = diff.inMinutes.remainder(60);
            //               //       print("============autooooooooooooooooooooo");
            //               //       await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
            //               //         // inDateTime: weAttendanceOneData.value.inDateTime,
            //               //         // outDateTime: DateTime.now(),
            //               //         // punchIn: true,
            //               //         // punchOut: true,
            //               //         // lag: "${position.longitude}",
            //               //         // lat: "${position.latitude}",
            //               //         id: weAttendanceOneData.value.id,
            //               //         staffId: loginController.staffLoginData.value.staffId,
            //               //         hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
            //               //         salaryAmount: "${salaryPerMinute * diff.inMinutes}",
            //               //         clockOut: dateTime,
            //               //         clockOutLat: "${position.longitude}",
            //               //         clockOutLong: "${position.latitude}",
            //               //         clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
            //               //         updatedAt: dateTime,
            //               //       )).then((value) {
            //               //         readWeAttendanceOneData();
            //               //         EasyLoading.showSuccess("Punch Out Successfully");
            //               //         print("================= atoooooooooo succccccccccccc");
            //               //       });
            //               //       // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
            //               //       //     // inDateTime: weAttendanceOneData.value.inDateTime,
            //               //       //     // outDateTime: DateTime.now(),
            //               //       //     // punchIn: true,
            //               //       //     // punchOut: true,
            //               //       //     // lag: "${position.longitude}",
            //               //       //     // lat: "${position.latitude}",
            //               //       //   id: weAttendanceOneData.value.id,
            //               //       //   staffId: loginController.staffLoginData.value.staffId,
            //               //       //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
            //               //       //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
            //               //       //   clockOut: dateTime,
            //               //       //   clockOutLat: "${position.longitude}",
            //               //       //   clockOutLong: "${position.latitude}",
            //               //       //   clockOutAddress: "",
            //               //       //   updatedAt: dateTime,
            //               //       // )).then((value) async {
            //               //       //   readWeAttendanceOneData();
            //               //       //   EasyLoading.showSuccess("Punch Out Successfully");
            //               //       //   print("================= atoooooooooo succccccccccccc");
            //               //       // });
            //               //     });
            //               //   }
            //               //
            //               //   // ConstHelper.constHelper.showSimpleNotification(title: "Distance : ${distance.toStringAsFixed(1)}", body: "Time :  ${DateFormat('hh:mm:ss a  |  dd MMM yyyy').format(DateTime.now())}");
            //               //   // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.lag}\ndiiiiii $distance ${weAttendanceOneData.value.punchIn} ${weAttendanceOneData.value.punchOut} ${distance >= 30}");
            //               //   // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.long}\ndiiiiii $distance ${weAttendanceOneData.value.clockIn} ${weAttendanceOneData.value.clockOut} ${distance >= 30}");
            //               //   // List<SubSiteDataModel> subCompanySiteList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: loginController.staffLoginData.value.companyId!) ?? [];
            //               //   // double range = subCompanySiteList.isEmpty ? 0 : subCompanySiteList.where((element) => element.id == weAttendanceOneData.value.subCompanyId!).toList().isEmpty ? 0 : double.parse(subCompanySiteList.where((element) => element.id == weAttendanceOneData.value.subCompanyId!).toList().first.range!);
            //               //   // print("=============== rangeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $range");
            //               //   // if(distance >= 30)
            //               //   await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString()));
            //               //
            //               // });
            //             }
            //             else
            //             {
            //               await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: "00.000000",lat: "00.000000"));
            //             }
            //           });
            //         }
            //       }
            //       print("ERRORRRRRRRRRRRR 11111111 $e ${trackingDataList!.length} ${dateWiseTrackingData.length}");
            //     }
            //   }
            //   else
            //   {
            //     officeInOrOut.value = false;
            //   }
            // }
          }
          else
          {
            weAttendanceOneData.value = PunchInOutDataModel(
              // inDateTime: null,
              // outDateTime: null,
              // punchIn: false,
              // punchOut: null,
              // lag: "",
              // lat: "",
              clockIn: null,
              clockOut: null,
              clockInLat: "",
              clockInLong: "",
              clockOutLat: "",
              clockOutLong: "",
            );
          }
        }
        else {
          weAttendanceOneData.value = PunchInOutDataModel(
            // inDateTime: null,
            // outDateTime: null,
            // punchIn: false,
            // punchOut: null,
            // lag: "",
            // lat: "",
            clockIn: null,
            clockOut: null,
            clockInLat: "",
            clockInLong: "",
            clockOutLat: "",
            clockOutLong: "",
          );
        }
      }
      else
      {
        weAttendanceOneData.value = PunchInOutDataModel(
          // inDateTime: null,
          // outDateTime: null,
          // punchIn: false,
          // punchOut: null,
          // lag: "",
          // lat: "",
          clockIn: null,
          clockOut: null,
          clockInLat: "",
          clockInLong: "",
          clockOutLat: "",
          clockOutLong: "",
        );
        return;
      }
    } catch (e) {
      print("errorrrrrrrrrrrr $e");
      return;
    }
  }

  Future<void> readWeAttendanceOneOfflineData()
  async {
    LoginController loginController = Get.put(LoginController());
    loginController.getUserData();
    PunchInOutDataModel? punchInOutDataModel = await SharedPref.sharedpref.readUserTodayPunchInOutData();
    if(punchInOutDataModel != null)
    {
      weAttendanceOneData.value = punchInOutDataModel;
    }
    else {
      weAttendanceOneData.value = PunchInOutDataModel(
        // inDateTime: null,
        // outDateTime: null,
        // punchIn: false,
        // punchOut: null,
        // lag: "",
        // lat: "",
        clockIn: null,
        clockOut: null,
        clockInLat: "",
        clockInLong: "",
        clockOutLat: "",
        clockOutLong: "",
      );
    }
  }

  // Future<void> initBackgroundFetch() async {
  //   print("===============~~~~~~~~~~~~~~~~~~~~~ STARTTTTTTTTTTTT ");
  //   var val = await BackgroundFetch.configure(
  //     BackgroundFetchConfig(
  //
  //       minimumFetchInterval: 15,
  //       // Fetch interval in minutes
  //       stopOnTerminate: false,
  //       enableHeadless: true,
  //       startOnBoot: true,
  //       requiresBatteryNotLow: false,
  //       requiresCharging: false,
  //       requiresStorageNotLow: false,
  //     ),
  //         (String taskId) async {
  //       print("===============~~~~~~~~~~~~~~~~~~~~~ BACKGROUND 2222222222 $taskId");
  //       final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  //       Position currentPosition = await _geolocator.getCurrentPosition();
  //       print("===============~~~~~~~~~~~~~~~~~~~~~ POSITIONNNNNNNNNNN $currentPosition");
  //       double distance = Geolocator.distanceBetween(
  //         currentPosition.latitude,
  //         currentPosition.longitude,
  //         21.1664583,
  //         72.8413321,
  //       );
  //       print("=========== distanceeeeeeeeeeeeeeeeeeeeeeee $distance");
  //       // EasyLoading.showInfo("$distance");
  //       if (distance > 30) {
  //         DateTime dateTime = await NTP.now();
  //         // await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(
  //         //   inDateTime: dateTime,
  //         //   lag: currentPosition.longitude.toString(),
  //         //   lat: currentPosition.latitude.toString(),
  //         // ));
  //       }
  //       // Check location, calculate distance, and save to database
  //       // Use geolocator to get user's current location
  //       // Calculate distance using Haversine formula
  //       // Save location to SQLite database using sqflite
  //       print("===============~~~~~~~~~~~~~~~~~~~~~ BACKGROUND ENDDDDDDDDDDDDDDDD");
  //       BackgroundFetch.finish(taskId);
  //     },
  //         (String taskId) async {
  //       print("===============~~~~~~~~~~~~~~~~~~~~~ BACKGROUND 22222222 2222222222");
  //       print("===============~~~~~~~~~~~~~~~~~~~~~ BACKGROUND 22222222 ENDDDDDDDDDDDDDDDD");
  //       // BackgroundFetch.finish(taskId);
  //     },
  //   ).then((value) {
  //     print("===============~~~~~~~~~~~~~~~~~~~~~ 1111111 $value");
  //   });
  //
  //   print("===============~~~~~~~~~~~~~~~~~~~~~ 2222222222 ENDDDDDDDDDDDD $val");
  // }

  Future<void> checkLeaveTypeDataAvailable({required LeaveTypeDataModel leaveTypeDataModel})
  async {
    leaveTypeDataAvailableList.value = [];
    vadhelaLeaveTypeDays.value = 0;
    List<LeaveDataModel>? checkData = await ApiHelper.apiHelper.getAllLeaveData();
    leaveTypeDataAvailableList.value = checkData!.where((element) => element.leaveTypeId == leaveTypeDataModel.leaveTypeId).toList();

    vadhelaLeaveTypeDays.value = int.parse(leaveTypeDataModel.leaveNos!) - leaveTypeDataAvailableList.fold(0,(previousValue, element) => previousValue + int.parse(element.days!));
  }

  void checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      print("=====================CONNECTIVITYYYYYYYYYYYYYYYYYY $result");
      onlineOffline.value = result != ConnectivityResult.none;
    });
  }


}
