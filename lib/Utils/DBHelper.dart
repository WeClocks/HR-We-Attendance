import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/PunchInOutDataModel.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';

class DBHelper
{
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();

  Database? database;

  Future<Database?> checkDb()
  async {
    if(database != null)
    {
      return database;
    }
    return await createDB();
  }

  Future<Database> createDB()
  async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,'we_attendance.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String punchInOutQuery = "CREATE TABLE punchInOut (id INTEGER PRIMARY KEY AUTOINCREMENT, inDateTime TEXT, outDateTime TEXT, lat TEXT, lag TEXT, punchIn TEXT, punchOut TEXT)";
        String trackingQuery = "CREATE TABLE tracking (id INTEGER PRIMARY KEY AUTOINCREMENT, staff_id TEXT, created_at TEXT, updated_at TEXT, lat TEXT, long TEXT, gps_active TEXT)";
        String userQuery = "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, first_name TEXT, middle_name TEXT, last_name TEXT)";
        db.execute(punchInOutQuery);
        db.execute(trackingQuery);
      },
    );
  }

  /// ************* PUNCH IN-OUT DATABASE *************

  Future<void> insertPunchInOutData({required PunchInOutDataModel weAttendanceDataModel})
  async {
    database = await checkDb();

    database!.insert('punchInOut', {
      // "inDateTime": weAttendanceDataModel.inDateTime?.toIso8601String(),
      // "outDateTime": weAttendanceDataModel.outDateTime?.toIso8601String(),
      // "lat": weAttendanceDataModel.lat,
      // "lag": weAttendanceDataModel.lag,
      // "punchIn": weAttendanceDataModel.punchIn.toString(),
      // "punchOut": weAttendanceDataModel.punchOut.toString(),
      "inDateTime": weAttendanceDataModel.clockIn?.toIso8601String(),
      "outDateTime": weAttendanceDataModel.clockOut?.toIso8601String(),
      "lat": weAttendanceDataModel.clockInLat,
      "lag": weAttendanceDataModel.clockInLong,
      "punchIn": (weAttendanceDataModel.clockIn != null).toString(),
      "punchOut": (weAttendanceDataModel.clockOut != null).toString(),
    },);
  }

  Future<void> updatePunchInOutOneData({required PunchInOutDataModel weAttendanceDataModel})
  async {
    database = await checkDb();

    database!.update('punchInOut', {
      // "inDateTime": weAttendanceDataModel.inDateTime?.toIso8601String(),
      // "outDateTime": weAttendanceDataModel.outDateTime?.toIso8601String(),
      // "lat": weAttendanceDataModel.lat,
      // "lag": weAttendanceDataModel.lag,
      // "punchIn": weAttendanceDataModel.punchIn.toString(),
      // "punchOut": weAttendanceDataModel.punchOut.toString(),
      "inDateTime": weAttendanceDataModel.clockIn?.toIso8601String(),
      "outDateTime": weAttendanceDataModel.clockOut?.toIso8601String(),
      "lat": weAttendanceDataModel.clockOutLat,
      "lag": weAttendanceDataModel.clockOutLong,
      "punchIn": (weAttendanceDataModel.clockIn != null).toString(),
      "punchOut": (weAttendanceDataModel.clockOut != null).toString(),
    },where: "id = ?",whereArgs: [weAttendanceDataModel.id]);
  }

  Future<List<PunchInOutDataModel>?> readPunchInOutData()
  async {
    database = await checkDb();

    String readPunchInOutQuery = "SELECT * FROM punchInOut";

    List punchInOutList = await database!.rawQuery(readPunchInOutQuery);

    if(punchInOutList.isNotEmpty)
    {
      return punchInOutList.map((e) => PunchInOutDataModel.fromJson(e)).toList();
    }
    return null;
  }

  Future<PunchInOutDataModel?> readPunchInOutDataDateWise({required DateTime dateTime})
  async {
    database = await checkDb();

    String readPunchInOutQuery = "SELECT * FROM punchInOut";

    List punchInOutList = await database!.rawQuery(readPunchInOutQuery);
    if(punchInOutList.isNotEmpty)
    {
      List<PunchInOutDataModel> punchInOutDataList =  punchInOutList.map((e) => PunchInOutDataModel.fromJson(e)).toList();
      List<PunchInOutDataModel> finalPunchInOutDataList = punchInOutDataList.where((element) => DateTime(element.clockIn!.year,element.clockIn!.month,element.clockIn!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0).toList();
      return finalPunchInOutDataList.isNotEmpty ? finalPunchInOutDataList.last : null;
    }
    return null;
  }

  Future<void> deletePunchInOutOneData({required int id})
  async {
    database = await checkDb();

    database!.delete('punchInOut',where: "id = ?",whereArgs: [id],);
  }

  /// ************* TRACKING DATABASE *************

  Future<void> insertTrackingData({required TrackingModel trackingModel})
  async {
    database = await checkDb();

    database!.insert('tracking',{
      "lat": trackingModel.lat,
      "long": trackingModel.long,
      "staff_id": trackingModel.staffId,
      "gps_active": trackingModel.gpsActive,
      "created_at": trackingModel.createdAt?.toString(),
      "updated_at": trackingModel.updatedAt?.toString(),
    });
  }

  Future<List<TrackingModel>?> readTrackingData()
  async {
    database = await checkDb();

    String readPunchInOutQuery = "SELECT * FROM tracking";

    List trackingList = await database!.rawQuery(readPunchInOutQuery);

    if(trackingList.isNotEmpty)
    {
      return trackingList.map((e) => TrackingModel.fromJson(e)).toList();
    }
    return null;
  }


  Future<TrackingModel?> readTrackingDataDateWise({required DateTime dateTime, required String staff_id})
  async {
    database = await checkDb();

    String readPunchInOutQuery = "SELECT * FROM tracking";

    List trackingList = await database!.rawQuery(readPunchInOutQuery);

    if(trackingList.isNotEmpty)
    {
      List<TrackingModel> trackingDataList =  trackingList.map((e) => TrackingModel.fromJson(e)).toList();
      return trackingDataList.where((element) => (DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0 && element.staffId == staff_id)).toList().isEmpty ? null : trackingDataList.where((element) => (DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0 && element.staffId == staff_id)).toList().last;
    }
    return null;
  }

  Future<List<TrackingModel>?> readTrackingDataListDateWise({required DateTime dateTime, required String staff_id})
  async {
    database = await checkDb();

    String readPunchInOutQuery = "SELECT * FROM tracking";

    List trackingList = await database!.rawQuery(readPunchInOutQuery);

    if(trackingList.isNotEmpty)
    {
      List<TrackingModel> trackingDataList =  trackingList.map((e) => TrackingModel.fromJson(e)).toList();
      return trackingDataList.where((element) => (DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(dateTime.year,dateTime.month,dateTime.day)) == 0 && element.staffId == staff_id)).toList();
    }
    return null;
  }

  Future<void> deletetrackingOneData({required int id})
  async {
    database = await checkDb();

    database!.delete('tracking',where: "id = ?",whereArgs: [id],);
  }

  Future<void> updateTrackingData({required TrackingModel trackingModel})
  async {
    database = await checkDb();

    database!.update('tracking',{
      "lat": trackingModel.lat,
      "long": trackingModel.long,
      "staff_id": trackingModel.staffId,
      "gps_active": trackingModel.gpsActive,
      "created_at": trackingModel.createdAt?.toString(),
      "updated_at": trackingModel.updatedAt?.toString(),
    },where: "id = ?",whereArgs: [trackingModel.id]);
  }

}