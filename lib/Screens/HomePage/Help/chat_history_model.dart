
import 'dart:convert';

ChatHistory chatHistoryFromJson(String str) => ChatHistory.fromJson(json.decode(str));

String chatHistoryToJson(ChatHistory data) => json.encode(data.toJson());

class ChatHistory {
    ChatHistory({
        required this.msg,
        required this.data,
    });

    String msg;
    List<HistoryDataList> data;

    factory ChatHistory.fromJson(Map<String, dynamic> json) => ChatHistory(
        msg: json["msg"],
        data: List<HistoryDataList>.from(json["data"].map((x) => HistoryDataList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class HistoryDataList {
    HistoryDataList({
        required this.id,
        required this.userId,
        required this.message,
        required this.roomName,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    String id;
    String userId;
    String message;
    String roomName;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory HistoryDataList.fromJson(Map<String, dynamic> json) => HistoryDataList(
        id: json["_id"],
        userId: json["userId"],
        message: json["message"],
        roomName: json["roomName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "message": message,
        "roomName": roomName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
