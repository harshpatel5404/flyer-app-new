import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyerapp/Screens/HomePage/homepage.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import '../Notifications/notifications.dart';
import 'package:http/http.dart' as http;

class SupportSection extends StatefulWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
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
          title: Text("Support"),
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans-Semibold",
            fontSize: 20,
            color: Colors.black,

          ),
          titleSpacing: 2,
          actions: [InkWell(
            onTap: (){
              Get.to(Notifications());
            },
            child: Padding(
              padding:  EdgeInsets.only(right: W*0.04),
              child: Center(
                child: Stack(
                  children: [
                    Icon(Icons.notifications_none_outlined,color: flyBlack2,),
                    Padding(
                      padding:  EdgeInsets.only(left: W*0.03,),
                      child: CircleAvatar(
                        backgroundColor: flyOrange2,
                        radius: 7,
                        child: Text("!",style: TextStyle(
                            fontSize: 11
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )],
        ),
        backgroundColor: flyBackground,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("For all enquiries, please email us using",
                  style: TextStyle(
                    fontFamily: "OpenSans-Bold",
                    fontSize: 15,
                    color: flyBlack2,
                  ),
                ),
                Center(
                  child: Text("the form below",
                    style: TextStyle(
                      fontFamily: "OpenSans-Bold",
                      fontSize: 15,
                      color: flyBlack2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                          width: W*0.9,
                          height: H*0.08,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent,width: 0.5)
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Text("Name"),
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
                      SizedBox(height: H*0.03,),
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
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Text("Email ID"),
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
                      SizedBox(height: H*0.03,),
                      Container(
                          height: H*0.08,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent,width: 0.5)
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Text("Contact No."),
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
                      SizedBox(height: H*0.03,),
                      Container(
                        child: Center(
                          child: TextFormField(
                            maxLines: 5,
                            maxLength: 500,
                            controller: messageController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.white,
                                label: Text("Message"),
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
                        ),
                      ),
                      SizedBox(height: H*0.05,),
                      InkWell(
                        onTap: (){
                          if(nameController.text.isEmpty && emailController.text.isEmpty
                              && phoneController.text.isEmpty && messageController.text.isEmpty)
                          {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2
                                ),
                                content: Column(
                                  children: [
                                    Text("Please fill the details!",style:TextStyle(
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
                                              padding: EdgeInsets.symmetric(horizontal:W*0.05,vertical: H*0.01),
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
                          }else if(nameController.text.length < 3)
                          {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2
                                ),
                                content: Column(
                                  children: [
                                    Text("Name must be atleast 3 characters",style:TextStyle(
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
                                              padding: EdgeInsets.symmetric(horizontal:W*0.05,vertical: H*0.01),
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
                          }else if(emailController.text.isEmpty)
                          {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2
                                ),
                                content: Column(
                                  children: [
                                    Text("Please enter the email",style:TextStyle(
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
                                              padding: EdgeInsets.symmetric(horizontal:W*0.05,vertical: H*0.01),
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
                          }else if((!emailController.text.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))){
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
                          else if(phoneController.text.isEmpty)
                          {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2
                                ),
                                content: Column(
                                  children: [
                                    Text("Please enter the phone number",style:TextStyle(
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
                                              padding: EdgeInsets.symmetric(horizontal:W*0.05,vertical: H*0.01),
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
                          }else if(phoneController.text.length != 10 )
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
                                    Text("Phone Number is not valid",style:TextStyle(
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
                          else if(messageController.text.isEmpty)
                          {
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2
                                ),
                                content: Column(
                                  children: [
                                    Text("Please enter the message",style:TextStyle(
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
                                              padding: EdgeInsets.symmetric(horizontal:W*0.05,vertical: H*0.01),
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
                            supportApi(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                phoneController.text.trim(),
                                messageController.text.trim()
                            );
                            Get.to(HomePage());
                            Get.defaultDialog(
                                title: "",
                                titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'OpenSans-Bold',
                                    color: flyOrange2
                                ),
                                content: Column(
                                  children: [
                                    Text("Thank you for contacting Support Team!",style:TextStyle(
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future supportApi(String name,String email,String contact,String message) async {
    var baseurl = "https://ondemandflyers.com:8087/distributor/support";
    final response = await http.post(
        Uri.parse("$baseurl"),
      body: json.encode({
        "name": name,
        "email": email,
        "contact": contact,
        "message": message
      }),
        headers: {
          "Content-Type": "application/json",
        }
    );
    print(response.body);
  }
}
