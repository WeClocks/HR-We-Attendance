import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/HomePage.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/View/LoginPage.dart';
import 'package:hr_we_attendance/Screens/SplashScreen/View/SplashPage.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ConstHelper.dart';
import 'package:hr_we_attendance/Utils/DBHelper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_we_attendance/Utils/LocalString.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';

import 'firebase_options.dart';

HomeController homeController = Get.put(HomeController());
LoginController loginController = Get.put(LoginController());

@pragma('vm:entry-point')
void onStart(ServiceInstance serviceInstance)
async {
  DartPluginRegistrant.ensureInitialized();

  serviceInstance.on("setAsForeground").listen((event) {
    print("=============setAsForegroundsetAsForegroundsetAsForeground");
  });

  serviceInstance.on("setAsBackground").listen((event) {
    print("=============setAsBackgroundsetAsBackgroundsetAsBackground");
  });

  // serviceInstance.on("stopService").listen((event) {
  //   print("=============stopServicestopServicestopService");
  //   serviceInstance.stopSelf();
  // });

  tracking();
  // Timer.periodic(const Duration(seconds: 15), (timer) async {
  //
  // });
}

Future<void> tracking()
async {
  // print("==========STARTTTTTTTTTTTTTTTTTTTTTTTT");
  // PermissionStatus permission = await Permission.location.request();
  //
  // print("===========~~~~~~~~~~~~~~~~~~~~ $permission");
  // if(permission == PermissionStatus.granted || permission == PermissionStatus.limited)
  // {
  // }
  // else
  // {
  //   await Permission.locationWhenInUse.request();
  //   tracking();
  // }

  homeController = Get.put(HomeController());

  try {
    bool? login = await SharedPref.sharedpref.readSync(key: 'login');
    // print("===========loginnnnnnnnnn7666666666666 $login");
    if(login != null && login)
    {
      await loginController.getUserData().then((value) async {
        await homeController.readWeAttendanceOneOnlineData().then((value) async {
          // print("===================~~~~~~~~~~~ ${homeController.weAttendanceOneData.value.punchIn} ${homeController.officeIn} checkkkkkkkkkkkk  ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ===");
          print("===================~~~~~~~~~~~ FIRSTTTTTTTTTTTTT${homeController.weAttendanceOneData.value.clockIn} ${homeController.officeIn} checkkkkkkkkkkkk  ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ===");
          // if(homeController.weAttendanceOneData.value.punchIn == true && homeController.weAttendanceOneData.value.punchOut == false)
          var connectivityResult = await Connectivity().checkConnectivity();
          if(connectivityResult == ConnectivityResult.none)
          {
            await homeController.readWeAttendanceOneOfflineData().then((value) async {
              // print("===================~~~~~~~~~~~ ${homeController.weAttendanceOneData.value.punchIn} ${homeController.officeIn} checkkkkkkkkkkkk  ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ===");
              print("===================~~~~~~~~~~~offfffffffff ${homeController.weAttendanceOneData.value.clockIn} ${homeController.officeIn} checkkkkkkkkkkkk  ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ===");
              // if(homeController.weAttendanceOneData.value.punchIn == true && homeController.weAttendanceOneData.value.punchOut == false)
              if(homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null)
              {
                bool gpsEnable = await Geolocator.isLocationServiceEnabled();
                if(gpsEnable)
                {
                  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low,).then((position) async {
                    // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: homeController.weAttendanceOneData.value.inDateTime == null ? DateTime.now() : homeController.weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
                    TrackingModel? trackingDataDateWiseModel = await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: DateTime.now(),staff_id: loginController.UserLoginData.value.id!,);
                    print("========== ~~~~~~~offfffffffffpooooooooooo $position $trackingDataDateWiseModel");
                    if(trackingDataDateWiseModel == null)
                    {
                      await SharedPref.sharedpref.readUserTodayTrackingLastData().then((trackingOneData) async
                      {
                        print("======trcktracktracktrack $trackingOneData");
                        await DBHelper.dbHelper.insertTrackingData(trackingModel: trackingOneData ?? TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString())).then((value) => tracking());

                      });
                    }
                    else
                    {
                      TrackingModel trackingOneData = trackingDataDateWiseModel;
                      // List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
                      // TrackingModel? trackingOneData = dateWiseTrackingData.isEmpty ? null : dateWiseTrackingData.last;

                      double distance = Geolocator.distanceBetween(
                        position.latitude,
                        position.longitude,
                        double.parse(trackingOneData.lat!),
                        double.parse(trackingOneData.long!),
                      );
                      print("===~~~~~~~offfffffffff======trackkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${loginController.UserLoginData.value.id} ${homeController.weAttendanceOneData.value.staffId} $distance  $trackingOneData");
                      // print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes}");
                      print("~~~~~~~offfffffffffdurationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inMinutes}");

                      // // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours) >= 12)
                      // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours) >= 12)
                      // {
                      //   await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
                      //     DateTime dateTime = DateTime.now();
                      //     Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute));
                      //     double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
                      //     int min = diff.inMinutes.remainder(60);
                      //     print("============autooooooooooooooooooooo");
                      //     await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
                      //       // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                      //       // outDateTime: DateTime.now(),
                      //       // punchIn: true,
                      //       // punchOut: true,
                      //       // lag: "${position.longitude}",
                      //       // lat: "${position.latitude}",
                      //       id: homeController.weAttendanceOneData.value.id,
                      //       staffId: loginController.staffLoginData.value.staffId,
                      //       hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
                      //       salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                      //       clockOut: dateTime,
                      //       clockOutType: "Auto",
                      //       clockOutLat: "${position.longitude}",
                      //       clockOutLong: "${position.latitude}",
                      //       clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
                      //       updatedAt: dateTime,
                      //     )).then((value) {
                      //       homeController.readWeAttendanceOneOnlineData();
                      //       EasyLoading.showSuccess("Punch Out Successfully");
                      //       print("================= atoooooooooo succccccccccccc");
                      //     });
                      //     // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
                      //     //     // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                      //     //     // outDateTime: DateTime.now(),
                      //     //     // punchIn: true,
                      //     //     // punchOut: true,
                      //     //     // lag: "${position.longitude}",
                      //     //     // lat: "${position.latitude}",
                      //     //   id: homeController.weAttendanceOneData.value.id,
                      //     //   staffId: loginController.staffLoginData.value.staffId,
                      //     //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
                      //     //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                      //     //   clockOut: dateTime,
                      //     //   clockOutLat: "${position.longitude}",
                      //     //   clockOutLong: "${position.latitude}",
                      //     //   clockOutAddress: "",
                      //     //   updatedAt: dateTime,
                      //     // )).then((value) async {
                      //     //   homeController.readWeAttendanceOneData();
                      //     //   EasyLoading.showSuccess("Punch Out Successfully");
                      //     //   print("================= atoooooooooo succccccccccccc");
                      //     // });
                      //   });
                      // }

                      // ConstHelper.constHelper.showSimpleNotification(title: "Distance : ${distance.toStringAsFixed(1)}", body: "Time :  ${DateFormat('hh:mm:ss a  |  dd MMM yyyy').format(DateTime.now())}");
                      // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.lag}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ${distance >= 30}");
                      print("=======~~~~~~~offfffffffff============ distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.long}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ${distance >= 30}");
                      SubSiteDataModel? subSiteDataModel = await SharedPref.sharedpref.readUserSubSiteData();
                      double range = subSiteDataModel == null ? 0 : double.parse(subSiteDataModel.ranges!);
                      print("==========~~~~~~~offfffffffff===== rangeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $range");
                      // if(distance >= 30)
                      if(distance >= (range == 0 ? 50 : range))
                      {
                        await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString())).then((value) => tracking());
                      }
                      else
                      {
                        tracking();
                      }
                    }
                  });
                }
                else
                {
                  // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: homeController.weAttendanceOneData.value.inDateTime == null ? DateTime.now() : homeController.weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
                  TrackingModel? trackingDataDateWiseModel = await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: DateTime.now(),staff_id: loginController.UserLoginData.value.id!,);

                  if(trackingDataDateWiseModel == null)
                  {
                    await SharedPref.sharedpref.readUserTodayTrackingLastData().then((trackingOneData) async
                    {
                      await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: "00.000000",lat: "00.000000")).then((value) => tracking());
                    });
                  }
                  else
                  {
                    if(trackingDataDateWiseModel.gpsActive!.toLowerCase() == "On".toLowerCase())
                    {
                      await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: "00.000000",lat: "00.000000")).then((value) => tracking());
                    }
                  }
                }
              }
              else
              {
                print("================= ofiiiiiiiiiiiiiiiiiiii");
                tracking();
              }
            });

            // tracking();
          }
          else
          {
            if(homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null)
            {
              bool gpsEnable = await Geolocator.isLocationServiceEnabled();
              if(gpsEnable)
              {
                await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low,).then((position) async {
                  // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: homeController.weAttendanceOneData.value.inDateTime == null ? DateTime.now() : homeController.weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
                  await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!).then((trackingDataList) async
                  {
                    List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
                    TrackingModel? trackingOneData = dateWiseTrackingData.isEmpty ? null : dateWiseTrackingData.last;
                    if(trackingOneData != null)
                    {
                      SharedPref.sharedpref.setUserTodayTrackingLastData(trackingModel: trackingOneData);
                    }
                    double distance = trackingOneData == null ? 0 : Geolocator.distanceBetween(
                      position.latitude,
                      position.longitude,
                      double.parse(trackingOneData.lat!),
                      double.parse(trackingOneData.long!),
                    );
                    print("=========trackkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${loginController.UserLoginData.value.id} ${homeController.weAttendanceOneData.value.staffId} $distance ${dateWiseTrackingData.length} ${trackingDataList!.length} $trackingOneData");
                    // print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes}");
                    print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inMinutes}");

                    // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours) >= 12)
                    if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours) >= 12)
                    {
                      await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
                        DateTime dateTime = DateTime.now();
                        Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute));
                        double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
                        int min = diff.inMinutes.remainder(60);
                        print("============autooooooooooooooooooooo");
                        await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
                          // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                          // outDateTime: DateTime.now(),
                          // punchIn: true,
                          // punchOut: true,
                          // lag: "${position.longitude}",
                          // lat: "${position.latitude}",
                          id: homeController.weAttendanceOneData.value.id,
                          staffId: loginController.staffLoginData.value.staffId,
                          hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
                          salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                          clockOut: dateTime,
                          clockOutType: "Auto",
                          clockOutLat: "${position.longitude}",
                          clockOutLong: "${position.latitude}",
                          clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
                          updatedAt: dateTime,
                        )).then((value) {
                          homeController.readWeAttendanceOneOnlineData();
                          EasyLoading.showSuccess("Punch Out Successfully");
                          print("================= atoooooooooo succccccccccccc");
                        });
                        // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
                        //     // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                        //     // outDateTime: DateTime.now(),
                        //     // punchIn: true,
                        //     // punchOut: true,
                        //     // lag: "${position.longitude}",
                        //     // lat: "${position.latitude}",
                        //   id: homeController.weAttendanceOneData.value.id,
                        //   staffId: loginController.staffLoginData.value.staffId,
                        //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
                        //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                        //   clockOut: dateTime,
                        //   clockOutLat: "${position.longitude}",
                        //   clockOutLong: "${position.latitude}",
                        //   clockOutAddress: "",
                        //   updatedAt: dateTime,
                        // )).then((value) async {
                        //   homeController.readWeAttendanceOneData();
                        //   EasyLoading.showSuccess("Punch Out Successfully");
                        //   print("================= atoooooooooo succccccccccccc");
                        // });
                      });
                    }

                    // ConstHelper.constHelper.showSimpleNotification(title: "Distance : ${distance.toStringAsFixed(1)}", body: "Time :  ${DateFormat('hh:mm:ss a  |  dd MMM yyyy').format(DateTime.now())}");
                    // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.lag}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ${distance >= 30}");
                    print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.long}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ${distance >= 30}");
                    List<SubSiteDataModel> subCompanySiteList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: loginController.staffLoginData.value.companyId!) ?? [];
                    double range = subCompanySiteList.isEmpty ? 0 : subCompanySiteList.where((element) => element.id == homeController.weAttendanceOneData.value.subCompanyId!).toList().isEmpty ? 0 : double.parse(subCompanySiteList.where((element) => element.id == homeController.weAttendanceOneData.value.subCompanyId!).toList().first.ranges!);
                    print("=============== rangeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $range");
                    // if(distance >= 30)
                    if(distance >= (range == 0 ? 50 : range))
                    {
                      await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString())).then((value) => tracking());
                    }
                    else
                    {
                      tracking();
                    }
                  });
                });
              }
              else
              {
                List<TrackingModel>? trackingDataList = await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!);
                List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
                if(dateWiseTrackingData.isNotEmpty)
                {
                  if(dateWiseTrackingData.last.gpsActive!.toLowerCase() == "On".toLowerCase())
                  {
                    await Geolocator.getLastKnownPosition().then((position) async {
                      if(position != null)
                      {
                        // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: homeController.weAttendanceOneData.value.inDateTime == null ? DateTime.now() : homeController.weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
                        await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: loginController.UserLoginData.value.id!).then((trackingDataList) async
                        {
                          List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
                          TrackingModel? trackingOneData = dateWiseTrackingData.isEmpty ? null : dateWiseTrackingData.last;
                          double distance = trackingOneData == null ? 0 : Geolocator.distanceBetween(
                            position.latitude,
                            position.longitude,
                            double.parse(trackingOneData.lat!),
                            double.parse(trackingOneData.long!),
                          );

                          // print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes}");
                          print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inMinutes}");

                          // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours) >= 12)
                          if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours) >= 12)
                          {
                            await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
                              DateTime dateTime = DateTime.now();
                              Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute));
                              double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
                              int min = diff.inMinutes.remainder(60);
                              print("============autooooooooooooooooooooo");
                              await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
                                // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                                // outDateTime: DateTime.now(),
                                // punchIn: true,
                                // punchOut: true,
                                // lag: "${position.longitude}",
                                // lat: "${position.latitude}",
                                id: homeController.weAttendanceOneData.value.id,
                                staffId: loginController.staffLoginData.value.staffId,
                                hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
                                salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                                clockOut: dateTime,
                                clockOutType: "Auto",
                                clockOutLat: "${position.longitude}",
                                clockOutLong: "${position.latitude}",
                                clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
                                updatedAt: dateTime,
                              )).then((value) {
                                homeController.readWeAttendanceOneOnlineData();
                                EasyLoading.showSuccess("Punch Out Successfully");
                                print("================= atoooooooooo succccccccccccc");
                              });
                              // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
                              //     // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                              //     // outDateTime: DateTime.now(),
                              //     // punchIn: true,
                              //     // punchOut: true,
                              //     // lag: "${position.longitude}",
                              //     // lat: "${position.latitude}",
                              //   id: homeController.weAttendanceOneData.value.id,
                              //   staffId: loginController.staffLoginData.value.staffId,
                              //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
                              //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                              //   clockOut: dateTime,
                              //   clockOutLat: "${position.longitude}",
                              //   clockOutLong: "${position.latitude}",
                              //   clockOutAddress: "",
                              //   updatedAt: dateTime,
                              // )).then((value) async {
                              //   homeController.readWeAttendanceOneData();
                              //   EasyLoading.showSuccess("Punch Out Successfully");
                              //   print("================= atoooooooooo succccccccccccc");
                              // });
                            });
                          }

                          // ConstHelper.constHelper.showSimpleNotification(title: "Distance : ${distance.toStringAsFixed(1)}", body: "Time :  ${DateFormat('hh:mm:ss a  |  dd MMM yyyy').format(DateTime.now())}");
                          // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.lag}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ${distance >= 30}");
                          // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.long}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ${distance >= 30}");
                          // List<SubSiteDataModel> subCompanySiteList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: loginController.staffLoginData.value.companyId!) ?? [];
                          // double range = subCompanySiteList.isEmpty ? 0 : subCompanySiteList.where((element) => element.id == homeController.weAttendanceOneData.value.subCompanyId!).toList().isEmpty ? 0 : double.parse(subCompanySiteList.where((element) => element.id == homeController.weAttendanceOneData.value.subCompanyId!).toList().first.range!);
                          // print("=============== rangeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $range");
                          // if(distance >= 30)
                          await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString())).then((value) => tracking());

                        });
                      }
                      else
                      {
                        tracking();
                      }
                    });
                  }
                  else
                  {
                    tracking();
                  }
                }
                else
                {
                  tracking();
                }
              }
            }
            else
            {
              print("================= ofiiiiiiiiiiiiiiiiiiii");
              tracking();
            }
          }
        });
      });
    }
    else
    {
      tracking();
    }
  } catch(e) {
    tracking();
    // var connectivityResult = await Connectivity().checkConnectivity();
    // print(" EORRRRRRRRRRR errorrrrr : $e $connectivityResult");
    // if(connectivityResult == ConnectivityResult.none)
    //   {
    //     await homeController.readWeAttendanceOneOfflineData().then((value) async {
    //       // print("===================~~~~~~~~~~~ ${homeController.weAttendanceOneData.value.punchIn} ${homeController.officeIn} checkkkkkkkkkkkk  ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ===");
    //       print("===================~~~~~~~~~~~offfffffffff ${homeController.weAttendanceOneData.value.clockIn} ${homeController.officeIn} checkkkkkkkkkkkk  ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ===");
    //       // if(homeController.weAttendanceOneData.value.punchIn == true && homeController.weAttendanceOneData.value.punchOut == false)
    //       if(homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null)
    //       {
    //         bool gpsEnable = await Geolocator.isLocationServiceEnabled();
    //         if(gpsEnable)
    //         {
    //           await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest,).then((position) async {
    //             // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: homeController.weAttendanceOneData.value.inDateTime == null ? DateTime.now() : homeController.weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
    //             TrackingModel? trackingDataDateWiseModel = await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: DateTime.now());
    //             print("========== ~~~~~~~offfffffffffpooooooooooo $position $trackingDataDateWiseModel");
    //             if(trackingDataDateWiseModel == null)
    //               {
    //                 await SharedPref.sharedpref.readUserTodayTrackingLastData().then((trackingOneData) async
    //                 {
    //                   print("======trcktracktracktrack $trackingOneData");
    //                   await DBHelper.dbHelper.insertTrackingData(trackingModel: trackingOneData ?? TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString())).then((value) => tracking());
    //
    //                 });
    //               }
    //             else
    //               {
    //                 TrackingModel trackingOneData = trackingDataDateWiseModel;
    //                 // List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
    //                 // TrackingModel? trackingOneData = dateWiseTrackingData.isEmpty ? null : dateWiseTrackingData.last;
    //
    //                 double distance = Geolocator.distanceBetween(
    //                   position.latitude,
    //                   position.longitude,
    //                   double.parse(trackingOneData.lat!),
    //                   double.parse(trackingOneData.long!),
    //                 );
    //                 print("===~~~~~~~offfffffffff======trackkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${loginController.UserLoginData.value.id} ${homeController.weAttendanceOneData.value.staffId} $distance  $trackingOneData");
    //                 // print("durationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes}");
    //                 print("~~~~~~~offfffffffffdurationnnnnnnnnnnn ${DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inMinutes}");
    //
    //                 // // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours) >= 12)
    //                 // if((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours) >= 12)
    //                 // {
    //                 //   await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
    //                 //     DateTime dateTime = DateTime.now();
    //                 //     Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute));
    //                 //     double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
    //                 //     int min = diff.inMinutes.remainder(60);
    //                 //     print("============autooooooooooooooooooooo");
    //                 //     await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
    //                 //       // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
    //                 //       // outDateTime: DateTime.now(),
    //                 //       // punchIn: true,
    //                 //       // punchOut: true,
    //                 //       // lag: "${position.longitude}",
    //                 //       // lat: "${position.latitude}",
    //                 //       id: homeController.weAttendanceOneData.value.id,
    //                 //       staffId: loginController.staffLoginData.value.staffId,
    //                 //       hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
    //                 //       salaryAmount: "${salaryPerMinute * diff.inMinutes}",
    //                 //       clockOut: dateTime,
    //                 //       clockOutType: "Auto",
    //                 //       clockOutLat: "${position.longitude}",
    //                 //       clockOutLong: "${position.latitude}",
    //                 //       clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
    //                 //       updatedAt: dateTime,
    //                 //     )).then((value) {
    //                 //       homeController.readWeAttendanceOneOnlineData();
    //                 //       EasyLoading.showSuccess("Punch Out Successfully");
    //                 //       print("================= atoooooooooo succccccccccccc");
    //                 //     });
    //                 //     // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
    //                 //     //     // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
    //                 //     //     // outDateTime: DateTime.now(),
    //                 //     //     // punchIn: true,
    //                 //     //     // punchOut: true,
    //                 //     //     // lag: "${position.longitude}",
    //                 //     //     // lat: "${position.latitude}",
    //                 //     //   id: homeController.weAttendanceOneData.value.id,
    //                 //     //   staffId: loginController.staffLoginData.value.staffId,
    //                 //     //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
    //                 //     //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
    //                 //     //   clockOut: dateTime,
    //                 //     //   clockOutLat: "${position.longitude}",
    //                 //     //   clockOutLong: "${position.latitude}",
    //                 //     //   clockOutAddress: "",
    //                 //     //   updatedAt: dateTime,
    //                 //     // )).then((value) async {
    //                 //     //   homeController.readWeAttendanceOneData();
    //                 //     //   EasyLoading.showSuccess("Punch Out Successfully");
    //                 //     //   print("================= atoooooooooo succccccccccccc");
    //                 //     // });
    //                 //   });
    //                 // }
    //
    //                 // ConstHelper.constHelper.showSimpleNotification(title: "Distance : ${distance.toStringAsFixed(1)}", body: "Time :  ${DateFormat('hh:mm:ss a  |  dd MMM yyyy').format(DateTime.now())}");
    //                 // print("=================== distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.lag}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.punchIn} ${homeController.weAttendanceOneData.value.punchOut} ${distance >= 30}");
    //                 print("=======~~~~~~~offfffffffff============ distanceeeeeeeeeeeeeeeeeee ~~ posiiiii ${position.latitude} ${position.longitude} trackkkkkkk ${trackingOneData!.lat!} ${trackingOneData.long}\ndiiiiii $distance ${homeController.weAttendanceOneData.value.clockIn} ${homeController.weAttendanceOneData.value.clockOut} ${distance >= 30}");
    //                 SubSiteDataModel? subSiteDataModel = await SharedPref.sharedpref.readUserSubSiteData();
    //                 double range = subSiteDataModel == null ? 0 : double.parse(subSiteDataModel.ranges!);
    //                 print("==========~~~~~~~offfffffffff===== rangeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $range");
    //                 // if(distance >= 30)
    //                 if(distance >= (range == 0 ? 50 : range))
    //                 {
    //                   await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString())).then((value) => tracking());
    //                 }
    //                 else
    //                 {
    //                   tracking();
    //                 }
    //               }
    //           });
    //         }
    //         else
    //         {
    //           // await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: homeController.weAttendanceOneData.value.inDateTime == null ? DateTime.now() : homeController.weAttendanceOneData.value.inDateTime!).then((trackingOneData) async
    //           TrackingModel? trackingDataDateWiseModel = await DBHelper.dbHelper.readTrackingDataDateWise(dateTime: DateTime.now());
    //
    //           if(trackingDataDateWiseModel == null)
    //           {
    //             await SharedPref.sharedpref.readUserTodayTrackingLastData().then((trackingOneData) async
    //             {
    //               await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: "00.000000",lat: "00.000000")).then((value) => tracking());
    //             });
    //           }
    //           else
    //           {
    //             if(trackingDataDateWiseModel.gpsActive!.toLowerCase() == "On".toLowerCase())
    //               {
    //                 await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "Off",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: "00.000000",lat: "00.000000")).then((value) => tracking());
    //               }
    //           }
    //         }
    //       }
    //       else
    //       {
    //         print("================= ofiiiiiiiiiiiiiiiiiiii");
    //         tracking();
    //       }
    //     });
    //   }
    // else
    //   {
    //     tracking();
    //   }
  }

}

///  IOS
@pragma('vm:entry-point')
Future<bool> iosOnBackground(ServiceInstance serviceInstance) async
{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await loginController.initializeService();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      translations: LocalString(),
      locale: const Locale('en','US'),
      initialRoute: 'splash',
      routes: {
        'splash':(p0) => Splash_Screen(),
        'login':(p0) => LoginPage(),
        '/' : (context) => const HomePage(),
      },
      navigatorKey: homeController.navigatorKey,
      builder: EasyLoading.init(),
    );
  }
}

