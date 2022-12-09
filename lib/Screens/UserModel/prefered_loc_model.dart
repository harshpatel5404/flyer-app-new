// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.msg,
    required this.data,
  });

  String msg;
  List<PreferedLocModel> data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    msg: json["msg"],
    data: List<PreferedLocModel>.from(json["data"].map((x) => PreferedLocModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PreferedLocModel {
  PreferedLocModel({
   required this.id,
   required this.latitude,
   required this.longitude,
   required this.address,
   required this.city,
  });

  String id;
  double latitude;
  double longitude;
  String address;
  String city;

  factory PreferedLocModel.fromJson(Map<String, dynamic> json) => PreferedLocModel(
    id: json["_id"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    address: json["address"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "city": city,
  };
}
