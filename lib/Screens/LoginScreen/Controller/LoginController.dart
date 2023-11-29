import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/DesignationsModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/ProblemModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/ConstHelper.dart';
import 'package:hr_we_attendance/Utils/LocationPermissionPage.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';
import 'package:hr_we_attendance/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class LoginController extends GetxController
{
  RxBool hidePass = true.obs;
  Rx<UserLoginModel> UserLoginData = UserLoginModel().obs;
  Rx<StaffDataModel> staffLoginData = StaffDataModel().obs;
  Rx<DesignationsModel> designationData = DesignationsModel().obs;
  RxString imagepath = "".obs;
  RxString imagepath2 = "".obs;
  RxList<ProblemModel> problemData = <ProblemModel>[].obs;
  Rx<TextEditingController> txtRemark = TextEditingController().obs;
  Future<void> splash()
  async {
    bool? locationPermission = await SharedPref.sharedpref.readSync(key: 'locationPermission');
    bool? login = await SharedPref.sharedpref.readSync(key: 'login');
    print("================c$login");
    getAllData();
    if(locationPermission != null && locationPermission)
      {
        if (login != null && login) {
          homeController.readUserSiteAndSubSiteData();
          Timer(Duration(seconds: 3), () {
            Get.offNamed('/');
          });
        } else {
          Timer(Duration(seconds: 3), () {
            Get.offNamed('login');
          });
        }
      }
    else
      {
        Timer(const Duration(seconds: 3), () {
          Get.to(const LocationPermissionPage());
        });
      }
  }

  HomeController homeController = Get.put(HomeController());
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
      bool? punchIn = await SharedPref.sharedpref.readSync(key: 'punchIn');
      print("============== 8777777777777 PINNNNNNNNNNNNNN $punchIn");
      if(punchIn != null && punchIn)
        {
          await initializeService();
        }
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
    bool? punchIn = await SharedPref.sharedpref.readSync(key: 'punchIn');
    print("======punchInnnnnnnnnnnnnnnnnnnnnnnnnnnnn1055555555555 $punchIn");
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

  void login()
  async{
    bool? Login = await SharedPref.sharedpref.readSync(key: 'login');
  }

  Future<void> getUserData() async {
    UserLoginData.value = await SharedPref.sharedpref.readUserLoginData() ?? UserLoginModel();
    staffLoginData.value = await SharedPref.sharedpref.readUserStaffData() ?? StaffDataModel();
    designationData.value = await SharedPref.sharedpref.readUserDesignationData() ?? DesignationsModel();
    var connectivityResult = await Connectivity().checkConnectivity();
    print("=====================userrrrrrrrrrrrrr ${UserLoginData.value.name != null && UserLoginData.value.id != null}");
   if(UserLoginData.value.name != null && UserLoginData.value.id != null && connectivityResult != ConnectivityResult.none)
     {
       List<SiteDataModel>? siteDataList = await ApiHelper.apiHelper.getAllSiteData();
       homeController.siteDropDownList.value = siteDataList ?? [];
       List<SiteDataModel> userLoginSiteData = homeController.siteDropDownList.where((p0) {
         print("======================= checkkkkkkkkkkkk ${p0.id} == ${staffLoginData.value.companyId!} ::: ${p0.id == staffLoginData.value.companyId!}");
         return p0.id == staffLoginData.value.companyId!;
       }).toList();
       print("=================siteeeeeeeeeeeeeeeeeeee ${homeController.siteDropDownList} ${userLoginSiteData.isNotEmpty}");
       if(userLoginSiteData.isNotEmpty)
       {
         homeController.siteOneDropDownItem.value = userLoginSiteData.first;
         homeController.subSiteDropDownList.value = await ApiHelper.apiHelper.getAllSubSiteData(company_id: homeController.siteOneDropDownItem.value.id!) ?? [];
       }

       if(staffLoginData.value.id == null || staffLoginData.value.designationId == null)
         {
           StaffDataModel staffOneData = await ApiHelper.apiHelper.getStaffData(staff_id: loginController.UserLoginData.value.id!) ?? StaffDataModel();
           SharedPref.sharedpref.setUserStaffData(userStaffData: staffOneData);
           staffLoginData.value = staffOneData;
           if(designationData.value.id == null)
             {
               DesignationsModel? designationOneData = await ApiHelper.apiHelper.getDesignationsIdWise(designation_id: staffOneData.designationId!);
               SharedPref.sharedpref.setUserDesignationData(userDesignationdata: designationOneData!);
               designationData.value = designationOneData;
             }
         }
       else
         {
           if(designationData.value.id == null)
           {
             DesignationsModel? designationOneData = await ApiHelper.apiHelper.getDesignationsIdWise(designation_id: staffLoginData.value.designationId!);
             SharedPref.sharedpref.setUserDesignationData(userDesignationdata: designationOneData!);
             designationData.value = designationOneData;
           }
         }
     }
  }

  Future<void> pickImage(context) async {
    final ImagePicker _pickimage = ImagePicker();
    final image = await _pickimage.pickImage(source: ImageSource.camera).then((value) async {
      if (value != null) {
        File imgPath =  await CropImage(File(value.path), context);
        imagepath.value = imgPath.path;
        print("pppppppppppp ${imagepath.value}");
      }
    });
  }
  Future<File> CropImage(File imageFile,context)
  async{
    final croppedFile = await ImageCropper().cropImage(sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if(croppedFile != null)
    {
      imageCache.clear();
      imageFile = File(croppedFile.path);
      print("iiiiiiiiiiiiii  $imageFile");
    }
    return imageFile;
  }

  Future<void> pickProblemImage(context) async {
    final ImagePicker _pickimage = ImagePicker();
    EasyLoading.show(status: "Please Wait...");
    final image = await _pickimage.pickImage(source: ImageSource.camera,imageQuality: 50).then((value) async {
      print("mmmmmmmmmmmmmmmmmm");
      if (value != null) {
        imagepath2.value = value.path;
        print("pppppppppppp ${imagepath2.value}");
      }
      EasyLoading.dismiss();
    });
  }
}