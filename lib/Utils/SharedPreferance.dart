import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/DesignationsModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/SubSiteDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/StaffDataModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Model/UserLoginModel.dart';
class SharedPref {

  SharedPref._();

  static SharedPref sharedpref = SharedPref._();

  Future<void> insertSync({bool? check,required String key})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, "$check");
  }

  Future<bool?> readSync({required String key})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? check = sharedPreferences.getString(key);
    if(check != null && check != "null")
    {
      // ignore: sdk_version_since
      return bool.parse(check);
    }
    return null;
  }

  void setUserLoginData({required UserLoginModel userdata})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map userMapData = userdata.toJson();
    print("==================maptostringggggggggg userrrrrrr ${jsonEncode(userMapData)}");
    sharedPreferences.setString("userData", jsonEncode(userMapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<UserLoginModel?> readUserLoginData()
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userStringData = sharedPreferences.getString("userData");
    print("==================stringgggg $userStringData");
    if(userStringData != null)
    {
      UserLoginModel userData = UserLoginModel.fromJson(jsonDecode(userStringData!));
      return userData;
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }

  void setUserStaffData({required StaffDataModel userStaffData})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map userMapData = userStaffData.toJson();
    print("==================maptostringggggggggg ${jsonEncode(userMapData)}");
    sharedPreferences.setString("userStaffData", jsonEncode(userMapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<StaffDataModel?> readUserStaffData()
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userStringData = sharedPreferences.getString("userStaffData");
    print("==================stringgggg $userStringData");
    if(userStringData != null)
    {
      StaffDataModel userStaffData = StaffDataModel.fromJson(jsonDecode(userStringData!));
      return userStaffData;
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }

  void setUserDesignationData({required DesignationsModel userDesignationdata})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map userMapData = userDesignationdata.toJson();
    print("==================maptostringggggggggg ${jsonEncode(userMapData)}");
    sharedPreferences.setString("userDesignationData", jsonEncode(userMapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<DesignationsModel?> readUserDesignationData()
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userStringData = sharedPreferences.getString("userDesignationData");
    print("==================stringgggg $userStringData");
    if(userStringData != null)
    {
      DesignationsModel userDesignationData = DesignationsModel.fromJson(jsonDecode(userStringData!));
      return userDesignationData;
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }

  void setUserTodayPunchInOutData({required PunchInOutDataModel punchInOutDataModel})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map userMapData = punchInOutDataModel.toJson();
    print("==================maptostringggggggggg ${jsonEncode(userMapData)}");
    sharedPreferences.setString("punchInOutData", jsonEncode(userMapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<PunchInOutDataModel?> readUserTodayPunchInOutData()
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userStringData = sharedPreferences.getString("punchInOutData");
    print("==================stringgggg $userStringData");
    if(userStringData != null)
    {
      PunchInOutDataModel punchInOutData = PunchInOutDataModel.fromJson(jsonDecode(userStringData!));
      return punchInOutData;
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }

  void setUserTodayTrackingLastData({required TrackingModel trackingModel})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map userMapData = trackingModel.toJson();
    print("==================maptostringgggggggggtrackkkkkkkkkk ${jsonEncode(userMapData)}");
    sharedPreferences.setString("trackingLastData", jsonEncode(userMapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<TrackingModel?> readUserTodayTrackingLastData()
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userStringData = sharedPreferences.getString("trackingLastData");
    print("==================stringgggg $userStringData");
    if(userStringData != null)
    {
      TrackingModel trackingModel = TrackingModel.fromJson(jsonDecode(userStringData!));
      return trackingModel;
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }

  void setUserSubSiteData({required SubSiteDataModel subSiteDataModel})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map userMapData = subSiteDataModel.toJson();
    print("==================maptostringggggggggg ${jsonEncode(userMapData)}");
    sharedPreferences.setString("userSubSiteData", jsonEncode(userMapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<SubSiteDataModel?> readUserSubSiteData()
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userStringData = sharedPreferences.getString("userSubSiteData");
    print("==================stringgggg $userStringData");
    if(userStringData != null)
    {
      SubSiteDataModel subSiteDataModel = SubSiteDataModel.fromJson(jsonDecode(userStringData!));
      return subSiteDataModel;
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }

  void setMapData({required String key,required Map mapData})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("==================maptostringggggggggg ${jsonEncode(mapData)}");
    sharedPreferences.setString(key, jsonEncode(mapData));
    // sharedPreferences.setString("name", userdata.name!);
    // sharedPreferences.setString("id", userdata.id!);
    // sharedPreferences.setString("address", userdata.address!);
    // sharedPreferences.setString("mobile", userdata.mobile!);
    // sharedPreferences.setString("email", userdata.email!);
    // sharedPreferences.setString("status", userdata.status!);
  }

  Future<dynamic> readMapData({required String key})
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userMapData = sharedPreferences.getString(key);
    print("==================stringgggg $userMapData");
    if(userMapData != null)
    {
      return jsonDecode(userMapData);
    }
    return null;
    // UserLoginModel? user = UserLoginModel();
    //
    // user.name = sharedPreferences.getString("name");
    // user.id = sharedPreferences.getString("id");
    // user.address = sharedPreferences.getString("address");
    // user.mobile = sharedPreferences.getString("mobile");
    // user.email = sharedPreferences.getString("email");
    // user.status = sharedPreferences.getString("status");
    //
    // UserLoginModel? userData = UserLoginModel(
    //   name: user.name,
    //   id: user.id,
    //   email: user.email,
    //   address: user.address,
    //   mobile: user.mobile,
    //   status: user.status,
    // );
    // return userData;
  }
}
