import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/Api/all_api.dart';
import 'package:flyerapp/Screens/LoginScreen/login_screen.dart';
import 'package:flyerapp/Screens/Terms%20&%20Condition/terms_and_condition.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Constants/colors.dart';
import 'package:get/get.dart';
import '../../Widgets/progress_indicator.dart';
import '../HomePage/PreferedLocation/prefered_location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  void initState() {
    super.initState();
    getMyJobData();
  }

  List _dropDownList = [];
  bool _loading = false;
  void getMyJobData() async {
    var url =
        "https://ondemandflyers.com:8087/distributor/applicableDocumentList";
    var response = await http.get(
      Uri.parse(
        url,
      ),
      headers: {
        // 'x-access-token': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDhmNmEwOTQ4MzhiNjc5MDZiN2VmOCIsImlhdCI6MTY1ODQ3MTc2NiwiZXhwIjoxNjY4ODM5NzY2fQ.3tWNWqu9CQCAFMAlFJHsVQhAaMllwUugDY7xLaR7R-I",
        "content-type": "application/json",
      },
    );
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    setState(() {
      _dropDownList = jsonData['data'];
      print(_dropDownList[0]['label']);
    });
    print(jsonData);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool checkBox = false;
  final formKey = GlobalKey<FormState>();
  File? image;
  // File? file;
  File? file1;
  File? file2;
  String? downloadUrl1;
  String? downloadUrl2;
  bool isLoading = false;
  String? imageMime;
  String? imageMime1;
  String? imageMime2;
  String? _myState;

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: H * 0.1,
                  ),
                  Text(
                    "Create New Account",
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: H * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you are already registered.",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Light',
                            fontSize: 18,
                            color: flyGray1),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          " Sign In",
                          style: TextStyle(
                              fontFamily: 'OpenSans-Medium',
                              fontSize: 18,
                              color: flyBlue2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: H * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: "Choose Option",
                          titleStyle: TextStyle(color: flyOrange2),
                          middleText: "",
                          content: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: H * 0.01, bottom: H * 0.009),
                                child: InkWell(
                                  onTap: () async {
                                    var status = await Permission.camera.status;
                                    if (status.isDenied) {
                                      Get.defaultDialog(
                                          title: "",
                                          titleStyle: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'OpenSans-Bold',
                                              color: flyBlack2),
                                          content: Column(
                                            children: [
                                              Text(
                                                "Go to settings for allow the camera permission.",
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
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Center(
                                                            child: Text(
                                                          "Ok",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'OpenSans-Bold',
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ));
                                    } else {
                                      pickImage(ImageSource.camera);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.camera,
                                        color: flyOrange2,
                                      ),
                                      Text(
                                        " Camera",
                                        style: TextStyle(
                                          fontFamily: "OpenSans-Regular",
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: H * 0.01, bottom: H * 0.009),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        color: flyOrange2,
                                      ),
                                      Text(
                                        " Gallery",
                                        style: TextStyle(
                                          fontFamily: "OpenSans-Regular",
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: flyOrange3,
                      child: CircleAvatar(
                        radius: 43,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        backgroundImage: image != null
                            ? FileImage(image!) as ImageProvider
                            : AssetImage("assets/images/Profile_pic.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.05,
                  ),
                  Container(
                      width: W * 0.85,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text("Full Name"),
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
                    height: H * 0.04,
                  ),
                  Container(
                    width: W * 0.85,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0.5)),
                    child: Center(
                      child: IntlPhoneField(
                        controller: phoneController,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text("Phone Number"),
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Regular',
                                color: flyGray3),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: flyGray4))),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          print(phone.number);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.04,
                  ),
                  Container(
                      width: W * 0.85,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text("Email"),
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
                    height: H * 0.04,
                  ),
                  Container(
                      width: W * 0.85,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          obscureText: hidePassword1,
                          controller: passwordController,
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
                              label: Text("Password"),
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
                    height: H * 0.04,
                  ),
                  Container(
                      width: W * 0.85,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          obscureText: hidePassword2,
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      hidePassword2 = !hidePassword2;
                                    });
                                  },
                                  child: hidePassword2
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
                              label: Text("Confirm Password"),
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
                  Center(
                    child: Container(
                      width: W * 0.85,
                      height: H * 0.08,
                      decoration:
                          BoxDecoration(border: Border.all(color: flyGray2)),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: _myState,
                            iconSize: 30,
                            icon: (null),
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Regular',
                                color: flyBlack2),
                            hint: Text(
                              'Select Document Type',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'OpenSans-Regular',
                                  color: flyBlack2),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myState = newValue;
                                getMyJobData();
                                print(_myState);
                              });
                            },
                            items: _dropDownList.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['value']),
                                value: item['value'].toString(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.04,
                  ),
                  Container(
                    height: H * 0.14,
                    width: W * 0.85,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 2), color: flyGray4)
                        ],
                        color: flyWhite,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          color: flyGray4,
                        )),
                    child: InkWell(
                      onTap: () {
                        Get.defaultDialog(
                            title: "Choose Option",
                            titleStyle: TextStyle(color: flyOrange2),
                            middleText: "",
                            content: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: H * 0.01, bottom: H * 0.009),
                                  child: InkWell(
                                    onTap: () async {
                                      var status =
                                          await Permission.camera.status;
                                      if (status.isDenied) {
                                        Get.defaultDialog(
                                            title: "",
                                            titleStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'OpenSans-Bold',
                                                color: flyBlack2),
                                            content: Column(
                                              children: [
                                                Text(
                                                  "Go to settings for allow the camera permission.",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Center(
                                                              child: Text(
                                                            "Ok",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'OpenSans-Bold',
                                                                color: Colors
                                                                    .white),
                                                          ))),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));
                                      }
                                      pickImage4(ImageSource.camera);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.camera,
                                          color: flyOrange2,
                                        ),
                                        Text(
                                          " Camera",
                                          style: TextStyle(
                                            fontFamily: "OpenSans-Regular",
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    pickImage4(ImageSource.gallery);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: H * 0.01, bottom: H * 0.009),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.photo,
                                          color: flyOrange2,
                                        ),
                                        Text(
                                          " Gallery",
                                          style: TextStyle(
                                            fontFamily: "OpenSans-Regular",
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      },
                      child: Center(
                        child: file1 == null
                            ? buildDottedBorderRegister(
                                H, W, "  Upload Front Side")
                            : buildUploadNoDotted1(H),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.02,
                  ),
                  Container(
                    height: H * 0.14,
                    width: W * 0.85,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 2), color: flyGray4)
                        ],
                        color: flyWhite,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          color: flyGray4,
                        )),
                    child: InkWell(
                      onTap: () {
                        Get.defaultDialog(
                            title: "Choose Option",
                            titleStyle: TextStyle(color: flyOrange2),
                            middleText: "",
                            content: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: H * 0.01, bottom: H * 0.009),
                                  child: InkWell(
                                    onTap: () async {
                                      var status =
                                          await Permission.camera.status;
                                      if (status.isDenied) {
                                        Get.defaultDialog(
                                            title: "",
                                            titleStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'OpenSans-Bold',
                                                color: flyBlack2),
                                            content: Column(
                                              children: [
                                                Text(
                                                  "Go to settings for allow the camera permission.",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Center(
                                                              child: Text(
                                                            "Ok",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'OpenSans-Bold',
                                                                color: Colors
                                                                    .white),
                                                          ))),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));
                                      }
                                      pickImage3(ImageSource.camera);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.camera,
                                          color: flyOrange2,
                                        ),
                                        Text(
                                          " Camera",
                                          style: TextStyle(
                                            fontFamily: "OpenSans-Regular",
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    pickImage3(ImageSource.gallery);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: H * 0.01, bottom: H * 0.009),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.photo,
                                          color: flyOrange2,
                                        ),
                                        Text(
                                          " Gallery",
                                          style: TextStyle(
                                            fontFamily: "OpenSans-Regular",
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      },
                      child: Center(
                        child: file2 == null
                            ? buildDottedBorderRegister(
                                H, W, "  Upload Back Side")
                            : buildUploadNoDotted2(H),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: W * 0.04),
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkBox,
                            checkColor: Colors.white,
                            activeColor: flyOrange2,
                            onChanged: (value) {
                              setState(() {
                                checkBox = value!;
                              });
                            }),
                        Text(
                          "I Agree with the",
                          style: TextStyle(
                              fontFamily: 'OpenSans-Light',
                              shadows: [
                                Shadow(
                                    color: flyGray3, offset: Offset(1.2, 1.2))
                              ],
                              fontSize: 13,
                              color: flyBlack),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(TermsAndConditionCustomer());
                          },
                          child: Text(
                            " Terms & Conditions.",
                            style: TextStyle(
                                fontFamily: 'OpenSans-Medium',
                                shadows: [
                                  Shadow(
                                      color: flyGray3, offset: Offset(1.5, 1.5))
                                ],
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: flyBlack),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: H * 0.02,
                  ),
                  checkBox == true
                      ? InkWell(
                          onTap: () async {
                            if (fullNameController.text.isEmpty &&
                                phoneController.text.isEmpty &&
                                emailController.text.isEmpty &&
                                passwordController.text.isEmpty &&
                                confirmPasswordController.text.isEmpty) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Please fill the details!",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (fullNameController.text.length < 3) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Name must be at least 3 characters",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (phoneController.text.length != 10) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Phone Number is not valid",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (!emailController.text.contains(RegExp(
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
                                        "Email address is not valid",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (passwordController.text.length < 6) {
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (passwordController.text.length !=
                                confirmPasswordController.text.length) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Password does not match",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (image == null) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Please upload your picture",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (_myState == null) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Please select the type of document",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else if (file1 == null || file2 == null) {
                              Get.defaultDialog(
                                  title: "Error found",
                                  titleStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'OpenSans-Bold',
                                      color: flyBlack2),
                                  content: Column(
                                    children: [
                                      Text(
                                        "Document picture is required",
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
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
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            } else {
                              // _myState == "Driving License"?
                              signUp2(
                                  fullNameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  confirmPasswordController.text.trim(),
                                  phoneController.text.trim(),
                                  image!,
                                  file1!,
                                  file2!,
                                  context);
                            }
                          },
                          child: Container(
                            width: W * 0.8,
                            height: H * 0.08,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                    colors: [flyOrange1, flyOrange2],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight)),
                            child: Center(
                                child: Text(
                              "Next",
                              style: TextStyle(
                                  fontFamily: "Opensans-Bold",
                                  fontSize: 16,
                                  color: Colors.white),
                            )),
                          ),
                        )
                      : Container(
                          width: W * 0.8,
                          height: H * 0.08,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: flyGray3),
                          child: Center(
                              child: Text(
                            "Next",
                            style: TextStyle(
                                fontFamily: "Opensans-Bold",
                                fontSize: 16,
                                color: Colors.white),
                          )),
                        ),
                  SizedBox(
                    height: H * 0.06,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildUploadNoDotted1(double H) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: H * 0.025,
            child: Padding(
              padding: EdgeInsets.only(right: Get.width * 0.02),
              child: Image.asset("assets/images/upload_dl.png"),
            )),
        Container(
          width: W * 0.55,
          child: Center(
            child: Text(
              basename(file1!.path),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'OpenSans-Bold', color: flyBlack),
            ),
          ),
        )
      ],
    );
  }

  Row buildUploadNoDotted2(double H) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: H * 0.025,
            child: Padding(
              padding: EdgeInsets.only(right: Get.width * 0.02),
              child: Image.asset("assets/images/upload_dl.png"),
            )),
        Container(
          width: W * 0.55,
          child: Center(
            child: Text(
              basename(file2!.path),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'OpenSans-Bold', color: flyBlack),
            ),
          ),
        )
      ],
    );
  }

  buildDottedBorderRegister(double H, double W, String title) {
    return Container(
      height: H * 0.1,
      width: W * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: H * 0.025,
              child: Image.asset("assets/images/upload_dl.png")),
          Text(
            title,
            style: TextStyle(
                fontSize: 13, fontFamily: 'OpenSans-Medium', color: flyBlack),
          )
        ],
      ),
    );
  }

  var H = Get.height;
  var W = Get.width;
  Future signUp(String fullName, email, password, confirmPassword, phoneNumber,
      File displayPicture, File drivingLicense) async {
    var apiURL = "https://ondemandflyers.com:8087/distributor/signup";
    final bytes2 = Io.File(drivingLicense.path).readAsBytesSync();
    String base64File = base64.encode(bytes2);
    print("File: $base64File");
    final bytes = Io.File(displayPicture.path).readAsBytesSync();
    String base64Image = base64.encode(bytes);
    print("Image: $base64Image");

    var mapData = json.encode({
      "full_name": fullName,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "phone_number": phoneNumber,
      "display_picture": "data:image/jpg;base64,$base64Image",
      "document": "data:$imageMime;base64,$base64File",
      "document_type": _myState
    });
    print("JSON DATA : ${mapData}");
    http.Response response = await http.post(Uri.parse(apiURL),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: mapData);
    print("This is my response : ${response.body}");
    setState(() {
      isLoading = true;
    });
    try {
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        var data = jsonDecode(response.body);
        Get.to(LoginScreen());
        Get.defaultDialog(
            title: "Congratulations!",
            titleStyle: TextStyle(
                fontSize: 18, fontFamily: 'OpenSans-Bold', color: flyOrange2),
            content: Column(
              children: [
                Text(
                  "A verification mail is sent to your email id",
                  style: TextStyle(
                      fontSize: 12,
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
                          padding: EdgeInsets.all(12),
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
                  ],
                )
              ],
            ));
        print("DataForResponse: ${data}");
        print("Response ye hai : ${response.statusCode}");
      } else if (response.statusCode == 409) {
        Get.defaultDialog(
            title: "Error found",
            titleStyle: TextStyle(
                fontSize: 15, fontFamily: 'OpenSans-Bold', color: flyBlack2),
            content: Column(
              children: [
                Text(
                  "Email Already Exist",
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
                        Get.to(LoginScreen());
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                              child: Text(
                            "Click here",
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
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUp2(
      String fullName,
      email,
      password,
      confirmPassword,
      phoneNumber,
      File displayPicture,
      File drivingLicense1,
      File drivingLicense2,
      BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: flyOrange2,
          ));
        });
    var apiURL = "https://ondemandflyers.com:8087/distributor/signup";
    final bytes2 = Io.File(drivingLicense1.path).readAsBytesSync();
    String base64File = base64.encode(bytes2);
    print("File: $base64File");
    final bytes3 = Io.File(drivingLicense2.path).readAsBytesSync();
    String base64File2 = base64.encode(bytes3);
    print("File: $base64File2");
    final bytes = Io.File(displayPicture.path).readAsBytesSync();
    String base64Image = base64.encode(bytes);
    print("Image: $base64Image");
    imageMime1 = lookupMimeType(file1!.path);
    print(imageMime2);
    imageMime2 = lookupMimeType(file2!.path);
    print(imageMime2);
    print("File: $base64File");
    print("File2: $base64File2");

    var mapData = json.encode({
      "full_name": fullName,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "phone_number": phoneNumber,
      "display_picture": "data:image/jpg;base64,$base64Image",
      "document_front": "data:$imageMime1;base64,$base64File",
      "document_back": "data:$imageMime2;base64,$base64File2",
      "document_type": _myState
    });
    print("JSON DATA : ${mapData}");
    print(imageMime1);
    print(imageMime2);

    http.Response response = await http.post(Uri.parse(apiURL),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: mapData);
    print("This is my response : ${response.body}");
    setState(() {
      isLoading = true;
    });
    try {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        setState(() {
          isLoading = false;
        });
        var data = jsonDecode(response.body);
        Navigator.of(context).pop();
        Get.to(LoginScreen());
        Get.defaultDialog(
            title: "Congratulations!",
            titleStyle: TextStyle(
                fontSize: 18, fontFamily: 'OpenSans-Bold', color: flyOrange2),
            content: Column(
              children: [
                Text(
                  "A verification mail is sent to your email id",
                  style: TextStyle(
                      fontSize: 12,
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
                          padding: EdgeInsets.all(12),
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
                  ],
                )
              ],
            ));
        print("DataForResponse: $data");
        print("Response ye hai : ${response.statusCode}");
      } else if (response.statusCode == 409) {
        Navigator.of(context).pop();
        Get.defaultDialog(
            title: "Error found",
            titleStyle: TextStyle(
                fontSize: 15, fontFamily: 'OpenSans-Bold', color: flyBlack2),
            content: Column(
              children: [
                Text(
                  "Email Already Exist",
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
                        Get.to(LoginScreen());
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                              child: Text(
                            "Click here",
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
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadImageCheck(
      String fullName, email, password, confirmPassword, phoneNumber) async {
    var bytes = File(image!.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    print('upload proccess started');
    var apiPostData = json.encode({
      "full_name": fullName,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "phone_number": phoneNumber,
    });
    http.Response response = await http.post(
        Uri.parse("https://ondemandflyers.com:8087/distributor/signup"),
        body: apiPostData);
    if (response.statusCode == 200) {
      print('successfull');
      print('JSON : ${response.body}');
    } else if (response.statusCode == 409) {
      Fluttertoast.showToast(msg: "Mail is already existed");
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
      print(base64Image);
      print(response.body);
      print('fail');
    }
  }

  // Future uploadDisplayPicture(
  //     fullName, email, password, confirmPassword, phoneNumber) async {
  //   // print('file ${drivingLicense.path}');
  //   // print('file ${displayPicture.path}');
  //   var stream = http.ByteStream(image!.openRead());
  //   stream.cast();
  //   var length = await image!.length();

  //   var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //         "https://ondemandflyers.com:8087/distributor/signup",
  //       ));
  //   String value1 = '';
  //   request.fields.addAll({
  //     "full_name": fullName,
  //     "email": email,
  //     "password": password,
  //     "confirm_password": confirmPassword,
  //     "phone_number": phoneNumber,
  //   });
  //   var multiPart = http.MultipartFile(
  //     'display_picture',
  //     stream,
  //     length,
  //     filename: image!.path,
  //   );
  //   request.files.add(multiPart);
  //   var multiPart2 = http.MultipartFile(
  //     'driving_license',
  //     stream,
  //     length,
  //     filename: file!.path,
  //   );
  //   request.files.add(multiPart2);
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     print('Image Uploaded');
  //     print('urlofpost = ${request.fields}');
  //   } else {
  //     print(response.statusCode);
  //     print('fail');
  //     print(image!.path);
  //   }
  // }

  Future<void> uploadImage() async {
    var stream = http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    var uri = Uri.parse("https://ondemandflyers.com:8087/distributor/signup");
    var request = http.MultipartRequest('POST', uri);
    request.fields['full_name'] = 'title';
    var multiPart = http.MultipartFile('display_picture', stream, length);

    request.files.add(multiPart);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploaded');
    } else {
      print('fail');
    }

    try {} catch (e) {}
  }

  Future registerUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Please wait...",
          );
        });
    {
      FirebaseFirestore.instance
          .collection("Google Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "full_name": FirebaseAuth.instance.currentUser?.displayName,
        "email": FirebaseAuth.instance.currentUser?.email,
        "phone_number": phoneController.text.trim(),
        "password": passwordController.text.trim(),
        "confirm_password": confirmPasswordController.text.trim(),
        "id": FirebaseAuth.instance.currentUser?.uid,
        "image": FirebaseAuth.instance.currentUser?.photoURL,
        "driving_license": downloadUrl1.toString()
      });
      displayToastMessage(
          "Congratulation, Your account has been created ", context);
      Get.to(PreferedLocation());
    }
  }

  // Future uploadFile() async {
  //   String postId = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child('driving_license')
  //       .child('post_$postId.jpg');
  //   await reference.putFile(file!);
  //   downloadUrl1 = await reference.getDownloadURL();
  //   return downloadUrl1;
  // }

  // Future selectFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf']);
  //   if (result == null) return;
  //   final path = result.files.single.path!;
  //   setState(() {
  //     file = File(path);
  //   });
  // }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        print(imageTemporary);
        this.image = imageTemporary;
        Get.back();
      });
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }

  // Future pickImage2(ImageSource source) async {
  //   try {
  //     final file = await ImagePicker().pickImage(source: source);
  //     if (file == null) return;
  //     final imageTemporary = File(file.path);
  //     setState(() {
  //       print(imageTemporary);
  //       this.file = imageTemporary;
  //       Get.back();
  //       imageMime = lookupMimeType(file.path);
  //       print(imageMime);
  //     });
  //   } on PlatformException catch (e) {
  //     print("Failed to pick image:$e");
  //   }
  // }

  Future pickImage3(ImageSource source) async {
    try {
      final file2 = await ImagePicker().pickImage(source: source);
      if (file2 == null) return;
      final imageTemporary = File(file2.path);
      setState(() {
        print(imageTemporary);
        this.file2 = imageTemporary;
        Get.back();
        imageMime2 = lookupMimeType(file2.path);
        print(imageMime2);
      });
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }

  Future pickImage4(ImageSource source) async {
    try {
      final file1 = await ImagePicker().pickImage(source: source);
      if (file1 == null) return;
      final imageTemporary = File(file1.path);
      setState(() {
        print(imageTemporary);
        this.file1 = imageTemporary;
        Get.back();
        imageMime1 = lookupMimeType(file1.path);
        print(imageMime1);
      });
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }

  // Future uploadPicture(BuildContext context) async {
  //   String postId = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child('images')
  //       .child('post_$postId.jpg');
  //   await reference.putFile(file!);
  //   downloadUrl2 = await reference.getDownloadURL();
  //   return downloadUrl2;
  // }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

class FirebaseApiForImage {
  static UploadTask? uploadFile(String destination, File image) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(image);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

showProgressBar(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Please wait...",
        );
      });
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
