// To parse this JSON data, do
//
//     final leaveTypeDataModel = leaveTypeDataModelFromJson(jsonString);

import 'dart:convert';

LeaveTypeDataModel leaveTypeDataModelFromJson(String str) => LeaveTypeDataModel.fromJson(json.decode(str));

String leaveTypeDataModelToJson(LeaveTypeDataModel data) => json.encode(data.toJson());

class LeaveTypeDataModel {
  int? id;
  bool? success;
  String? leaveTypeId;
  String? leaveTypeName;
  String? leaveNos;
  String? status;

  LeaveTypeDataModel({
    this.id,
    this.success,
    this.leaveTypeId,
    this.leaveTypeName,
    this.leaveNos,
    this.status,
  });

  factory LeaveTypeDataModel.fromJson(Map<String, dynamic> json) => LeaveTypeDataModel(
    id: json["id"],
    success: bool.parse(json["success"].toString()),
    leaveTypeId: json["leave_type_id"],
    leaveTypeName: json["leave_type_name"],
    leaveNos: json["leave_nos"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "success": success,
    "leave_type_id": leaveTypeId,
    "leave_type_name": leaveTypeName,
    "leave_nos": leaveNos,
    "status": status,
  };
}
