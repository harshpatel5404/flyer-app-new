import 'dart:async';
import 'dart:convert';
import 'package:flyerapp/Screens/HomePage/Help/chat_controller.dart';
import 'package:flyerapp/Screens/HomePage/Help/help.dart';
import 'package:flyerapp/Screens/HomePage/Help/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/SharedPrefrence/sharedprefrence.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../Constants/colors.dart';
import '../../Api/all_api.dart';
import '../../Job Details/job_details.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Profile/edit_profile.dart';
import '../../UserModel/job_model.dart';
import '../../UserModel/user_model.dart';

class HomePageMain extends StatefulWidget {
  const HomePageMain({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  late Future<JobModel> futureAlbum;
  Timer? timer;
  @override
  void initState() {
    connect();
    getJobData();
    getUserData();
    getProfileData();
    super.initState();
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController searchJobController = TextEditingController();
  String? userName;
  String name = "";
  String email = "";
  String? userNameAPI;
  String? userEmail;
  String? tokenAPI;
  double? lat;
  double? long;
  List<dynamic> _jobs = [];
  bool _loading = false;
  Future getProfileData() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    setState(() {
      _loading = true;
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

  getJobData() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
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
      _loading = false;
    });
    print(jsonData);
    return jsonData;
  }

  List<dynamic> _searchJobs = [];
  Future<List<Datum>> getSearchJobs() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    setState(() {
      _loading = true;
    });
    var url = "https://ondemandflyers.com:8087/distributor/searchJobs";
    var searchController = searchJobController.text.trim();
    var response = await http.get(
      Uri.parse(
        "$url/$searchController",
      ),
      headers: {
        'x-access-token': "$tokenAPI",
      },
    );
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    var jsonData = jsonDecode(response.body);
    setState(() {
      _searchJobs = jsonData['data'];
      print(_searchJobs[0]['jobTitle']);
      _loading = false;
    });
    print(jsonData);
    return jsonData;
  }

  void connect() async {
    ChatController chatController = Get.put(ChatController());
    userName = await getName();
    var token = await getToken();
    List notificationList = [];
    socket = IO.io(
      "https://ondemandflyers.com:8087/",
      {
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'token': token, "role": 'distributor'}
      },
    );
    socket!.connect();
    try {
      socket!.onConnect((data) {
        print("Connected");
        print(socket!.id);
        socket!.on('notification', (data) {
          var title = data["title"];
          print(title);
          var description = data["description"];
          print(description);
          print(data);
          notificationList.add({
            "title": title,
            "description": description,
            "type": "Job",
          });
          NotificationService()
              .showNotification(0, title.toString(), description.toString());
        });
        socket!.on('message', (data) {
          print(data);
          // print(data['message']);
          // print(data['username']);
          chatController.messageslist.add(ChatMessage(
              messageContent: data["message"].toString(),
              messageType: data["username"].toString()));
          NotificationService().showNotification(
              0, data["username"].toString(), data["message"].toString());
          print(chatController.messageslist);
        });
      });
    } catch (e) {
      print(e.toString());
    }
    socket!.onDisconnect((data) => print("DisConnected"));
    print(socket!.connected);
  }

