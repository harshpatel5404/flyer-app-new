import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/Profile/change_dl.dart';
import 'package:mime/mime.dart';
import '../../Constants/colors.dart';
import 'package:get/get.dart';
import '../../Widgets/progress_indicator.dart';
import '../HomePage/PreferedLocation/prefered_location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import '../SharedPrefrence/sharedprefrence.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool checkBox = false;

  File? image;
  File? file;
  String? downloadUrl1;
  String? downloadUrl2;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
      getProfileData();
  }
  Future getProfileData() async {
    userNameAPI = await getName();
    userEmail = await getEmail();
    displayPicture = await getDisplayPicture();
    drivingLicenseFromAPi = await getDrivingLicense();
    phoneNumber = await getPhoneNumber();
    password = await getPassword();
    tokenFromAPI = await getToken();
    print("MyToken : $tokenFromAPI");
    setState((){
      userNameAPI;
      userEmail;
      displayPicture;
      drivingLicenseFromAPi;
      phoneNumber;
      password;
      tokenFromAPI;
    });
    tokenAPI = await getToken();
    setState(() {
      tokenAPI;
      print(tokenAPI);
    });
    var url =
        "https://ondemandflyers.com:8087/distributor/profile";
    var response = await http.get(
      Uri.parse(
        url,
      ),
      headers: {
        'x-access-token': "$tokenAPI",
      },
    );
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    var jsonData = jsonDecode(response.body);
    print("This is my Profile : $jsonData");
    nameForProfile = jsonData["data"]["full_name"];
    phoneForProfile = jsonData["data"]["phone_number"];
    dpForProfile = jsonData["data"]["display_picture"];
    dlForProfileFront = jsonData["data"]["document_front"];
    dlForProfileBack = jsonData["data"]["document_back"];
    documentType = jsonData["data"]["document_type"];

    print(jsonData["data"]["full_name"]);
    fullNameController.text = nameForProfile!;
    phoneController.text = phoneForProfile!;
    setState((){});
  }


  @override
  Widget build(BuildContext context) {

    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: flyBackground,
          elevation: 0,
          leading: Container(
              child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
          title: Text("Edit your profile"),
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans-Semibold",
            fontSize: 20,
            color: Colors.black,

          ),
          titleSpacing: 2,
        ),
        backgroundColor: flyBackground,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
               dlForProfileBack == null ?
               buildFrontColumn(H, W) :
               buildFrontAndColumn(H, W),
                SizedBox(height: H*0.04,),
                InkWell(
                  onTap: (){
                    if(fullNameController.text.isEmpty){
                      Get.defaultDialog(
                          title: "",
                          titleStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'OpenSans-Bold',
                              color: flyOrange2
                          ),
                          content: Column(
                            children: [
                              Text("Please enter your name",style:TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'OpenSans-Bold',
                                  color: flyBlack2
                              ),),
                              SizedBox(height: H*0.02,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: flyOrange2,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                                            fontFamily: 'OpenSans-Bold',
                                            color: Colors.white),))
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                      );
                    }
                    else if(phoneController.text.length != 10){
                      Get.defaultDialog(
                          title: "",
                          titleStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'OpenSans-Bold',
                              color: flyOrange2
                          ),
                          content: Column(
                            children: [
                              Text("Please check your phone number!",style:TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'OpenSans-Bold',
                                  color: flyBlack2
                              ),),
                              SizedBox(height: H*0.02,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: flyOrange2,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                                            fontFamily: 'OpenSans-Bold',
                                            color: Colors.white),))
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                      );
                    }else{
                      updateProfileForText();
                      updateProfileForPhone();
                    }
                  },
                  child: Container(
                    width: W*0.8,
                    height: H*0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: flyOrange2
                    ),
                    child: Center(child:
                    Text("Update",
                      style: TextStyle(
                          fontFamily: "Opensans-Bold",
                          fontSize: 16,
                          color: Colors.white
                      ),
                    )
                    ),
                  ),
                ),
                SizedBox(height: H*0.06,),
              ],
            ),
          )
          ,
        ),
      ),
    );
  }

  Column buildFrontColumn(double H, double W) {
    return Column(
                children: [
                  SizedBox(
                    height: H*0.02,
                  ),
                  InkWell(
                    onTap: (){
                      Get.defaultDialog(
                          title: "Choose Option",
                          titleStyle: TextStyle(color: flyOrange2),
                          middleText: "",
                          content: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: H*0.01,bottom: H*0.009),
                                child: InkWell(
                                  onTap: (){
                                    pickImage(ImageSource.camera);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera,color: flyOrange2,),
                                      Text(" Camera",
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
                                onTap:(){
                                  pickImage(ImageSource.gallery);
                                },
                                child: Padding(
                                  padding:  EdgeInsets.only(left: H*0.01,bottom: H*0.009),
                                  child: Row(
                                    children: [
                                      Icon(Icons.photo,color: flyOrange2,),
                                      Text(" Gallery",
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
                          )
                      );
                    },
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: flyOrange3,
                      child: CircleAvatar(
                        radius: 43,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        backgroundImage: image != null ? FileImage(image!)  as ImageProvider : NetworkImage("$dpForProfile"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: H*0.05,
                  ),
                  Container(
                      width: W*0.85,
                      height: H*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent,width: 0.5)
                      ),
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
                                color: flyGray3
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: flyGray4)
                            ),
                          ),
                          onChanged: (value){
                            if(fullNameController.text.isNotEmpty){
                              value = fullNameController.text;
                            }
                          },
                        ),
                      )),
                  SizedBox(
                    height: H*0.04,
                  ),
                  Container(
                      width: W*0.85,
                      height: H*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent,width: 0.5)
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text("Phone Number"),
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'OpenSans-Regular',
                                  color: flyGray3
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: flyGray4)
                              )
                          ),
                        ),
                      )),
                  SizedBox(
                    height: H*0.04,
                  ),
                  documentType != null ?
                  Text(
                    "$nameForProfile's $documentType",
                    style: TextStyle(
                        color: flyBlack2,
                        fontFamily: "Opensans-Bold",
                        fontSize: 16),
                  ) :
                  Text(
                    "Loading...",
                    style: TextStyle(
                        color: flyBlack2,
                        fontFamily: "Opensans-Bold",
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: H*0.02,
                  ),
                  Container(
                    height: H*0.18,
                    width: W*0.85,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: file == null ? NetworkImage(
                              "$dlForProfileFront",
                            ) as ImageProvider : FileImage(file!)
                        )
                    ),
                  ),
                  SizedBox(
                    height: H*0.02,
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(ChangeDocs());
                    },
                    child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: flyGray5
                        ),
                        child: Text("Change Document",
                          style: TextStyle(
                            color: flyBlack,
                            fontFamily: "Opensans-Bold",
                            fontSize: 16,
                          ),
                        )
                    ),
                  ),
                ],
              );
  }
  Column buildFrontAndColumn(double H, double W) {
    return Column(
      children: [
        SizedBox(
          height: H*0.02,
        ),
        InkWell(
          onTap: (){
            Get.defaultDialog(
                title: "Choose Option",
                titleStyle: TextStyle(color: flyOrange2),
                middleText: "",
                content: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: H*0.01,bottom: H*0.009),
                      child: InkWell(
                        onTap: (){
                          pickImage(ImageSource.camera);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera,color: flyOrange2,),
                            Text(" Camera",
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
                      onTap:(){
                        pickImage(ImageSource.gallery);
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(left: H*0.01,bottom: H*0.009),
                        child: Row(
                          children: [
                            Icon(Icons.photo,color: flyOrange2,),
                            Text(" Gallery",
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
                )
            );
          },
          child: CircleAvatar(
            radius: 46,
            backgroundColor: flyOrange3,
            child: CircleAvatar(
              radius: 43,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              backgroundImage: image != null ? FileImage(image!)  as ImageProvider : NetworkImage("$dpForProfile"),
            ),
          ),
        ),
        SizedBox(
          height: H*0.05,
        ),
        Container(
            width: W*0.85,
            height: H*0.08,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent,width: 0.5)
            ),
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
                      color: flyGray3
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: flyGray4)
                  ),
                ),
                onChanged: (value){
                  if(fullNameController.text.isNotEmpty){
                    value = fullNameController.text;
                  }
                },
              ),
            )),
        SizedBox(
          height: H*0.04,
        ),
        Container(
            width: W*0.85,
            height: H*0.08,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent,width: 0.5)
            ),
            child: Center(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    label: Text("Phone Number"),
                    labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'OpenSans-Regular',
                        color: flyGray3
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: flyGray4)
                    )
                ),
              ),
            )),
        SizedBox(
          height: H*0.04,
        ),
        documentType != null ?
        Text(
          "$nameForProfile's $documentType",
          style: TextStyle(
              color: flyBlack2,
              fontFamily: "Opensans-Bold",
              fontSize: 16),
        ) :
        Text(
          "Loading...",
          style: TextStyle(
              color: flyBlack2,
              fontFamily: "Opensans-Bold",
              fontSize: 16),
        ),
        SizedBox(
          height: H*0.02,
        ),
        Container(
          height: H*0.18,
          width: W*0.85,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: file == null ? NetworkImage(
                    "$dlForProfileFront",
                  ) as ImageProvider : FileImage(file!)
              )
          ),
        ),
        SizedBox(
          height: H*0.01,
        ),
        Text(
          "Front",
          style: TextStyle(
              color: flyBlack2,
              fontFamily: "Opensans-Bold",
              fontSize: 16),
        ),
        Container(
          height: H*0.18,
          width: W*0.85,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: file == null ? NetworkImage(
                    "$dlForProfileBack",
                  ) as ImageProvider : FileImage(file!)
              )
          ),
        ),
        SizedBox(
          height: H*0.01,
        ),
        Text(
          "Back",
          style: TextStyle(
              color: flyBlack2,
              fontFamily: "Opensans-Bold",
              fontSize: 16),
        ),
        SizedBox(
          height: H*0.02,
        ),
        InkWell(
          onTap: (){
            Get.to(ChangeDocs());
          },
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: flyGray5
              ),
              child: Text("Change Document",
                style: TextStyle(
                  color: flyBlack,
                  fontFamily: "Opensans-Bold",
                  fontSize: 16,
                ),
              )
          ),
        ),
      ],
    );
  }

  Row buildUploadNoDotted(double H) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: H*0.025,
            child: Padding(
              padding:  EdgeInsets.only(right: Get.width*0.02),
              child: Image.asset("assets/images/upload_dl.png"),
            )),
        Text(basename(file!.path),
          style: TextStyle(
              fontSize: 13,
              fontFamily: 'OpenSans-Bold',
              color: flyBlack
          ),
        )
      ],
    );
  }

   buildDottedBorderRegister(double H, double W) {
    return Container(
      height: H*0.1,
      width: W*0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: H*0.025,
              child: Image.asset("assets/images/upload_dl.png")),
          Text("  Change Document",
            style: TextStyle(
                fontSize: 13,
                fontFamily: 'OpenSans-Medium',
                color: flyBlack
            ),
          )
        ],
      ),
    );
  }
  Future updateProfileForText() async {
    var H = Get.height;
    var W = Get.width;
    var apiURL = "https://ondemandflyers.com:8087/distributor/profile";
    var token = tokenFromAPI;
    var mapData = json.encode({
      "full_name" : fullNameController.text.trim(),
    });
    print("JSON DATA : $mapData");

    http.Response response = await http.put(Uri.parse(apiURL),
        headers: {"Content-Type": "application/json",
                  'x-access-token': "$token",
                  'Accept': 'application/json',},
        body: mapData);
    setState((){
      isLoading = true;
    });
    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("DataForResponse: ${data}");
        print(response.statusCode);

        Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans-Bold',
                color: flyOrange2
            ),
            content: Column(
              children: [
                Text("Your profile is successfully updated!",style:TextStyle(
                    fontSize: 12,
                    fontFamily: 'OpenSans-Bold',
                    color: flyBlack2
                ),),
                SizedBox(height: H*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        getProfileData();
                        Get.offAll(HomePage());
                        Get.back();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                  ],
                )
              ],
            )
        );

        setState((){
          isLoading = false;
        });
      }else{
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future updateProfileForPhone() async {
    var H = Get.height;
    var W = Get.width;
    var apiURL = "https://ondemandflyers.com:8087/distributor/profile";
    var token = tokenFromAPI;
    var mapData = json.encode({
      "phone_number" : phoneController.text.trim(),
    });
    print("JSON DATA : $mapData");

    http.Response response = await http.put(Uri.parse(apiURL),
        headers: {"Content-Type": "application/json",
          'x-access-token': "$token",
          'Accept': 'application/json',},
        body: mapData);
    print(response.statusCode);
    setState((){
      isLoading = true;
    });
    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("DataForResponse: ${data}");
        print(response.statusCode);

        Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans-Bold',
                color: flyOrange2
            ),
            content: Column(
              children: [
                Text("Your profile is successfully updated!",style:TextStyle(
                    fontSize: 12,
                    fontFamily: 'OpenSans-Bold',
                    color: flyBlack2
                ),),
                SizedBox(height: H*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        getProfileData();
                        Get.offAll(HomePage());
                        Get.back();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                  ],
                )
              ],
            )
        );

        setState((){
          isLoading = false;
        });
      }else if(response.statusCode ==409){
        Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans-Bold',
                color: flyOrange2
            ),
            content: Column(
              children: [
                Text("Phone Number Already Exist!",style:TextStyle(
                    fontSize: 12,
                    fontFamily: 'OpenSans-Bold',
                    color: flyBlack2
                ),),
                SizedBox(height: H*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                  ],
                )
              ],
            )
        );
      }
      else{
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future updateProfileForDp() async {
    final bytes2 = Io.File(image!.path).readAsBytesSync();
    String base64Image = base64.encode(bytes2);
    var apiURL = "https://ondemandflyers.com:8087/distributor/profile";
    var token = tokenFromAPI;
    var mapData = json.encode({
      "display_picture" : "data:image/jpg;base64,$base64Image",

    });
    print("JSON DATA : $mapData");

    http.Response response = await http.put(Uri.parse(apiURL),
        headers: {"Content-Type": "application/json",
          'x-access-token': "$token",
          'Accept': 'application/json',},
        body: mapData);
    setState((){
      isLoading = true;
    });
    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("DataForResponse: ${data}");
        print(response.statusCode);
        Fluttertoast.showToast(msg: "Profile Updated Successfully!");
        Get.offAll(HomePage());
        setState((){
          isLoading = false;
        });
      }else{
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future updateProfileForDL() async {
    final bytes = Io.File(file!.path).readAsBytesSync();
    String base64File = base64.encode(bytes);
    var apiURL = "https://ondemandflyers.com:8087/distributor/profile";
    var token = tokenFromAPI;
    var mapData = json.encode({
      "driving_license" : "data:$imageMime;base64,$base64File"
    });
    print("JSON DATA : $mapData");

    http.Response response = await http.put(Uri.parse(apiURL),
        headers: {"Content-Type": "application/json",
          'x-access-token': "$token",
          'Accept': 'application/json',},
        body: mapData);
    setState((){
      isLoading = true;
    });
    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("DataForResponse: ${data}");
        print(response.statusCode);
        Fluttertoast.showToast(msg: "Profile Updated Successfully!");
        Get.offAll(HomePage());
        setState((){
          isLoading = false;
        });
      }else{
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    }catch(e){
      print(e.toString());
    }
  }


  Future registerUser(BuildContext context)async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Please wait...",);
        }
    );
    {
      FirebaseFirestore.instance.collection("Google Users").doc(FirebaseAuth.instance.currentUser?.uid).set(
          {
            "full_name" : FirebaseAuth.instance.currentUser?.displayName,
            "email" : FirebaseAuth.instance.currentUser?.email,
            "phone_number" : phoneController.text.trim(),
            "password" : passwordController.text.trim(),
            "confirm_password" : confirmPasswordController.text.trim(),
            "id" : FirebaseAuth.instance.currentUser?.uid,
            "image" : FirebaseAuth.instance.currentUser?.photoURL,
            "driving_license" : downloadUrl1.toString()
          }
      );
      displayToastMessage("Congratulation, Your account has been created ", context);
      Get.to(PreferedLocation());
    }
  }
  Future uploadFile() async{
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child('driving_license').child('post_$postId.jpg');
    await reference.putFile(file!);
    downloadUrl1 = await reference.getDownloadURL();
    return downloadUrl1;
  }

  Future selectFile()async {
    var H = Get.height;
    var W = Get.width;
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );
    if(result == null) return drivingLicenseFromAPi;
    final path = result.files.single.path!;
    setState((){
      file = File(path);
      Get.defaultDialog(
          title: "",
          titleStyle: TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans-Bold',
              color: flyOrange2
          ),
          content: Column(
            children: [
              Text("Are you sure you want to select this file",style:TextStyle(
                  fontSize: 12,
                  fontFamily: 'OpenSans-Bold',
                  color: flyBlack2
              ),),
              SizedBox(height: H*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      updateProfileForDL();
                      Get.offAll(EditProfile());
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: H*0.015,horizontal: W*0.05),
                        decoration: BoxDecoration(
                            color: flyOrange2,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                            fontFamily: 'OpenSans-Bold',
                            color: Colors.white),))
                    ),
                  ),
                  SizedBox(width: W*0.03,),
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: flyGray2,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Center(child: Text("Cancel",style: TextStyle(fontSize: 13,
                            fontFamily: 'OpenSans-Bold',
                            color: flyBlack2),))
                    ),
                  ),
                ],
              )
            ],
          )
      );
    });

  }
  Future pickImage2(ImageSource source) async{
    var H = Get.height;
    var W = Get.width;
    try{
      final file = await ImagePicker().pickImage(source:source);
      if (file == null) return;
      final imageTemporary = File(file.path);
      setState((){
        print(imageTemporary);
        this.file = imageTemporary;
        Get.back();
        imageMime = lookupMimeType(file.path);
        print(imageMime);
        Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans-Bold',
                color: flyOrange2
            ),
            content: Column(
              children: [
                Text("Are you sure you want to select this file",style:TextStyle(
                    fontSize: 12,
                    fontFamily: 'OpenSans-Bold',
                    color: flyBlack2
                ),),
                SizedBox(height: H*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        updateProfileForDL();
                        getProfileData();
                        Get.offAll(EditProfile());
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: H*0.015,horizontal: W*0.05),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                    SizedBox(width: W*0.03,),
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: flyGray2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Cancel",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2),))
                      ),
                    ),
                  ],
                )
              ],
            )
        );
      });
    }on PlatformException catch (e){
      print("Failed to pick image:$e");
    }
  }

  Future pickImage(ImageSource source) async{
    var H = Get.height;
    var W = Get.width;
    try{
      final image = await ImagePicker().pickImage(source:source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState((){
        this.image = imageTemporary;
        Get.back();
        Get.defaultDialog(
            title: "",
            titleStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans-Bold',
                color: flyOrange2
            ),
            content: Column(
              children: [
                Text("Are you sure you want to select this file",style:TextStyle(
                    fontSize: 12,
                    fontFamily: 'OpenSans-Bold',
                    color: flyBlack2
                ),),
                SizedBox(height: H*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        updateProfileForDp();
                        getProfileData();
                        Get.offAll(EditProfile());
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: H*0.015,horizontal: W*0.05),
                          decoration: BoxDecoration(
                              color: flyOrange2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white),))
                      ),
                    ),
                    SizedBox(width: W*0.03,),
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: flyGray2,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(child: Text("Cancel",style: TextStyle(fontSize: 13,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2),))
                      ),
                    ),
                  ],
                )
              ],
            )
        );
        const Center(
          child: CircularProgressIndicator(
            color: flyOrange2,
          ),
        );
      });
    }on PlatformException catch (e){
      print("Failed to pick image:$e");
    }
  }

  Future uploadPicture(BuildContext context) async{
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child('images').child('post_$postId.jpg');
    await reference.putFile(file!);
    downloadUrl2 = await reference.getDownloadURL();
    return downloadUrl2;
  }

}
displayToastMessage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}
String? userNameAPI;
String? userEmail;
String? displayPicture;
String? drivingLicenseFromAPi;
String? phoneNumber;
String? password;
String? tokenFromAPI;
String? imageMime;
String? nameForProfile;
String? phoneForProfile;
String? dpForProfile;
String? dlForProfileFront;
String? dlForProfileBack;
String? documentType;
String? tokenAPI;