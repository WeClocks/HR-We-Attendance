import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsController extends GetxController
{
  RxList notificationsList = [].obs;
  RxString selectedDate = DateTime.now().toIso8601String().obs;
}