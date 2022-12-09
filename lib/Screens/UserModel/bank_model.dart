// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
  BankModel({
    required this.msg,
    required this.data,
  });

  String msg;
  List<BankDetails> data;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    msg: json["msg"],
    data: List<BankDetails>.from(json["data"].map((x) => BankDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BankDetails {
  BankDetails({
   required this.id,
   required this.owner,
   required this.accountHolderName,
   required this.accountNumber,
   required this.ifsc,
   required this.createdAt,
   required this.updatedAt,
   required this.v,
  });

  String id;
  String owner;
  String accountHolderName;
  String accountNumber;
  String ifsc;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    id: json["_id"],
    owner: json["owner"],
    accountHolderName: json["accountHolderName"],
    accountNumber: json["accountNumber"],
    ifsc: json["ifsc"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "owner": owner,
    "accountHolderName": accountHolderName,
    "accountNumber": accountNumber,
    "ifsc": ifsc,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
