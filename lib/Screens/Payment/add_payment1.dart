import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyerapp/Screens/Payment/payment.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Constants/colors.dart';
import '../SharedPrefrence/sharedprefrence.dart';
import '../UserModel/bank_model.dart';

class AddBankAccount1 extends StatefulWidget {
  const AddBankAccount1({Key? key}) : super(key: key);

  @override
  State<AddBankAccount1> createState() => _AddBankAccount1State();
}

class _AddBankAccount1State extends State<AddBankAccount1> {
  @override
  void initState() {
    super.initState();
  }

  String? tokenAPI;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool hidePassword3 = true;
  TextEditingController accountHolder = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
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
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF4D4D4D),
                  ))),
          title: Text("Add Bank Account"),
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
              padding: EdgeInsets.only(left: H * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: H * 0.05,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add New Bank Detail",
                      style: TextStyle(
                          fontFamily: 'Gothic-Regular',
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.02,
                  ),
                  Container(
                      width: W * 0.9,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          controller: accountHolder,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text("Account Holder Name"),
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
                  Container(
                      width: W * 0.9,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          controller: accountNumber,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text("Account Number"),
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
                  Container(
                      width: W * 0.9,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.transparent, width: 0.5)),
                      child: Center(
                        child: TextFormField(
                          controller: ifscCode,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text("Routing number"),
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
                    height: H * 0.15,
                  ),
                  InkWell(
                    onTap: () {
                      if (accountHolder.text.isEmpty &&
                          accountNumber.text.isEmpty &&
                          ifscCode.text.isEmpty) {
                        Get.defaultDialog(
                            title: "",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyOrange2),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        setState(() {
                                          _bankDetails;
                                        });
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
                                  ],
                                )
                              ],
                            ));
                      } else if (accountHolder.text.isEmpty) {
                        Get.defaultDialog(
                            title: "",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyOrange2),
                            content: Column(
                              children: [
                                Text(
                                  "Please enter the account holder name",
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
                                        setState(() {
                                          _bankDetails;
                                        });
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
                                  ],
                                )
                              ],
                            ));
                      } else if (accountNumber.text.isNotEmpty &&
                          accountNumber.text.length != 11) {
                        Get.defaultDialog(
                            title: "",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyOrange2),
                            content: Column(
                              children: [
                                Text(
                                  "The account No should be 11 digit",
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
                                        setState(() {
                                          _bankDetails;
                                        });
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
                                  ],
                                )
                              ],
                            ));
                      } else if (accountNumber.text.isEmpty) {
                        Get.defaultDialog(
                            title: "",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyOrange2),
                            content: Column(
                              children: [
                                Text(
                                  "Please enter the account number",
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
                                        setState(() {
                                          _bankDetails;
                                        });
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
                                  ],
                                )
                              ],
                            ));
                      } else if (ifscCode.text.isNotEmpty &&
                          ifscCode.text.length != 9) {
                        Get.defaultDialog(
                            title: "",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyOrange2),
                            content: Column(
                              children: [
                                Text(
                                  "Routing number should be 9 digits",
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
                                        setState(() {
                                          _bankDetails;
                                        });
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
                                  ],
                                )
                              ],
                            ));
                      } else if (ifscCode.text.isEmpty) {
                        Get.defaultDialog(
                            title: "",
                            titleStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans-Bold',
                                color: flyOrange2),
                            content: Column(
                              children: [
                                Text(
                                  "Please enter your routing number",
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
                                        setState(() {
                                          _bankDetails;
                                        });
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
                                  ],
                                )
                              ],
                            ));
                      } else {
                        addBankAccount(accountHolder.text.trim(),
                            accountNumber.text.trim(), ifscCode.text.trim());
                      }
                    },
                    child: Container(
                      width: W * 0.9,
                      height: H * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gradient: LinearGradient(
                              colors: [flyOrange1, flyOrange2],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
                      child: Center(
                          child: Text(
                        "Submit",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 16,
                            color: Colors.white),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: H * 0.04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _bankDetails = [];
  bool _loading = false;
  Future<List<BankDetails>> getMyBankDetails() async {
    tokenAPI = await getToken();
    setState(() {});
    print(tokenAPI);
    var baseurl =
        "https://ondemandflyers.com:8087/distributor/bank/accountList";
    var response = await http.get(
      Uri.parse(
        baseurl,
      ),
      headers: {
        'x-access-token': "$tokenAPI",
      },
    );

    var jsonData = jsonDecode(response.body);
    setState(() {
      _bankDetails = jsonData['data'];
      print(_bankDetails[0]['accountHolderName']);
      print("printToken : $tokenAPI");
    });
    return jsonData;
  }

  Future addBankAccount(
      String accountHolder, String accountNumber, String ifscCode) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: flyOrange2,
          ));
        });
    var H = Get.height;
    var W = Get.width;
    tokenAPI = await getToken();
    var baseurl = "https://ondemandflyers.com:8087/distributor/bank/account";
    final response = await http.post(Uri.parse("$baseurl"),
        body: json.encode({
          "accountHolderName": accountHolder,
          "accountNumber": accountNumber,
          "routingNumber": ifscCode
        }),
        headers: {
          'x-access-token': "$tokenAPI",
          "Content-Type": "application/json",
        });
    print(tokenAPI);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Get.back();
      Fluttertoast.showToast(msg: "Your account is update sucessfully");
    } else if (response.statusCode == 400) {
      Navigator.of(context).pop();
      Get.defaultDialog(
          title: "Something went wrong!",
          titleStyle: TextStyle(
              fontSize: 15, fontFamily: 'OpenSans-Bold', color: flyOrange2),
          content: Column(
            children: [
              Text(
                "Account number or Routing number already exist!",
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
    } else {}
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flyerapp/Screens/Payment/payment.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../Constants/colors.dart';
// import '../SharedPrefrence/sharedprefrence.dart';
// import '../UserModel/bank_model.dart';

// class AddBankAccount1 extends StatefulWidget {
//   const AddBankAccount1({Key? key}) : super(key: key);

//   @override
//   State<AddBankAccount1> createState() => _AddBankAccount1State();
// }

// class _AddBankAccount1State extends State<AddBankAccount1> {
//   @override
//   void initState(){
//     addBankAccount(accountHolder.text, accountNumber.text, ifscCode.text);
//     super.initState();
//   }
//   String? tokenAPI;
//   bool hidePassword1 = true;
//   bool hidePassword2 = true;
//   bool hidePassword3 = true;
//   TextEditingController accountHolder = TextEditingController();
//   TextEditingController accountNumber = TextEditingController();
//   TextEditingController ifscCode = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     var H = MediaQuery.of(context).size.height;
//     var W = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: Container(
//               child: InkWell(
//                   onTap: (){
//                     Get.back();
//                   },
//                   child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
//           title: Text("Add Bank Account"),
//           titleTextStyle: TextStyle(
//             fontFamily: "OpenSans-Semibold",
//             fontSize: 22,
//             color: Colors.black,

//           ),
//           titleSpacing: 2,

//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding:  EdgeInsets.only(left: H*0.03),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   SizedBox(height: H*0.05,),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text("Add New Bank Detail",
//                       style: TextStyle(
//                           fontFamily: 'Gothic-Regular',
//                           fontSize: 18,
//                           color: Colors.black
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: H*0.02,),
//                   Container(
//                       width: W*0.9,
//                       height: H*0.08,
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.transparent,width: 0.5)
//                       ),
//                       child: Center(
//                         child: TextFormField(
//                           controller: accountHolder,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               label: Text("Account Holder Name"),
//                               labelStyle: TextStyle(
//                                   fontSize: 15,
//                                   fontFamily: 'OpenSans-Regular',
//                                   color: flyGray3
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black)
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: flyGray4)
//                               )
//                           ),
//                         ),
//                       )),
//                   SizedBox(height: H*0.02,),
//                   Container(
//                       width: W*0.9,
//                       height: H*0.08,
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.transparent,width: 0.5)
//                       ),
//                       child: Center(
//                         child: TextFormField(
//                           controller: accountNumber,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               label: Text("Account Number"),
//                               labelStyle: TextStyle(
//                                   fontSize: 15,
//                                   fontFamily: 'OpenSans-Regular',
//                                   color: flyGray3
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black)
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: flyGray4)
//                               )
//                           ),
//                         ),
//                       )),
//                   SizedBox(height: H*0.02,),
//                   Container(
//                       width: W*0.9,
//                       height: H*0.08,
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.transparent,width: 0.5)
//                       ),
//                       child: Center(
//                         child: TextFormField(
//                           controller: ifscCode,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               label: Text("IFSC Code"),
//                               labelStyle: TextStyle(
//                                   fontSize: 15,
//                                   fontFamily: 'OpenSans-Regular',
//                                   color: flyGray3
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black)
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: flyGray4)
//                               )
//                           ),
//                         ),
//                       )),
//                   SizedBox(height: H*0.15,),
//                   InkWell(
//                     onTap: (){
//                       if(accountHolder.text.isEmpty && accountNumber.text.isEmpty && ifscCode.text.isEmpty)
//                       {
//                         Get.defaultDialog(
//                             title: "",
//                             titleStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: 'OpenSans-Bold',
//                                 color: flyOrange2
//                             ),
//                             content: Column(

