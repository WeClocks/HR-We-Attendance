import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveTypeDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';

class PoLeaveController extends GetxController
{
  RxList<LeaveDataModel> leaveDataList = <LeaveDataModel>[].obs;
  Rx<LeaveDataModel> leaveOneData = LeaveDataModel().obs;
  RxList<LeaveTypeDataModel> leaveReasonTypeList = <LeaveTypeDataModel>[].obs;
  RxString filterName = "Pending".obs;
  Rx<StaffDataModel> staffOneData = StaffDataModel().obs;
 }