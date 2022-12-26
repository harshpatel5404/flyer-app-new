import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/HomePage/HomePage/homepage_main.dart';
import 'package:flyerapp/Screens/HomePage/MyJobs/my_jobs.dart';
import 'package:flyerapp/Screens/HomePage/Shipments/shipments.dart';
import 'package:flyerapp/Screens/JobSheetDetails/job_sheet_details.dart';
import 'package:flyerapp/Screens/JobTracking/job_tracking.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../HomePage/homepage.dart';
import '../Notifications/notifications.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import '../UserModel/job_model.dart';
import '../UserModel/job_status_model.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({Key? key}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  String? jobId;
  List<dynamic> _jobs = [];
  bool _loading = false;
  Future<List<Datum>> getJobData() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
    });
    setState(() {
      _loading = true;
    });
    var url = "https://ondemandflyers.com:8087/distributor/preferredJobs";
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
    setState(() {
      _jobs = jsonData['data'];
      print(_jobs[0]['jobTitle']);
      _loading = false;
    });
    print(jsonData);
    return jsonData;
  }

  @override
  void initState() {
    getJobData();
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    userNameAPI = await getName();
    userEmail = await getEmail();
    jobApiId = await getJobId();
    jobTitle = await getJobTitle();
    startDate = await getJobCreatedDate();
    endDate = await getEndDate();
    flyer = await getFlyersCount();
    doorHanger = await getDoorHangersCount();
    hourlyRate = await getHourlyRate();
    numDays = await getNumOfDaysRequired();
    startLocation = await getStartLocation();
    endLocation = await getEndLocation();
    setState(() {});
  }

  String? tokenAPI;
  String? jobApiId;
  String? userNameAPI;
  String? userEmail;
  String? jobTitle;
  String? startDate;
  String? endDate;
  int? flyer;
  int? doorHanger;
  int? hourlyRate;
  int? numDays;
  String? startLocation;
  String? endLocation;
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
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4D4D4D),
                ))),
        title: Text("Job Details"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 22,
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
                          "3",
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
      body: Center(
        child: Column(
          children: [
            Container(
              height: H * 0.45,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: H * 0.2,
                      width: W * 0.9,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [flyMargenta, flyOrange2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CORPORATE",
                                  style: TextStyle(
                                      fontFamily: "Gothic-Regular",
                                      color: Colors.white,
                                      fontSize: 23),
                                ),
                                Text(
                                  "FLYER",
                                  style: TextStyle(
                                      fontFamily: "Gothic-Bold",
                                      color: Colors.white,
                                      fontSize: 45),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: W * 0.01,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$userNameAPI",
                                  style: TextStyle(
                                      fontFamily: "Gothic-Regular",
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                Container(
                                  width: W * 0.4,
                                  child: Text(
                                    "$userEmail",
                                    style: TextStyle(
                                        fontFamily: "Gothic-Regular",
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: H * 0.1),
                      child: Container(
                        width: W * 0.8,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset.zero,
                                  color: flyGray4,
                                  blurRadius: 10)
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: W * 0.8,
                                child: Text(
                                  "$jobTitle",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: H * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Job Post Date:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    formatter.parse("$startDate").toString(),
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 14,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Completed By:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    formatter.parse("$endDate").toString(),
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 14,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: H * 0.03,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Number of Flyer:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    '$flyer',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Number of Doorhangers:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    '$doorHanger',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: H * 0.03,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Hourly rate: (USD)",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    '$hourlyRate',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Total Number Of Days:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    '$numDays',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              "Job Location",
              style: TextStyle(
                  color: flyBlue1, fontFamily: "Opensans-Bold", fontSize: 15),
            ),
            SizedBox(
              height: H * 0.01,
            ),
            Container(
              width: W * 0.9,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 1), color: flyGray4, blurRadius: 20)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFC4C4C4),
                          child: CircleAvatar(
                            radius: 19,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/from_tracking.png"),
                              )),
                            ),
                          ),
                        ),
                        Container(
                          width: W * 0.7,
                          child: Text(
                            '  $startLocation',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: "Opensans-Regular",
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: W * 0.05),
                      child: Image.asset("assets/images/tracking_line.png"),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFC4C4C4),
                          child: CircleAvatar(
                            radius: 19,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage("assets/images/map2.png"),
                              )),
                            ),
                          ),
                        ),
                        Container(
                          width: W * 0.7,
                          child: Text(
                            '  $endLocation',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: "Opensans-Regular",
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: H * 0.04,
            ),
            InkWell(
              onTap: () async {
                jobId = await getJobId();
                var jobIdFromApi = jobId;
                print("This is my job Id : $jobApiId");
                var baseurl = "https://ondemandflyers.com:8087";
                final response = await http.post(
                    Uri.parse("$baseurl/distributor/applyJob/$jobIdFromApi"),
                    headers: {
                      'x-access-token': "$tokenAPI",
                      "Content-Type": "application/json",
                    });
                print('This is  my jobId : $jobIdFromApi');
                print('This is token : $tokenAPI');
                print(response.body);

                if (response.statusCode == 409) {
                  Get.defaultDialog(
                      title: "",
                      titleStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans-Bold',
                          color: flyOrange2),
                      content: Column(
                        children: [
                          Text(
                            "You already applied to this job",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'OpenSans-Bold',
                                color: flyBlack2),
                          ),
                          SizedBox(
                            height: H * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: H * 0.05,
                                    width: W * 0.2,
                                    decoration: BoxDecoration(
                                        color: flyOrange2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                        child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: Colors.white),
                                    ))),
                              ),
                              SizedBox(
                                width: W * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: H * 0.05,
                                    width: W * 0.2,
                                    decoration: BoxDecoration(
                                        color: flyGray3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                        child: Text(
                                      "cancel",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: Colors.white),
                                    ))),
                              ),
                            ],
                          )
                        ],
                      ));
                } else if (response.statusCode == 200) {
                  var data = ({
                    "type": "Job",
                    "title": "Job Application",
                    "description": "$userNameAPI has applied for $jobTitle job",
                    "jobId": jobIdFromApi
                  });
                  socket!.emit('notification', {data});
                  Get.to(HomePage());
                  Get.defaultDialog(
                      title: "Congratulations!!",
                      titleStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans-Bold',
                          color: flyOrange2),
                      content: Column(
                        children: [
                          Text(
                            "Your job is applied and will show in Myjobs",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'OpenSans-Bold',
                                color: flyBlack2),
                          ),
                          Center(
                            child: Text(
                              "after admin's confirmation",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'OpenSans-Bold',
                                  color: flyBlack2),
                            ),
                          ),
                          SizedBox(
                            height: H * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: H * 0.05,
                                    width: W * 0.2,
                                    decoration: BoxDecoration(
                                        color: flyOrange2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                        child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: Colors.white),
                                    ))),
                              ),
                              SizedBox(
                                width: W * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: H * 0.05,
                                    width: W * 0.2,
                                    decoration: BoxDecoration(
                                        color: flyGray3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                        child: Text(
                                      "cancel",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: Colors.white),
                                    ))),
                              ),
                            ],
                          )
                        ],
                      ));
                }
              },
              child: Container(
                width: W * 0.8,
                height: H * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: flyOrange2),
                child: Center(
                    child: Text(
                  "Apply",
                  style: TextStyle(
                      fontFamily: "Opensans-Bold",
                      fontSize: 16,
                      color: Colors.white),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
