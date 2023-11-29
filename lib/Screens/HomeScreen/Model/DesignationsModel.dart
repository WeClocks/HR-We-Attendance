// To parse this JSON data, do
//
//     final designationsModel = designationsModelFromJson(jsonString);

import 'dart:convert';

DesignationsModel designationsModelFromJson(String str) => DesignationsModel.fromJson(json.decode(str));

String designationsModelToJson(DesignationsModel data) => json.encode(data.toJson());

class DesignationsModel {
  final String? id;
  final dynamic companyId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  DesignationsModel({
    this.id,
    this.companyId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory DesignationsModel.fromJson(Map<String, dynamic> json) => DesignationsModel(
    id: json["id"],
    companyId: json["company_id"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
