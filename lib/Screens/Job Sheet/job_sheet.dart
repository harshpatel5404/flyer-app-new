import 'dart:convert';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/HomePage/Deliveries/deliveries.dart';
import 'package:flyerapp/Screens/HomePage/Shipments/shipments.dart';
import 'package:flyerapp/Screens/JobSheetDetails/job_sheet_details.dart';
import 'package:flyerapp/Screens/Start%20Job/start_job.dart';
import '../../Constants/colors.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:get/get.dart';
import '../HomePage/Invite Friends/invite_friends.dart';
import '../HomePage/PreferedLocation/prefered_loca_edit.dart';
import '../Job Details/job_details.dart';
import '../LoginScreen/login_screen.dart';
import '../Payment/payment.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import '../UserModel/job_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class JobSheet extends StatefulWidget {
  const JobSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<JobSheet> createState() => _JobSheetState();
}

class _JobSheetState extends State<JobSheet> {
  String? tokenAPI;
  List<dynamic> _myJobs = [];
  bool _loading = false;
  Future<List<Datum>> getMyJobData() async {
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
    });
    setState(() {
      _loading = true;
    });
    var url = "https://ondemandflyers.com:8087/distributor/jobSheetList";
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
    print(tokenAPI);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    setState(() {
      _myJobs = jsonData['data'];
      print(_myJobs[0]['jobTitle']);
      _loading = false;
    });
    print(jsonData);
    return jsonData;
  }

  @override
  void initState() {
    getMyJobData();
    super.initState();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  setJobCreatedDate(
                                      _myJobs[index]["createdAt"]);
                                  setEndDate(_myJobs[index]["endDate"]);
                                  setFlyersCount(_myJobs[index]["flyersCount"]);
                                  setDoorHangersCount(
                                      _myJobs[index]["doorHangersCount"]);
                                  setHourlyRate(_myJobs[index]["hourlyRate"]);
                                  setNumOfDaysRequired(
                                      _myJobs[index]["numOfDaysRequired"]);
                                  setStartLocation(_myJobs[index]
                                      ["startLocation"]["address"]);
                                  setEndLocation(
                                      _myJobs[index]["endLocation"]["address"]);
                                  setLatitudeStart(_myJobs[index]
                                      ["startLocation"]["latitude"]);
                                  setLongitudeStart(_myJobs[index]
                                      ["startLocation"]["longitude"]);
                                  setLatitudeEnd(_myJobs[index]["endLocation"]
                                      ["latitude"]);
                                  setLongitudeEnd(_myJobs[index]["endLocation"]
                                      ["longitude"]);
                                  Get.to(StartJob());
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
                                          ? CircularProgressIndicator(
                                              color: flyOrange2,
                                            )
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: H * 0.03,
                                          ),
                                          Container(
                                            width: W * 0.6,
                                            child: Text(
                                              " ${_myJobs[index]['jobTitle']}",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                    fontFamily:
                                                        'OpenSans-Regular',
                                                    color: Color(0xFF808080)),
                                              ),
                                              Container(
                                                width: W * 0.4,
                                                child: Text(
                                                  _myJobs[index]
                                                          ['startLocation']
                                                      ['address'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                    fontFamily:
                                                        'OpenSans-Regular',
                                                    color: Color(0xFF808080)),
                                              ),
                                              Text(
                                                formatter
                                                    .parse(date)
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'OpenSans-Regular',
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
                  : Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: H * 0.01),
                      child: Padding(
                        padding: EdgeInsets.only(left: W * 0.05),
                        child: Row(
                          children: [
                            // Container(
                            //     height: H * 0.02,
                            //     width: W * 0.04,
                            //     child: CircularProgressIndicator(
                            //       color: flyOrange2,
                            //     )),
                            SizedBox(
                              width: W * 0.06,
                            ),
                            Text(
                              "Look's like their is nothing in job sheet...",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'OpenSans-Bold',
                                  color: flyOrange2),
                            ),
                          ],
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
