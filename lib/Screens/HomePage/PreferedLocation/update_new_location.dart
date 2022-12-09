import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/HomePage/PreferedLocation/prefered_loca_edit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import '../../../Constants/colors.dart';
import '../../SharedPrefrence/sharedprefrence.dart';


class UpdateNewLocation extends StatefulWidget {
  const UpdateNewLocation({Key? key}) : super(key: key);

  @override
  State<UpdateNewLocation> createState() => _UpdateNewLocationState();
}

class _UpdateNewLocationState extends State<UpdateNewLocation> {
  DetailsResult? selectLocation;
  DetailsResult? cityLocation;
  late FocusNode selectFocusNode;
  late FocusNode cityFocusNode;
  late GooglePlace googlePlace;
  Timer? _debounce;
  List<AutocompletePrediction> predictions = [];
  TextEditingController placeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String apiKey = 'AIzaSyBMrf4s0FyFlJyzJ6bVNizbhJmKlC-p3h4';
    googlePlace = GooglePlace(apiKey);
    selectFocusNode = FocusNode();
    cityFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectFocusNode.dispose();
    cityFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: flyBackground,
        elevation: 0,
        leading: Container(
            child: InkWell(
                onTap: () {
                  Get.off(PreferedLocaEdit());
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4D4D4D),
                ))),
        title: Text("Location Update"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 22,
          color: Colors.black,
        ),
        titleSpacing: 2,
      ),
      backgroundColor: flyBackground,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  width: W * 0.9,
                  height: H * 0.08,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.transparent, width: 0.5)),
                  child: Center(
                    child: TextFormField(
                      autofocus: false,
                      controller: placeController,
                      focusNode: selectFocusNode,
                      decoration: InputDecoration(
                          suffixIcon: placeController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      predictions = [];
                                      placeController.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.clear_outlined,
                                    color: flyOrange2,
                                  ))
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          label: Text("Enter your preferred location..."),
                          labelStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Regular',
                              color: flyGray3),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: flyGray4))),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {}
                        });
                      },
                    ),
                  )),
              SizedBox(
                height: H * 0.02,
              ),
              Container(
                  width: W * 0.9,
                  height: H * 0.08,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.transparent, width: 0.5)),
                  child: Center(
                    child: TextFormField(
                      autofocus: false,
                      controller: cityController,
                      focusNode: cityFocusNode,
                      decoration: InputDecoration(
                          suffixIcon: cityController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      predictions = [];
                                      cityController.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.clear_outlined,
                                    color: flyOrange2,
                                  ))
                              : null,
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
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {}
                        });
                      },
                    ),
                  )),
              Container(
                height: H * 0.5,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: predictions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: flyOrange2,
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        predictions[index].description.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'OpenSans-Regular',
                            color: flyBlack),
                      ),
                      onTap: () async {
                        final placeId = predictions[index].placeId!;
                        final details = await googlePlace.details.get(placeId);
                        // print(details!.result!.geometry!.location!.lat);
                        if (details != null &&
                            details.result != null &&
                            mounted) {
                          if (selectFocusNode.hasFocus) {
                            setState(() {
                              selectLocation = details.result;
                              placeController.text =
                                  details.result!.formattedAddress!;
                              // print(selectLocation!.name);
                              // print(selectLocation!.geometry!.location!.lat);
                              // print(selectLocation!.geometry!.location!.lng);
                              // print(selectLocation!.formattedAddress);
                              
                            });
                          } else if (cityFocusNode.hasFocus) {
                            setState(() {
                              cityLocation = details.result;
                              cityController.text = cityLocation!.name!;
                              
                            });
                          }
                        }
                        predictions.clear();
                      },
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  updateLocation();
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: H * 0.13),
                  child: Container(
                    width: W * 0.8,
                    height: H * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                            colors: [flyOrange1, flyOrange2],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight)),
                    child: Center(
                        child: Text(
                      "Update",
                      style: TextStyle(
                          fontFamily: "Opensans-Bold",
                          fontSize: 18,
                          color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future updateLocation() async {
    String? tokenAPI;
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    var token = "$tokenAPI";
    var apiURL = "https://ondemandflyers.com:8087/distributor/location";

    http.Response response = await http.patch(Uri.parse(apiURL),
        headers: {
          "Content-Type": "application/json",
          'x-access-token': token,
        },
        body: json.encode({
          "locations": [
            {
              "latitude": selectLocation!.geometry!.location!.lat,
              "longitude": selectLocation!.geometry!.location!.lng,
              "address": selectLocation!.formattedAddress,
              "city": cityLocation!.name
            }
          ]
        }));
    if (response.statusCode == 200) {
      Get.to(PreferedLocaEdit());
      Fluttertoast.showToast(msg: "Your location update successfully");
    }

    var data = jsonDecode(response.body);
    print(data);
  }
}
