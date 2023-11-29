import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/DesignationsModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/HomePage.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:hr_we_attendance/main.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff29B5F4),
          body: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    height: Get.height/2.8,
                    color: Color(0xff29B5F4),
                    padding: EdgeInsets.only(bottom: Get.width/10),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: 10),
                          child: Lottie.asset("assets/animation/BxIqvvVLW6.json",fit: BoxFit.cover),
                        ),
                        // SizedBox(width: Get.width/5),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding:  EdgeInsets.only(top: 10),
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/image/we.png',fit: BoxFit.cover,width: Get.width/3,height: Get.width/3,),
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText('Field Staff Tracking System',speed: const Duration(milliseconds: 200),textStyle: TextStyle(color: Colors.amber))
                                      ],
                                      isRepeatingAnimation: true,
                                      totalRepeatCount: 1000000000,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Get.width/30),
                  Container(
                    height: (Get.height - (Get.height / 2.8)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                    ),
                    alignment: Alignment.center,
                    child: Form(
                      key: key,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: Get.width/10),
                          Text("LOGIN - HR",style: TextStyle(color: Colors.orange,fontSize: 18,fontWeight: FontWeight.bold),),
                          SizedBox(height: Get.width/10),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width/20, right: Get.width/20),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: txtEmail,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(right: Get.width/20, left: Get.width/20),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff29B5F4)),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff29B5F4),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),

                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xff29B5F4)
                                ),
                                //filled: true,
                                //fillColor: Color(0xFF40dedf),
                                labelText: "Username",
                                labelStyle: TextStyle(color: Color(0xff29B5F4)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Username";
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: Get.width/12,),
                          Obx(
                                () =>
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.width/20, right: Get.width/20),
                                  child: TextFormField(
                                    controller: txtPass,
                                    style: TextStyle(color: Colors.black,),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: Get.width/20, right: Get.width/20),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff29B5F4),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff29B5F4),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff29B5F4),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff29B5F4),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10)),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Color(0xff29B5F4),
                                        ),
                                        //filled: true,
                                        //fillColor: Color(0xFF40dedf),
                                        labelText: "Password",
                                        // errorStyle: TextStyle(color: Colors.white),
                                        labelStyle: TextStyle(color: Color(0xff29B5F4)),
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            loginController.hidePass.value =
                                            !loginController.hidePass.value;
                                          },
                                          icon: loginController.hidePass
                                              .value ==
                                              true
                                              ? Icon(
                                            Icons.visibility_off,
                                            color: Color(0xff29B5F4),
                                          )
                                              : Icon(
                                            Icons.visibility,
                                            color: Color(0xff29B5F4),
                                          ),
                                        )),
                                    obscureText: loginController.hidePass.value,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Password";
                                      }
                                    },
                                  ),
                                ),
                          ),
                          SizedBox(height: Get.width/50),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: Get.width/30),
                              child: InkWell(
                                  onTap: () {

                                    EasyLoading.showError("Sorry Working Progress");

                                    // showDialog(context: context, builder: (context) {
                                    //   return AlertDialog(
                                    //     title: Text("Forgot Password?"),
                                    //     content: Text("Are you sure want to forgot password?"),
                                    //     actions: [
                                    //       ElevatedButton(
                                    //           onPressed: () async {
                                    //             Get.back();
                                    //           },
                                    //           child: Text("Yes",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                                    //       ElevatedButton(
                                    //         onPressed: () {
                                    //           Get.back();
                                    //         },
                                    //         child: Text("No",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                                    //     ],
                                    //   );
                                    // },);
                                  },
                                  child: Text("Forgot Password?",style: TextStyle(color: Color(0xff29B5F4)),)),
                            ),
                          ),
                          SizedBox(
                            height: Get.width/20,
                          ),
                          GestureDetector(
                            child: Center(
                              child: Container(
                                height: Get.width/7.5,
                                width: Get.width/1.15,
                                decoration: BoxDecoration(
                                    color: Color(0xff29B5F4),
                                    // gradient: LinearGradient(
                                    //   colors: [
                                    //     Color(0xFF40dedf),
                                    //     Color(0xFF0fb2e9),
                                    //   ],
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    // ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey.shade700,
                                        offset: Offset(2, 4),)
                                    ]
                                ),
                                child: Center(
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,color: Colors.white),
                                    )),
                              ),
                            ),
                            onTap: () async {
                              // print(
                              //     "=========== ${home_controller.textemail
                              //         .text} ${home_controller.textpass.text}");
                              var connectivityResult = await Connectivity().checkConnectivity();
                              if(connectivityResult != ConnectivityResult.none)
                              {

                                if (key.currentState!
                                    .validate()) {
                                  EasyLoading.show(status: "Please Wait...");
                                  Map<String, dynamic>? LoginData = await ApiHelper.apiHelper.userLogin(username: txtEmail.text, password: txtPass.text,language: 'en');
                                  if(LoginData!['success'] == true)
                                  {
                                    UserLoginModel user = LoginData['data'];
                                    if(user.id != '121')
                                      {
                                        loginController.UserLoginData.value = LoginData['data'];
                                        SharedPref.sharedpref.setUserLoginData(userdata: loginController.UserLoginData.value);
                                        StaffDataModel staffOneData = await ApiHelper.apiHelper.getStaffData(staff_id: loginController.UserLoginData.value.id!) ?? StaffDataModel();
                                        SharedPref.sharedpref.setUserStaffData(userStaffData: staffOneData);
                                        DesignationsModel? designationOneData = await ApiHelper.apiHelper.getDesignationsIdWise(designation_id: staffOneData.designationId!);
                                        SharedPref.sharedpref.setUserDesignationData(userDesignationdata: designationOneData!);
                                        SharedPref.sharedpref.insertSync(check: true,key: "login");
                                        loginController.getUserData();
                                        List<PunchInOutDataModel> attendanceDataList = await ApiHelper.apiHelper.getAttendanceUserIdWise(staff_id: loginController.UserLoginData.value.id!) ?? [];
                                        if(attendanceDataList.isNotEmpty)
                                        {
                                          DateTime dateTime = DateTime.now();
                                          List<PunchInOutDataModel> weAttendanceOne = attendanceDataList.where((element) {
                                            return ((DateTime(element.clockIn!.year,element.clockIn!.month,element.clockIn!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0));
                                          }).toList();
                                          print("================== 8333333333333333333 ${weAttendanceOne.isNotEmpty}");

                                          if (weAttendanceOne.isNotEmpty)
                                          {
                                            await SharedPref.sharedpref.insertSync(check: true,key: 'punchIn');
                                            bool? punchIn = await SharedPref.sharedpref.readSync(key: 'punchIn');
                                            print("=================== 866666666pppppppppppiiiiiiiiiiiiii $punchIn");
                                            homeController.weAttendanceOneData.value = weAttendanceOne.first;
                                            await loginController.initializeService();
                                          }
                                        }
                                        homeController.readUserSiteAndSubSiteData();
                                        homeController.readWeAttendanceOneOnlineData();
                                        EasyLoading.dismiss();
                                        Get.offNamed('/');
                                        Get.snackbar("Success", "Login is Successfully", backgroundColor: Colors.green,colorText: Colors.white,padding: EdgeInsets.all(Get.height/130));
                                      }
                                    else
                                      {
                                        EasyLoading.showError("Please Enter Only HR Username Or Password");
                                      }
                                  }
                                  else
                                  {
                                    EasyLoading.dismiss();
                                    Get.snackbar("Alert", LoginData['message'],backgroundColor: Colors.red,padding: EdgeInsets.all(Get.height/130),duration: Duration(seconds: 2),colorText: Colors.white);
                                  }
                                }
                              }
                              else
                              {
                                EasyLoading.showError("Please Check Your Internet");
                              }

                            },
                          ),
                          SizedBox(height: Get.width/30),
                          Text("Technical Support",style: TextStyle(color: Colors.orange),),
                          GestureDetector(
                              onTap: () async {
                                print("jjjjjjjjj");
                                Uri uri = Uri(path: '8000272989',scheme: 'tel');
                                if(await canLaunchUrl(uri))
                                {
                                  await launchUrl(uri);
                                }
                              },
                              child: Text("8000272989",style: TextStyle(color: Color(0xff29B5F4)),)),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }
}
