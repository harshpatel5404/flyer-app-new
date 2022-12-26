import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/HomePage/Deliveries/deliveries.dart';
import 'package:flyerapp/Screens/HomePage/Help/help.dart';
import 'package:flyerapp/Screens/SharedPrefrence/sharedprefrence.dart';
import 'package:flyerapp/Screens/Take%20Picture/take_picture.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/colors.dart';
import '../HomePage/HomePage/homepage_main.dart';
import 'map_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class JobTracking extends StatefulWidget {
  @override
  State<JobTracking> createState() => _JobTrackingState();
}

class _JobTrackingState extends State<JobTracking> {
  String? jobId;
  String? tokenApi;
  File? image;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  Position? currentPosition;
  double? lat;
  double? long;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String? userName;
  String? idFromApi;
  String? iconUri;
  String? startLocation;
  String? endLocation;
  double? startLat;
  double? startLong;
  double? endLat;
  double? endLong;
  Timer? timer;
  Set<Marker>? _markers;
  Future locatePosition() async {
    idFromApi = await getId();
    userName = await getName();
    iconUri = await getDisplayPicture();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    lat = position.latitude;
    long = position.longitude;
    var data = ({
      "distributorId": idFromApi,
      "distributorName": userName,
      "lat": lat,
      "lng": long,
      "iconUri": iconUri
      // "time" : DateTime.now()
    });
    setState(() {
      print(userName);
      print(lat);
      print(long);
      print(idFromApi);
      print(iconUri);
      print(DateTime.now());
    });
    socket!.emit('liveLocationUpdate', {data});
  }

  Future getUserData() async {
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
    startLocation = await getStartLocation();
    endLocation = await getEndLocation();
    startLat = await getLatitudeStart();
    startLong = await getLongitudeStart();
    endLat = await getLatitudeEnd();
    endLong = await getLongitudeEnd();
    setState(() {});
    _initialPosition =
        CameraPosition(target: LatLng(lat!, long!), zoom: 14.4746);
    final Polyline _polyline = Polyline(
        polylineId: PolylineId('_polyline'),
        points: [LatLng(startLat!, startLong!), LatLng(endLat!, endLong!)]);
    _markers = {
      Marker(
          markerId: MarkerId('currentLocation'),
          icon: currentLocationIcon,
          position: LatLng(lat!, long!)),
      Marker(
          markerId: MarkerId('start'),
          icon: sourceIcon,
          position: LatLng(startLat!, startLong!)),
      Marker(
          markerId: MarkerId('end'),
          icon: destinationIcon,
          position: LatLng(endLat!, endLong!)),
    };
  }

  late CameraPosition _initialPosition;
  @override
  void dispose() {
    super.dispose();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getUserData());
  }

  @override
  void initState() {
    timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => locatePosition());
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getUserData());
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
            title: Text("Job Tracking"),
            titleTextStyle: TextStyle(
              fontFamily: "OpenSans-Semibold",
              fontSize: 22,
              color: Colors.black,
            ),
            titleSpacing: 2,
            actions: [
              Padding(
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
              )
            ],
          ),
          body: lat != null && long != null
              ? Stack(
                  children: [
                    GoogleMap(
                      polylines: _polylines,
                      initialCameraPosition: _initialPosition,
                      markers: Set.from(_markers!),
                      onMapCreated: (GoogleMapController controller) {
                        Future.delayed(Duration(milliseconds: 2000), () {
                          controller.animateCamera(CameraUpdate.newLatLngBounds(
                              MapUtils.boundsFromLatLngList(_markers!
                                  .map((loc) => loc.position)
                                  .toList()),
                              1));
                          setPolylines();
                          // _getPolyline();
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: H * 0.02),
                            child: InkWell(
                              onTap: () {
                                Get.to(TakePicture());
                              },
                              child: Container(
                                width: W * 0.35,
                                height: H * 0.06,
                                decoration: BoxDecoration(
                                  color: flyBlue1,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                ),
                                child: Center(
                                    child: Text(
                                  "Upload Photo",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 16,
                                      color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: W * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: H * 0.02),
                            child: InkWell(
                              onTap: () {
                                completeJob();
                              },
                              child: Container(
                                width: W * 0.35,
                                height: H * 0.06,
                                decoration: BoxDecoration(
                                  color: flyOrange2,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                ),
                                child: Center(
                                    child: Text(
                                  "Finish",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 16,
                                      color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: W * 0.03,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: flyOrange2,
                  ),
                )),
    );
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/map.png")
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/face.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/flyer.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBMrf4s0FyFlJyzJ6bVNizbhJmKlC-p3h4",
      PointLatLng(startLat!, startLong!),
      PointLatLng(endLat!, endLong!),
    );
    if (result.status == 'OK') {
      result.points.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5,
            polylineId: PolylineId('polyline'),
            color: Colors.red,
            points: polylineCoordinates));
      });
    }
  }

  Future completeJob() async {
    tokenApi = await getToken();
    jobId = await getJobId();
    userName = await getName();
    var jobTitle = await getJobTitle();
    var baseurl = "https://ondemandflyers.com:8087/distributor/completeJob";
    var jobIdForApi = jobId;
    var token = "$tokenApi";
    final response =
        await http.patch(Uri.parse("$baseurl/$jobIdForApi"), headers: {
      'x-access-token': token,
      "Content-Type": "application/json",
    });
    print(response.body);
    if (response.statusCode == 200) {
      Get.to(Deliveries());
      Fluttertoast.showToast(msg: "Job Completed Successfully!");
      functionForSocket({
        'type': 'Job',
        'title': 'Job Completed!',
        'description': '$userName has successfully completed the job $jobTitle',
        'jobId': jobId
      });
    }
  }
}