  Position? currentPosition;
  Future locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    lat = position.latitude;
    print(lat);
    long = position.longitude;
    print(long);
    var location = ({
      "lat": lat,
      "lng": long,
    });
    socket!.emit('liveLocationUpdate', {location});
  }

  Future getUserData() async {
    userNameAPI = await getName();
    userEmail = await getEmail();
    tokenAPI = await getToken();
    setState(() {
      userNameAPI;
      userEmail;
      tokenAPI;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          extendBody: true,
          backgroundColor: Color(0xFFF6F7F9),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: H * 0.08,
                          padding:
                              EdgeInsets.only(left: W * 0.05, right: W * 0.05),
                          child: TextFormField(
                            controller: searchJobController,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF8771A7),
                                ),
                                hintText: "Search job according to city..",
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4A4979),
                                    fontFamily: "NunitoSans-Regular"),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: flyOrange2, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: flyOrange2, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: W * 0.05,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (searchJobController.text.isNotEmpty) {
                                getSearchJobs();
                              } else {
                                _searchJobs.clear();
                              }
                            },
                            child: Container(
                              height: H * 0.08,
                              width: W * 0.15,
                              child: Center(
                                child: Text(
                                  "Go",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "NunitoSans-Bold",
                                      color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: flyOrange2,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: H * 0.02,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/hello_homescreen.png"),
                              fit: BoxFit.fill)),
                      height: H * 0.2,
                      width: W * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(left: W * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            nameForProfile == null
                                ? Text(
                                    "Loading...",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'OpenSans-Bold',
                                        color: Colors.white),
                                  )
                                : Text(
                                    "$nameForProfile",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'OpenSans-Bold',
                                        color: Colors.white),
                                  ),
                            Text(
                              "$userEmail",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'OpenSans-Regular',
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.03,
                  ),
                  Text(
                    "     Search job list",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'OpenSans-Bold',
                        color: flyBlue1),
                  ),
                  SizedBox(
                    height: H * 0.01,
                  ),
                  _searchJobs.isNotEmpty
                      ? Container(
                          height: H * 0.5,
                          child: ListView.builder(
                              itemCount: _searchJobs.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var date = _searchJobs[index]['createdAt'];
                                return Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setJobId(_searchJobs[index]["_id"]);
                                          setJobTitle(
                                              _searchJobs[index]["jobTitle"]);
                                          setJobCreatedDate(
                                              _searchJobs[index]["createdAt"]);
                                          setEndDate(
                                              _searchJobs[index]["endDate"]);
                                          setFlyersCount(_searchJobs[index]
                                              ["flyersCount"]);
                                          setDoorHangersCount(_searchJobs[index]
                                              ["doorHangersCount"]);
                                          setHourlyRate(
                                              _searchJobs[index]["hourlyRate"]);
                                          setNumOfDaysRequired(
                                              _searchJobs[index]
                                                  ["numOfDaysRequired"]);
                                          setStartLocation(_searchJobs[index]
                                              ["startLocation"]["address"]);
                                          setEndLocation(_searchJobs[index]
                                              ["endLocation"]["address"]);
                                          Get.to(JobDetails());
                                        },
                                        child: Container(
                                          height: H * 0.15,
                                          width: W * 0.9,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              _loading
                                                  ? CircularProgressIndicator(
                                                      color: flyOrange2,
                                                    )
                                                  : Container(
                                                      color: Colors.red,
                                                      width: W * 0.3,
                                                      height: H * 0.15,
                                                      child: Image.network(
                                                        _searchJobs[index]
                                                            ['bannerImage'],
                                                        fit: BoxFit.cover,
                                                      )),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: H * 0.03,
                                                  ),
                                                  Container(
                                                    width: W * 0.55,
                                                    child: Text(
                                                      " ${_searchJobs[index]['jobTitle']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          color: Color(
                                                              0xFF333333)),
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
                                                            fontFamily:
                                                                'OpenSans-Regular',
                                                            color: Color(
                                                                0xFF808080)),
                                                      ),
                                                      Container(
                                                        width: W * 0.4,
                                                        child: Text(
                                                          _searchJobs[index][
                                                                  'startLocation']
                                                              ['address'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'OpenSans-Regular',
                                                              color: Color(
                                                                  0xFF333333)),
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
                                                            fontFamily:
                                                                'OpenSans-Regular',
                                                            color: Color(
                                                                0xFF808080)),
                                                      ),
                                                      Text(
                                                        formatter
                                                            .parse(date)
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'OpenSans-Regular',
                                                            color: Color(
                                                                0xFF333333)),
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
                              }),
                        )
                      : Padding(
                          padding: EdgeInsets.only(left: W * 0.02),
                          child: Row(
                            children: [
                              Text(
                                "    Search job will be available here...",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: H * 0.01,
                  ),
                  Text(
                    "     Prefered job list",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'OpenSans-Bold',
                        color: flyBlue1),
                  ),
                  SizedBox(
                    height: H * 0.02,
                  ),
                  _jobs.isNotEmpty
                      ? Container(
                          height: H * 0.35,
                          child: ListView.builder(
                              itemCount: _jobs.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var date = _jobs[index]['createdAt'];
                                return Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setJobId(_jobs[index]["_id"]);
                                          setJobTitle(_jobs[index]["jobTitle"]);
                                          setJobCreatedDate(
                                              _jobs[index]["createdAt"]);
                                          setEndDate(_jobs[index]["endDate"]);
                                          setFlyersCount(
                                              _jobs[index]["flyersCount"]);
                                          setDoorHangersCount(
                                              _jobs[index]["doorHangersCount"]);
                                          setHourlyRate(
                                              _jobs[index]["hourlyRate"]);
                                          setNumOfDaysRequired(_jobs[index]
                                              ["numOfDaysRequired"]);
                                          setStartLocation(_jobs[index]
                                              ["startLocation"]["address"]);
                                          setEndLocation(_jobs[index]
                                              ["endLocation"]["address"]);
                                          Get.to(JobDetails());
                                        },
                                        child: Container(
                                          height: H * 0.15,
                                          width: W * 0.9,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              _loading
                                                  ? CircularProgressIndicator(
                                                      color: flyOrange2,
                                                    )
                                                  : Container(
                                                      color: Colors.red,
                                                      width: W * 0.3,
                                                      height: H * 0.15,
                                                      child: Image.network(
                                                        _jobs[index]
                                                            ['bannerImage'],
                                                        fit: BoxFit.cover,
                                                      )),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: H * 0.03,
                                                  ),
                                                  Container(
                                                    width: W * 0.55,
                                                    child: Text(
                                                      " ${_jobs[index]['jobTitle']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          color: Color(
                                                              0xFF333333)),
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
                                                            fontFamily:
                                                                'OpenSans-Regular',
                                                            color: Color(
                                                                0xFF808080)),
                                                      ),
                                                      Container(
                                                        width: W * 0.4,
                                                        child: Text(
                                                          _jobs[index][
                                                                  'startLocation']
                                                              ['address'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'OpenSans-Regular',
                                                              color: Color(
                                                                  0xFF333333)),
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
                                                            fontFamily:
                                                                'OpenSans-Regular',
                                                            color: Color(
                                                                0xFF808080)),
                                                      ),
                                                      Text(
                                                        formatter
                                                            .parse(date)
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'OpenSans-Regular',
                                                            color: Color(
                                                                0xFF333333)),
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
                              }),
                        )
                      : Padding(
                          padding: EdgeInsets.only(left: W * 0.02),
                          child: Row(
                            children: [
                              // Container(
                              //     height: H * 0.02,
                              //     width: W * 0.04,
                              //     child: CircularProgressIndicator(
                              //       color: flyOrange2,
                              //     )),
                              SizedBox(
                                width: W * 0.04,
                              ),
                              Text(
                                "Look's like no job your location...",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
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
              )
            ],
          ),
        ],
      ),
    );
  }

  Future apiCallLoginData() async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://ondemandflyers.com:8087/distributor/login"));
    if (response.statusCode == 200) {
      setState(() {
        var stringRespone = response.body.length;
        print(stringRespone);
      });
    }
  }
}

IO.Socket? socket;

class Job {
  final String name;
  Job({required this.name});
}
