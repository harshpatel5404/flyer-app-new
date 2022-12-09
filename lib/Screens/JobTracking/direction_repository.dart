// import 'package:dio/dio.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// class DirectionsRepository{
//   static const String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
//
//   final Dio dio;
//   DirectionsRepository({Dio dio}) : dio = dio ?? Dio();
//
//   Future<Directions>getDirection({
//   required LatLng origin,
//   required LatLng destination
//   })async{
//     final response = await dio.get(
//       baseUrl,
//       queryParameters: {
//         'origin' : "${origin.latitude},${origin.longitude}",
//         'destination' : "${destination.latitude},${destination.longitude}",
//         'key' : "AIzaSyBMrf4s0FyFlJyzJ6bVNizbhJmKlC-p3h4"
//       }
//     );
//     if(response.statusCode == 200){
//       return Directions.fromMap(response.data);
//     }
//     return 'error';
//   }
// }