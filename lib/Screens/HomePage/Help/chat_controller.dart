import 'dart:convert';
import 'package:flyerapp/Screens/HomePage/Help/chat_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../SharedPrefrence/sharedprefrence.dart';
import 'help.dart';

class ChatController extends GetxController {
  RxList<ChatMessage> messageslist = <ChatMessage>[].obs;
  List<HistoryDataList> historydatalist = <HistoryDataList>[].obs;
  RxBool ischatLoading = true.obs;
  RxString chatmsg = "".obs;
  RxString id = "".obs;

  void getuserid() async {
    id.value = (await getId())!;
    print(id.value);
  }

  Future<List<HistoryDataList>?> getMessage() async {
    ischatLoading.value = true;
    var roomname = await getId();
    var baseUrl = "https://ondemandflyers.com:8087";
    final response = await http.get(
        Uri.parse("$baseUrl/chat/distributorChatHistory/$roomname"),
        headers: {
          "Content-Type": "application/json",
        });
    try {
      List<HistoryDataList> historydatalist = [];
      if (response.statusCode == 200) {
        messageslist.clear();
        ChatHistory chatHistory =
            ChatHistory.fromJson(jsonDecode(response.body));
        historydatalist = chatHistory.data;
        if (historydatalist.isEmpty) {
          ischatLoading.value = false;
          print("userid");
          messageslist.add(
            ChatMessage(messageContent: "Start to chat for getting help", messageType:"distributor"),
          );
        }
        for (var ele in historydatalist) {
          messageslist.add(
            ChatMessage(messageContent: ele.message, messageType: ele.userId),
          );
        }
      } else {
        var data = jsonDecode(response.body);
        print(data);
          ischatLoading.value = false;
          chatmsg.value = "Some Error Occured!";
        return historydatalist;
      }
    } catch (e) {
        ischatLoading.value = false;
          chatmsg.value = "Somwthing Went Wrong!";
      print(e.toString());
      return null;
    }
  }
}
