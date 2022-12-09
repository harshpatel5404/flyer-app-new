import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/Profile/profile.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../Constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

import '../HomePage/homepage.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import 'edit_profile.dart';

class ChangeDocs extends StatefulWidget {
  const ChangeDocs({Key? key}) : super(key: key);

  @override
  State<ChangeDocs> createState() => _ChangeDocsState();
}

class _ChangeDocsState extends State<ChangeDocs> {
  String? imageMime;
  String? _myState;
  List _dropDownList = [];
  bool _loading = false;
  File? file;
  File? file1;
  void getMyJobData()async{
    var url = "https://ondemandflyers.com:8087/distributor/applicableDocumentList";
    var response = await http.get(Uri.parse(url,),

      headers: {
        // 'x-access-token': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDhmNmEwOTQ4MzhiNjc5MDZiN2VmOCIsImlhdCI6MTY1ODQ3MTc2NiwiZXhwIjoxNjY4ODM5NzY2fQ.3tWNWqu9CQCAFMAlFJHsVQhAaMllwUugDY7xLaR7R-I",
        "content-type": "application/json",
      },);
    // JobModel jobModel = JobModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(jobModel.jobTitle);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    setState((){
      _dropDownList = jsonData['data'];
      print(_dropDownList[0]['label']);
    });
    print(jsonData);
  }
  @override
  void initState() {
    super.initState();
    getMyJobData();
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
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
        title: Text("Change Document"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 20,
          color: Colors.black,

        ),
        titleSpacing: 2,
      ),
      body: dlForProfileBack == null ? buildFrontColumn(W, H) : buildFrontAndBackColumn(W, H),
    );
  }

  Column buildFrontColumn(double W, double H) {
    return Column(
      children: [
        Center(
          child: Container(
            width: W * 0.85,
            height: H * 0.08,
            decoration: BoxDecoration(
                border: Border.all(color: flyGray2)
            ),
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
                  hint: Text('Select New Document Type',style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'OpenSans-Regular',
                      color: flyBlack2),),
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
        SizedBox(height: H*0.02,),
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
        SizedBox(height: H*0.02,),
        InkWell(
          onTap: (){
            if(_myState == null){
              Get.defaultDialog(
                title: "",
                  content: Column(
                    children: [
                      Text(
                        "Please select the document type",
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
            }else{
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
            }
          },
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: flyGray5
              ),
              child: Text("Upload New Document",
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
  Column buildFrontAndBackColumn(double W, double H) {
    return Column(
      children: [
        Center(
          child: Container(
            width: W * 0.85,
            height: H * 0.08,
            decoration: BoxDecoration(
                border: Border.all(color: flyGray2)
            ),
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
                  hint: Text('Select New Document Type',style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'OpenSans-Regular',
                      color: flyBlack2),),
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
        SizedBox(height: H*0.02,),
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
        SizedBox(height: H*0.02,),
        InkWell(
          onTap: (){
            if(_myState == null){
              Get.defaultDialog(
                  title: "",
                  content: Column(
                    children: [
                      Text(
                        "Please select the document type",
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
            }else{
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
            }
          },
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: flyGray5
              ),
              child: Text("Upload Front Side",
                style: TextStyle(
                  color: flyBlack,
                  fontFamily: "Opensans-Bold",
                  fontSize: 16,
                ),
              )
          ),
        ),
        SizedBox(height: H*0.02,),
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
        SizedBox(height: H*0.02,),
        InkWell(
          onTap: (){
            if(_myState == null){
              Get.defaultDialog(
                  title: "",
                  content: Column(
                    children: [
                      Text(
                        "Please select the document type",
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
            }else{
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
                            pickImage2(ImageSource.camera);
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
                          pickImage2(ImageSource.gallery);
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
            }
          },
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: flyGray5
              ),
              child: Text("Upload Back Side",
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
  Future pickImage(ImageSource source) async{
    var H = Get.height;
    var W = Get.width;
    try{
      final image = await ImagePicker().pickImage(source:source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState((){
        this.file = imageTemporary;
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
                        updateProfileForDL();
                          getProfileData();
                        Get.offAll(HomePage());
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
  Future pickImage2(ImageSource source) async{
    var H = Get.height;
    var W = Get.width;
    try{
      final file1 = await ImagePicker().pickImage(source:source);
      if (file1 == null) return;
      final imageTemporary = File(file1.path);
      setState((){
        this.file1 = imageTemporary;
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
                        updateProfileForDLBack();
                        getProfileData();
                        Get.offAll(HomePage());
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
  Future updateProfileForDL() async {
    final bytes = Io.File(file!.path).readAsBytesSync();
    String base64File = base64.encode(bytes);
    imageMime = lookupMimeType(file!.path);
    print(base64File);
    var apiURL = "https://ondemandflyers.com:8087/distributor/profile";
    var token = tokenFromAPI;
    var mapData = json.encode({
      "document_front" : "data:$imageMime;base64,$base64File",
      "document_type" : _myState
    });
    print("JSON DATA : $mapData");

    http.Response response = await http.put(Uri.parse(apiURL),
        headers: {"Content-Type": "application/json",
          'x-access-token': "$token",
          'Accept': 'application/json',},
        body: mapData);
    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("DataForResponse: ${data}");
        print(response.statusCode);
      }else{
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future updateProfileForDLBack() async {
    final bytes = Io.File(file1!.path).readAsBytesSync();
    String base64File = base64.encode(bytes);
    imageMime = lookupMimeType(file1!.path);
    print(base64File);
    var apiURL = "https://ondemandflyers.com:8087/distributor/profile";
    var token = tokenFromAPI;
    var mapData = json.encode({
      "document_back" : "data:$imageMime;base64,$base64File",
      "document_type" : _myState
    });
    print("JSON DATA : $mapData");

    http.Response response = await http.put(Uri.parse(apiURL),
        headers: {"Content-Type": "application/json",
          'x-access-token': "$token",
          'Accept': 'application/json',},
        body: mapData);
    try{
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print("DataForResponse: ${data}");
        print(response.statusCode);
      }else{
        var data = jsonDecode(response.body);
        print("Data: ${data}");
      }
    }catch(e){
      print(e.toString());
    }
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
    setState((){});
  }
}
