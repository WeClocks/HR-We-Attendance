import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/ChangePasswordScreen/Controller/ChangePasswordController.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/SharedPreferance.dart';

class PassWordVerifyPage extends StatefulWidget {
  const PassWordVerifyPage({super.key});

  @override
  State<PassWordVerifyPage> createState() => _PassWordVerifyPageState();
}

class _PassWordVerifyPageState extends State<PassWordVerifyPage> {
  ChangePasswordController passwordController = Get.put(ChangePasswordController());
  LoginController loginController = Get.put(LoginController());
  GlobalKey<FormState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xFF5b1aa0)),
            backgroundColor: Color(0xfff0e5ff),
            actions: [
              IconButton(onPressed: () {

              }, icon: Icon(Icons.info_outline,color: Color(0xFF5b1aa0),))
            ],
          ),
          body: Obx(
            () => Padding(
              padding:  EdgeInsets.only(right: 10,left: 10,top: 10),
              child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reset password",style: TextStyle(fontSize: 22,color:Color(0xFF5b1aa0),fontWeight: FontWeight.bold),),
                      Text("Enter the old password with your account and verify \nold paswword to reset your password",style: TextStyle(color: Colors.grey.shade600),),
                      SizedBox(height: Get.width/20),
                      TextFormField(
                        controller: passwordController.oldPassword.value,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            contentPadding: EdgeInsets.only(left: 20,right: 20),
                            labelText: "Old Password"
                        ),
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "Please Enter the password";
                          }
                          else if(value.length != 10)
                          {
                            return "Please enter max 10 character";
                          }
                          else if(!BCrypt.checkpw(value, loginController.UserLoginData.value.password!))
                          {
                            return "Please enter right password";
                          }
                        },
                      ),
                      SizedBox(height: Get.width/20),
                      TextFormField(
                        controller: passwordController.newPassword.value,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
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
                                color: Color(0xFF5b1aa0),
                              )
                                  : Icon(
                                Icons.visibility,
                                color: Color(0xFF5b1aa0),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 20,right: 20),
                            labelText: "New Password"
                        ),
                        obscureText: loginController.hidePass.value,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "Please Enter the password";
                          }
                          else if(value.length != 10)
                          {
                            return "Please enter max 10 character";
                          }
                        },
                      ),
                      SizedBox(height: Get.width/20),
                      TextFormField(
                        controller: passwordController.confNewPassword.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.only(left: 20,right: 20),
                          labelText: "Confirm new password",
                        ),
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "Please Enter the password";
                          }
                          else if(value.length != 10)
                          {
                            return "Please enter max 10 character";
                          }
                          else if(value != passwordController.newPassword.value.text)
                          {
                            return "Please enter same as new password";
                          }
                        },

                      ),
                      SizedBox(height: Get.width/20),
                      InkWell(
                        onTap: () async {
                          if(key.currentState!.validate())
                          {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: Text("Reset password?"),
                                content: Text("Are you sure want to reset password?"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                        EasyLoading.show(status: "Please Wait...");
                                        String password = BCrypt.hashpw(passwordController.newPassword.value.text, BCrypt.gensalt());
                                        UserLoginModel user = loginController.UserLoginData.value;
                                        print("=============== beforeeeeeeeeeeev ${loginController.UserLoginData.value.password}\n${user.password}");
                                        loginController.UserLoginData.value.password = password;
                                        user.password = password;
                                        loginController.UserLoginData.value = loginController.UserLoginData.value;
                                        print("=============== aftereeeeeeeeeeee ${loginController.UserLoginData.value.password}\n${user.password}\n$password");
                                        await ApiHelper.apiHelper.changePassword(id: loginController.UserLoginData.value.id!, password: password).then((value) async {
                                          SharedPref.sharedpref.setUserLoginData(userdata: user);
                                          loginController.UserLoginData.value = await SharedPref.sharedpref.readUserLoginData() ?? UserLoginModel();
                                          print("=============== aftereeeeeeeeeeee 22222222 ${loginController.UserLoginData.value.password}\n${user.password}\n$password");
                                          EasyLoading.dismiss();
                                          EasyLoading.showSuccess("Your Password Change Successfully");
                                          Get.back();
                                        });
                                      },
                                      child: Text("Yes",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("No",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
                                ],
                              );
                            },);
                            // bool verify = ;
                            //  EasyLoading.showSuccess("Hash Password\n${loginController.UserLoginData.value.password}\n${BCrypt.hashpw(passwordController.newPassword.value.text, BCrypt.gensalt())}");
                          }
                        },
                        child: Container(
                          height: Get.width/8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF5b1aa0),
                          ),
                          alignment: Alignment.center,
                          child: Text("Change Password",style: TextStyle(color: Color(0xfff0e5ff)),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
