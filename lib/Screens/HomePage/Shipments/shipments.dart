import 'dart:convert';
import 'package:flyerapp/Screens/JobTracking/job_tracking.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/JobSheetDetails/job_sheet_details.dart';
import 'package:flyerapp/Screens/Notifications/notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Constants/colors.dart';
import '../../Job Details/job_my_jobs_status.dart';
import '../../SharedPrefrence/sharedprefrence.dart';
import '../../UserModel/job_model.dart';


class Shipments extends StatefulWidget {
  const Shipments({Key? key}) : super(key: key);

  @override
  State<Shipments> createState() => _ShipmentsState();
}

class _ShipmentsState extends State<Shipments> {
  List<dynamic> _myJobs = [];
  bool _loading = false;
  String? tokenAPI;
  Future<List<Datum>> getMyJobData()async{
    tokenAPI = await getToken();
    setState((){
      tokenAPI;
      print(tokenAPI);
    });
    setState((){
      _loading = true;
    });
    var url = "https://ondemandflyers.com:8087/distributor/approvedJobs";
    var response = await http.get(Uri.parse(url,),
      headers: {
        'x-access-token': "$tokenAPI",
      },);
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    int index;
    var jsonData = jsonDecode(response.body);
    print(response.body);
    setState((){
      _myJobs = jsonData['data'];
      print(_myJobs[0]['trackId']);
      print(_myJobs[0]['jobTitle']);
      _loading = false;
    });

    print(jsonData);
    return jsonData;
  }
  @override
  void initState(){
    getMyJobData();
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
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
        title: Text("Shipments"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 20,
          color: Colors.black,

        ),
        titleSpacing: 2,
        actions: [InkWell(
          onTap: (){
            Get.to(Notifications());
          },
          child: Padding(
            padding:  EdgeInsets.only(right: W*0.04),
            child: Center(
              child: Stack(
                children: [
                  Icon(Icons.notifications_none_outlined,color: flyBlack2,),
                  Padding(
                    padding:  EdgeInsets.only(left: W*0.03,),
                    child: CircleAvatar(
                      backgroundColor: flyOrange2,
                      radius: 7,
                      child: Text("!",style: TextStyle(
                          fontSize: 11
                      ),),
                    ),
                  )
                ],
              ),
            ),
          ),
        )],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: H*0.02,),
            _myJobs.isNotEmpty ? ListView.builder(
                itemCount: _myJobs.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context ,index){
                  var date = _myJobs[index]['createdAt'];
                  return Column(
                    children: [
                      InkWell(
                          onTap: (){
                            setJobTitle(_myJobs[index]["jobTitle"]);
                            setJobCreatedDate(_myJobs[index]["createdAt"]);
                            setStartLocation(_myJobs[index]["startLocation"]["address"]);
                            setTrackId(_myJobs[index]["trackId"]);
                            Get.to(JobSheetDetails());
                          },
                          child: Container(
                            height: H*0.15,
                            width: W*0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                _loading ?CircularProgressIndicator(color: flyOrange2,)  : Container(
                                    color: Colors.red,
                                    width: W*0.3,
                                    height: H*0.15,
                                    child: Image.network(_myJobs[index]['bannerImage'],fit: BoxFit.cover,)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: H*0.03,),
                                    Container(
                                      width: W*0.6,
                                      child: Text(" ${_myJobs[index]['jobTitle']}",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                            fontFamily: 'OpenSans-Bold',
                                            color: Color(0xFF333333)
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: H*0.01,),
                                    Row(
                                      children: [
                                        Text("  Location :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans-Regular',
                                              color: Color(0xFF808080)
                                          ),
                                        ),
                                        Container(
                                          width: W*0.4,
                                          child: Text(_myJobs[index]['startLocation']['address'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'OpenSans-Regular',
                                                color: Color(0xFF333333)
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("  Date :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans-Regular',
                                              color: Color(0xFF808080)
                                          ),
                                        ),
                                        Text(formatter.parse(date).toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans-Regular',
                                              color: Color(0xFF333333)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: H*0.015,)
                    ],
                  );
                }) : Center(child: Padding(
              padding:  EdgeInsets.only(top: H*0.01),
              child: Padding(
                padding: EdgeInsets.only(left: W * 0.05),
                child: Row(
                  children: [
                    Container(
                        height: H * 0.02,
                        width: W * 0.04,
                        child: CircularProgressIndicator(
                          color: flyOrange2,
                        )),
                    SizedBox(
                      width: W * 0.02,
                    ),
                    Text(
                      "Look's like their is nothing in shipments...",
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
        )
      ),
    );
  }
  Container buildCardFlyer(double H, double W) {
    return Container(
      height: H*0.15,
      width: W*0.9,
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
              Text("  Flyer Distribution",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'OpenSans-Bold',
                    color: Color(0xFF333333)
                ),
              ),
              Row(
                children: [
                  Text("  Location :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)
                    ),
                  ),
                  Text(" Area 1, New Town, Kolkata ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)
                    ),
                  ),

                ],
              ),
              Row(
                children: [
                  Text("  Pincode :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)
                    ),
                  ),
                  Text(" 700091 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("  Date :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)
                    ),
                  ),
                  Text(" 17 May 2022 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("  Completed :",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF808080)
                    ),
                  ),
                  Text(" 17 June 2022",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'OpenSans-Regular',
                        color: Color(0xFF333333)
                    ),
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
