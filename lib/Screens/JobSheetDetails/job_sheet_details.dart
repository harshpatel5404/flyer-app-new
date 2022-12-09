import 'dart:async';
import 'dart:convert';
import 'package:flyerapp/Screens/HomePage/Help/help.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/Job%20Sheet/job_sheet.dart';
import 'package:flyerapp/Screens/Job%20Sheet/job_sheet_main.dart';
import 'package:flyerapp/Screens/SharedPrefrence/sharedprefrence.dart';
import 'package:flyerapp/Screens/Start%20Job/start_job.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/colors.dart';
import '../Notifications/notifications.dart';
import '../Profile/edit_profile.dart';
import '../UserModel/job_status_model.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;


class JobSheetDetails extends StatefulWidget {
  const JobSheetDetails({Key? key}) : super(key: key);

  @override
  State<JobSheetDetails> createState() => _JobSheetDetailsState();
}

class _JobSheetDetailsState extends State<JobSheetDetails> {
  IO.Socket? socket;
  late Future<DataModel> futureAlbum;
  String? jobId;
  String? token;
  String? shipmentStatus;
  String? shipmentDescription;
  String? trackId;
  String? userNameAPI;
  String? userEmail;
  String? tokenAPI;
  String? jobTitle;
  String? startDate;
  String? startLocation;
  String? userName;
  Timer? timer;
  String? id;
  Future getProfileData() async {
    userNameAPI = await getName();
    userEmail = await getEmail();
    setState((){});
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    var url =
        "https://ondemandflyers.com:8087/distributor/profile";
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
    setState((){});
  }
  Future getUserData()async{
    userNameAPI = await getName();
    userEmail = await getEmail();
    jobTitle = await getJobTitle();
    startLocation = await getStartLocation();
    startDate = await getJobCreatedDate();
    trackId = await getTrackId();
    setState((){
      userNameAPI;
      userEmail;
      tokenAPI;
    });
  }
  void shipment()async{
    tokenAPI = await getToken();
    print("My track id: $trackId");
    setState((){});
    var baseurl = "https://ondemandflyers.com:8087/distributor/shipmentStatus";
    var trackIdForUrl = "$trackId";
    setState((){
      print("this is my track id : $trackIdForUrl");
    });
    var url = "$baseurl/received/$trackIdForUrl";
    var token = tokenAPI;
    var response = await http.patch(Uri.parse(url,),
      headers: {
        'x-access-token': "$token",
      },);
    var  jsonData = jsonDecode(response.body);
    print(jsonData);
    print(token);
    print(trackIdForUrl);
    Get.to(HomePage());
    Fluttertoast.showToast(msg: "Your job is available now on Job Sheet!");
  }
  void shipmentStatusAPI()async{
    tokenAPI = await getToken();
    trackId = await getTrackId();
    print("This is my TrackID: $trackId");
    print("This is my token : $tokenAPI");
    setState((){});
    var baseurl = "https://ondemandflyers.com:8087/distributor/shipmentStatus";
    var url = "$baseurl/$trackId";
    var token = tokenAPI;
    var response = await http.get(Uri.parse(url,),
      headers: {
        'x-access-token': "$token",
      },);
    print(response.body);
    var  jsonData = jsonDecode(response.body);
    shipmentStatus = jsonData["data"]["shipmentStatus"];
    shipmentDescription = jsonData["data"]["shipmentDescription"];
    print("This is my shipment status : $shipmentStatus");
    print("This is my message: $shipmentDescription");
    setState((){});
  }
  @override
  void initState(){
    getUserData();
    shipmentStatusAPI();
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => shipmentStatusAPI());
    timer!.cancel();
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
        title: Text("Shipment Status"),
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
      body: Center(
        child: Column(
          children: [
            Container(
              height: H*0.38,
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
                          SizedBox(width: W*0.01,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: W*0.4,
                                child: Text("$nameForProfile",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Gothic-Regular",
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              Text("$userEmail",
                                style: TextStyle(
                                    fontFamily: "Gothic-Regular",
                                    color: Colors.white,
                                    fontSize: 9.8
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
                              Text("$jobTitle",
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 15
                                ),
                              ),
                              SizedBox(height: H*0.01,),
                              Row(
                                children: [
                                  Text("Job Post Date:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 14,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Container(
                                    width: W*0.5,
                                    child: Text(" $startLocation",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'OpenSans-Regular',
                                          fontSize: 12,
                                          color: Color(0xFF333333)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Location:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 14,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Text(formatter.parse("$startDate").toString(),
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 12,
                                        color: Color(0xFF333333)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: H*0.04,),
                              Divider(
                                color: Color(0xFFEFEFEF),
                              ),
                              Row(
                                children: [
                                  Text("Tracking ID:",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 14,
                                        color: Color(0xFF808080)
                                    ),
                                  ),
                                  Text(" $trackId",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Regular',
                                        fontSize: 12,
                                        color: Color(0xFF333333)
                                    ),
                                  ),
                                  SizedBox(height: H*0.04,),
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
            SizedBox(height: H*0.02,),
           shipmentStatus == null ?
           Text(" Loading...",
             style: TextStyle(
                 fontFamily: 'OpenSans-Bold',
                 fontSize: 14,
                 color: Colors.grey.shade600
             ),
           ) :
           Padding(
              padding:  EdgeInsets.only(right: W*0.05),
              child: Row(
               mainAxisAlignment:MainAxisAlignment.center,
               children: [
                 Text("Shipment Status:",
                   style: TextStyle(
                       fontFamily: 'OpenSans-Bold',
                       fontSize: 16,
                       color: flyBlack2
                   ),
                 ),
                 Text(" $shipmentStatus",
                   style: TextStyle(
                       fontFamily: 'OpenSans-Semibold',
                       fontSize: 14,
                       color: Colors.grey.shade600
                   ),
                 ),
                 SizedBox(height: H*0.04,),
               ],
           ),
            ),
           SizedBox(height: H*0.02,),
           shipmentStatus.toString() == "out for delivery" ?
           InkWell(
             onTap: (){
               shipment();
               functionForSocket(
                   {
                     "type": "Delivery",
                     "title": "Packet received!",
                     "description": "$userNameAPI has received the packet for the job $jobTitle",
                     "trackId": trackId
                   }
               );
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
               Text("Received",
                 style: TextStyle(
                     fontFamily: "Opensans-Bold",
                     fontSize: 16,
                     color: Colors.white
                 ),
               )
               ),
             ),
           ) : const Text(""),
           SizedBox(
             height: H*0.02,
           ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Note:-",
                style:  const TextStyle(
                    fontFamily: "Opensans-Bold",
                    fontSize: 13,
                    color: flyOrange2
                ),),
              Text(" $shipmentDescription",
                style:  const TextStyle(
                    fontFamily: "Opensans-Bold",
                    fontSize: 12,
                    color: flyBlack
                ),)
            ],
          )
          ],
        ),
      ),
    );
  }
}