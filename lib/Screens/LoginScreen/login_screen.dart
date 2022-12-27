import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Constants/colors.dart';
import 'package:flyerapp/Screens/Api/all_api.dart';
import 'package:flyerapp/Screens/Face%20Recognition/face_recognition.dart';
import 'package:flyerapp/Screens/Forgot%20password/forgot_password.dart';
import 'package:flyerapp/Screens/HomePage/PreferedLocation/prefered_location.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/Registeration/registeration.dart';
import 'package:flyerapp/Screens/Registeration/registeration.dart';
import 'package:flyerapp/Screens/Registeration/registration_facebook.dart';
import 'package:flyerapp/Screens/Registeration/registration_google.dart';
import 'package:flyerapp/Screens/User/user.dart';
import 'package:flyerapp/main.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../../Widgets/progress_indicator.dart';
import '../Google Sign in/google_api.dart';
import '../Registeration/registration_apple.dart';
import '../SharedPrefrence/sharedprefrence.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
bool hidePassword1 = true;
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
GoogleSignInAccount? currentUser;
String userEmail = "";

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: H * 0.06,
                ),
                Text(
                  "Hey,",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: H * 0.005,
                ),
                Text(
                  "Sign in now",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: H * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If you are new?",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Light',
                          fontSize: 17,
                          color: flyGray1),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(Registration());
                      },
                      child: Text(
                        " Create New Account",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Medium',
                            fontSize: 17,
                            color: Colors.blue.shade800),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: H * 0.05,
                ),
                Container(
                    width: W * 0.85,
                    height: H * 0.08,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 0.5)),
                    child: Center(
                      child: TextFormField(
                        // validator: (value){
                        // if(value == null || value.isEmpty){
                        // return 'Enter your email address';
                        // }else if (RegExp(
                        //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        //     .hasMatch(value)) {
                        //   return null;
                        // }else{
                        //   return 'Please enter valid email address';
                        // }
                        // },
                        controller: email,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                color: flyGray3),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                    )),
                SizedBox(
                  height: H * 0.02,
                ),
                Container(
                    width: W * 0.85,
                    height: H * 0.08,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 0.5)),
                    child: Center(
                      child: TextFormField(
                        controller: password,
                        obscureText: hidePassword1,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    hidePassword1 = !hidePassword1;
                                  });
                                },
                                child: hidePassword1
                                    ? Icon(
                                        Icons.visibility_outlined,
                                        color: flyGray3,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: flyGray3,
                                      )),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                color: flyGray3),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                    )),
                SizedBox(
                  height: H * 0.04,
                ),
                InkWell(
                  onTap: () {
                    Get.to(ForgotPassword());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontFamily: 'OpenSans-Medium',
                        fontSize: 16,
                        color: flyMargenta),
                  ),
                ),
                SizedBox(height: H * 0.03),
                InkWell(
                  onTap: () async {
                    if (!email.text.contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                      Get.defaultDialog(
                          title: "Error found",
                          titleStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2),
                          content: Column(
                            children: [
                              Text(
                                "Email is required",
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
                                            borderRadius: BorderRadius.all(
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
                                            borderRadius: BorderRadius.all(
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
                    } else if (password.text.isEmpty) {
                      Get.defaultDialog(
                          title: "Error found",
                          titleStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2),
                          content: Column(
                            children: [
                              Text(
                                "Password is required",
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
                                            borderRadius: BorderRadius.all(
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
                                            borderRadius: BorderRadius.all(
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
                    } else if (password.text.length < 6) {
                      Get.defaultDialog(
                          title: "Error found",
                          titleStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2),
                          content: Column(
                            children: [
                              Text(
                                "Password must be atleast 6 characters",
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
                                            borderRadius: BorderRadius.all(
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
                                            borderRadius: BorderRadius.all(
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
                      setState(() {
                        loading == true;
                        const CircularProgressIndicator(
                          color: flyOrange2,
                        );
                      });
                      print('clicked');
                      await loginUser(email.text.trim(), password.text.trim());
                      setState(() {
                        loading == false;
                      });
                    }
                  },
                  child: Container(
                    width: W * 0.85,
                    height: H * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                            colors: [flyOrange1, flyOrange2],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight)),
                    child: Center(
                        child: Text(
                      "Sign In",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 16,
                          color: Colors.white),
                    )),
                  ),
                ),
                SizedBox(height: H * 0.08),
                Text(
                  "Or",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Light',
                      fontSize: 19,
                      color: Color(0xFFCBCBCB)),
                ),
                Text(
                  "Sign in with",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 18,
                      color: flyGray1),
                ),
                SizedBox(height: H * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        signInWithFacebook();
                      },
                      child: CircleAvatar(
                        radius: 31,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 30,
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          child: Container(
                            height: H * 0.035,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/facebook.png"))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: W * 0.05,
                    ),
                    InkWell(
                      onTap: () {
                        googleLogin();
                      },
                      child: CircleAvatar(
                        radius: 31,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 30,
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          child: Container(
                            height: H * 0.035,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/google.png"))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: W * 0.05,
                    ),
                    if (Platform.isIOS)
                      InkWell(
                        onTap: () async {
                          await signinApple();
                        },
                        child: CircleAvatar(
                          radius: 31,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 30,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            child: Container(
                              height: H * 0.04,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/apple.png"))),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future loginUser(email, password) async {
    var H = Get.height;
    var W = Get.width;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: flyOrange2,
          ));
        });
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
        Navigator.of(context).pop();
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
        print(response.body);
        Navigator.of(context).pop();
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
        Navigator.of(context).pop();
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

  Future signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      final userEmail = userData['email'];
      final userName = userData['name'];
      print(userEmail);
      if (loginResult.status == LoginStatus.success) {
        setFacebookEmail(userEmail);
        setFacebookName(userName);
        Get.to(FacebookRegistration());
      }
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print("facebook error $e");
    }
  }

  // Future<String?> signInWithFacebook() async {
  //   try {
  //     final FirebaseAuth _auth = FirebaseAuth.instance;
  //     final _instance = FacebookAuth.instance;
  //     final result = await _instance.login(permissions: ['email']);
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);
  //       final a = await _auth.signInWithCredential(credential);
  //       await _instance.getUserData().then((userData) async {
  //         await _auth.currentUser!.updateEmail(userData['email']);
  //       });

        
  //     } else if (result.status == LoginStatus.cancelled) {
  //       print("cancelled");
  //       return 'Login cancelled';
  //     } else {
  //       print("error");
  //       return 'Error';
  //     }
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  Future googleLogin() async {
    print("googleLogin method Called");

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }

      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $reslut");
      print(reslut.displayName);
      print(reslut.email);
      print(reslut.photoUrl);
      Get.to(GoogleSignInRegistration());
    } catch (error) {
      print(error);
    }
  }

  Future signIn() async {
    var apiURL = "https://ondemandflyers.com:8087/distributor/login";
    Map mapData = {
      "email": email.text.trim(),
      "password": password.text.trim()
    };
    print("JSON DATA : ${mapData}");
    http.Response response = await http.post(Uri.parse(apiURL), body: mapData);
    var data = jsonDecode(response.body);
    print("Data: ${data}");
    loading ? CircularProgressIndicator() : Get.to(HomePage());
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "  Authenticating,Please wait...",
          );
        });
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  signinApple() async {
    if (!await TheAppleSignIn.isAvailable()) {
      return null; //Break from the program
    }

    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (await TheAppleSignIn.isAvailable()) {
      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider('apple.com');
          print(result.credential!.user);
          Get.to(GoogleSignInRegistration());

          break; //All the required credentials
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error!.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }
// Future googleSignIn() async{
//   await GoogleSignInApi.login();
// }
}
