// To parse this JSON data, do
//
//     final siteDataModel = siteDataModelFromJson(jsonString);

import 'dart:convert';

SiteDataModel siteDataModelFromJson(String str) => SiteDataModel.fromJson(json.decode(str));

String siteDataModelToJson(SiteDataModel data) => json.encode(data.toJson());

class SiteDataModel {
  final bool? success;
  final String? id;
  final String? name;
  final String? mobile;
  final String? ranges;
  final String? address;
  final String? lat;
  final String? longs;

  SiteDataModel({
    this.success,
    this.id,
    this.name,
    this.mobile,
    this.ranges,
    this.address,
    this.lat,
    this.longs,
  });

  factory SiteDataModel.fromJson(Map<String, dynamic> json) => SiteDataModel(
    success: json["success"],
    id: json["id"],
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
    "name": name,
    "mobile": mobile,
    "ranges": ranges,
    "address": address,
    "lat": lat,
    "longs": longs,
  };
}
