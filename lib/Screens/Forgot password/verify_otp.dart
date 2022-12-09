import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/Forgot%20password/reset_password.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import 'package:http/http.dart' as http;

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  String? tokenAPI;
  String? email;
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
        title: Text("Verify OTP"),
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
                    child: Center(child: Image.asset("assets/images/verify_otp.png"))),
                SizedBox(height: H*0.08,),
                Text("Reset Password",
                  style: TextStyle(
                    fontFamily: "OpenSans-Bold",
                    fontSize: 20,
                    color: Colors.black,

                  ),
                ),
                Text("Code has been send to your email Id",
                  style: TextStyle(
                    fontFamily: "OpenSans-Regular",
                    fontSize: 15,
                    color: Color(0xFF828282),
                  ),
                ),
                SizedBox(height: H*0.07,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTextFormOTP(W, H,otpController1),
                    buildTextFormOTP(W, H,otpController2),
                    buildTextFormOTP(W, H,otpController3),
                    buildTextFormOTP(W, H,otpController4),
                  ],
                ),
                SizedBox(height: H*0.05,),
                InkWell(
                  onTap: (){
                    if(otpController1.text.isEmpty && otpController2.text.isEmpty
                        && otpController3.text.isEmpty && otpController4.text.isEmpty
                    ){
                      Get.defaultDialog(
                          title: "Error found",
                          titleStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans-Bold',
                              color: flyBlack2
                          ),
                          content: Column(

                            children: [
                              Text("Please enter the OTP!",style:TextStyle(
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
                    }
                    verifyOtp();
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
                    Text("Next",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 16,
                          color: Colors.white
                      ),
                    )
                    ),
                  ),
                ),
                SizedBox(height: H*0.08,),
                InkWell(
                  onTap: (){
                    forgotPassword();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Resend OTP  ",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Semibold',
                            fontSize: 16,
                            color: Color(0xFF929292)
                        ),
                      ),
                      Container(
                          height: H*0.028,
                          width: W*0.07,
                          child: Image.asset("assets/images/orange_arrow_frnt.png",)),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  Container buildTextFormOTP(double W, double H,TextEditingController controller) {
    return Container(
        width: W*0.18,
        height: H*0.08,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent,width: 0.5)
        ),
        child: Center(
          child: TextFormField(
            controller: controller,
            onChanged: (value){
              if(value.length == 1){
                FocusScope.of(context).nextFocus();
              }
            },
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
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
        ));
  }
  var H = Get.height;
  var W = Get.height;
  Future verifyOtp() async {
    tokenAPI = await getToken();
    email = await getEmail();
    var baseurl = "https://ondemandflyers.com:8087/distributor/verifyOtp";
    var emailId = email;
    print(emailId);
    var otp = otpController1.text.trim() + otpController2.text.trim() + otpController3.text.trim() + otpController4.text.trim();
    print(otp);
    final response = await http.post(
        Uri.parse("$baseurl/$emailId/$otp"),
        headers: {
          "Content-Type": "application/json",
        });
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){
      Get.to(ResetPassword());
    }
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
              Text("Incorrect OTP!",style:TextStyle(
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
    }
  }
  Future forgotPassword() async {
    tokenAPI = await getToken();
    email = await getEmail();
    var baseurl = "https://ondemandflyers.com:8087/distributor/sendOtp";
    var emailId = email;
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
    }
    print(emailId);
    print(response.body);
    print(response.statusCode);
  }
}