import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';

class HRStaffAttendanceController extends GetxController
{
  RxString selectedDate = DateTime.now().toIso8601String().obs;
  RxList<SiteDataModel> siteDataList = <SiteDataModel>[].obs;
  RxList<SubSiteDataModel> subSiteDataList = <SubSiteDataModel>[].obs;
  RxMap allAttendanceData = {}.obs;
  RxMap selectedSiteAllAttendanceData = {}.obs;
  Rx<SiteDataModel> selectedSiteData = SiteDataModel().obs;
}