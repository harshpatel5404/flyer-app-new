import 'dart:convert';
import 'package:flyerapp/Screens/Job%20Details/job_my_jobs_status.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Constants/colors.dart';
import '../../Job Details/job_details.dart';
import '../../Notifications/notifications.dart';
import '../../SharedPrefrence/sharedprefrence.dart';
import '../../UserModel/job_model.dart';
import '../homepage.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({Key? key}) : super(key: key);

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  String? tokenAPI;
  String? token;
  Future getUserData() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
  }

  List<dynamic> _myJobs = [];
  bool _loading = false;
  Future getMyJobData() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    setState(() {
      _loading = true;
    });
    setState(() {
      token = tokenAPI;
      print("mera token :$token");
    });
    var url = "https://ondemandflyers.com:8087/distributor/myJobs";
    var response = await http.get(
      Uri.parse(
        url,
      ),
      headers: {
        // 'x-access-token': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDhmNmEwOTQ4MzhiNjc5MDZiN2VmOCIsImlhdCI6MTY1ODQ3MTc2NiwiZXhwIjoxNjY4ODM5NzY2fQ.3tWNWqu9CQCAFMAlFJHsVQhAaMllwUugDY7xLaR7R-I",
        "content-type": "application/json",
        'x-access-token': '$token',
      },
    );
    print("printToken : $tokenAPI");
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    setState(() {
      print("printToken : $tokenAPI");
      _myJobs = jsonData['data'];
      _loading = false;
    });
  
  }

  @override
  void initState() {
    super.initState();
    getMyJobData();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
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
                  Get.to(HomePage());
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4D4D4D),
                ))),
        title: Text("My Jobs"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 20,
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
                          "!",
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: H * 0.02,
          ),
          _myJobs.isNotEmpty
              ? ListView.builder(
                  itemCount: _myJobs.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var date = _myJobs[index]['createdAt'];
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              setJobId(_myJobs[index]["_id"]);
                              setJobTitle(_myJobs[index]["jobTitle"]);
                              setJobCreatedDate(_myJobs[index]["createdAt"]);
                              setEndDate(_myJobs[index]["endDate"]);
                              setFlyersCount(_myJobs[index]["flyersCount"]);
                              setDoorHangersCount(
                                  _myJobs[index]["doorHangersCount"]);
                              setHourlyRate(_myJobs[index]["hourlyRate"]);
                              setNumOfDaysRequired(
                                  _myJobs[index]["numOfDaysRequired"]);
                              setStartLocation(
                                  _myJobs[index]["startLocation"]["address"]);
                              setEndLocation(
                                  _myJobs[index]["endLocation"]["address"]);
                              Get.to(JobDetailsMyJobs());
                            },
                            child: Container(
                              height: H * 0.15,
                              width: W * 0.9,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  _loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: flyOrange2,
                                        ))
                                      : Container(
                                          color: Colors.red,
                                          width: W * 0.3,
                                          height: H * 0.15,
                                          child: Image.network(
                                            _myJobs[index]['bannerImage'],
                                            fit: BoxFit.cover,
                                          )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: H * 0.03,
                                      ),
                                      Container(
                                        width: W * 0.6,
                                        child: Text(
                                          " ${_myJobs[index]['jobTitle']}",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 15,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Color(0xFF333333)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: H * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "  Location :",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'OpenSans-Regular',
                                                color: Color(0xFF808080)),
                                          ),
                                          Container(
                                            width: W * 0.4,
                                            child: Text(
                                              _myJobs[index]['startLocation']
                                                  ['address'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'OpenSans-Regular',
                                                  color: Color(0xFF333333)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "  Date :",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'OpenSans-Regular',
                                                color: Color(0xFF808080)),
                                          ),
                                          Text(
                                            formatter.parse(date).toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'OpenSans-Regular',
                                                color: Color(0xFF333333)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: H * 0.015,
                        )
                      ],
                    );
                  })
              : Padding(
                  padding: EdgeInsets.only(left: W * 0.05),
                  child: Row(
                    children: [
                      Container(
                        height: H * 0.02,
                        width: W * 0.04,
                        // child: CircularProgressIndicator(
                        //   color: flyOrange2,
                        // ),
                      ),
                      SizedBox(
                        width: W * 0.02,
                      ),
                      Text(
                        "Look's like their is no jobs in My jobs...",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'OpenSans-Bold',
                            color: flyOrange2),
                      ),
                    ],
                  ),
                ),
        ],
      )),
    );
  }

  Container buildCardFlyer(double H, double W) {
    return Container(
      height: H * 0.15,
      width: W * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Image.asset("assets/images/flyer.png"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "  Flyer Distribution",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'OpenSans-Bold',
                    color: Color(0xFF333333)),
              ),
              Row(
                children: [
                  Text(
                    "  Location :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)),
                  ),
                  Text(
                    " Area 1, New Town, Kolkata ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "  Pincode :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)),
                  ),
                  Text(
                    " 700091 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "  Date :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)),
                  ),
                  Text(
                    " 17 May 2022 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "  Completed :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)),
                  ),
                  Text(
                    " 17 June 2022",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
