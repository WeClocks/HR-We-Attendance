import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Obx(
                () =>  Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper: CustomeShape(),
                    child: Container(
                      height: Get.width/1.8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              const Color(0xFF5b1ab2),
                              const Color(0xFF5b1aa0),
                              Colors.blue.shade50,
                            ]
                        ),
                        // borderRadius: BorderRadius.only(bottomRight: Radius.circular(150),bottomLeft: Radius.circular(150),)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 80),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Obx(() => loginController.imagepath.isEmpty ?Container(
                          height: Get.width/3,
                          width: Get.width/3,
                          decoration: BoxDecoration(
                            color: Color(0xfff0e5ff),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade100,width: 6),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.person,color: Colors.white,size: 50,),
                        ):Container(
                          height: Get.width/3,
                          width: Get.width/3,
                          decoration: BoxDecoration(
                              color: Color(0xfff0e5ff),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.grey.shade100)
                              ],
                              border: Border.all(color: Colors.grey.shade100,width: 6),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(loginController.imagepath.value.toString()))
                              )
                          ),
                        ),),
                        Text("${loginController.UserLoginData.value.name}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 150,left: 100),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      child: Container(
                        height: Get.width/12,
                        width: Get.width/12,
                        decoration: BoxDecoration(
                            color: Color(0xFF5b1aa0),
                            shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.camera_alt,color: Color(0xfff0e5ff),size: 18,),
                      ),
                      onTap: () async {
                        var connectivityResult = await Connectivity().checkConnectivity();
                        if(connectivityResult != ConnectivityResult.none)
                        {
                          loginController.pickImage(context);
                          print("jjjjjjjjjjjjjj");

                          print("${loginController.imagepath.value}");
                        }
                        else
                        {
                          EasyLoading.showError("Please Check Your Internet");
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 50),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text("profile".tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
                IconButton(onPressed: () async {
                  Get.back();
                }, icon: const Icon(Icons.arrow_back,color: Colors.white,))
              ],
            ),
          ),
        )
    );
  }
}

class CustomeShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}