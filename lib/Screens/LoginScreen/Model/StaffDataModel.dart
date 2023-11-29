// To parse this JSON data, do
//
//     final staffDataModel = staffDataModelFromJson(jsonString);

import 'dart:convert';

StaffDataModel staffDataModelFromJson(String str) => StaffDataModel.fromJson(json.decode(str));

String staffDataModelToJson(StaffDataModel data) => json.encode(data.toJson());

class StaffDataModel {
  final bool? success;
  final String? id;
  final String? staffId;
  final String? companyId;
  final String? departmentId;
  final String? designationId;
  final String? salaryType;
  final String? salaryAmount;
  final String? companyName;

  StaffDataModel({
    this.success,
    this.id,
    this.staffId,
    this.companyId,
    this.departmentId,
    this.designationId,
    this.salaryType,
    this.salaryAmount,
    this.companyName,
  });

  factory StaffDataModel.fromJson(Map<String, dynamic> json) => StaffDataModel(
    success: json["success"],
    id: json["id"],
    staffId: json["staff_id"],
    companyId: json["company_id"],
    departmentId: json["department_id"],
    designationId: json["designation_id"],
    salaryType: json["salary_type"],
    salaryAmount: json["salary_amount"],
    companyName: json["company_name"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "id": id,
    "staff_id": staffId,
    "company_id": companyId,
    "department_id": departmentId,
    "designation_id": designationId,
    "salary_type": salaryType,
    "salary_amount": salaryAmount,
    "company_name": companyName,
  };
}
