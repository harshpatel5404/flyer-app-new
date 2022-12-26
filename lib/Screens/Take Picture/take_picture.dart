import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/HomePage/Help/help.dart';
import 'package:flyerapp/Screens/JobTracking/job_tracking.dart';
import 'package:flyerapp/Screens/SharedPrefrence/sharedprefrence.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/colors.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({Key? key}) : super(key: key);

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  double? lat;
  double? long;
  Position? currentPosition;
  String? country;
  String? state;
  String? locality;
  String? subLocality;
  String? jobIdFromApi;
  String? tokenFromApi;
  Future getLatLong() async {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    bool serviceEnabled;
    LocationPermission permission;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 15, fontFamily: 'OpenSans-Bold', color: flyBlack2),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
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
        setState(() {});
        List<Placemark> placemark = await placemarkFromCoordinates(lat!, long!);
        print(placemark[0].toString());
        setState(() {
          subLocality = placemark[0].subLocality;
          locality = placemark[0].locality;
          state = placemark[0].administrativeArea;
          country = placemark[0].country;
        });
      } else if (permission == LocationPermission.whileInUse) {
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
        setState(() {});
        List<Placemark> placemark = await placemarkFromCoordinates(lat!, long!);
        print(placemark[0].toString());
        setState(() {
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

  File? image;
  late GooglePlace? googlePlace;
  @override
  void initState() {
    super.initState();
    String apiKey = 'AIzaSyBMrf4s0FyFlJyzJ6bVNizbhJmKlC-p3h4';
    googlePlace = GooglePlace(apiKey);
  }

  List<AutocompletePrediction> predictions = [];
  void autoCompleteSearch(String value) async {
    var result = await googlePlace?.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        print(result.predictions!.first.description);
        predictions = result.predictions!;
      });
    }
  }

  TextEditingController cityController = TextEditingController();
  TextEditingController numOfFlyersDistributed = TextEditingController();
  TextEditingController numOfDoorHangersDistributed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: H * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.only(left: W * 0.05),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            height: H * 0.028,
                            width: W * 0.07,
                            child: Image.asset(
                              "assets/images/back_arrow.png",
                            )),
                      ),
                      Text(
                        "  Take Picture",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Medium', fontSize: 24),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: H * 0.03,
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: flyOrange3,
                        child: CircleAvatar(
                          radius: 102,
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          backgroundImage: image != null
                              ? FileImage(image!) as ImageProvider
                              : AssetImage("assets/images/door_hanger.png"),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        pickImageMethod(ImageSource.camera, 90);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: H * 0.2, left: W * 0.4),
                        child: Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 21,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: flyBackground,
                              backgroundImage:
                                  AssetImage("assets/images/add_image.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: H * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    country == null
                        ? Row(
                            children: [
                              Text(
                                " Tap here",
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Semibold',
                                    fontSize: 19,
                                    color: flyOrange2,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_downward_sharp,
                                color: flyOrange2,
                              )
                            ],
                          )
                        : Text(
                            "$subLocality,$locality,$state,$country",
                            style: TextStyle(
                                fontFamily: 'OpenSans-Semibold',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
                SizedBox(
                  height: H * 0.01,
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
                  height: H * 0.01,
                ),
                Container(
                    width: W * 0.9,
                    height: H * 0.07,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0.5)),
                    child: Center(
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text("Enter your city"),
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Regular',
                                color: flyGray3),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: flyGray4))),
                      ),
                    )),
                SizedBox(
                  height: H * 0.02,
                ),
                Container(
                    width: W * 0.9,
                    height: H * 0.07,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0.5)),
                    child: Center(
                      child: TextFormField(
                        controller: numOfFlyersDistributed,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text("Enter number of flyers"),
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Regular',
                                color: flyGray3),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: flyGray4))),
                      ),
                    )),
                SizedBox(
                  height: H * 0.02,
                ),
                Container(
                    width: W * 0.9,
                    height: H * 0.07,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0.5)),
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: numOfDoorHangersDistributed,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text("Enter number of door hangers"),
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Regular',
                                color: flyGray3),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: flyGray4))),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: W * 0.05, top: H * 0.09),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (image == null) {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyBlack2),
                                content: Column(
                                  children: [
                                    Text(
                                      "Please capture image!",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: flyBlack2),
                                    ),
                                    SizedBox(
                                      height: H * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                          } else if (cityController.text.isEmpty) {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyBlack2),
                                content: Column(
                                  children: [
                                    Text(
                                      "Please provide city name!",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: flyBlack2),
                                    ),
                                    SizedBox(
                                      height: H * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                          } else if (numOfFlyersDistributed.text.isEmpty) {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyBlack2),
                                content: Column(
                                  children: [
                                    Text(
                                      "Please provide number of flyer!",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: flyBlack2),
                                    ),
                                    SizedBox(
                                      height: H * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                          } else if (numOfDoorHangersDistributed.text.isEmpty) {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyBlack2),
                                content: Column(
                                  children: [
                                    Text(
                                      "Please provide number of Door Hanger!",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans-Bold',
                                          color: flyBlack2),
                                    ),
                                    SizedBox(
                                      height: H * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                          } else {
                            uploadImage();
                          }
                        },
                        child: Container(
                          width: W * 0.42,
                          height: H * 0.08,
                          decoration: BoxDecoration(
                            color: flyBlue1,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          child: Center(
                              child: Text(
                            "Upload Picture",
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 16,
                                color: Colors.white),
                          )),
                        ),
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

  Future uploadImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: flyOrange2,
          ));
        });
    tokenFromApi = await getToken();
    jobIdFromApi = await getJobId();
    var id = await getId();
    var userName = await getName();
    var jobTitle = await getJobTitle();
    print(jobTitle);
    print(userName);
    print(id);
    var apiURL = "https://ondemandflyers.com:8087/distributor/submitReport";
    var jobId = jobIdFromApi;
    final bytes2 = Io.File(image!.path).readAsBytesSync();
    String base64Image = base64.encode(bytes2);
    print("Image: $base64Image");

    var mapData = json.encode({
      "numOfFlyersDistributed": numOfFlyersDistributed.text.trim(),
      "numOfDoorHangersDistributed": numOfDoorHangersDistributed.text.trim(),
      "latitude": lat,
      "longitude": long,
      "address": "$subLocality,$locality,$state,$country",
      "city": cityController.text.trim(),
      "images": ["data:image/jpg;base64,$base64Image"]
    });
    print("JSON DATA : ${mapData}");
    var token = "$tokenFromApi";
    http.Response response = await http.post(Uri.parse("$apiURL/$jobId"),
        headers: {"Content-Type": "application/json", "x-access-token": token},
        body: mapData);
    var data = jsonDecode(response.body);
    print("This is my report id : ${data["data"]["_id"]}");
    var reportId = data["data"]["_id"];
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Get.offAll(JobTracking());
      Fluttertoast.showToast(msg: "Report Submitted Successfully!");
      functionForSocket({
        'type': 'Job Report',
        'title': 'Job Report Submission',
        'description': "$userName have submitted reports for the job $jobTitle",
        'jobId': jobId,
        'distributorId': id,
        'reportId': reportId,
      });
    }
  }

  Future pickImageMethod(ImageSource source, int imageQuality) async {
    try {
      final image = await ImagePicker()
          .pickImage(imageQuality: imageQuality, source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }
}
