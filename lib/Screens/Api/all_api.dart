import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../../Constants/colors.dart';
import '../../Widgets/progress_indicator.dart';
import '../HomePage/PreferedLocation/prefered_location.dart';
import '../HomePage/homepage.dart';
import '../LoginScreen/login_screen.dart';
import '../Registeration/registeration.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import '../UserModel/user_model.dart';
import 'package:http_parser/http_parser.dart';

class AllApi {
  signInWithApple() async {
    if (!await TheAppleSignIn.isAvailable()) {
      return;
    }
    final res = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email,Scope.fullName])
    ]);
  }

  Future signUp(String fullName, email, password, confirmPassword, phoneNumber,
      File displayPicture, File drivingLicense) async {
    var apiURL = "https://ondemandflyers.com:8087/distributor/signup";
    final bytes2 = Io.File(drivingLicense.path).readAsBytesSync();
    String base64File = base64.encode(bytes2);
    final bytes = Io.File(displayPicture.path).readAsBytesSync();
    String base64Image = base64.encode(bytes);
    var mapData = json.encode({
      "full_name": fullName,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "phone_number": phoneNumber,
      "display_picture": "data:image/jpg;base64,$base64Image",
      "driving_license": "data:application/pdf;base64,$base64File"
    });
    print("JSON DATA : ${mapData}");
    http.Response response = await http.post(Uri.parse(apiURL),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: mapData);
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Get.to(LoginScreen());
        print("DataForResponse: ${data}");
        print(response.statusCode);
        Fluttertoast.showToast(
            msg: "A Verification Email Sent To Your Email Id!");
      } else {
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future setChatMessage(message) async {
    var id = await getId();
    var baseUrl = "https://ondemandflyers.com:8087";
    final response = await http.post(Uri.parse("$baseUrl/chat/message"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "distributorId": id,
          "userId": id,
          "message": message,
          "roomName": id
        }),
        encoding: Encoding.getByName('utf-8'));
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
      } else {
        var data = jsonDecode(response.body);
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var H = Get.height;
  var W = Get.width;
  Future loginUser(email, password) async {
    final response = await http.post(
        Uri.parse("https://ondemandflyers.com:8087/distributor/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
          "password": password,
        }),
        encoding: Encoding.getByName('utf-8'));
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        print('Data : ${data["data"]["data"]}');
        setId(data["data"]["data"]["_id"]);
        setName(data["data"]["data"]["full_name"]);
        setToken(data["data"]["token"]);
        setEmail(data["data"]["data"]["email"]);
        setDisplayPicture(data["data"]["data"]["display_picture"]);
        setPhoneNumber(data["data"]["data"]["phone_number"]);
        //setAddress(data["data"]["data"]["locations"]["address"]);
        Get.to(PreferedLocation());
      } else if (response.statusCode == 403) {
        Get.defaultDialog(
            title: "Error found",
            titleStyle: TextStyle(
                fontSize: 15, fontFamily: 'OpenSans-Bold', color: flyBlack2),
            content: Column(
              children: [
                Text(
                  "Your Account Is Not Active, Please Contact Admin!",
                  style: TextStyle(
                      fontSize: 11,
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
      } else if (response.statusCode == 401) {
        Get.defaultDialog(
            title: "Error found",
            titleStyle: TextStyle(
                fontSize: 15, fontFamily: 'OpenSans-Bold', color: flyBlack2),
            content: Column(
              children: [
                Text(
                  "Invalid credentials",
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
      } else {
        var data = jsonDecode(response.body);
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future uploadDisplayPicture(fullName, email, password, confirmPassword,
      phoneNumber, File displayPicture) async {
    // print('file ${drivingLicense.path}');
    // print('file ${displayPicture.path}');
    var stream = http.ByteStream(displayPicture.openRead());
    stream.cast();
    var length = await displayPicture.length();

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          "https://ondemandflyers.com:8087/distributor/signup",
        ));
    String value1 = '';
    request.fields.addAll({
      "full_name": fullName,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "phone_number": phoneNumber,
    });
    request.fields['full_name'] = 'title';
    var multiPart = http.MultipartFile('display_picture', stream, length);
    request.files.add(multiPart);
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image Uploaded');
      print('urlofpost = ${request.fields}');
    } else {
      print('fail');
    }
  }

  Future updateProfile(
      phoneNumber, fullName, token, String? tokenFromAPI) async {
    dio.FormData formData = dio.FormData.fromMap({
      "phone_number": phoneNumber,
      // "driving_license": drivingLicense,
      "full_name": fullName,
      // "display_picture": await dio.MultipartFile.fromFile("$displayPicture",
      //     filename: DateTime.now().microsecond.toString())
    });
    var dio1 = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'x-access-token':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDAwNmVhOWNkMDRlNjI4YzY1ZTAxZiIsImlhdCI6MTY1ODEyMDkwMiwiZXhwIjoxNjY4NDg4OTAyfQ.Psr3BtgjY5cHd_frdj_I7mQ3wpBqw8i1OkrXvC_QKkw",
        },
      ),
    );

    var response = await dio1.put(
      'https://ondemandflyers.com:8087/distributor/profile',
      data: formData,
    );
    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
    } else {
      var data = response.data;
      print(data);
    }
  }
}
