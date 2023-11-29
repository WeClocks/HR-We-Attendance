// To parse this JSON data, do
//
//     final staffModel = staffModelFromJson(jsonString);

import 'dart:convert';

StaffModel staffModelFromJson(String str) => StaffModel.fromJson(json.decode(str));

String staffModelToJson(StaffModel data) => json.encode(data.toJson());

class StaffModel {
  String? id;
  String? deviceId;
  String? name;
  DateTime? dob;
  String? mobile;
  String? email;
  String? address;
  String? city;
  String? password;
  String? setPasswordToken;
  DateTime? createdAt;
  String? updatedAt;
  String? deletedAt;

  StaffModel({
    this.id,
    this.deviceId,
    this.name,
    this.dob,
    this.mobile,
    this.email,
    this.address,
    this.city,
    this.password,
    this.setPasswordToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
    id: json["id"],
    deviceId: json["device_id"],
    name: json["name"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    mobile: json["mobile"],
    email: json["email"],
    address: json["address"],
    city: json["city"],
    password: json["password"],
    setPasswordToken: json["set_password_token"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "device_id": deviceId,
    "name": name,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "mobile": mobile,
    "email": email,
    "address": address,
    "city": city,
    "password": password,
    "set_password_token": setPasswordToken,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}
