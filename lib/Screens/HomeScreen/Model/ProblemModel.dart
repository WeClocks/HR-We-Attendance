// To parse this JSON data, do
//
//     final problemModel = problemModelFromJson(jsonString);

import 'dart:convert';

ProblemModel problemModelFromJson(String str) => ProblemModel.fromJson(json.decode(str));

String problemModelToJson(ProblemModel data) => json.encode(data.toJson());

class ProblemModel {
  int? probId;
  String? userId;
  String? problem;
  String? prob_img;
  DateTime? insDateTime;
  String? status;

  ProblemModel({
    this.probId,
    this.userId,
    this.problem,
    this.prob_img,
    this.insDateTime,
    this.status,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) => ProblemModel(
    probId: int.parse(json["prob_id"].toString()),
    userId: json["user_id"],
    problem: json["problem"],
    prob_img: json["prob_img"],
    insDateTime: json["ins_date_time"] == null ? null : DateTime.parse(json["ins_date_time"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "prob_id": probId,
    "user_id": userId,
    "problem": problem,
    "prob_img": prob_img,
    "ins_date_time": insDateTime?.toIso8601String(),
    "status": status,
  };
}
