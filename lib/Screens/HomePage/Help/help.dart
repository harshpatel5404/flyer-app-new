import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/Api/all_api.dart';
import 'package:flyerapp/Screens/HomePage/Help/chat_controller.dart';
import 'package:get/get.dart';
import '../../../Constants/colors.dart';
import '../../Notifications/notifications.dart';
import '../../SharedPrefrence/sharedprefrence.dart';
import '../HomePage/homepage_main.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  //IO.Socket? socket;
  var userName;

  //void connect() async {
  //   socket = IO.io(
  //     "https://nodeserver.mydevfactory.com:8087",
  //     {
  //       'transports': ['websocket'],
  //       'autoConnect': false,
  //     },
  //   );
  //   socket!.connect();
  //   try {
  //     socket!.onConnect((data) {
  //       print("Connected");
  // socket!.on('message', (data) {
  //   print(data);
  //   var ss = data;
  //   // print(data['message']);
  //   // print(data['username']);
  //   chatController.messageslist.add(ChatMessage(
  //       messageContent: data["message"].toString(),
  //       messageType: data["username"].toString()));
  // });
  // NotificationService().showNotification(
  //     0, data["username"].toString(), data["message"].toString());
  // print(chatController.messageslist);
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   socket!.onDisconnect((data) => print("DisConnected"));
  //   print(socket!.connected);
  //}

  ChatController chatController = Get.put(ChatController());
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // setId("62d7ef37874cc852d6f8536e");
    // setName("harshad");
    // connect();
    chatController.getuserid();
    chatController.getMessage();
  }

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: flyBackground,
      appBar: AppBar(
        backgroundColor: flyBackground,
        elevation: 0,
        leading: Container(
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4D4D4D),
                ))),
        title: Text("Help"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 18,
          color: Colors.black,
        ),
        titleSpacing: 2,
        actions: [
          InkWell(
            onTap: () {
              Get.to(Notifications());
            },
            child: Padding(
              padding: EdgeInsets.only(right: W * 0.04),
              child: Center(
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: flyBlack2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: W * 0.03,
                      ),
                      child: CircleAvatar(
                        backgroundColor: flyOrange2,
                        radius: 7,
                        child: Text(
                          "0",
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Obx(
        () => chatController.messageslist.isNotEmpty
            ? Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: H * 0.05),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: chatController.messageslist.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: (chatController
                                            .messageslist[index].messageType !=
                                        chatController.id.value
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (chatController.messageslist[index]
                                                .messageType !=
                                            chatController.id.value
                                        ? Color.fromARGB(255, 197, 197, 197)
                                        : flyOrange1),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    chatController
                                        .messageslist[index].messageContent,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "OpenSans-Regular",
                                        color: chatController
                                                    .messageslist[index]
                                                    .messageType !=
                                                chatController.id.value
                                            ? Color(0xff4b4b4b)
                                            : Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: H * 0.069,
                        width: W,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 0.5)),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: W,
                                child: TextFormField(
                                  controller: msgController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'OpenSans-Regular',
                                          color: flyGray3),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: InputBorder.none),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: W * 0.03),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: W * 0.03,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        userName = await getName();
                                        print(userName);
                                        if (msgController.text != "") {
                                          // setId("62d7ef37874cc852d6f8536e");
                                          // setName("harshad");
                                          var userId = await getId();
                                          var name = await getName();
                                          print(name);
                                          // NotificationService().showNotification(
                                          //     0, "test", "body", "payload");
                                          print(userId);
                                          print(msgController.text);
                                          socket!.emit('message', {
                                            "message": msgController.text,
                                            "userId": userId,
                                            "username": name,
                                            "roomName": userId
                                          });
                                          functionForSocket({
                                            "type": "Chat",
                                            "title":
                                                "'You have one new message from $userName'",
                                            "description":
                                                "$userName sent you ${msgController.text}",
                                          });

                                          scrollController.animateTo(
                                              scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);

                                          AllApi().setChatMessage(
                                              msgController.text);
                                          chatController.messageslist.add(
                                              ChatMessage(
                                                  messageContent:
                                                      msgController.text,
                                                  messageType:
                                                      userId.toString()));
                                          msgController.clear();
                                        } else {
                                          print("write");
                                        }
                                      },
                                      child: CircleAvatar(
                                          radius: 21,
                                          backgroundColor: flyOrange3,
                                          child: Image.asset(
                                              "assets/images/send.png")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            : chatController.chatmsg.value == ""
                ? Center(
                    child: CircularProgressIndicator(
                      color: flyOrange1,
                    ),
                  )
                : Text(chatController.chatmsg.value),
      ),
    );
  }
}

void functionForSocket(Object data) {
  socket!.emit('notification', {data});
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}
