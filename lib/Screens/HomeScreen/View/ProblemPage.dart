import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/ProblemModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/View/AddProblemPage.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/PhotoViewPage.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFF5b1aa0),),
          backgroundColor: Color(0xfff0e5ff),
          title: Text("problem".tr,style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16)),
          centerTitle: true,
          actions: [
            Padding(
              padding:  EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () {
                  loginController.imagepath2.value = "";
                  loginController.txtRemark.value.clear();
                  Get.to(AddProblemPage(),transition: Transition.fadeIn);
                },
                child: Container(
                    height: Get.width/10,
                    width: Get.width/10,
                    decoration: const BoxDecoration(
                        color: Color(0xFF5b1aa0),
                        shape: BoxShape.circle
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.add,color: Color(0xfff0e5ff))
                ),
              ),
            )
          ],
        ),
        body: Obx(() => loginController.problemData.value.isEmpty?Padding(
          padding:  EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Lottie.asset("assets/animation/nodata2.json",height: Get.width/1.5,width: Get.width/1.5,fit: BoxFit.fill)),
              Center(child: Text("${'once_you_start'.tr} ${'problem'.tr.toLowerCase()}, ${'you_ll'.tr}")),
              Center(child: Text("see_it_listen_here".tr))
            ],
          ),
        ):Padding(
            padding:  EdgeInsets.only(top: 5),
            child: Obx(() => ListView.builder(itemBuilder: (context, index) {
              return Padding(
                padding:  EdgeInsets.only(top: 5,bottom: 5,right: 5,left: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff0e5ff),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(Get.width/60),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text("${index+1}"),
                                SizedBox(width: Get.width/30),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(child: Text("${loginController.problemData[index].problem}",)),
                                      Text("${DateFormat('dd-MM-yyyy | hh:mm a').format(loginController.problemData[index].insDateTime!)}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Get.width/30,),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  EasyLoading.show(status: "${'please_wait'.tr}...");
                                  String networkImagePath = loginController.problemData[index].prob_img!;
                                  final response = await http.get(Uri.parse(networkImagePath));

                                  final documentDirectory = await getTemporaryDirectory();

                                  String imageName = networkImagePath.split('/').last;
                                  String path = join(documentDirectory.path, imageName);
                                  final filePath = File(path);
                                  filePath.writeAsBytesSync(response.bodyBytes);
                                  Get.to(PhotoViewPage(imagePath: filePath.path),transition: Transition.fadeIn);
                                  EasyLoading.dismiss();
                                },
                                child: Container(
                                  height: Get.width/10,
                                  width: Get.width/10,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF5b1aa0),
                                      shape: BoxShape.circle
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.photo,color: Color(0xfff0e5ff),),
                                ),
                              ),
                              SizedBox(width: Get.width/60),
                              InkWell(
                                onTap: () async {
                                  var connectivityResult = await Connectivity().checkConnectivity();
                                  if(connectivityResult != ConnectivityResult.none)
                                  {
                                    if(DateFormat('dd-MM-yyyy').format(loginController.problemData[index].insDateTime!) == DateFormat('dd-MM-yyyy').format(DateTime.now()))
                                    {
                                      // ignore: use_build_context_synchronously
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xfff0e5ff),
                                          title: Text("${'submit'.tr}?",style: TextStyle(color: Color(0xFF5b1aa0)),),
                                          content: Text("${'are_you_sure_want_to'.tr} ${'submit'.tr} ${'this'.tr} ${'problem'.tr}?",style: const TextStyle(color: Color(0xFF5b1aa0)),),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  EasyLoading.show(status: "${'please_wait'.tr}...");
                                                  Get.back();
                                                  List<ProblemModel>? userData= await ApiHelper.apiHelper.getProblem(user_id: loginController.UserLoginData.value.id!);
                                                  List<ProblemModel> problemData = userData!.where((element) {
                                                    return (("${element.problem}"=="${loginController.problemData[index].problem}"));
                                                  }).toList();

                                                  await ApiHelper.apiHelper.removeProblem(problem_id: "${problemData.first.probId}").then((value) async {
                                                    loginController.problemData.value = (await ApiHelper.apiHelper.getProblem(user_id: loginController.UserLoginData.value.id!))!;
                                                    print("qqqqqqqqqqqqqqqq${loginController.problemData.length}");
                                                    EasyLoading.dismiss();
                                                  });
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
                                    else
                                    {
                                      EasyLoading.showError("you_can_not".tr);
                                    }
                                  }
                                  else
                                  {
                                    EasyLoading.showError("please_check_your_internet".tr);
                                  }
                                },
                                child: Container(
                                  height: Get.width/10,
                                  width: Get.width/10,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.delete,color: Color(0xfff0e5ff),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
              itemCount: loginController.problemData.length,
            ),)
        ),)
    ));
  }
}
