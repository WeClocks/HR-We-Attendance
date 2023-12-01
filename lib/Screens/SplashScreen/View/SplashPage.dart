import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ConstHelper.dart';
import 'package:hr_we_attendance/Utils/DBHelper.dart';
import 'package:hr_we_attendance/Utils/LocationPermissionPage.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';
import 'package:hr_we_attendance/main.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> with SingleTickerProviderStateMixin{
  late Tween<double> _tweenSize;
  late Animation<double> _animationSize;
  late AnimationController _animationController;
  RxDouble size = 0.0.obs;
  LoginController loginController = Get.put(LoginController());
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    // getAllData();
    readSelectedLanguage();
    readSiteData();
    loginController.login();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _tweenSize = Tween(begin: 0, end: 150);
    _animationSize = _tweenSize.animate(_animationController);
    animationSize();
    _animationController.forward();
    loginController.getUserData();
    loginController.splash();
    homeController.checkConnectivity();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  Future<void> readSelectedLanguage()
  async {
    dynamic selectedLanguage = await SharedPref.sharedpref.readMapData(key: 'SelectedLanguage');
    print("===================selectedLanguageselectedLanguage $selectedLanguage");
    if(selectedLanguage == null)
    {
      SharedPref.sharedpref.setMapData(key: 'SelectedLanguage', mapData: {'name': 'English','lang': 'en', 'con': 'US'});
      homeController.selectedLanguage.value = {'name': 'English','lang': 'en', 'con': 'US'};
    }
    else
    {
      homeController.selectedLanguage.value = selectedLanguage;
    }
    Locale locale = Locale(homeController.selectedLanguage['lang'],homeController.selectedLanguage['con']);
    Get.updateLocale(locale);
  }

  Future<void> readSiteData()
  async {
    List<SiteDataModel>? siteDataList = await ApiHelper.apiHelper.getAllSiteData();
    homeController.siteDropDownList.value = siteDataList ?? [];
    print("================= ssssssssssssssssss ${homeController.siteDropDownList.length} ${siteDataList ?? 0}");
  }

  void animationSize()
  {
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      if(size.value != 150)
      {
        size.value++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
                children:[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Obx(
                          () => SizedBox(
                        height: size.value,
                        width: size.value,
                        // color: Colors.white,
                        child: Image.asset("assets/image/wc1.png",fit: BoxFit.cover,),
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}
