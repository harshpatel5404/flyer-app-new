import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/HomePage/PreferedLocation/update_new_location.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Constants/colors.dart';
import '../../Notifications/notifications.dart';
import '../../SharedPrefrence/sharedprefrence.dart';
import '../../UserModel/prefered_loc_model.dart';

class PreferedLocaEdit extends StatefulWidget {
  const PreferedLocaEdit({Key? key}) : super(key: key);

  @override
  State<PreferedLocaEdit> createState() => _PreferedLocaEditState();
}

class _PreferedLocaEditState extends State<PreferedLocaEdit> {
  @override
  void initState() {
    setState(() {
      getMyLocations();
    });
    super.initState();
  }

  String? tokenAPI;
  List<dynamic> _locations = [];
  bool _loading = false;
  Future getMyLocations() async {
    try {
      tokenAPI = await getToken();
      setState(() {
        tokenAPI;
      });
      setState(() {
        _loading = true;
      });
      var url =
          "https://ondemandflyers.com:8087/distributor/myPreferredLocations";
      var response = await http.get(
        Uri.parse(
          url,
        ),
        headers: {
          'x-access-token': "$tokenAPI",
        },
      );
      // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      // print(jobModel.jobTitle);
      var jsonData = jsonDecode(response.body);
      print(response.statusCode);
      setState(() {
        print("this is my response : ${jsonData['data']}");
        print("This is address : ${jsonData['data'][0]['address']}");
        _locations = jsonData['data'];
        print(_locations[0]['address']);
        _loading = false;
      });
      print(jsonData);
    } catch (e) {}
  }

  bool checkBox = false;
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
                  onTap: () {
                    Get.to(HomePage());
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF4D4D4D),
                  ))),
          title: Text("Preferred Location"),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _locations.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _locations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            height: H * 0.23,
                            child: Container(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(4, 4),
                                              blurRadius: 5,
                                              color: flyGray4)
                                        ]),
                                    height: H * 0.2,
                                    width: W * 0.9,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Address",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        "Opensans-Semibold",
                                                    color: Color(0xFF828282)),
                                              ),
                                              Checkbox(
                                                  value: checkBox,
                                                  checkColor: Colors.white,
                                                  activeColor: flyOrange2,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      checkBox = value!;
                                                    });
                                                  }),
                                            ],
                                          ),
                                          Text(
                                            "${_locations[index]['address']}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF828282),
                                                fontFamily: "Opensans-Regular"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          )
                        ],
                      );
                    },
                  )
                : Padding(
                    padding: EdgeInsets.only(top: H * 0.02),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: flyOrange2,
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(bottom: H * 0.13),
              child: Container(
                width: W * 0.8,
                height: H * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                        colors: [flyOrange1, flyOrange2],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight)),
                child: Center(
                    child: InkWell(
                  onTap: () {
                    Get.to(UpdateNewLocation());
                  },
                  child: Text(
                    "Update New Location",
                    style: TextStyle(
                        fontFamily: "Opensans-Bold",
                        fontSize: 16,
                        color: Colors.white),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
