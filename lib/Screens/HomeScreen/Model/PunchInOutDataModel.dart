// To parse this JSON data, do
//
//     final punchInOutDataModel = punchInOutDataModelFromJson(jsonString);

import 'dart:convert';

PunchInOutDataModel punchInOutDataModelFromJson(String str) => PunchInOutDataModel.fromJson(json.decode(str));

String punchInOutDataModelToJson(PunchInOutDataModel data) => json.encode(data.toJson());

class PunchInOutDataModel {
  final String? id;
  final String? staffId;
  final String? staffJoiningId;
  final String? departmentId;
  final String? subCompanyId;
  final String? type;
  final String? remark;
  final DateTime? clockIn;
  final String? clockInLat;
  final String? clockInLong;
  final String? clockInAddress;
  final DateTime? clockOut;
  final String? clockOutLat;
  final String? clockOutType;
  final String? clockOutLong;
  final String? clockOutAddress;
  final String? hours;
  final String? salaryAmount;
  final String? clockInAttendanceBy;
  final String? clockOutAttendanceBy;
  final DateTime? photoClockIn;
  final DateTime? photoClockOut;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PunchInOutDataModel({
    this.id,
    this.staffId,
    this.staffJoiningId,
    this.departmentId,
    this.subCompanyId,
    this.type,
    this.remark,
    this.clockIn,
    this.clockInLat,
    this.clockInLong,
    this.clockInAddress,
    this.clockOut,
    this.clockOutType,
    this.clockOutLat,
    this.clockOutLong,
    this.clockOutAddress,
    this.hours,
    this.salaryAmount,
    this.clockInAttendanceBy,
    this.clockOutAttendanceBy,
    this.photoClockIn,
    this.photoClockOut,
    this.createdAt,
    this.updatedAt,
  });

  factory PunchInOutDataModel.fromJson(Map<String, dynamic> json) => PunchInOutDataModel(
    id: json["id"],
    staffId: json["staff_id"],
    staffJoiningId: json["staff_joining_id"],
    departmentId: json["department_id"],
    subCompanyId: json["sub_company_id"],
    type: json["type"],
    remark: json["remark"],
    clockIn: json["clock_in"] == null ? null : DateTime.parse(json["clock_in"]),
    clockInLat: json["clock_in_lat"],
    clockInLong: json["clock_in_long"],
    clockInAddress: json["clock_in_address"],
    clockOut: json["clock_out"] == null ? null : DateTime.parse(json["clock_out"]),
    clockOutLat: json["clock_out_lat"],
    clockOutType: json["clock_out_type"],
    clockOutLong: json["clock_out_long"],
    clockOutAddress: json["clock_out_address"],
    hours: json["hours"],
    salaryAmount: json["salary_amount"],
    clockInAttendanceBy: json["clock_in_attendance_by"],
    clockOutAttendanceBy: json["clock_out_attendance_by"],
    photoClockIn: json["photo_clock_in"] == null ? null : DateTime.parse(json["photo_clock_in"]),
    photoClockOut: json["photo_clock_out"] == null ? null : DateTime.parse(json["photo_clock_out"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "staff_id": staffId,
    "staff_joining_id": staffJoiningId,
    "department_id": departmentId,
    "sub_company_id": subCompanyId,
    "type": type,
    "remark": remark,
    "clock_in": clockIn?.toIso8601String(),
    "clock_in_lat": clockInLat,
    "clock_in_long": clockInLong,
    "clock_in_address": clockInAddress,
    "clock_out": clockOut?.toIso8601String(),
    "clock_out_type": clockOutType,
    "clock_out_lat": clockOutLat,
    "clock_out_long": clockOutLong,
    "clock_out_address": clockOutAddress,
    "hours": hours,
    "salary_amount": salaryAmount,
    "clock_in_attendance_by": clockInAttendanceBy,
    "clock_out_attendance_by": clockOutAttendanceBy,
    "photo_clock_in": photoClockIn?.toIso8601String(),
    "photo_clock_out": photoClockOut?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
