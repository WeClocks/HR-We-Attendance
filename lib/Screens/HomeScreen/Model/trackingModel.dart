// To parse this JSON data, do
//
//     final trackingModel = trackingModelFromJson(jsonString);

import 'dart:convert';

TrackingModel trackingModelFromJson(String str) => TrackingModel.fromJson(json.decode(str));

String trackingModelToJson(TrackingModel data) => json.encode(data.toJson());

class TrackingModel {
  final String? id;
  final String? staffId;
  final String? lat;
  final String? long;
  final String? gpsActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TrackingModel({
    this.id,
    this.staffId,
    this.lat,
    this.long,
    this.gpsActive,
    this.createdAt,
    this.updatedAt,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) => TrackingModel(
    id: json["id"].toString(),
    staffId: json["staff_id"],
    lat: json["lat"],
    long: json["long"],
    gpsActive: json["gps_active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "staff_id": staffId,
    "lat": lat,
    "long": long,
    "gps_active": gpsActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
