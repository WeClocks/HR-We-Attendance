import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Utils/ConstHelper.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';
import 'package:hr_we_attendance/main.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    // getAllData();
    notificationPermission();
    super.initState();
  }

  Future<void> getAllData()
  async {
    ConstHelper.constHelper.initializeNotification();
    // PermissionStatus permission = await Permission.location.request();
    // DateTime dateTime = await NTP.now();
    // await dotenv.load(fileName: "assets/config/.env");
    DateTime dateTime = DateTime.now();
    homeController.weAttendanceOneData.value = PunchInOutDataModel(
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
    homeController.nowTime.value = dateTime.toIso8601String();
    await homeController.readWeAttendanceOneOnlineData().then((value) async {
      await initializeService();
    });
    // EasyGeofencing.startGeofenceService(
    //     pointedLatitude: '21.1664583',
    //     pointedLongitude: '72.8413321',
    //     radiusMeter: '30',
    //     eventPeriodInSeconds: 2);
    print("========== 111 ${homeController.nowTime.value}  222 $dateTime");
  }


  Future<void> initializeService()
  async {
    final flutterBackgroundService = FlutterBackgroundService();
    await flutterBackgroundService.configure(
      iosConfiguration: IosConfiguration(
        onBackground: iosOnBackground,
        onForeground: onStart,
        autoStart: true,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        // notificationChannelId: "1",
        // initialNotificationTitle: "Time : ${DateTime.now()}",
        // initialNotificationContent: "Content : ${DateTime.now()}",
        // foregroundServiceNotificationId: 90
      ),
    );
    flutterBackgroundService.startService();
  }

  Future<void> notificationPermission()
  async {
    print("=notttttttttttttt");
    await Permission.notification.request();
    ConstHelper.constHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(Get.width/20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.location_on_outlined,color: const Color(0xFF5b1aa0),size: Get.width/10,),
                    SizedBox(height: Get.width/60,),
                    const Text(
                      "Use your Location",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: Get.width/10,),
                const Text(
                  "To see maps for automatically tracked activities, allow We Attendance to use your location all of the time.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                    fontSize: 16
                  ),
                ),
                // SizedBox(height: Get.width/10,),
                const Text(
                  "We Attendance collects location data to show walk and bike rides on a map even when the app is closed or not in use.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                    fontSize: 16
                  ),
                ),
                // SizedBox(height: Get.width/20,),
                SizedBox(
                  height: Get.width/1.6,
                  // width: Get.width/1.6,
                  child: Image.asset("assets/image/locationPermissionImage.jpg",fit: BoxFit.cover,),
                ),
                // SizedBox(height: Get.width/20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: (){
                        SharedPref.sharedpref.insertSync(check: true,key: 'locationPermission');
                        Get.offNamed('login');
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                      ),
                      child: const Text("DENY"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Permission.location.request().then((value) async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Enable Battery Restrictions",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                content: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "1. Click Open Settings Button",
                                      style: TextStyle(color: Colors.black,fontSize: 12,),
                                    ),
                                    Text(
                                      "2. Click Battery Server(Power Saver)",
                                      style: TextStyle(color: Colors.black,fontSize: 12,),
                                    ),
                                    Text(
                                      "3. Select No-Restrictions(Unrestrictions) Option",
                                      style: TextStyle(color: Colors.black,fontSize: 12,),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await AppSettings.openAppSettings().then((value) => Get.back());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3)
                                      )
                                    ),
                                    child: const Text("Open Settings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3)
                                      )
                                    ),
                                    child: const Text("Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                  ),
                                ],
                              );
                            },).then((value) {
                            SharedPref.sharedpref.insertSync(check: true,key: 'locationPermission');
                            Get.offNamed('login');
                          });

                        });
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                      ),
                      child: const Text("ACCEPT"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
