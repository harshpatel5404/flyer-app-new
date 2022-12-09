

import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/JobTracking/job_tracking.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import 'package:http/http.dart' as http;
class StartJob extends StatefulWidget {
  const StartJob({Key? key}) : super(key: key);

  @override
  State<StartJob> createState() => _StartJobState();
}

class _StartJobState extends State<StartJob> {
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
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
        title: Text("Job Details"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 22,
          color: Colors.black,

        ),
        titleSpacing: 2,
        actions: [Padding(
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
                    child: Text("3",style: TextStyle(
                        fontSize: 11
                    ),),
                  ),
                )
              ],
            ),
          ),
        )],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: H*0.4,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter
                    ,child: Container(
                    height: H*0.2,
                    width: W*0.9,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [flyMargenta,flyOrange2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CORPORATE",
                                style: TextStyle(
                                    fontFamily: "Gothic-Regular",
                                    color: Colors.white,
                                    fontSize: 23
                                ),
                              ),
                              Text("FLYER",
                                style: TextStyle(
                                    fontFamily: "Gothic-Bold",
                                    color: Colors.white,
                                    fontSize: 45
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: W*0.05,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hello John",
                                style: TextStyle(
                                    fontFamily: "Gothic-Regular",
                                    color: Colors.white,
                                    fontSize: 23
                                ),
                              ),
                              Text("info@johndeo.com",
                                style: TextStyle(
                                    fontFamily: "Gothic-Regular",
                                    color: Colors.white,
                                    fontSize: 15
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
                      padding:  EdgeInsets.only(top: H*0.1),
                      child: Container(
                        width: W*0.8,
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                                offset: Offset.zero,
                                color:flyGray4,
                                blurRadius: 10
                            )],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Flyer Distribution",
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 18
                                ),
                              ),
                              SizedBox(height: H*0.01,),
                              Row(
                                children: [
                                  Text("Job Post Date:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Text(" 17 May 2022",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Completed By:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Text(" 17 May 2022",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: H*0.03,),
                              Row(
                                children: [
                                  Text("Number of Flyer:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Text(" 1000",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Number of Doorhangers:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Text(" 1000",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 15,
                                        color: Color(0xFF333333)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: H*0.03,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text("Job Location",
              style: TextStyle(
                  color: flyBlue1,
                  fontFamily: "Opensans-Bold",
                  fontSize: 15
              ),
            ),
            SizedBox(height: H*0.01,),
            Container(
              width: W*0.9,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                      offset: Offset(1,1),
                      color:flyGray4,
                      blurRadius: 20
                  )],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
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
                            backgroundColor: Colors.white
                            ,child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/from_tracking.png"),
                                )
                            ),
                          ),
                          ),
                        ),
                        Text("  Area 1,New Town,Kolkata 700091",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontFamily: "Opensans-Regular",
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: W*0.05),
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
                            backgroundColor: Colors.white
                            ,child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/map.png"),
                                )
                            ),
                          ),
                          ),
                        ),
                        Text("  Area 1,New Town,Kolkata 700091",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontFamily: "Opensans-Regular",
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: H*0.05,),
            InkWell(
              onTap: (){
                startJob();
                Get.to(JobTracking());
              },
              child: Container(
                width: W*0.9,
                height: H*0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                        colors: [flyOrange1,flyOrange2],
                        begin: Alignment.bottomLeft,
                        end:  Alignment.topRight
                    )
                ),
                child: Center(child:
                Text("Start Job",
                  style: TextStyle(
                      fontFamily: "Opensans-Bold",
                      fontSize: 16,
                      color: Colors.white
                  ),
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future startJob() async {
    var baseurl = "https://nodeserver.mydevfactory.com:8087";
    var jobId = "62da743debbd0204069c0b07";
    final response = await http.patch(
        Uri.parse("$baseurl/distributor/startJob/$jobId"),
        headers: {
          'x-access-token': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDhmNmEwOTQ4MzhiNjc5MDZiN2VmOCIsImlhdCI6MTY1ODQ3MTc2NiwiZXhwIjoxNjY4ODM5NzY2fQ.3tWNWqu9CQCAFMAlFJHsVQhAaMllwUugDY7xLaR7R-I",
          "Content-Type": "application/json",
        });
    print(response.body);
  }
}