//                               children: [
//                                 Text("Please fill the details!",style:TextStyle(
//                                     fontSize: 13,
//                                     fontFamily: 'OpenSans-Bold',
//                                     color: flyBlack2
//                                 ),),
//                                 SizedBox(height: H*0.02,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: (){
//                                         Get.back();
//                                         setState(() {
//                                           _bankDetails;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: H*0.05,
//                                           width: W*0.2,
//                                           decoration: BoxDecoration(
//                                               color: flyOrange2,
//                                               borderRadius: BorderRadius.all(Radius.circular(8))
//                                           ),
//                                           child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
//                                               fontFamily: 'OpenSans-Bold',
//                                               color: Colors.white),))
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                         );
//                       }
//                       else if(accountHolder.text.isEmpty)
//                       {
//                         Get.defaultDialog(
//                             title: "",
//                             titleStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: 'OpenSans-Bold',
//                                 color: flyOrange2
//                             ),
//                             content: Column(

//                               children: [
//                                 Text("Please enter the account holder name",style:TextStyle(
//                                     fontSize: 13,
//                                     fontFamily: 'OpenSans-Bold',
//                                     color: flyBlack2
//                                 ),),
//                                 SizedBox(height: H*0.02,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: (){
//                                         Get.back();
//                                         setState(() {
//                                           _bankDetails;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: H*0.05,
//                                           width: W*0.2,
//                                           decoration: BoxDecoration(
//                                               color: flyOrange2,
//                                               borderRadius: BorderRadius.all(Radius.circular(8))
//                                           ),
//                                           child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
//                                               fontFamily: 'OpenSans-Bold',
//                                               color: Colors.white),))
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                         );
//                       }
//                       else if(accountNumber.text.isNotEmpty && accountNumber.text.length != 11)
//                       {
//                         Get.defaultDialog(
//                             title: "",
//                             titleStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: 'OpenSans-Bold',
//                                 color: flyOrange2
//                             ),
//                             content: Column(

