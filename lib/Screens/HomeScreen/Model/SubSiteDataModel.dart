// To parse this JSON data, do
//
//     final subSiteDataModel = subSiteDataModelFromJson(jsonString);

import 'dart:convert';

SubSiteDataModel subSiteDataModelFromJson(String str) => SubSiteDataModel.fromJson(json.decode(str));

String subSiteDataModelToJson(SubSiteDataModel data) => json.encode(data.toJson());

class SubSiteDataModel {
  final bool? success;
  final String? id;
  final String? companyId;
  final String? name;
  final String? mobile;
  final String? ranges;
  final String? address;
  final String? lat;
  final String? longs;

  SubSiteDataModel({
    this.success,
    this.id,
    this.companyId,
    this.name,
    this.mobile,
    this.ranges,
    this.address,
    this.lat,
    this.longs,
  });

  factory SubSiteDataModel.fromJson(Map<String, dynamic> json) => SubSiteDataModel(
    success: json["success"],
    id: json["id"],
    companyId: json["company_id"],
    name: json["name"],
    mobile: json["mobile"],
    ranges: json["ranges"],
    address: json["address"],
    lat: json["lat"],
    longs: json["longs"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "id": id,
    "company_id": companyId,
    "name": name,
    "mobile": mobile,
    "ranges": ranges,
    "address": address,
    "lat": lat,
    "longs": longs,
  };
}
