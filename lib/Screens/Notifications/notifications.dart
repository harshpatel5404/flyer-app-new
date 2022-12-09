import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String? tokenAPI;
  @override
  void initState(){
    super.initState();
    getNotifications();
  }

  Future getNotifications()async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    var token = tokenAPI;
    var url = "https://ondemandflyers.com:8087/distributor/notifications";
    var response = await http.get(Uri.parse(url,),

      headers: {
        // 'x-access-token': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDhmNmEwOTQ4MzhiNjc5MDZiN2VmOCIsImlhdCI6MTY1ODQ3MTc2NiwiZXhwIjoxNjY4ODM5NzY2fQ.3tWNWqu9CQCAFMAlFJHsVQhAaMllwUugDY7xLaR7R-I",
        "content-type": "application/json",
        'x-access-token': '$token',
      },);
    print("printToken : $tokenAPI");
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    setState((){
      print("printToken : $tokenAPI");
      _notificationList = jsonData['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: flyBackground,
        appBar: AppBar(
          backgroundColor: flyBackground,
          elevation: 0,
          leading: Container(
              child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
          title: Text("Notifications"),
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans-Semibold",
            fontSize: 18  ,
            color: Colors.black,

          ),
          titleSpacing: 2,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _notificationList.isNotEmpty ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _notificationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                boxShadow: [BoxShadow(
                                    offset: Offset(4,4),
                                    blurRadius: 5,
                                    color: flyGray4
                                )]
                            ),
                            height: H*0.15,
                            width: W*0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: H*0.03,),
                                  Text("${_notificationList[index]["title"]}",
                                    style: TextStyle(
                                        fontFamily: "Opensans-Bold",
                                        fontSize: 15,
                                        color: Color(0xFF626262)
                                    ),
                                  ),
                                  SizedBox(height: H*0.01,),
                                  Text("${_notificationList[index]["description"]}",
                                    style: TextStyle(
                                        fontFamily: "Opensans-Regular",
                                        fontSize: 12,
                                        color: Color(0xFF626262)
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                        SizedBox(height: H*0.02,)
                      ],
                    );
                  },
                ) : Padding(
                  padding:  EdgeInsets.only(top: H*0.02),
                  child:Text(
                    "Look's like their is no notifications...",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Bold',
                        color: flyOrange2),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
List<dynamic> _notificationList = [];
var Name = "";