//                               children: [
//                                 Text("The account No should be 11 digit",style:TextStyle(
//                                     fontSize: 13,
//                                     fontFamily: 'OpenSans-Bold',
//                                     color: flyBlack2
//                                 ),),
//                                 SizedBox(height: H*0.02,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: (){
//                                         Get.back();
//                                         setState(() {
//                                           _bankDetails;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: H*0.05,
//                                           width: W*0.2,
//                                           decoration: BoxDecoration(
//                                               color: flyOrange2,
//                                               borderRadius: BorderRadius.all(Radius.circular(8))
//                                           ),
//                                           child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
//                                               fontFamily: 'OpenSans-Bold',
//                                               color: Colors.white),))
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                         );
//                       }
//                       else if(accountNumber.text.isEmpty)
//                       {
//                         Get.defaultDialog(
//                             title: "",
//                             titleStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: 'OpenSans-Bold',
//                                 color: flyOrange2
//                             ),
//                             content: Column(

//                               children: [
//                                 Text("Please enter the account number",style:TextStyle(
//                                     fontSize: 13,
//                                     fontFamily: 'OpenSans-Bold',
//                                     color: flyBlack2
//                                 ),),
//                                 SizedBox(height: H*0.02,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: (){
//                                         Get.back();
//                                         setState(() {
//                                           _bankDetails;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: H*0.05,
//                                           width: W*0.2,
//                                           decoration: BoxDecoration(
//                                               color: flyOrange2,
//                                               borderRadius: BorderRadius.all(Radius.circular(8))
//                                           ),
//                                           child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
//                                               fontFamily: 'OpenSans-Bold',
//                                               color: Colors.white),))
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                         );
//                       }
//                       else if(ifscCode.text.isNotEmpty && ifscCode.text.length != 11)
//                       {
//                         Get.defaultDialog(
//                             title: "",
//                             titleStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: 'OpenSans-Bold',
//                                 color: flyOrange2
//                             ),
//                             content: Column(

