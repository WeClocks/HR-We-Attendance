// To parse this JSON data, do
//
//     final leaveDataModel = leaveDataModelFromJson(jsonString);

import 'dart:convert';

LeaveDataModel leaveDataModelFromJson(String str) => LeaveDataModel.fromJson(json.decode(str));

String leaveDataModelToJson(LeaveDataModel data) => json.encode(data.toJson());

class LeaveDataModel {
  int? leaveId;
  String? userId;
  String? schoolId;
  String? clusterId;
  String? aprovedId;
  String? leaveTypeId;
  String? startDate;
  String? endDate;
  String? days;
  String? reason;
  String? photo;
  String? leaveStatus;
  String? leaveStatusReason;
  DateTime? leaveStatusDateTime;
  DateTime? insDateTime;
  DateTime? updateDateTime;
  String? status;

  LeaveDataModel({
    this.leaveId,
    this.userId,
    this.schoolId,
    this.clusterId,
    this.aprovedId,
    this.leaveTypeId,
    this.startDate,
    this.endDate,
    this.days,
    this.reason,
    this.photo,
    this.leaveStatus,
    this.leaveStatusReason,
    this.leaveStatusDateTime,
    this.insDateTime,
    this.updateDateTime,
    this.status,
  });

  factory LeaveDataModel.fromJson(Map<String, dynamic> json) => LeaveDataModel(
    leaveId: int.parse(json["leave_id"].toString()),
    userId: json["user_id"],
    schoolId: json["school_id"],
    clusterId: json["cluster_id"],
    aprovedId: json["aproved_id"],
    leaveTypeId: json["leave_type_id"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    days: json["days"],
    reason: json["reason"],
    photo: json["photo"],
    leaveStatus: json["leave_status"],
    leaveStatusReason: json["leave_status_reason"],
    leaveStatusDateTime: json["leave_status_date_time"] == null ? null : DateTime.parse(json["leave_status_date_time"]),
    insDateTime: json["ins_date_time"] == null ? null : DateTime.parse(json["ins_date_time"]),
    updateDateTime: json["update_date_time"] == null ? null : DateTime.parse(json["update_date_time"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "leave_id": leaveId,
    "user_id": userId,
    "school_id": schoolId,
    "cluster_id": clusterId,
    "aproved_id": aprovedId,
    "leave_type_id": leaveTypeId,
    "start_date": startDate,
    "end_date": endDate,
    "days": days,
    "reason": reason,
    "photo": photo,
    "leave_status": leaveStatus,
    "leave_status_reason": leaveStatusReason,
    "leave_status_date_time": leaveStatusDateTime?.toIso8601String(),
    "ins_date_time": insDateTime?.toIso8601String(),
    "update_date_time": updateDateTime?.toIso8601String(),
    "status": status,
  };
}
