import 'dart:async';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hr_we_attendance/Screens/ChangePasswordScreen/Controller/ChangePasswordController.dart';
import 'package:hr_we_attendance/Screens/ChangePasswordScreen/View/PasswordVerifyPage.dart';
import 'package:hr_we_attendance/Screens/HRStaffAttendance/Controller/HrStaffAttendanceController.dart';
import 'package:hr_we_attendance/Screens/HRTrackScreen/controller/HRTrackController.dart';
import 'package:hr_we_attendance/Screens/HRTrackScreen/view/HRTrackPage.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveTypeDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/ProblemModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/HRStaffAttendance/View/HRStaffAttendancePage.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/LeavePage.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/ProblemPage.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/ProfilePage.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/MapsScreen/view/MapsPage.dart';
import 'package:hr_we_attendance/Screens/NotificationsScreen/controller/NotificationsController.dart';
import 'package:hr_we_attendance/Screens/NotificationsScreen/view/NotificationsPage.dart';
import 'package:hr_we_attendance/Screens/PoLeaveScreen/Controller/PoLeaveController.dart';
import 'package:hr_we_attendance/Screens/PoLeaveScreen/View/PoLeavePage.dart';
import 'package:hr_we_attendance/Screens/ReportScreen/controller/ReportController.dart';
import 'package:hr_we_attendance/Screens/ReportScreen/view/ReportPage.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ConstHelper.dart';
import 'package:hr_we_attendance/Utils/DBHelper.dart';
import 'package:hr_we_attendance/Utils/FirebaseHelper.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';
import 'package:hr_we_attendance/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  ReportController reportController = Get.put(ReportController());
  HRTrackController hrTrackController = Get.put(HRTrackController());
  HRStaffAttendanceController hrController = Get.put(HRStaffAttendanceController());
  PoLeaveController poLeaveController = Get.put(PoLeaveController());
  ChangePasswordController passwordController = Get.put(ChangePasswordController());
  NotificationsController notificationsController = Get.put(NotificationsController());
  RxInt circulerOnOff = 0.obs;
  Stream<ServiceStatus>? _locationServiceStream;
  late Stream<bool> _gpsStatusStream;
  RxBool oneTimeClick = false.obs;
  RxBool punchOutAnywhere = false.obs;
  // Location location = Location();
  // Stream<bool>? _locationStatusStream;

  Future<void> checkUserInnerLocation()
  async {
    for(int k = 0; k<(k+1);)
    {
      // print("==========================kkkkkkkkkkkk $k sitesubsiteeeeeeeeeeeee ${homeController.siteOneDropDownItem.value.name} && ${homeController.subSiteOneDropDownItem.value.name} ::: ${homeController.siteOneDropDownItem.value.name != null && homeController.subSiteOneDropDownItem.value.name != null}");
      bool gpsEnable = await Geolocator.isLocationServiceEnabled();
      if(gpsEnable)
      {
        try {
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((position) async {
            if(homeController.siteOneDropDownItem.value.name != null && homeController.subSiteOneDropDownItem.value.name != null)
            {
              double distance = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(homeController.subSiteOneDropDownItem.value.lat!), double.parse(homeController.subSiteOneDropDownItem.value.longs!));
              homeController.officeInOrOut.value = (distance <= double.parse(homeController.subSiteOneDropDownItem.value.ranges!));
            }
            k++;

          });
        } catch(e) {
          k++;
          print("ERRORRRRRRRRRRRR 222222222 $e");
        }
      }
      else
      {
        k++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserInnerLocation();
    homeController.officeInOrOut.value = false;
    // _gpsStatusStream = Geolocator.isLocationServiceEnabled().asStream();
    _startLocationStatusStream();
    // homeController.initBackgroundFetch();
    FirebaseHelper.firebaseHelper.firebaseMessaging();
    Timer.periodic(Duration(seconds: 1), (timer) async {
      // DateTime dateTime = await NTP.now();
      DateTime dateTime = DateTime.now();
      homeController.nowTime.value = dateTime.toIso8601String();
      homeController.readWeAttendanceOneOnlineData();
    });
    fetchData();
  }

  void _startLocationStatusStream() {
    _gpsStatusStream = Geolocator.getServiceStatusStream().map(
          (status) {
        print("================statusssssssssssssss");
        if(status != ServiceStatus.enabled)
        {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                // content: Container(
                //   width: Get.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(9),
                //     color: Colors.black,
                //   ),
                //   child: C,
                // ),
                title: const Text("Please Turn On Your GPS?",style: TextStyle(fontSize: 14,),),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        )
                    ),
                    child: const Text("Close",style: TextStyle(color: Color(0xFF5b1aa0)),),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await AppSettings.openAppSettings(type: AppSettingsType.location).then((value) => Timer(Duration(seconds: 2), () => Get.back()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5b1aa0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        )
                    ),
                    child: Text("Turn On",style: TextStyle(color: Colors.blue.shade50),),
                  ),
                ],
              );
            },
          );
        }
        return status == ServiceStatus.enabled;
      },
    );
    setState(() {});
  }

  final StreamController<List> streamController = StreamController<List>();
  Future<void> fetchData() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.none)
    {
      await ApiHelper.apiHelper.getAllNotificationsData().then((data) {
        if(data != null && data.isNotEmpty)
        {
          streamController.sink.add(data);
        }
        fetchData();
      });
    }
    else
    {
      fetchData();
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerScrimColor: const Color(0xFF5b1aa0),
        appBar: AppBar(
          leading: Container(
            height: Get.width/11,
            width: Get.width/11,
            margin: EdgeInsets.only(right: Get.width/30),
            // color: Colors.red,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: IconButton(
                      onPressed: () async {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        List notificationsList = (await ApiHelper.apiHelper.getAllNotificationsData())!;
                        List notificationDataList = notificationsList.where((element) {
                          return (element['user_id'] == loginController.UserLoginData.value.id);
                        }).toList();
                        notificationsController.notificationsList.value = List.from(notificationDataList.reversed);
                        Get.to(const NotificationsPage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: Color(0xFF5b1aa0),
                        size: Get.width/14,
                      )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: StreamBuilder(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      // print("====================== gggggggggggg");
                      if(snapshot.hasData)
                      {
                        List notifiList = snapshot.data!;
                        List notificationsNotSeenList = notifiList.where((element) {
                          DateTime date = DateTime.parse(element['ins_date_time']);
                          return ((DateTime(date.year,date.month,date.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,)) == 0) && (element['seen'] == "false") && (element['user_id'] == loginController.UserLoginData.value.id));
                          // return ((element['seen'] == "false") && (element['school_id'] == home_controller.UserData.value.schoolId) && (element['standard_id'] == home_controller.UserData.value.standardId) && (element['hostel_id'] == home_controller.UserData.value.hostelId) && (element['cluster_id'] == home_controller.UserData.value.clusterId) && (element['user_id'] == home_controller.UserData.value.uid) && (element['central_kitchan_id'] == home_controller.UserData.value.centralKitchanId) && (element['civil_id'] == home_controller.UserData.value.civilId) && (element['dept_id'] == home_controller.UserData.value.deptId) && (element['lipik_id'] == home_controller.UserData.value.lipikId) && (element['officer_id'] == home_controller.UserData.value.officerId) && (element['apo_id'] == home_controller.UserData.value.apoId));
                        }).toList();

                        RxInt count = notificationsNotSeenList.length.obs;

                        return Obx(() => count.value == 0 ? Container() : Container(
                          margin: EdgeInsets.only(top: count.value > 10 ? Get.width/90 : Get.width/180),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          // alignment: Alignment.center,
                          padding: EdgeInsets.all(count.value > 10 ? Get.width/180 : Get.width/90),
                          child: Text(
                            "${count.value}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),);
                      }
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Colors.white,
          title: Obx(
                () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${loginController.UserLoginData.value.name} ",
                  style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
                ),
                Text(
                  "( ${loginController.designationData.value.name} )",
                  style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 10,overflow: TextOverflow.ellipsis),
                ),
                // FutureBuilder(future: DBHelper.dbHelper.readTrackingData(), builder: (context, snapshot) {
                //   if(snapshot.hasData)
                //     {
                //       return Text(
                //         "Length  :  ${snapshot.data!.length}",
                //         style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
                //       );
                //     }
                //   return const Text(
                //     "Not Length",
                //     style: TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
                //   );
                // },)
              ],
            ),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: Get.width / 35),
                child: PopupMenuButton(
                  padding: EdgeInsets.zero,

                  itemBuilder: (context) {
                    return loginController.designationData.value.id == "121" ? [
                      PopupMenuItem(
                        child: Text("profile".tr),
                        value: 1,
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("hr_staff_attendance".tr),),
                      PopupMenuItem(
                        value: 3,
                        child: Text("leave_request".tr),),
                      PopupMenuItem(
                        value: 4,
                        child: Text("change_language".tr),),
                      PopupMenuItem(
                        value: 5,
                        child: Text("change_password".tr),),
                      PopupMenuItem(
                        value: 6,
                        child: Text("logout".tr),),
                    ] : [
                      PopupMenuItem(
                        value: 1,
                        child: Text("profile".tr),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("change_password".tr),),
                      PopupMenuItem(
                        value: 3,
                        child: Text("change_language".tr),),
                      PopupMenuItem(
                        value: 4,
                        child: Text("logout".tr),),
                    ];
                  },
                  offset: Offset(0,30),
                  onSelected: (value) async {
                    if(loginController.designationData.value.id == "121")
                    {
                      if(value == 1)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        Get.to(ProfilePage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else if(value == 2)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        hrController.siteDataList.value = (await ApiHelper.apiHelper.getAllSiteData()) ?? [];
                        hrController.selectedDate.value = DateTime.now().toIso8601String();
                        hrController.allAttendanceData.value = (await ApiHelper.apiHelper.getAllStaffAttendance(dateTime: DateTime.parse(hrController.selectedDate.value))) ?? [];
                        Get.to(const HrStaffAttendancePage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else if(value == 3)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        poLeaveController.filterName.value = "Pending";
                        await ApiHelper.apiHelper.getPoAllLeaveData().then((value) {
                          poLeaveController.leaveDataList.value = value!.where((element) {
                            return element.leaveStatus!.toLowerCase() == poLeaveController.filterName.toLowerCase();
                          }).toList();
                          Get.to(const PoLeavePage(),transition: Transition.fadeIn);
                          EasyLoading.dismiss();
                        });
                      }
                      else if (value == 4)
                      {
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
                                  children: homeController.languageList
                                      .map((e) => ElevatedButton(
                                      onPressed: () async {
                                        EasyLoading.show(status: "${'please_wait'.tr}...");
                                        Locale local = Locale(e['lang'],e['con']);
                                        Get.updateLocale(local);
                                        homeController.selectedLanguage.value = e;
                                        SharedPref.sharedpref.setMapData(key: 'SelectedLanguage', mapData: homeController.selectedLanguage);
                                        Get.back();
                                        EasyLoading.dismiss();
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Text("${e['name']}",style: const TextStyle(
                                              color: Color(0xFF2C2C50),
                                            ),),
                                            Text(" (${e['lang'] == 'en' ? 'English' : e['lang'] == 'mr' ? 'मराठी' : e['lang'] == 'hi' ? 'हिंदी' : 'ગુજરાતી'})",style: const TextStyle(
                                              color: Colors.grey,
                                            ),),
                                          ],
                                        ),
                                      )))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      else if (value == 5)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        passwordController.oldPassword.value.clear();
                        passwordController.newPassword.value.clear();
                        passwordController.confNewPassword.value.clear();
                        Get.to(PassWordVerifyPage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else
                      {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("${'logout'.tr}?"),
                            content: Text("${'are_you_sure_want_to'.tr} ${'logout'.tr.toLowerCase()}?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    SharedPref.sharedpref.insertSync(check: false,key: "login");
                                    Get.offNamed('login');
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
                    }
                    else
                    {
                      if(value == 1)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        Get.to(ProfilePage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else if (value == 2)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        passwordController.oldPassword.value.clear();
                        passwordController.newPassword.value.clear();
                        passwordController.confNewPassword.value.clear();
                        Get.to(PassWordVerifyPage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else if (value == 3)
                      {
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
                                  children: homeController.languageList
                                      .map((e) => ElevatedButton(
                                      onPressed: () async {
                                        EasyLoading.show(status: "${'please_wait'.tr}...");
                                        Locale local = Locale(e['lang'],e['con']);
                                        Get.updateLocale(local);
                                        homeController.selectedLanguage.value = e;
                                        SharedPref.sharedpref.setMapData(key: 'SelectedLanguage', mapData: homeController.selectedLanguage);
                                        Get.back();
                                        EasyLoading.dismiss();
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Text("${e['name']}",style: const TextStyle(
                                              color: Color(0xFF2C2C50),
                                            ),),
                                            Text(" (${e['lang'] == 'en' ? 'English' : e['lang'] == 'mr' ? 'मराठी' : e['lang'] == 'hi' ? 'हिंदी' : 'ગુજરાતી'})",style: const TextStyle(
                                              color: Colors.grey,
                                            ),),
                                          ],
                                        ),
                                      )))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      else
                      {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("${'logout'.tr}?"),
                            content: Text("${'are_you_sure_want_to'.tr} ${'logout'.tr.toLowerCase()}?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    SharedPref.sharedpref.insertSync(check: false,key: "login");
                                    Get.offNamed('login');
                                  },
                                  child: Text("yes".tr,style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("no".tr,style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                            ],
                          );
                        },);
                      }
                    }
                  },
                  child: Icon(Icons.person,color: Color(0xFF5b1aa0)),
                )
            ),
            StreamBuilder(
              stream: _gpsStatusStream,
              builder: (context, snapshot) {
                homeController.gpsAvailable.value = false;
                if(snapshot.hasError)
                {
                  return Container();
                  return Padding(
                    padding: EdgeInsets.only(right: Get.width / 75),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.error_outlined,
                        color: Color(0xFF5b1aa0),
                      ),
                    ),
                  );
                }
                else if(snapshot.hasData)
                {
                  homeController.gpsAvailable.value = true;
                  bool? check = snapshot.data;
                  // bool check = service == null ? false : service == ServiceStatus.enabled;
                  // EasyGeofencing.startGeofenceService(
                  //     pointedLatitude: '21.1664583',
                  //     pointedLongitude: '72.8413321',
                  //     radiusMeter: '30',
                  //     eventPeriodInSeconds: 0);
                  if(check != null)
                  {
                    if(check)
                    {
                      homeController.gpsOn!.value = true;
                      EasyLoading.dismiss();
                    }
                    else
                    {
                      homeController.gpsOn!.value = false;
                      // Get.defaultDialog();
                    }
                  }
                  print("===========bbbbbbbbbbbbbb $check ${homeController.gpsOn!.value}");
                  return Container();
                  return Padding(
                    padding: EdgeInsets.only(right: Get.width / 75),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        (check != null && check) ? Icons.done_all : Icons.close,
                        color: Color(0xFF5b1aa0),
                      ),
                    ),
                  );
                }
                return Container();
                return Padding(
                  padding: EdgeInsets.only(right: Get.width / 75),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.circle_outlined,
                      color: Color(0xFF5b1aa0),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(Get.width / 30),
          child: Obx(
                () => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text:
                          "${DateFormat('hh:mm').format(DateTime.parse(homeController.nowTime.value))}",
                          style: TextStyle(
                              fontSize: 35,
                              color: Color(0xFF5b1aa0),
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                          " ${DateFormat('a').format(DateTime.parse(homeController.nowTime.value))}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5b1aa0),
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
                      Text(
                        "${DateFormat('dd - MMM - yyyy').format(DateTime.parse(homeController.nowTime.value))}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF5b1aa0),
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: Get.width/10,),
                      Container(
                        width: Get.width,
                        // height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xfff0e5ff),
                            borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: homeController.siteDropDownList.map((element) => DropdownMenuItem(value: "${element.name}",child: Text("${element.name}"),onTap: () async {
                              homeController.siteOneDropDownItem.value = element;
                              EasyLoading.show(status: "${'please_wait'.tr}...");
                              // EasyGeofencing.startGeofenceService(
                              //     pointedLatitude: '0.0',
                              //     pointedLongitude: '0.0',
                              //     radiusMeter: '${element.range}',
                              //     eventPeriodInSeconds: 2);
                              // homeController.geofenceStreamData = EasyGeofencing.getGeofenceStream();
                              List<SubSiteDataModel>? subSiteDataList = await ApiHelper.apiHelper.getAllSubSiteData(company_id: element.id!);
                              print("====================llllllllllll ${element.id} ${element.name} $subSiteDataList");
                              homeController.officeInOrOut.value = false;
                              homeController.subSiteOneDropDownItem.value = SubSiteDataModel();
                              homeController.subSiteDropDownList.value = subSiteDataList ?? [];
                              EasyLoading.dismiss();
                            },)).toList(),
                            style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                              fontWeight: FontWeight.bold,
                            ),
                            dropdownColor: const Color(0xfff0e5ff),
                            iconEnabledColor: const Color(0xFF5b1aa0),
                            onChanged: (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut != null || (loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16")) ?  (value) {} : (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null && (loginController.designationData.value.id == null ? true : loginController.designationData.value.id != "16")) ? null :  (value) {},
                            // onChanged: (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut != null) ?  (value) {} : (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null) ? null :  (value) {},
                            value: homeController.siteOneDropDownItem.value.name,
                            hint: Text("choose_site".tr,style: const TextStyle(color: Colors.grey),),

                          ),
                        ),
                      ),
                      SizedBox(height: Get.width/30,),
                      Container(
                        width: Get.width,
                        // height: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xfff0e5ff),
                            borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: homeController.subSiteDropDownList.map((element) => DropdownMenuItem(value: "${element.name}",child: Text("${element.name}"),onTap: () async {
                              EasyLoading.show(status: "${'please_wait'.tr}...");
                              homeController.subSiteOneDropDownItem.value = element;
                              EasyGeofencing.startGeofenceService(
                                  pointedLatitude: '${element.lat}',
                                  pointedLongitude: '${element.longs}',
                                  radiusMeter: '${element.ranges}',
                                  eventPeriodInSeconds: 2);
                              await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((position) {
                                double distance = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(element.lat!), double.parse(element.longs!));
                                homeController.officeInOrOut.value = (distance <= double.parse(element.ranges!));
                                print("========== distanceeeeeeeeeeeee $distance");
                              });
                              // if(!oneTimeClick.value)
                              //   {
                              //     oneTimeClick.value = true;
                              //     homeController.geofenceStreamData = EasyGeofencing.getGeofenceStream();
                              //     // GeofenceStatus geoFence = await homeController.geofenceStreamData!.first;
                              //     homeController.geofenceStreamData!.listen((event) {
                              //       homeController.officeInOrOut.value = event == GeofenceStatus.enter;
                              //       print("=listennnnnnnnnnnnnnnnnnnnnnnn $event");
                              //     });
                              //   }
                              print("==========================~~~~~~~~~~~~ ${homeController.geofenceStreamData}");
                              EasyLoading.dismiss();
                            },)).toList(),
                            style: const TextStyle(
                              color: Color(0xFF5b1aa0),
                              fontWeight: FontWeight.bold,
                            ),
                            dropdownColor: const Color(0xfff0e5ff),
                            iconEnabledColor: const Color(0xFF5b1aa0),
                            onChanged: (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut != null || (loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16")) ?  (value) {} : (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null && (loginController.designationData.value.id == null ? true : loginController.designationData.value.id != "16")) ? null :  (value) {},
                            // onChanged: (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut != null) ?  (value) {} : (homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut == null) ? null :  (value) {},
                            value: homeController.subSiteOneDropDownItem.value.name,
                            hint: Text("choose_sub_site".tr,style: const TextStyle(color: Colors.grey),),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ((loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16") && !homeController.officeInOrOut.value)  ? Get.width/30 : Get.width/8,),
                  Column(
                    children: [
                      (homeController.weAttendanceOneData.value.clockIn == null || homeController.weAttendanceOneData.value.clockOut != null) ? Container() : ((loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16") && !homeController.officeInOrOut.value) ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(value: punchOutAnywhere.value, onChanged: (value) => punchOutAnywhere.value = value ?? false,),
                          InkWell(
                            onTap: () {
                              punchOutAnywhere.value = !punchOutAnywhere.value;
                            },
                            child: Text("${'punch_out_anywhere'.tr}?",),
                          )
                        ],
                      ) : Container(),
                      InkWell(
                        onTap: () async {
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.none)
                          {
                            if(homeController.siteOneDropDownItem.value.name == null || homeController.siteOneDropDownItem.value.name != null ? homeController.siteOneDropDownItem.value.name!.isEmpty : true)
                            {
                              EasyLoading.showError("${'please'.tr} ${'choose_site'.tr}.");
                            }
                            else if(homeController.siteOneDropDownItem.value.name == null || homeController.subSiteOneDropDownItem.value.name != null ? homeController.subSiteOneDropDownItem.value.name!.isEmpty : true)
                            {
                              EasyLoading.showError("${'please'.tr} ${'choose_sub_site'.tr}.");
                            }
                            else if(circulerOnOff.value == 1)
                            {
                              EasyLoading.showError("${'please_wait'.tr}...");
                            }
                            else
                            {
                              print("================~~~~~~~~~~~== ${homeController.officeInOrOut.value} ${loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16"} llllll ${(homeController.officeInOrOut.value || (loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16"))}");
                              if(homeController.officeInOrOut.value || ((homeController.weAttendanceOneData.value.clockIn == null || homeController.weAttendanceOneData.value.clockOut != null) ? false : punchOutAnywhere.value ? loginController.designationData.value.id == null ? false : loginController.designationData.value.id == "16" : false))
                              {
                                // ignore: use_build_context_synchronously
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      // content: Container(
                                      //   width: Get.width,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(9),
                                      //     color: Colors.black,
                                      //   ),
                                      //   child: C,
                                      // ),
                                      // title: Text("Are you sure want to Punch ${(homeController.weAttendanceOneData.value.punchOut == null || homeController.weAttendanceOneData.value.punchOut!) ? "In" : "Out"} ?",style: const TextStyle(fontSize: 14,),),
                                      title: Text("${'are_you_sure_want_to'.tr} ${'punch'.tr} ${(homeController.weAttendanceOneData.value.clockIn == null || homeController.weAttendanceOneData.value.clockOut != null) ? "in".tr : "out".tr} ?",style: const TextStyle(fontSize: 14,),),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(9),
                                              )
                                          ),
                                          child: Text("no".tr,style: const TextStyle(color: Colors.white),),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Get.back();
                                            circulerOnOff.value = 1;
                                            // DateTime dateTime = await NTP.now();
                                            DateTime dateTime = DateTime.now();
                                            await Geolocator.requestPermission();
                                            await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((position) async {
                                              await placemarkFromCoordinates(position.latitude, position.longitude).then((place) async {
                                                // if(homeController.weAttendanceOneData.value.punchIn! && homeController.weAttendanceOneData.value.punchOut!)
                                                if(homeController.weAttendanceOneData.value.clockIn != null && homeController.weAttendanceOneData.value.clockOut != null)
                                                {
                                                  // if(!(const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute))).isNegative)
                                                  if(!(const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute))).isNegative)
                                                  {
                                                    showDialog(
                                                      context: homeController.navigatorKey.currentContext!,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          // content: Container(
                                                          //   width: Get.width,
                                                          //   decoration: BoxDecoration(
                                                          //     borderRadius: BorderRadius.circular(9),
                                                          //     color: Colors.black,
                                                          //   ),
                                                          //   child: C,
                                                          // ),
                                                          title: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(Icons.info,size: Get.width/6,color: Colors.black,),
                                                              SizedBox(height: Get.width/60,),
                                                              // Text("Attendance Already Done\nNext Punch In\n${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).add((const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)))))} Or After\n${DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).add((const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)))).difference(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute)).inHours}:${DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).add((const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)))).difference(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute)).inMinutes.remainder(60)} Hrs Left",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,),),
                                                              Text("${'attendance'.tr} ${'already _done'.tr}\n${'next'.tr} ${'punch'.tr} ${'in'.tr}\n${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).add((const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)))))} ${'or'.tr} ${'after'.tr}\n${DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).add((const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)))).difference(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute)).inHours}:${DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).add((const Duration(hours: 12,minutes: 0) - DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)))).difference(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute)).inMinutes.remainder(60)} ${'hrs_left'.tr}",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,),),
                                                            ],
                                                          ),
                                                          actions: [
                                                            Center(
                                                              child: ElevatedButton(
                                                                onPressed: (){
                                                                  Get.back();
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.green,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(9),
                                                                    )
                                                                ),
                                                                child: Text("ok".tr,style: const TextStyle(color: Colors.white),),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                    // EasyLoading.showError("Attendance Already Done\nPlease Try On Next Day");
                                                  }
                                                  else
                                                  {
                                                    // if(homeController.officeInOrOut.value)
                                                    // {
                                                    //
                                                    //   await DBHelper.dbHelper.insertPunchInOutData(weAttendanceDataModel: PunchInOutDataModel(
                                                    //     inDateTime: dateTime,
                                                    //     outDateTime: dateTime,
                                                    //     punchIn: true,
                                                    //     punchOut: false,
                                                    //     lag: "${position.longitude}",
                                                    //     lat: "${position.latitude}",
                                                    //   )).then((value) async {
                                                    //     await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(inDateTime: DateTime.now(),lag: position.longitude.toString(),lat: position.latitude.toString()));
                                                    //     homeController.readWeAttendanceOneData();
                                                    //     circulerOnOff.value = 0;
                                                    //     Timer(const Duration(milliseconds: 300), () {
                                                    //       EasyLoading.showSuccess('Punch In Successfully');
                                                    //     });
                                                    //   });
                                                    // }
                                                    // else
                                                    // {
                                                    //   circulerOnOff.value = 0;
                                                    //   EasyLoading.showError("Sorry You Are Not In Office\nPlease Go Your Office");
                                                    // }
                                                  }
                                                }
                                                else
                                                {
                                                  SharedPref.sharedpref.setUserSubSiteData(subSiteDataModel: homeController.subSiteOneDropDownItem.value);
                                                  // if(homeController.weAttendanceOneData.value.punchIn!)
                                                  if(homeController.weAttendanceOneData.value.clockIn == null)
                                                  {

                                                    if(homeController.officeInOrOut.value)
                                                    {
                                                      await SharedPref.sharedpref.insertSync(check: true,key: 'punchIn');
                                                      bool? punchIn = await SharedPref.sharedpref.readSync(key: 'punchIn');
                                                      print("=================== 66666663000000000000pppppppppppiiiiiiiiiiiiii $punchIn");
                                                      await loginController.initializeService();
                                                      await ApiHelper.apiHelper.attendancePunchInData(punchInOutDataModel: PunchInOutDataModel(
                                                        // inDateTime: dateTime,
                                                        // outDateTime: dateTime,
                                                        // punchIn: true,
                                                        // punchOut: false,
                                                        // lag: "${position.longitude}",
                                                        // lat: "${position.latitude}",
                                                        staffId: loginController.staffLoginData.value.staffId,
                                                        staffJoiningId: loginController.staffLoginData.value.id,
                                                        departmentId: loginController.staffLoginData.value.departmentId,
                                                        subCompanyId: homeController.subSiteOneDropDownItem.value.id,
                                                        type: "day",
                                                        remark: "",
                                                        clockIn: dateTime,
                                                        clockInLat: "${position.longitude}",
                                                        clockInLong: "${position.latitude}",
                                                        clockInAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
                                                        createdAt: dateTime,
                                                      )).then((value) async {
                                                        print('snedSTarttttttttttttt11111111111111');
                                                        List notificationAllTokenList = await ApiHelper.apiHelper.getAllNotificationsTokenData() ?? [];
                                                        print("===============snedSTarttttttttttttt2222222222222");
                                                        StaffDataModel? hrData = await ApiHelper.apiHelper.getUserDesignationWise(designation_id: '121');
                                                        List oneNotificationTokenData = notificationAllTokenList.where((element) => element['user_id'] == hrData!.staffId!).toList();
                                                        await ApiHelper.apiHelper.insertNotificationData(title: "Hello HR....", description: "${loginController.UserLoginData.value.name}\nMy Today Punch In\nTime  :  ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}\nFrom  :  ${homeController.siteOneDropDownItem.value.name} --> ${homeController.subSiteOneDropDownItem.value.name}...", ins_date_time: DateTime.now(), user_id: hrData!.staffId!, seen: "false");
                                                        print("snedSTarttttttttttttt33333333333 ${oneNotificationTokenData}");
                                                        if(oneNotificationTokenData.isNotEmpty)
                                                        {
                                                          await ApiHelper.apiHelper.sendNotifications(title: "Hello HR....", body: "${loginController.UserLoginData.value.name}\nMy Today Punch In\nTime  :  ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}\nFrom  :  ${homeController.siteOneDropDownItem.value.name} --> ${homeController.subSiteOneDropDownItem.value.name}...", notification_token: oneNotificationTokenData.first['notification_token']);
                                                        }
                                                        await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString()));
                                                        await loginController.initializeService();
                                                        homeController.readWeAttendanceOneOnlineData();
                                                        Timer(const Duration(milliseconds: 300), () {
                                                          circulerOnOff.value = 0;
                                                          EasyLoading.showSuccess('${'punch'.tr} ${'in'.tr} ${'successfully'.tr}');
                                                        });
                                                        // await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(inDateTime: DateTime.now(),lag: position.longitude.toString(),lat: position.latitude.toString()));
                                                        // tracking();
                                                        // homeController.readWeAttendanceOneData();
                                                        // circulerOnOff.value = 0;
                                                        // Timer(const Duration(milliseconds: 300), () {
                                                        //   EasyLoading.showSuccess('Punch In Successfully');
                                                        // });
                                                      });
                                                      // await DBHelper.dbHelper.insertPunchInOutData(weAttendanceDataModel: PunchInOutDataModel(
                                                      //   // inDateTime: dateTime,
                                                      //   // outDateTime: dateTime,
                                                      //   // punchIn: true,
                                                      //   // punchOut: false,
                                                      //   // lag: "${position.longitude}",
                                                      //   // lat: "${position.latitude}",
                                                      //   staffId: loginController.staffLoginData.value.staffId,
                                                      //   staffJoiningId: loginController.staffLoginData.value.id,
                                                      //   departmentId: loginController.staffLoginData.value.departmentId,
                                                      //   subCompanyId: homeController.subSiteOneDropDownItem.value.id,
                                                      //   type: "day",
                                                      //   remark: "",
                                                      //   clockIn: dateTime,
                                                      //   clockInLat: "${position.longitude}",
                                                      //   clockInLong: "${position.latitude}",
                                                      //   clockInAddress: "",
                                                      //   createdAt: dateTime,
                                                      // )).then((value) async {
                                                      //   await DBHelper.dbHelper.insertTrackingData(trackingModel: TrackingModel(inDateTime: DateTime.now(),lag: position.longitude.toString(),lat: position.latitude.toString()));
                                                      //   homeController.readWeAttendanceOneData();
                                                      //   circulerOnOff.value = 0;
                                                      //   Timer(const Duration(milliseconds: 300), () {
                                                      //     EasyLoading.showSuccess('Punch In Successfully');
                                                      //   });
                                                      // });
                                                    }
                                                    else
                                                    {
                                                      circulerOnOff.value = 0;
                                                      EasyLoading.showError("${'sorry'.tr} ${'you_are_not_in_site'.tr}\n${'please_go_to_your_site'.tr}");
                                                    }
                                                  }
                                                  else
                                                  {
                                                    Duration diff = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute));
                                                    double salaryPerMinute = double.parse(loginController.staffLoginData.value.salaryAmount!) / 720;
                                                    int min = diff.inMinutes.remainder(60);
                                                    print("=hoursssssssssssssssssssss ${diff.inMinutes.remainder(60)}");
                                                    await ApiHelper.apiHelper.attendancePunchOutData(punchInOutDataModel: PunchInOutDataModel(
                                                      // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                                                      // outDateTime: dateTime,
                                                      // punchIn: true,
                                                      // punchOut: true,
                                                      // lag: "${position.longitude}",
                                                      // lat: "${position.latitude}",
                                                      id: homeController.weAttendanceOneData.value.id,
                                                      staffId: loginController.staffLoginData.value.staffId,
                                                      hours: "${diff.inHours}.${min >= 10 ? min : "0$min"}",
                                                      salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                                                      clockOut: dateTime,
                                                      clockOutType: "Manual",
                                                      clockOutLat: "${position.longitude}",
                                                      clockOutLong: "${position.latitude}",
                                                      clockOutAddress: (place.isNotEmpty && place.length >= 2) ? "${place[2].name},${place[0].street},${place[1].subLocality},${place[2].locality},${place[2].postalCode}" : "",
                                                      updatedAt: dateTime,
                                                    )).then((value) async {
                                                      await ApiHelper.apiHelper.insertTrackingData(trackingModel: TrackingModel(staffId: loginController.UserLoginData.value.id!,gpsActive: "On",createdAt: DateTime.now(),updatedAt: DateTime.now(),long: position.longitude.toString(),lat: position.latitude.toString()));
                                                      await loginController.initializeService();
                                                      circulerOnOff.value = 0;
                                                      homeController.readWeAttendanceOneOnlineData();
                                                      Timer(const Duration(milliseconds: 300), () {
                                                        EasyLoading.showSuccess('${'punch'.tr} ${'out'.tr} ${'successfully'.tr}');
                                                      });
                                                    });
                                                    // await DBHelper.dbHelper.updatePunchInOutOneData(weAttendanceDataModel: PunchInOutDataModel(
                                                    //     // inDateTime: homeController.weAttendanceOneData.value.inDateTime,
                                                    //     // outDateTime: dateTime,
                                                    //     // punchIn: true,
                                                    //     // punchOut: true,
                                                    //     // lag: "${position.longitude}",
                                                    //     // lat: "${position.latitude}",
                                                    //     id: homeController.weAttendanceOneData.value.id,
                                                    //   staffId: loginController.staffLoginData.value.staffId,
                                                    //   hours: "${diff.inHours}.${((diff.inMinutes.remainder(60) * 100) / 60).round()}",
                                                    //   salaryAmount: "${salaryPerMinute * diff.inMinutes}",
                                                    //   clockOut: dateTime,
                                                    //   clockOutLat: "${position.longitude}",
                                                    //   clockOutLong: "${position.latitude}",
                                                    //   clockOutAddress: "",
                                                    //   updatedAt: dateTime,
                                                    // )).then((value) async {
                                                    //   circulerOnOff.value = 0;
                                                    //   homeController.readWeAttendanceOneData();
                                                    //   Timer(const Duration(milliseconds: 300), () {
                                                    //     EasyLoading.showSuccess('Punch Out Successfully');
                                                    //   });
                                                    // });
                                                  }
                                                }
                                              });
                                            });
                                            circulerOnOff.value = 0;
                                            // Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(9),
                                              )
                                          ),
                                          child: Text("yes".tr,style: const TextStyle(color: Colors.white),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              else
                              {
                                // circulerOnOff.value = 0;
                                EasyLoading.showError("${'sorry'.tr} ${'you_are_not_in_site'.tr}\n${'please_go_to_your_site'.tr}");
                              }
                            }
                          }
                          else
                          {
                            EasyLoading.showError('please_check_internet'.tr);
                          }
                        },
                        splashColor: const Color(0xd25b1aa0),
                        borderRadius: BorderRadius.circular(1000),
                        child: Container(
                          padding: EdgeInsets.all(Get.width/80),
                          child: Container(
                            height: Get.width / 2.5,
                            width: Get.width / 2.5,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                  colors: [
                                    const Color(0xFF5b1aa0),
                                    const Color(0xFF5b1ab2),
                                    Colors.blue.shade50
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                      color:  Color(0x475b1aa0),
                                      offset: Offset(5, 15),
                                      blurRadius: 30
                                  )
                                ]
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                circulerOnOff.value == 0 ? Icon(
                                  Icons.ads_click,
                                  color: Colors.white,
                                  size: Get.width / 8,
                                ) : const CircularProgressIndicator(color: Colors.white,),
                                circulerOnOff.value == 1 ? SizedBox(height: Get.width/60,) : const SizedBox(),
                                Text(
                                  // "Punch ${(homeController.weAttendanceOneData.value.punchOut == null || homeController.weAttendanceOneData.value.punchOut!) ? "In" : "Out"}",
                                  "${'punch'.tr} ${(homeController.weAttendanceOneData.value.clockIn == null || homeController.weAttendanceOneData.value.clockOut != null) ? "in".tr : "out".tr}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      Text(
                        (homeController.officeInOrOut.value) ? "you_are_in_site".tr : "you_are_not_in_site".tr,
                        style: TextStyle(color: (homeController.officeInOrOut.value) ? Colors.green : Colors.red, fontSize: 18),
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),

                      // StreamBuilder<GeofenceStatus>(
                      //   stream: EasyGeofencing.getGeofenceStream(),
                      //   builder: (context, snapshot) {
                      //       if(snapshot.hasData)
                      //       {
                      //         GeofenceStatus geofenceStatus = snapshot.data!;
                      //         homeController.officeInOrOut.value = geofenceStatus == GeofenceStatus.enter;
                      //         homeController.officeIn = geofenceStatus == GeofenceStatus.enter;
                      //         print("==========ccccccccckkkkkkkkkkkkkkkk ${homeController.officeInOrOut.value} ${homeController.gpsOn} ${(geofenceStatus == GeofenceStatus.enter && homeController.gpsOn == null ? geofenceStatus == GeofenceStatus.enter : homeController.gpsOn!.value)}");
                      //         return Text(
                      //           "You are ${(geofenceStatus == GeofenceStatus.enter && (!homeController.gpsAvailable.value ? geofenceStatus == GeofenceStatus.enter : homeController.gpsOn.value)) ? "" : "not "}in Site",
                      //           style: TextStyle(color: (geofenceStatus == GeofenceStatus.enter && (!homeController.gpsAvailable.value ? geofenceStatus == GeofenceStatus.enter : homeController.gpsOn.value)) ? Colors.green : Colors.red, fontSize: 18),
                      //         );
                      //       }
                      //       return Text(
                      //         "${snapshot.error}",
                      //         style: TextStyle(color: Colors.red, fontSize: 18),
                      //       );
                      //     },
                      // )
                    ],
                  ),
                  SizedBox(height: Get.width/15),
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
                                homeController.weAttendanceOneData.value.clockIn == null ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.clockIn!),
                                style: const TextStyle(
                                  fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                              ),
                              Text(
                                "${'in'.tr.toUpperCase()} ${'time'.tr}",
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
                                (homeController.weAttendanceOneData.value.clockOut == null) ? "-" : DateFormat('hh:mm a').format(homeController.weAttendanceOneData.value.clockOut!),
                                style: const TextStyle(
                                  fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                              ),
                              Text(
                                "${'out'.tr} ${'time'.tr}",
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
                                // homeController.weAttendanceOneData.value.punchIn == false && (homeController.weAttendanceOneData.value.punchOut == null || homeController.weAttendanceOneData.value.punchOut == false) ? "-" : homeController.weAttendanceOneData.value.punchOut! ? "${DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours <= 0 ? "${DateFormat('mm').format(DateTime(0,0,0,0,DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes % 60))} Min." : "${DateFormat('hh').format(DateTime(0,0,0,DateTime(homeController.weAttendanceOneData.value.outDateTime!.year,homeController.weAttendanceOneData.value.outDateTime!.month,homeController.weAttendanceOneData.value.outDateTime!.day,homeController.weAttendanceOneData.value.outDateTime!.hour,homeController.weAttendanceOneData.value.outDateTime!.minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours))} Hrs."}" : "${DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours <= 0 ? "${DateFormat('mm').format(DateTime(0,0,0,0,DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inMinutes % 60))} Min." : "${DateFormat('hh').format(DateTime(0,0,0,DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.inDateTime!.year,homeController.weAttendanceOneData.value.inDateTime!.month,homeController.weAttendanceOneData.value.inDateTime!.day,homeController.weAttendanceOneData.value.inDateTime!.hour,homeController.weAttendanceOneData.value.inDateTime!.minute)).inHours))} Hrs."}",
                                (homeController.weAttendanceOneData.value.clockIn == null && homeController.weAttendanceOneData.value.clockOut == null) ? "-" : homeController.weAttendanceOneData.value.clockOut != null ? DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours <= 0 ? "${DateFormat('mm').format(DateTime(0,0,0,0,DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inMinutes % 60))} Min." : "${DateFormat('hh').format(DateTime(0,0,0,DateTime(homeController.weAttendanceOneData.value.clockOut!.year,homeController.weAttendanceOneData.value.clockOut!.month,homeController.weAttendanceOneData.value.clockOut!.day,homeController.weAttendanceOneData.value.clockOut!.hour,homeController.weAttendanceOneData.value.clockOut!.minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours))} Hrs." : DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours <= 0 ? "${DateFormat('mm').format(DateTime(0,0,0,0,DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inMinutes % 60))} Min." : "${DateFormat('hh').format(DateTime(0,0,0,DateTime(DateTime.parse(homeController.nowTime.value).year,DateTime.parse(homeController.nowTime.value).month,DateTime.parse(homeController.nowTime.value).day,DateTime.parse(homeController.nowTime.value).hour,DateTime.parse(homeController.nowTime.value).minute).difference(DateTime(homeController.weAttendanceOneData.value.clockIn!.year,homeController.weAttendanceOneData.value.clockIn!.month,homeController.weAttendanceOneData.value.clockIn!.day,homeController.weAttendanceOneData.value.clockIn!.hour,homeController.weAttendanceOneData.value.clockIn!.minute)).inHours))} Hrs.",
                                style: const TextStyle(
                                  fontSize: 16, color: Color(0xFF5b1aa0),fontWeight: FontWeight.bold,),
                              ),
                              Text(
                                "${'working_hrs'.tr}.",
                                style: const TextStyle(
                                  fontSize: 13, color: Colors.grey,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: IntrinsicHeight(
          child: Obx(
                () => Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: homeController.onlineOffline.value ? 0.0 : Get.width/9,
                  color: Colors.red,
                  curve: Curves.easeInOut,
                  width: Get.width,
                  alignment: Alignment.center,
                  child: Text(
                    "no_internet_connection".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                BottomNavigationBar(
                  onTap: (index) async{
                    if(loginController.designationData.value.id == "121")
                    {
                      if(index == 1)
                      {
                        hrTrackController.hrTrackOrNot.value = false;
                        Get.to(const MapsPage(),transition: Transition.rightToLeft);
                      }
                      else if(index == 2)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        reportController.totalPresent.value = 0;
                        reportController.totalAbsent.value = 0;
                        reportController.reportsList.value = [];
                        reportController.totalPresent.value = await ApiHelper.apiHelper.getPresent(staff_id: loginController.UserLoginData.value.id!, dateTime: DateTime.now());
                        List<PunchInOutDataModel> reportsList = await ApiHelper.apiHelper.getReport(staff_id: loginController.UserLoginData.value.id!, dateTime: DateTime.now()) ?? [];
                        reportController.reportsList.value = List.from(reportsList.reversed);
                        reportController.totalAbsent.value = ConstHelper.constHelper.getDaysInMonth(DateTime.now().year, DateTime.now().month) - reportController.totalPresent.value;
                        Get.to(const ReportPage(),transition: Transition.rightToLeft);
                        EasyLoading.dismiss();
                      }
                      else if(index == 3)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        homeController.leaveReasonTypeFilterList.value = [LeaveTypeDataModel(leaveTypeName: "All")];
                        homeController.leaveTypeFilterOneData.value = LeaveTypeDataModel(leaveTypeName: "All");
                        List<LeaveTypeDataModel>? leaveTypeList = await ApiHelper.apiHelper.getAllLeaveReason();
                        homeController.leaveReasonTypeFilterList.value.addAll(leaveTypeList!);
                        homeController.leaveData.value = (await ApiHelper.apiHelper.getAllLeaveData())!;
                        print("gggggggggggggg${homeController.leaveData.length}");
                        Get.to(LeavePage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else if(index == 4)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        hrTrackController.hrTrackOrNot.value = true;
                        hrTrackController.selectedDate.value = DateTime.now().toIso8601String();
                        hrTrackController.siteList.value = [SiteDataModel(name: "All")];
                        hrTrackController.selectedSiteData.value = SiteDataModel(name: "All");
                        await ApiHelper.apiHelper.getAllSiteData().then((value) {
                          if(value != null)
                          {
                            hrTrackController.siteList.addAll(value);
                          }
                        });
                        await ApiHelper.apiHelper.getHRAttendanceData(date: DateTime.parse(hrTrackController.selectedDate.value)).then((value) {
                          hrTrackController.hrAttendanceDataList.value = value == null ? [] : List.from(value.reversed);
                          Get.to(const HRTrackPage(),transition: Transition.fadeIn);
                          EasyLoading.dismiss();
                        });
                      }
                      else if(index == 5)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        loginController.problemData.value = (await ApiHelper.apiHelper.getProblem(user_id: loginController.UserLoginData.value.id!))!;
                        Get.to(ProblemPage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                    }
                    else
                    {
                      if(index == 1)
                      {
                        hrTrackController.hrTrackOrNot.value = false;
                        Get.to(const MapsPage(),transition: Transition.rightToLeft);
                      }
                      else if(index == 2)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        reportController.totalPresent.value = 0;
                        reportController.totalAbsent.value = 0;
                        reportController.reportsList.value = [];
                        reportController.totalPresent.value = await ApiHelper.apiHelper.getPresent(staff_id: loginController.UserLoginData.value.id!, dateTime: DateTime.now());
                        List<PunchInOutDataModel> reportsList = await ApiHelper.apiHelper.getReport(staff_id: loginController.UserLoginData.value.id!, dateTime: DateTime.now()) ?? [];
                        reportController.reportsList.value = List.from(reportsList.reversed);                        reportController.totalAbsent.value = ConstHelper.constHelper.getDaysInMonth(DateTime.now().year, DateTime.now().month) - reportController.totalPresent.value;
                        Get.to(const ReportPage(),transition: Transition.rightToLeft);
                        EasyLoading.dismiss();
                      }
                      else if(index == 3)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        homeController.leaveReasonTypeFilterList.value = [LeaveTypeDataModel(leaveTypeName: "All")];
                        homeController.leaveTypeFilterOneData.value = LeaveTypeDataModel(leaveTypeName: "All");
                        List<LeaveTypeDataModel>? leaveTypeList = await ApiHelper.apiHelper.getAllLeaveReason();
                        homeController.leaveReasonTypeFilterList.value.addAll(leaveTypeList!);
                        homeController.leaveData.value = (await ApiHelper.apiHelper.getAllLeaveData())!;
                        print("gggggggggggggg${homeController.leaveData.length}");
                        Get.to(LeavePage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                      else if(index == 4)
                      {
                        EasyLoading.show(status: "${'please_wait'.tr}...");
                        loginController.problemData.value = (await ApiHelper.apiHelper.getProblem(user_id: loginController.UserLoginData.value.id!))!;
                        Get.to(ProblemPage(),transition: Transition.fadeIn);
                        EasyLoading.dismiss();
                      }
                    }
                  },
                  items: loginController.designationData.value.id == "121" ? [
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.home_filled), label: "home".tr),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.fmd_good_outlined), label: "map".tr,),
                    BottomNavigationBarItem(icon: Icon(Icons.reorder), label: "report".tr),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.edit_road), label: "leave".tr),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.location_searching), label: "track".tr),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.camera_alt), label: "problems".tr),
                  ] : [
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.home_filled), label: "home".tr),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.fmd_good_outlined), label: "map".tr,),
                    BottomNavigationBarItem(icon: const Icon(Icons.reorder), label: "report".tr),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.edit_road), label: "leave".tr),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.camera_alt), label: "problems".tr),
                  ],
                  type: BottomNavigationBarType.fixed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
