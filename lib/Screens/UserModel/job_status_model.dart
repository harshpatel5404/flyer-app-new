// To parse this JSON data, do
//
//     final jobStatusModel = jobStatusModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

JobStatusModel jobStatusModelFromJson(String str) => JobStatusModel.fromJson(json.decode(str));

String jobStatusModelToJson(JobStatusModel data) => json.encode(data.toJson());

class JobStatusModel {
  JobStatusModel({
    required this.msg,
    required this.data,
  });

  String msg;
  DataModel data;

  factory JobStatusModel.fromJson(Map<String, dynamic> json) => JobStatusModel(
    msg: json["msg"],
    data: DataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": data.toJson(),
  };
}

class DataModel {
  DataModel({
    required this.isApproved,
    required this.shipmentStatus,
    required this.progress,
    required this.id,
    required this.isJobStarted,
    required this.job,
    required this.applicant,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  bool isApproved;
  String shipmentStatus;
  String progress;
  String id;
  bool isJobStarted;
  String job;
  String applicant;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    isApproved: json["isApproved"],
    shipmentStatus: json["shipmentStatus"],
    progress: json["progress"],
    id: json["_id"],
    isJobStarted: json["isJobStarted"],
    job: json["job"],
    applicant: json["applicant"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "isApproved": isApproved,
    "shipmentStatus": shipmentStatus,
    "progress": progress,
    "_id": id,
    "isJobStarted": isJobStarted,
    "job": job,
    "applicant": applicant,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
