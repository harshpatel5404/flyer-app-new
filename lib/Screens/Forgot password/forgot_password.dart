import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/Forgot%20password/verify_otp.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import 'package:http/http.dart' as http;

import '../SharedPrefrence/sharedprefrence.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  String? tokenAPI;
  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return Scaffold(
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
        title: Text("Forgot Password"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 22,
          color: Colors.black,

        ),
        titleSpacing: 2,

      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              children: [
                SizedBox(height: H*0.08,),
                Container(
                    height: H*0.15,
                    child: Center(child: Image.asset("assets/images/enter_no.png"))),
                SizedBox(height: H*0.08,),
                Text("Enter your email address",
                  style: TextStyle(
                    fontFamily: "OpenSans-Bold",
                    fontSize: 20,
                    color: Colors.black,

                  ),
                ),
                Text("You will get an OTP via mail",
                  style: TextStyle(
                    fontFamily: "OpenSans-Regular",
                    fontSize: 15,
                    color: Color(0xFF828282),
                  ),
                ),
                SizedBox(height: H*0.07,),
                Container(
                    width: W*0.9,
                    height: H*0.08,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent,width: 0.5)
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: flyGray4)
                            )
                        ),
                      ),
                    )),
                SizedBox(height: H*0.05,),
                InkWell(
                  onTap: (){
                    if(emailController.text.isEmpty){
                      Get.defaultDialog(
                          title: "Error found",
                          titleStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2
                          ),
                          content: Column(

                            children: [
                              Text("Please provide email address",style:TextStyle(
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
                    }else if (!emailController.text.contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                      Get.defaultDialog(
                          title: "Error found",
                          titleStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2
                          ),
                          content: Column(

                            children: [
                              Text("Email address is not valid",style:TextStyle(
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
                    else{
                      forgotPassword();
                      setEmail(emailController.text.trim());
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
                    Text("Send Verification Code",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 16,
                          color: Colors.white
                      ),
                    )
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
  var H = Get.height;
  var W = Get.height;
  Future forgotPassword() async {
    tokenAPI = await getToken();
    var baseurl = "https://ondemandflyers.com:8087/distributor/sendOtp";
    var emailId = emailController.text.trim();
    final response = await http.post(
        Uri.parse("$baseurl/$emailId"),
        headers: {
          "Content-Type": "application/json",
        });
    if(response.statusCode == 404){
      Get.defaultDialog(
          title: "Error found",
          titleStyle: TextStyle(
              fontSize: 15,
              fontFamily: 'OpenSans-Bold',
              color: flyBlack2
          ),
          content: Column(

            children: [
              Text("Incorrect Email Id!",style:TextStyle(
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
                        width: W*0.15,
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
                        height: H*0.05,
                        width: W*0.15,
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
      Fluttertoast.showToast(msg: "Verification OTP sent to you mail address");
      Get.to(VerifyOTP());
    }
    print(emailId);
    print(response.body);
    print(response.statusCode);
  }
}