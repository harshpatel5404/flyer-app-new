import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:flyerapp/Screens/LoginScreen/login_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Constants/colors.dart';
import '../SharedPrefrence/sharedprefrence.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState(){
    super.initState();
  }
  String? message;
  String? tokenAPI;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool hidePassword3 = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
              child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
          title: Text("Change Password"),
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans-Semibold",
            fontSize: 22,
            color: Colors.black,

          ),
          titleSpacing: 2,

        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:  EdgeInsets.only(left: H*0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: H*0.05,),
                  Container(
                      width: W*0.9,
                      height: H*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent,width: 0.5)
                      ),
                      child: Center(
                        child: TextFormField(
                          obscureText: hidePassword1,
                          controller: passwordController,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: (){
                                    setState((){
                                      hidePassword1 = !hidePassword1;
                                    });
                                  },
                                  child: hidePassword1 ?
                                  Icon(Icons.visibility_outlined,color: flyGray3,) :
                                  Icon(Icons.visibility_off,color: flyGray3,))
                              ,filled: true,
                              fillColor: Colors.white,
                              label: Text("Old Password"),
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
                  SizedBox(height: H*0.02,),
                  Container(
                      width: W*0.9,
                      height: H*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent,width: 0.5)
                      ),
                      child: Center(
                        child: TextFormField(
                          obscureText: hidePassword2,
                          controller: newPasswordController,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: (){
                                    setState((){
                                      hidePassword2 = !hidePassword2;
                                    });
                                  },
                                  child: hidePassword2 ?
                                  Icon(Icons.visibility_outlined,color: flyGray3,) :
                                  Icon(Icons.visibility_off,color: flyGray3,))
                              ,filled: true,
                              fillColor: Colors.white,
                              label: Text("New Password"),
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
                  SizedBox(height: H*0.02,),
                  Container(
                      width: W*0.9,
                      height: H*0.08,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent,width: 0.5)
                      ),
                      child: Center(
                        child: TextFormField(
                          obscureText: hidePassword3,
                          controller: newConfirmController,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: (){
                                    setState((){
                                      hidePassword3 = !hidePassword3;
                                    });
                                  },
                                  child: hidePassword3 ?
                                  Icon(Icons.visibility_outlined,color: flyGray3,) :
                                  Icon(Icons.visibility_off,color: flyGray3,))
                              ,filled: true,
                              fillColor: Colors.white,
                              label: Text("Confirm New Password"),
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
                  SizedBox(height: H*0.04,),
                  Row(
                    children: [
                      Text("*",style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'OpenSans-Regular',
                          color: Color(0xFFC7060B)
                      ),),
                      Text("Password should be at least 6 characters long.",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'OpenSans-Regular',
                            color: flyGray3
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: H*0.1,),
                  InkWell(
                    onTap: (){
                      if( passwordController.text.isEmpty || newPasswordController.text.isEmpty
                          || newConfirmController.text.isEmpty){
                        Get.defaultDialog(
                            title: "Error found",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyBlack2
                            ),
                            content: Column(

                              children: [
                                Text("Password is required!",style:TextStyle(
                                    fontSize: 13,
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
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyOrange2,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Colors.white),))
                                      ),
                                    ),
                                    SizedBox(width: W*0.05,),
                                    InkWell(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: Container(
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyGray3,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("cancel",style: TextStyle(fontSize: 13,
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
                      else if(passwordController.text.length < 6)
                      {
                        Get.defaultDialog(
                            title: "Error found",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyBlack2
                            ),
                            content: Column(

                              children: [
                                Text("Password must be atleast 6 characters",style:TextStyle(
                                    fontSize: 13,
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
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyOrange2,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Colors.white),))
                                      ),
                                    ),
                                    SizedBox(width: W*0.05,),
                                    InkWell(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: Container(
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyGray3,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("cancel",style: TextStyle(fontSize: 13,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Colors.white),))
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                        );
                      }else if(newPasswordController.text.length <6){
                        Get.defaultDialog(
                            title: "Error found",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyBlack2
                            ),
                            content: Column(

                              children: [
                                Text("Password must be atleast 6 characters",style:TextStyle(
                                    fontSize: 13,
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
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyOrange2,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Colors.white),))
                                      ),
                                    ),
                                    SizedBox(width: W*0.05,),
                                    InkWell(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: Container(
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyGray3,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("cancel",style: TextStyle(fontSize: 13,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Colors.white),))
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                        );
                      }else if(newPasswordController.text != newConfirmController.text){
                        Get.defaultDialog(
                            title: "Error found",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyBlack2
                            ),
                            content: Column(

                              children: [
                                Text("Password dose not match",style:TextStyle(
                                    fontSize: 13,
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
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyOrange2,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Colors.white),))
                                      ),
                                    ),
                                    SizedBox(width: W*0.05,),
                                    InkWell(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: Container(
                                          height: H*0.05,
                                          width: W*0.2,
                                          decoration: BoxDecoration(
                                              color: flyGray3,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Center(child: Text("cancel",style: TextStyle(fontSize: 13,
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
                        changePassword(
                            passwordController.text.trim(),
                            newPasswordController.text.trim()
                        );
                      }
                    },
                    child: Container(
                      width: W*0.9,
                      height: H*0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gradient: LinearGradient(
                              colors: [flyOrange1,flyOrange2],
                              begin: Alignment.bottomLeft,
                              end:  Alignment.topRight
                          )
                      ),
                      child: Center(child:
                      Text("Submit",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 16,
                            color: Colors.white
                        ),
                      )
                      ),
                    ),
                  ),
                  SizedBox(height: H*0.04,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future changePassword(String oldPassword,String newPassword) async {
    var H = Get.height;
    var W = Get.width;
    tokenAPI = await getToken();
    var baseurl = "https://ondemandflyers.com:8087/distributor/changePassword";
    final response = await http.post(
        Uri.parse("$baseurl"),
        body: json.encode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
        headers: {
          'x-access-token': "$tokenAPI",
          "Content-Type": "application/json",
        });
    var data = response.body;
    print("This is my response : $data");
    print(response.statusCode);
    if(response.statusCode == 400){
      Get.defaultDialog(
          title: "Error found",
          titleStyle: TextStyle(
              fontSize: 15,
              fontFamily: 'OpenSans-Bold',
              color: flyBlack2
          ),
          content: Column(

            children: [
              Text(" Old Password dose not match",style:TextStyle(
                  fontSize: 13,
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
                        height: H*0.05,
                        width: W*0.2,
                        decoration: BoxDecoration(
                            color: flyOrange2,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
                            fontFamily: 'OpenSans-Bold',
                            color: Colors.white),))
                    ),
                  ),
                  SizedBox(width: W*0.05,),
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                        height: H*0.05,
                        width: W*0.2,
                        decoration: BoxDecoration(
                            color: flyGray3,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Center(child: Text("cancel",style: TextStyle(fontSize: 13,
                            fontFamily: 'OpenSans-Bold',
                            color: Colors.white),))
                    ),
                  ),
                ],
              )
            ],
          )
      );
    }else if(response.statusCode == 200){
      Get.offAll(HomePage());
      Fluttertoast.showToast(msg: "Password Changed Successfully!");
    }
  }
}
