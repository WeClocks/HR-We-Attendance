import 'package:get/get.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';

class ReportController extends GetxController
{
  RxString selectedMonth = DateTime.now().toIso8601String().obs;
  RxList<PunchInOutDataModel> reportsList = <PunchInOutDataModel>[].obs;
  RxInt totalPresent = 0.obs;
  RxInt totalAbsent = 0.obs;
}