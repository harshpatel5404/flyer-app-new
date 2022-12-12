import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/Face%20Recognition/face_recognition.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/LoginScreen/login_screen.dart';
import 'package:get/get.dart';
import '../SharedPrefrence/sharedprefrence.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({Key? key}) : super(key: key);

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  String? finalEmail;
  String? finalToken;
  int delaySecond = 2;
  @override
  void initState() {
    super.initState();

    getValidationData().whenComplete(() async {
      bool checkScreenLock = await getLockScreenEnable();
      Timer(
          const Duration(seconds: 2),
          () => Get.to(() => checkScreenLock
              ? const FaceRecognition()
              : (finalEmail == null && finalToken == null) ||
                      (finalEmail == "" && finalToken == "")
                  ? const LoginScreen()
                  : const HomePage()));
    });
  }

  Future getValidationData() async {
    var obtainedEmail = getEmail();
    var obtainedToken = getToken();
    finalEmail = await obtainedEmail;
    finalToken = await obtainedToken;
    setState(() {});

    print(finalEmail);
    print(finalToken);
  }

  delayPage() async {
    var duration = Duration(seconds: delaySecond);
    return Timer(duration, goToLoginScreen);
  }

  void goToLoginScreen() {
    Get.to(LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/splash_screen.png"),
      ),
    );
  }
}
