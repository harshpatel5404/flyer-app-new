import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/Api/all_api.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/LoginScreen/login_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import '../../../Constants/colors.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

import '../../SharedPrefrence/sharedprefrence.dart';
class PreferedLocation extends StatefulWidget {
  const PreferedLocation({Key? key}) : super(key: key);

  @override
  State<PreferedLocation> createState() => _PreferedLocationState();
}

class _PreferedLocationState extends State<PreferedLocation> {

  TextEditingController stateController = TextEditingController(text: "");
  TextEditingController cityController = TextEditingController(text: "");
  late GooglePlace? googlePlace;
  double? lat;
  double? long;
  Position? currentPosition;
  String? country;
  String? state;
  String? locality;
  String? subLocality;
  Future getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    try{
      var H = MediaQuery.of(context).size.height;
      var W = MediaQuery.of(context).size.width;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
        return  Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'OpenSans-Bold',
                color: flyBlack2
            ),
            content: Column(
              children: [
                Text("Please turn on your device location!",style:TextStyle(
                    fontSize: 13,
                    fontFamily: 'OpenSans-Bold',
                    color: flyBlack2
                ),),
                SizedBox(height: H*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                          height: H*0.05,
                          width: W*0.2,
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                    SizedBox(width: W*0.05,),
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                          height: H*0.05,
                          width: W*0.2,
                          decoration: BoxDecoration(
                              color: flyGray3,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("cancel",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                  ],
                )
              ],
            )
        );
      }
      permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        currentPosition = position;
        lat = position.latitude;
        print(lat);
        long = position.longitude;
        print(long);
        var location = ({
          "lat": lat,
          "lng": long,
        });
        setState((){});
        List<Placemark> placemark = await placemarkFromCoordinates(lat!, long!);
        print(placemark[0].toString());
        setState((){
          subLocality = placemark[0].subLocality;
          locality = placemark[0].locality;
          state = placemark[0].administrativeArea;
          country = placemark[0].country;
        });
      }
      else if(permission == LocationPermission.whileInUse){
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        currentPosition = position;
        lat = position.latitude;
        print(lat);
        long = position.longitude;
        print(long);
        var location = ({
          "lat": lat,
          "lng": long,
        });
        setState((){});
        List<Placemark> placemark = await placemarkFromCoordinates(lat!, long!);
        print(placemark[0].toString());
        setState((){
          subLocality = placemark[0].subLocality;
          locality = placemark[0].locality;
          state = placemark[0].administrativeArea;
          country = placemark[0].country;
        });
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }
  List<AutocompletePrediction> predictions = [];
  void autoCompleteSearch(String value)async{
    var result = await googlePlace?.autocomplete.get(value);
    if(result != null && result.predictions != null && mounted){
      setState((){
        print(result.predictions!.first.description);
        predictions = result.predictions!;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: H * 0.03,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          height: H * 0.02,
                          width: W * 0.065,
                          child: Image.asset(
                            "assets/images/back_arrow.png",
                          )),
                    ),
                    Text(
                      "  Add Your Prefered Location",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Semibold',
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: H * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    country == null ? Row(
                      children: [
                        Text(" Tap here",
                          style: TextStyle(
                              fontFamily: 'OpenSans-Semibold',
                              fontSize: 19,
                              color: flyOrange2,
                              fontWeight: FontWeight.bold),),
                        Icon(Icons.arrow_downward_sharp,color: flyOrange2,)
                      ],
                    ) : Text("$subLocality,$locality,$state,$country",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Semibold',
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: H * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        getLatLong();
                      },
                      child: Text(
                        "Get your location",
                        style: TextStyle(
                            color: Color(0xFF646464),
                            fontFamily: 'OpenSans-Semibold',
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: H * 0.03,
                ),
                Container(
                    width: W * 0.9,
                    height: H * 0.05,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: flyGray4,
                              offset: Offset(0.05, 0.05),
                              blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: Colors.black12, width: 0.6)),
                    child: TextFormField(
                      cursorColor: flyOrange1,
                      controller: cityController,
                      onChanged: (value){
                        if(value.isNotEmpty){
                          autoCompleteSearch(value);
                          //places api
                        }else{
                          //clear out the reuslts
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your City",
                          hintStyle: TextStyle(fontFamily: "OpenSans-Medium"),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                              borderSide:
                              BorderSide(color: Colors.transparent)),
                          enabledBorder: UnderlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                              borderSide:
                              BorderSide(color: Colors.transparent))),
                    )),
                SizedBox(
                  height: H * 0.05,
                ),
                InkWell(
                  onTap: () {
                    updateLocation(
                        lat!,
                        long!,
                        cityController.text);
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
                          "Confirm Location",
                          style: TextStyle(
                              fontFamily: 'OpenSans-Medium',
                              fontSize: 16,
                              color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(
                  height: H * 0.03,
                ),
                InkWell(
                  onTap: (){
                    Get.to(HomePage());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SKIP",
                        style: TextStyle(
                            color: Color(0xFF646464),
                            fontFamily: 'OpenSans-Semibold',
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: W * 0.03,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: H * 0.028,
                            width: W * 0.06,
                            child: Image.asset(
                              "assets/images/orange_arrow_frnt.png",
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  var  H = Get.height;
  Future updateLocation(double lat, double long,String city,) async {
    String? tokenAPI;
    tokenAPI = await getToken();
    setState((){
      tokenAPI;
      print(tokenAPI);
    });
    var token =
        "$tokenAPI";
    var apiURL =
        "https://ondemandflyers.com:8087/distributor/location";

    http.Response response = await http.patch(Uri.parse(apiURL),
        headers: {
          "Content-Type": "application/json",
          'x-access-token': token,
        },
        body: json.encode({
          "locations": [
            {"latitude": lat, "longitude": long, "address": "$subLocality,$locality,$state,$country","city" : city}
          ]
        }));
    if(response.statusCode == 200){
      Get.to(HomePage());
    }

    var data = jsonDecode(response.body);
    print(data);

    // dio.FormData formData = dio.FormData.fromMap({
    //   "locations": [
    //     {"latitude": lat, "longitude": long, "address": "$city, $state"}
    //   ]
    // });
    // var dio1 = Dio(
    //   BaseOptions(
    //     headers: {
    //       'Content-Type': 'application/json; charset=utf-8',
    //       'x-access-token': token,
    //     },
    //   ),
    // );
    //
    // var response = await dio1.patch(
    //   apiURL,
    //   data: formData,
    // );
    // if (response.statusCode == 200) {
    //   var data = response.data;
    //   print(data);
    // } else {
    //   var data = response.data;
    //   print(data);
    // }
  }
}