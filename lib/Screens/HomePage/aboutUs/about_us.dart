import 'dart:convert';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flyerapp/Constants/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Notifications/notifications.dart';
import '../../SharedPrefrence/sharedprefrence.dart';



class CMS extends StatefulWidget {
  const CMS({Key? key}) : super(key: key);

  @override
  State<CMS> createState() => _CMSState();
}

class _CMSState extends State<CMS> {
  @override
  void initState(){
    super.initState();
    getTermsAndConditions();
  }
  int _currentIndex = 0;
  String? title;
  String? description;
  String? image;
  String? htmlString;
  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: flyBackground,
        elevation: 0,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Container(
              child: Icon(Icons.arrow_back_ios,color: flyOrange2,size: 20,)),
        ),
        centerTitle: true,
        title: title == null ? Text(
            "Loading.."
        ) : Text("$title"),
        titleTextStyle: TextStyle(
            fontSize: 16,
            fontFamily: "NunitoSans-Bold",
            color:Color(0xFF184673)
        ),
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
      backgroundColor: flyBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
              decoration: BoxDecoration(
                  color: flyGray4,
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              child:Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: H*0.18,
                      width: W*0.9,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "$image",
                              )
                          )
                      ),
                    ),
                    SizedBox(
                      height: H*0.02,
                    ),
                    description == null ? Text(
                        "Loading..",
                        style: TextStyle(fontSize: 13,
                            fontFamily: 'OpenSans-Bold',
                            color: Color(0xFF184673))) : Text(_parseHtmlString("$description"),style: TextStyle(fontSize: 13,
                        fontFamily: 'OpenSans-Bold',
                        color: Color(0xFF184673)),)
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
  Future getTermsAndConditions() async {

    var tokenAPI = await getToken();
    setState(() {
      print(tokenAPI);
    });
    var url =
        "https://ondemandflyers.com:8087/distributor/cms/page/about-us";
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
    print(jsonData["data"]["title"]);
    print(jsonData["data"]["image"]);
    title = (jsonData["data"]["title"]);
    image = (jsonData["data"]["image"]);
    description = (jsonData["data"]["description"]);
    setState((){});
  }
}
String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}