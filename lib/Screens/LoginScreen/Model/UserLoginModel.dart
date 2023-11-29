// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  String? message;
  bool? success;
  String? id;
  String? name;
  String? address;
  String? mobile;
  String? email;
  String? password;
  String? status;

  UserLoginModel({
    this.message,
    this.success,
    this.id,
    this.name,
    this.address,
    this.mobile,
    this.email,
    this.password,
    this.status,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
    message: json["message"],
    success: json["success"],
    id: json["id"],
    name: json["name"],
    address: json["address"],
    mobile: json["mobile"],
    email: json["email"],
    password: json["password"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "id": id,
    "name": name,
    "address": address,
    "mobile": mobile,
    "email": email,
    "password": password,
    "status": status,
  };
}