//                               children: [
//                                 Text("IFSC should be 11 digit",style:TextStyle(
//                                     fontSize: 13,
//                                     fontFamily: 'OpenSans-Bold',
//                                     color: flyBlack2
//                                 ),),
//                                 SizedBox(height: H*0.02,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: (){
//                                         Get.back();
//                                         setState(() {
//                                           _bankDetails;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: H*0.05,
//                                           width: W*0.2,
//                                           decoration: BoxDecoration(
//                                               color: flyOrange2,
//                                               borderRadius: BorderRadius.all(Radius.circular(8))
//                                           ),
//                                           child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
//                                               fontFamily: 'OpenSans-Bold',
//                                               color: Colors.white),))
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                         );
//                       }
//                       else if(ifscCode.text.isEmpty)
//                       {
//                         Get.defaultDialog(
//                             title: "",
//                             titleStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: 'OpenSans-Bold',
//                                 color: flyOrange2
//                             ),
//                             content: Column(

//                               children: [
//                                 Text("Something went wrong!",style:TextStyle(
//                                     fontSize: 13,
//                                     fontFamily: 'OpenSans-Bold',
//                                     color: flyBlack2
//                                 ),),
//                                 SizedBox(height: H*0.02,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: (){
//                                         Get.back();
//                                         setState(() {
//                                           _bankDetails;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: H*0.05,
//                                           width: W*0.2,
//                                           decoration: BoxDecoration(
//                                               color: flyOrange2,
//                                               borderRadius: BorderRadius.all(Radius.circular(8))
//                                           ),
//                                           child: Center(child: Text("Ok",style: TextStyle(fontSize: 13,
//                                               fontFamily: 'OpenSans-Bold',
//                                               color: Colors.white),))
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                         );
//                       }
//                       else{
//                         addBankAccount(
//                             accountHolder.text.trim(),
//                             accountNumber.text.trim(),
//                             ifscCode.text.trim()
//                         );
//                         Fluttertoast.showToast(msg: "Your account is update sucessfully");
//                       }},
//                     child: Container(
//                       width: W*0.9,
//                       height: H*0.08,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           gradient: LinearGradient(
//                               colors: [flyOrange1,flyOrange2],
//                               begin: Alignment.bottomLeft,
//                               end:  Alignment.topRight
//                           )
//                       ),
//                       child: Center(child:
//                       Text("Submit",
//                         style: TextStyle(
//                             fontFamily: 'OpenSans-Bold',
//                             fontSize: 16,
//                             color: Colors.white
//                         ),
//                       )
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: H*0.04,),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   List<dynamic> _bankDetails = [];
//   bool _loading = false;
//   Future<List<BankDetails>> getMyBankDetails() async {
//     tokenAPI = await getToken();
//     setState((){});
//     print(tokenAPI);
//     var baseurl = "https://ondemandflyers.com:8087/distributor/bank/accountList";
//     var response = await http.get(Uri.parse(baseurl,),
//       headers: {
//         'x-access-token': "$tokenAPI",
//       },);

//     var  jsonData = jsonDecode(response.body);
//     setState((){
//       _bankDetails = jsonData['data'];
//       print(_bankDetails[0]['accountHolderName']);
//       print("printToken : $tokenAPI");
//     });
//     return jsonData;
//   }
//   Future addBankAccount(String accountHolder,String accountNumber,String ifscCode) async {
//     tokenAPI = await getToken();
//     var baseurl = "https://ondemandflyers.com:8087/distributor/bank/account";
//     final response = await http.post(
//         Uri.parse("$baseurl"),
//         body: json.encode({
//           "accountHolderName": accountHolder,
//           "accountNumber": accountNumber,
//           "ifsc" : ifscCode
//         }),
//         headers: {
//           'x-access-token': "$tokenAPI",
//           "Content-Type": "application/json",
//         });
//     print(tokenAPI);
//     print(response.body);
//     print(response.statusCode);
//     if(response.statusCode == 200){
//       Get.back();
//       Fluttertoast.showToast(msg: "Please refresh the page");
//     }else{

//     }
//   }
// }