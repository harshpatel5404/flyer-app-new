import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyerapp/Constants/colors.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/LoginScreen/login_screen.dart';
import 'package:flyerapp/Screens/SharedPrefrence/sharedprefrence.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognition extends StatefulWidget {
  const FaceRecognition({
    Key? key,
  }) : super(key: key);

  @override
  State<FaceRecognition> createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool? _canCheckBiometric;
  bool? _isAuthenticate;
  bool showPincode = false;
  bool setPincode = false;
  String setPasswordHeder = "Set Password";
  int countFailedFace = 0;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  String tempSetPassword = "";
  String? finalEmail;
  String? finalToken;
  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _canCheckBiometric = null;
    setState(() {});
    _auth.isDeviceSupported().then((value) async {
      try {
        _canCheckBiometric = await _auth.canCheckBiometrics;
      } on PlatformException catch (e) {
        String passcode = await getPasscode();
        log("passcode " + passcode);
        _canCheckBiometric = false;
        if (passcode.isEmpty) {
          setPincode = true;
        } else {
          showPincode = true;
        }
      }
      if (_canCheckBiometric != null && _canCheckBiometric!) {
        _authenticateWithBiometrics();
      } else {
        String passcode = await getPasscode();
        log("passcode " + passcode);

        if (passcode.isEmpty) {
          setPincode = true;
        } else {
          showPincode = true;
        }
        setState(() {});
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticate != null) {
      _isAuthenticate = false;
      setState(() {});
    }
    try {
      _isAuthenticate = await _auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      _isAuthenticate = false;

      return;
    }
    if (!mounted) {
      return;
    }
    if (_isAuthenticate == true) {
      getValidationData().whenComplete(() async {
        callNavigate();
        setState(() {});
      });
    } else {
      countFailedFace++;
    }
    if (countFailedFace == 3) {
      String passcode = await getPasscode();
      log("passcode " + passcode);

      if (passcode.isEmpty) {
        setPincode = true;
      } else {
        showPincode = true;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: W,
          height: H,
          color: setPincode ? Colors.black : Colors.white,
          child: setPincode
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: PasscodeScreen(
                          title: Text(
                            setPasswordHeder,
                            style: TextStyle(color: Colors.white),
                          ),
                          passwordEnteredCallback: (String enteredPasscode) {
                            tempSetPassword = enteredPasscode;
                            setState(() {});
                            setPincode = false;
                            showPincode = true;
                            setState(() {});
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyBlack2),
                                content: Column(
                                  children: [
                                    Text(
                                      "Would you like to save your password",
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
                                            setPasscode(tempSetPassword);
                                            setPincode = false;
                                            showPincode = true;
                                            setState(() {});
                                            callNavigate();
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
                                            setPasscode("");
                                            setPincode = true;
                                            showPincode = false;
                                            setState(() {});
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
                          },
                          shouldTriggerVerification:
                              _verificationNotifier.stream,
                          cancelButton: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          deleteButton: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : showPincode
                  ? PasscodeScreen(
                      title: Text(
                        "Enter Password",
                        style: TextStyle(color: Colors.white),
                      ),
                      passwordEnteredCallback: (String enteredPasscode) async {
                        String passcode = await getPasscode();

                        bool isValid = passcode == enteredPasscode;
                        _verificationNotifier.add(isValid);
                        if (isValid) {
                          callNavigate();
                        }
                      },
                      cancelButton: InkWell(
                        onTap: () {
                          Get.to(FaceRecognition());
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      deleteButton: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      shouldTriggerVerification: _verificationNotifier.stream,
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/images/faceid.png",
                              width: W * 0.4,
                              height: W * 0.4,
                              color: _isAuthenticate == null
                                  ? Colors.black
                                  : _isAuthenticate!
                                      ? Colors.green
                                      : Colors.red),
                        ),
                        Positioned(
                            bottom: H * 0.1,
                            child: GestureDetector(
                              onTap: _authenticateWithBiometrics,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: W * 0.05, vertical: W * 0.05),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Please Authenticate Again',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                      ],
                    ),
        ),
      ),
    );
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

  callNavigate() {
    getValidationData().whenComplete(() {
      Timer(
          Duration(milliseconds: 300),
          () => (finalEmail == null && finalToken == null) ||
                  (finalEmail == "" && finalToken == "")
              ? Get.to(() => LoginScreen())
              : Get.to(() => HomePage()));
    });
  }
}
