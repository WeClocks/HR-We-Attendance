import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController
{
  Rx<TextEditingController> oldPassword  = TextEditingController().obs;
  Rx<TextEditingController> newPassword  = TextEditingController().obs;
  Rx<TextEditingController> confNewPassword  = TextEditingController().obs;

}