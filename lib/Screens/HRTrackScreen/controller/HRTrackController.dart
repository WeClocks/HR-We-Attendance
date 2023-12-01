import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';

class HRTrackController extends GetxController
{
  RxString selectedDate = DateTime.now().toIso8601String().obs;
  RxList hrAttendanceDataList = [].obs;
  // RxList hrAttendanceFilterDataList = [].obs;
  RxBool hrTrackOrNot = false.obs;
  RxMap hrAttendanceOneData = {}.obs;
  RxList<SiteDataModel> siteList = <SiteDataModel>[].obs;
  Rx<SiteDataModel> selectedSiteData = SiteDataModel().obs;
  Rx<SubSiteDataModel> userSubSiteData = SubSiteDataModel().obs;
}