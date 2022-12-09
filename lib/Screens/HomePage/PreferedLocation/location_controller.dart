// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_webservice/places.dart';
//
// class LocationController extends GetxController{
//   Placemark _placemark = Placemark();
//   Placemark get pickPlaceMarker => _placemark;
//   List<Prediction> _predictionList = [];
//   Future<List<Prediction>> searchLocation(BuildContext context,String text)async{
//     if(text != null && text.isNotEmpty){
//       http.Response response = await getLocationData(text);
//       var data = jsonDecode(response.body.toString());
//       print("my status is"+data["status"]);
//       if(data['status'] == 'OK'){
//         _predictionList = [];
//         data['predictions'].forEach((prediction)
//         => _predictionList.add(Prediction.fromJson(prediction)));
//       }else{
//         //ApiChecker.checkApi(response);
//       }
//     }
//     return _predictionList;
//   }
// }