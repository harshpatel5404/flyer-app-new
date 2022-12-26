import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/HomePage/Shipments/shipments.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/Job%20Details/variables.dart';
import 'package:flyerapp/Screens/JobSheetDetails/job_sheet_details.dart';
import 'package:flyerapp/Screens/JobTracking/job_tracking.dart';
import 'package:flyerapp/Screens/UserModel/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../HomePage/Help/help.dart';
import '../Notifications/notifications.dart';
import '../Profile/edit_profile.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import '../UserModel/job_model.dart';
import '../UserModel/job_status_model.dart';

class StartJob extends StatefulWidget {
  const StartJob({Key? key}) : super(key: key);

  @override
  State<StartJob> createState() => _StartJobState();
}

class _StartJobState extends State<StartJob> {
  late CameraPosition? _initialPosition;
  String? tokenAPI;
  String? jobApiId;
  String? userNameAPI;
  String? userEmail;
  String? jobTitle;
  String? startDate;
  String? endDate;
  double? startLat;
  double? startLong;
  double? endLat;
  double? endLong;
  String? jobId;
  int? flyer;
  int? doorHanger;
  int? hourlyRate;
  int? numDays;
  String? startLocation;
  String? endLocation;
  bool? Approved;
  late Future<DataModel> futureAlbum;
  Future getProfileData() async {
    userNameAPI = await getName();
    userEmail = await getEmail();
    setState(() {});
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    var url = "https://ondemandflyers.com:8087/distributor/profile";
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
    print("This is my Profile : $jsonData");
    nameForProfile = jsonData["data"]["full_name"];

    print(jsonData["data"]["full_name"]);
    setState(() {});
  }

  Future<DataModel> getMyJobData() async {
    tokenAPI = await getToken();
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
    startLat = await getLatitudeStart();
    startLong = await getLongitudeStart();
    endLat = await getLatitudeEnd();
    endLong = await getLongitudeEnd();
    _initialPosition = CameraPosition(target: LatLng(startLat!, startLong!));
    setState(() {});
    print(jobTitle);
    print(numDays);
    print(jobApiId);
    print(tokenAPI);
    var baseurl = "https://ondemandflyers.com:8087/distributor/myJobStatus";
    var jobId = "$jobApiId";
    var url = "$baseurl/$jobId";
    var response = await http.get(
      Uri.parse(
        url,
      ),
      headers: {
        'x-access-token': "$tokenAPI",
      },
    );

    var jsonData = jsonDecode(response.body);
    setState(() {
      print("printToken : $tokenAPI");
      Approved = jsonData['data']['isApproved'];
    });
    print(Approved);
    return jsonData;
  }

  Future getUserData() async {
    userNameAPI = await getName();
    userEmail = await getEmail();
    setState(() {
      userNameAPI;
      userEmail;
    });
  }

  @override
  void initState() {
    getUserData();
    getMyJobData();
    getProfileData();
    super.initState();
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
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4D4D4D),
                ))),
        title: Text("Start Job"),
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
                        padding: EdgeInsets.only(left: W * 0.05, top: H * 0.02),
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
                              width: W * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: W * 0.4,
                                  child: Text(
                                    "$nameForProfile",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: "Gothic-Regular",
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  width: W * 0.42,
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
                                width: W * 0.7,
                                child: Text(
                                  "$jobTitle",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 14),
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
                                        fontSize: 16,
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
                                        fontSize: 16,
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
                                    "Number of Flyers:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)),
                                  ),
                                  Text(
                                    " $flyer",
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
                                    " $doorHanger",
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
                                    " $hourlyRate",
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
                                    " $numDays",
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
                            "  $startLocation",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
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
                            "  $endLocation",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xFF333333),
                                fontFamily: "Opensans-Regular",
                                fontSize: 13),
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
                bool serviceEnabled;
                LocationPermission permission;
                serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled) {
                  return Get.defaultDialog(
                      title: "",
                      titleStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans-Bold',
                          color: flyBlack2),
                      content: Column(
                        children: [
                          Text(
                            "Please turn on your device location!",
                            style: TextStyle(
                                fontSize: 13,
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
                }
                permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                  Get.to(JobTracking());
                  startJob();
                } else if (permission == LocationPermission.whileInUse) {
                  Get.to(JobTracking());
                  startJob();
                }
              },
              child: Container(
                width: W * 0.9,
                height: H * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                        colors: [flyOrange1, flyOrange2],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight)),
                child: Center(
                    child: Text(
                  "Start Job",
                  style: TextStyle(
                      fontFamily: "Opensans-Bold",
                      fontSize: 16,
                      color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startJob() async {
    jobId = await getJobId();
    var userName = await getName();
    var jobTitle = await getJobTitle();
    tokenAPI = await getToken();
    jobId = await getJobId();
    print("This is my jobId : $jobId");
    var token = tokenAPI;
    var baseurl = "https://ondemandflyers.com:8087";
    final response = await http
        .patch(Uri.parse("$baseurl/distributor/startJob/$jobId"), headers: {
      'x-access-token': "$token",
      "Content-Type": "application/json",
    });
    print(response.body);
    functionForSocket({
      'type': 'Start Job',
      'title': 'Job Started!',
      'description': '$userName has started the job $jobTitle',
      'jobId': jobId
    });
  }
}
