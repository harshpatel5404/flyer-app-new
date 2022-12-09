// To parse this JSON data, do
//
//     final jobModel = jobModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

JobModel jobModelFromJson(String str) => JobModel.fromJson(json.decode(str));

String jobModelToJson(JobModel data) => json.encode(data.toJson());

class JobModel {
  JobModel({
    required this.msg,
    required this.data,
  });

  String msg;
  List<Datum> data;

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.startLocation,
    required this.endLocation,
    required this.isActive,
    required this.status,
    required this.id,
    required this.jobTitle,
    required this.jobDescription,
    required this.startDate,
    required this.endDate,
    required this.flyersCount,
    required this.doorHangersCount,
    required this.peopleCount,
    required this.numOfDaysRequired,
    required this.hourlyRate,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  Location startLocation;
  Location endLocation;
  bool isActive;
  String status;
  String id;
  String jobTitle;
  String jobDescription;
  DateTime startDate;
  DateTime endDate;
  int flyersCount;
  int doorHangersCount;
  int peopleCount;
  int numOfDaysRequired;
  int hourlyRate;
  String bannerImage;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    startLocation: Location.fromJson(json["startLocation"]),
    endLocation: Location.fromJson(json["endLocation"]),
    isActive: json["isActive"],
    status: json["status"],
    id: json["_id"],
    jobTitle: json["jobTitle"],
    jobDescription: json["jobDescription"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    flyersCount: json["flyersCount"],
    doorHangersCount: json["doorHangersCount"],
    peopleCount: json["peopleCount"],
    numOfDaysRequired: json["numOfDaysRequired"],
    hourlyRate: json["hourlyRate"],
    bannerImage: json["bannerImage"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "startLocation": startLocation.toJson(),
    "endLocation": endLocation.toJson(),
    "isActive": isActive,
    "status": status,
    "_id": id,
    "jobTitle": jobTitle,
    "jobDescription": jobDescription,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "flyersCount": flyersCount,
    "doorHangersCount": doorHangersCount,
    "peopleCount": peopleCount,
    "numOfDaysRequired": numOfDaysRequired,
    "hourlyRate": hourlyRate,
    "bannerImage": bannerImage,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class Location {
  Location({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.address,
    required this.label,
  });

  double latitude;
  double longitude;
  String city;
  String address;
  String label;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    city: json["city"],
    address: json["address"],
    label: json["label"] == null ? null : json["label"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "city": city,
    "address": address,
    "label": label == null ? null : label,
  };
}
