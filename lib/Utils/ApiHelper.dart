import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/DesignationsModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/LeaveTypeDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/ProblemModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ApiHelper {

  ApiHelper._();
  static ApiHelper apiHelper = ApiHelper._();



  Future<Map<String, dynamic>?> userLogin({required String username,required String password,required String language})
  async{
    String ApiLink = "https://weclockstechnology.com/flutter_api/user_login.php";
    var response = await http.post(Uri.parse(ApiLink),body: {"username":username,"password":password,"language": language});

    if(response.statusCode == 200)
    {
      var json = jsonDecode(response.body);
      return json['success'] == true ? {'data':UserLoginModel.fromJson(json),'success':true} : {'message': json['message'],'success':false};
    }
    return null;
  }

  Future<List<StaffModel>?> getStaffDataIdWise({required String id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_staffdata_id_wish.php";
    var response = await http.post(Uri.parse(apiLink),body: {"id":id});

    if(response.statusCode == 200)
    {
      List json = jsonDecode(response.body);

      return json.map((e) => StaffModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> insertNotificationsTokenData({required String notification_token, required String user_id})
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/notification_token_insert.php";
    var response = await http.post(Uri.parse(ApiLink), body: {
      'notification_token': notification_token,
      'user_id': user_id,
    });

    if (response.statusCode == 200) {
      print("================Inserttttttttt Yesssssssssssss ${response.body}");
    }
    else
    {
      print("================Inserttttttt Nooooooooooo ${response.body}");
    }
  }

  Future<List?> getAllNotificationsTokenData() async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_notification_token.php";
    var response = await http.get(Uri.parse(ApiLink),);

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      print("================ $json");
      return json;
    }
    return null;
  }

  Future<void> updateNotificationsTokenData({required String notification_token_id, required String notification_token,})
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/notification_token_update.php";
    print("================ uppppppppppp $notification_token_id");
    var response = await http.post(Uri.parse(ApiLink), body: {
      'notification_token_id': notification_token_id,
      'notification_token': notification_token,
    });

    if (response.statusCode == 200) {
      print("================Updateee Yesssssssssssss ${response.body}");
    }
    else
    {
      print("================Updateee Nooooooooooo ${response.body}");
    }
  }

  Future<void> insertNotificationData({required String title, required String description, required DateTime ins_date_time, required String user_id, required String seen})
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/notification_insert.php";
    var response = await http.post(Uri.parse(ApiLink), body: {
      'title': title,
      'description': description,
      'ins_date_time': DateFormat('yyyy-MM-dd hh:mm:ss').format(ins_date_time),
      'user_id': user_id,
      "seen": seen,
    });
    print('nottttttttttttttttDatttttttttttttttt $title ,,, $description,,, ${DateFormat('yyyy-MM-dd hh:mm:ss').format(ins_date_time)} ,,,, $user_id ,,, $seen');
    if (response.statusCode == 200) {
      print("================Inserttttttttt Yesssssssssssss ${response.body}");
    }
    else
    {
      print("================Inserttttttt Nooooooooooo ${response.body}");
    }
  }

  Future<void> updateNotSeenToSeenNotificationsData({required String notification_id, required String seen,}) async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/notification_update.php";
    var response = await http.post(Uri.parse(ApiLink),body: {
      'notification_id': notification_id,
      'seen': seen,
    },);

    if (response.statusCode == 200) {
      print("================ ${response.body}");
    }
    return null;
  }

  Future<List?> getAllNotificationsData() async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_notification.php";
    var response = await http.get(Uri.parse(ApiLink),);

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json;
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  Future<void> sendNotifications({required String title, required String body, required String notification_token,})
  async {
    var response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=AAAAz4rbYDA:APA91bHcQ_KgdpDBDx-5NKZC5pNubyzjYy-XJ0kkWUgm5Y9F_7fdqyM3F228ihhxzWzOBlzYLVZp4Bgxq1lJJ5fyes6-6REB0o47FEnY3ATqegVcJ4bogzvyVzxvRn2VtrkTOQ6zfbsf"
        },
        body: jsonEncode(
            {
              "to": notification_token,
              "notification": {
                "title": title,
                "body": body,
                // "image": "https://play-lh.googleusercontent.com/R1_CAEcA9ottrYZg8Ch0BUwTZJMMY8viB2a2Si5W6vKE6ezOV3C7l-PEjFZ1Xkxoyls=s124-rw",
                "mutable_content": true,
                "sound": "Tri-tone"
              },
              "data": {
                "page": "No",
                "url": "<url of media image>",
                "dl": "<deeplink action on tap of notification>"
              }
            }
        )
    );
  }

  Future<List<SiteDataModel>?> getAllSiteData()
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_site.php";
    var response = await http.get(Uri.parse(apiLink));

    if(response.statusCode == 200)
    {
      List json = jsonDecode(response.body);

      return json.map((e) => SiteDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<List?> getHRAttendanceData({required DateTime date})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_attendance_hr.php";
    var response = await http.post(Uri.parse(apiLink),body: {"date": DateFormat('yyyy-MM-dd').format(date)});

    if(response.statusCode == 200)
    {
      List json = jsonDecode(response.body);

      return json;
    }
    return null;


  }

  Future<List<SubSiteDataModel>?> getAllSubSiteData({required String company_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_sub_site.php";
    var response = await http.post(Uri.parse(apiLink),body: {"company_id":company_id,});

    if(response.statusCode == 200)
    {
      List json = jsonDecode(response.body);

      return json.map((e) => SubSiteDataModel.fromJson(e)).toList();
    }
    return null;


  }

  Future<StaffDataModel?> getStaffData({required String staff_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_staff_data.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id":staff_id,});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      if(jsonData.isNotEmpty)
      {
        return StaffDataModel.fromJson(jsonData.first);
      }
      return null;
    }
    return null;


  }

  Future<void> attendancePunchInData({required PunchInOutDataModel punchInOutDataModel})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/attendance_punch_in.php";
    var response = await http.post(Uri.parse(apiLink),body: {
      "staff_id":punchInOutDataModel.staffId,
      "staff_joining_id":punchInOutDataModel.staffJoiningId,
      "department_id":punchInOutDataModel.departmentId,
      "sub_company_id":punchInOutDataModel.subCompanyId,
      "type":punchInOutDataModel.type,
      "remark":punchInOutDataModel.remark,
      "clock_in":punchInOutDataModel.clockIn.toString(),
      "clock_in_lat":punchInOutDataModel.clockInLat,
      "clock_in_long":punchInOutDataModel.clockInLong,
      "clock_in_address":punchInOutDataModel.clockInAddress,
      "created_at":punchInOutDataModel.createdAt.toString(),
    });

    if(response.statusCode == 200)
    {
      print("======== SUCCESSSSSSSSSSSSS INNNNNNNNNN ${response.body}");
    }


  }

  Future<void> attendancePunchOutData({required PunchInOutDataModel punchInOutDataModel})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/attendance_punch_out.php";
    var response = await http.post(Uri.parse(apiLink),body: {
      "id":punchInOutDataModel.id,
      "staff_id":punchInOutDataModel.staffId,
      "hours":punchInOutDataModel.hours,
      "salary_amount":punchInOutDataModel.salaryAmount,
      "clock_out":punchInOutDataModel.clockOut.toString(),
      "clock_out_type":punchInOutDataModel.clockOutType,
      "clock_out_lat":punchInOutDataModel.clockOutLat,
      "clock_out_long":punchInOutDataModel.clockOutLong,
      "clock_out_address":punchInOutDataModel.clockOutAddress,
      "updated_at":punchInOutDataModel.updatedAt.toString(),
    });

    if(response.statusCode == 200)
    {
      print("======== SUCCESSSSSSSSSSSSS OUTTTTTTTTTT ${response.body}");
    }


  }

  Future<List<PunchInOutDataModel>?> getAttendanceUserIdWise({required String staff_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_attendance.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id":staff_id,});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData.map((e) => PunchInOutDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> insertTrackingData({required TrackingModel trackingModel})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/attendance_logs_insert.php";
    var response = await http.post(Uri.parse(apiLink),body: {
      "staff_id":trackingModel.staffId,
      "lat":trackingModel.lat,
      "long":trackingModel.long,
      "gps_active":trackingModel.gpsActive,
      "created_at":trackingModel.createdAt!.toString(),
      "updated_at":trackingModel.updatedAt.toString(),
    });

    if(response.statusCode == 200)
    {
      print("======== SUCCESSSSSSSSSSSSS OUTTTTTTTTTT ${response.body}");
    }


  }

  Future<List<TrackingModel>?> getTrackingUserIdWise({required String staff_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_attendance_logs.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id":staff_id,});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData.map((e) => TrackingModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> insertProblem({required ProblemModel problemModel})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/insert_problem.php";
    var response = await http.MultipartRequest('POST',Uri.parse(apiLink));


    File imageFile = File(problemModel.prob_img!);
    print('bbbbbbbbbbbb');
    String folderPath = "https://talwade.co.in/itdp/maintanance_img/";
    String fileName = basename(imageFile.path);
    print('oooooooooooo');
    print("============ $fileName");
    response.files.add(
      http.MultipartFile(
        'photo',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType(
          'image',
          'jpeg',
        ), // Adjust as needed
      ),
    );
    print("fffffffffffff");
    response.fields['user_id'] = "${problemModel.userId}";
    response.fields['problem'] = "${problemModel.problem}";
    response.fields['ins_date_time'] = "${problemModel.insDateTime}";
    response.fields['status'] = "${problemModel.status}";
    print('bbbbbbbbbbbb');

    try {
      http.StreamedResponse request = await response.send();
      if (request.statusCode == 200) {
        print('Success==========');
      }
    } catch (error) {
      print('Error during upload: $error');
    }
  }

  Future<List<ProblemModel>?> getProblem({required String user_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_problem.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id":user_id,});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData.map((e) => ProblemModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> removeProblem({required String problem_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/problem_delete.php";
    var response = await http.post(Uri.parse(apiLink),body: {"problem_id":problem_id,});

    if(response.statusCode == 200)
    {
      print("REMOVEEEEEEEEEEEE");
    }
  }

  Future<List<PunchInOutDataModel>?> getReport({required String staff_id,required DateTime dateTime})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_report.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id":staff_id,"date": DateFormat('yyyy-MM-dd').format(dateTime)});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData.map((e) => PunchInOutDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<dynamic> getPresent({required String staff_id,required DateTime dateTime})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_present_absent.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id":staff_id,"date": DateFormat('yyyy-MM-dd').format(dateTime)});

    var jsonData = jsonDecode(response.body);

    return jsonData;
  }


  Future<DesignationsModel?> getDesignationsIdWise({required String designation_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_designation.php";
    var response = await http.post(Uri.parse(apiLink),body: {"designation_id":designation_id,});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData.isEmpty ? null : DesignationsModel.fromJson(jsonData.first);
    }
    return null;
  }

  Future<List<LeaveDataModel>?> getAllLeaveData()
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_leave.php";
    var response = await http.get(Uri.parse(ApiLink));
    LoginController loginController = Get.put(LoginController());
    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      List<LeaveDataModel> finalList = json.map((e) => LeaveDataModel.fromJson(e)).toList();
      return finalList.where((element) => element.userId == loginController.UserLoginData.value.id).toList();    }
    return null;
  }

  Future<List<LeaveDataModel>?> getPoAllLeaveData()
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_leave.php";
    var response = await http.get(Uri.parse(ApiLink));
    LoginController loginController = Get.put(LoginController());
    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map((e) => LeaveDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> updateOneLeaveAcceptRejectData({required LeaveDataModel leaveDataModel})
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/leave_update_hr.php";
    var response = await http.post(Uri.parse(ApiLink),
      body: {
        "leave_id": leaveDataModel.leaveId!.toString(),
        "aproved_id": leaveDataModel.aprovedId,
        "leave_status": leaveDataModel.leaveStatus,
        "leave_status_reason": leaveDataModel.leaveStatusReason,
        "leave_status_date_time": "${leaveDataModel.leaveStatusDateTime}",
      },
    );
    if(response.statusCode == 200)
    {
      print("======== SUCCCCCCCCCCCCC ${response.body}");
    }
  }

  Future<List<LeaveTypeDataModel>?> getAllLeaveReason() async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_leave_type.php";
    var response = await http.get(Uri.parse(ApiLink));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map((e) => LeaveTypeDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<LeaveTypeDataModel>?> getLeaveDataLeaveTypeIdWise({required String leave_type_id}) async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_leave_type_id.php";
    var response = await http.post(Uri.parse(ApiLink),body: {"leave_type_id":leave_type_id});

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map((e) => LeaveTypeDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> insertLeaveData({required LeaveDataModel leaveDataModel})
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/leave_insert.php";
    var respose = await http.MultipartRequest('POST', Uri.parse(ApiLink));

    File imageFile = File(leaveDataModel.photo!);
    String folderPath =
        "https://weclockstechnology.com/smc_photo/smc_metting_photo/";
    String fileName = basename(imageFile.path);
    print("============ $fileName");
    respose.files.add(
      http.MultipartFile(
        'photo',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType(
          'image',
          'jpeg',
        ), // Adjust as needed
      ),
    );

    respose.fields['user_id'] = "${leaveDataModel.userId}";
    respose.fields['leave_type_id'] = "${leaveDataModel.leaveTypeId}";
    respose.fields['start_date'] = "${leaveDataModel.startDate}";
    respose.fields['end_date'] = "${leaveDataModel.endDate}";
    respose.fields['days'] = "${leaveDataModel.days}";
    respose.fields['reason'] = "${leaveDataModel.reason}";
    respose.fields['ins_date_time'] = "${leaveDataModel.insDateTime}";
    respose.fields['sync_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    respose.fields['sync_time'] = DateFormat('hh:mm:ss').format(DateTime.now());

    try {
      http.StreamedResponse request = await respose.send();
      if (request.statusCode == 200) {
        print('Success==========');
      }
    } catch (error) {
      print('Error during upload: $error');
    }
  }

  Future<void> updateOneLeaveData({required LeaveDataModel leaveDataModel})
  async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/leave_update.php";
    var respose = await http.MultipartRequest('POST', Uri.parse(ApiLink));

    File imageFile = File(leaveDataModel.photo!);
    String folderPath =
        "https://weclockstechnology.com/smc_photo/smc_metting_photo/";
    String fileName = basename(imageFile.path);
    print("============ $fileName");
    respose.files.add(
      http.MultipartFile(
        'photo',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType(
          'image',
          'jpeg',
        ), // Adjust as needed
      ),
    );

    respose.fields['leave_id'] = "${leaveDataModel.leaveId}";
    respose.fields['leave_type_id'] = "${leaveDataModel.leaveTypeId}";
    respose.fields['start_date'] = "${leaveDataModel.startDate}";
    respose.fields['end_date'] = "${leaveDataModel.endDate}";
    respose.fields['days'] = "${leaveDataModel.days}";
    respose.fields['reason'] = "${leaveDataModel.reason}";
    respose.fields['update_date_time'] = "${leaveDataModel.updateDateTime}";
    respose.fields['sync_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    respose.fields['sync_time'] = DateFormat('hh:mm:ss').format(DateTime.now());

    try {
      http.StreamedResponse request = await respose.send();
      if (request.statusCode == 200) {
        print('Success==========');
      }
    } catch (error) {
      print('Error during upload: $error');
    }
  }

  Future<List<LeaveDataModel>?> getLeaveDatauserWise({required String user_id}) async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_user_leave.php";
    var response = await http.post(Uri.parse(ApiLink),body: {"user_id":user_id});

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map((e) => LeaveDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> deleteLeaveDataIdWise({required String leave_id}) async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/leave_delete.php";
    var response = await http.post(Uri.parse(ApiLink),body: {"leave_id":leave_id});

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
    }
  }

  Future<List<LeaveDataModel>?> getLeaveDataLeaveTypeIdWise2({required String leave_type_id}) async {
    String ApiLink = "https://weclockstechnology.com/flutter_api/fatch_leave_id_wise.php";
    var response = await http.post(Uri.parse(ApiLink),body: {"leave_type_id":leave_type_id});
    LoginController loginController = Get.put(LoginController());
    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      List<LeaveDataModel> finalList = json.map((e) => LeaveDataModel.fromJson(e)).toList();
      return finalList.where((element) => element.userId == loginController.UserLoginData.value.id).toList();
    }
    return null;
  }

  Future<dynamic> getAllStaffAttendance({required DateTime dateTime}) async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_attendance_all.php";
    var response = await http.post(Uri.parse(apiLink),body: {"date":DateFormat('yyyy-MM-dd').format(dateTime),});

    if(response.statusCode == 200)
    {
      var jsonData = jsonDecode(response.body);

      return jsonData;
    }
    return null;
  }

  Future<dynamic> getAllStaffAttendanceSiteWise({required DateTime dateTime,required String site_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_attendance_all_site_wise.php";
    var response = await http.post(Uri.parse(apiLink),body: {"date":DateFormat('yyyy-MM-dd').format(dateTime),'company_id': site_id});

    if(response.statusCode == 200)
    {
      var jsonData = jsonDecode(response.body);

      return jsonData;
    }
    return null;
  }

  Future<void> changePassword({required String id,required String password})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/change_password.php";
    var response = await http.post(Uri.parse(apiLink),body: {"id": id,'password': password});

    if(response.statusCode == 200)
    {
      print("========SUCCESSSSS ${response.body}");
    }
  }

  Future<StaffDataModel?> getUserDesignationWise({required String designation_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fetch_user_designation_wise.php";
    var response = await http.post(Uri.parse(apiLink),body: {"designation_id": designation_id});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData.isEmpty ? null : StaffDataModel.fromJson(jsonData.last);
    }
    return null;
  }

  Future<List?> getStaffCompanyWise({required String company_id})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_staff_joining_company_wise.php";
    var response = await http.post(Uri.parse(apiLink),body: {"company_id": company_id});

    if(response.statusCode == 200)
    {
      List jsonData = jsonDecode(response.body);

      return jsonData;
    }
    return null;
  }

  Future<int?> getStaffAttendanceCompanyAndMonthWise({required String staff_id, required DateTime date})
  async {
    String apiLink = "https://weclockstechnology.com/flutter_api/fatch_attendance_month_wise.php";
    var response = await http.post(Uri.parse(apiLink),body: {"staff_id": staff_id, 'date': DateFormat('yyyy-MM-dd').format(date)});

    if(response.statusCode == 200)
    {
      int jsonData = jsonDecode(response.body);

      return jsonData;
    }
    return null;
  }

}
