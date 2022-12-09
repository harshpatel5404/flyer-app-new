import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';

class FaceRecoRegisteration extends StatefulWidget {
  const FaceRecoRegisteration({Key? key}) : super(key: key);

  @override
  State<FaceRecoRegisteration> createState() => _FaceRecoRegisterationState();
}

class _FaceRecoRegisterationState extends State<FaceRecoRegisteration> {
  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: H*0.04,),
                Padding(
                  padding:  EdgeInsets.only(left: W*0.05),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Container(
                            height: H*0.028,
                            width: W*0.07,
                            child: Image.asset("assets/images/back_arrow.png",)),
                      ),
                      Text("  Face Recognition",
                        style: TextStyle(
                            fontFamily: 'OpenSans-Medium',
                            fontSize: 24
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: H*0.03,),
                Container(
                  height: H*0.6,
                  width: W*0.9,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/face.png"
                          ),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: W*0.05 ,top: H*0.09),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    InkWell(
                      onTap: (){},
                      child: Container(
                        width: W*0.42,
                        height: H*0.08,
                        decoration: BoxDecoration(
                            color: flyGray5,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: Center(child:
                        Text("Retake Photo",
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 16,
                              color: flyBlack2
                          ),
                        )
                        ),
                      ),
                    ),
                      SizedBox(width: W*0.07,),
                      InkWell(
                        onTap: (){},
                        child: Container(
                          width: W*0.42,
                          height: H*0.08,
                          decoration: BoxDecoration(
                              color: flyBlue1,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          child: Center(child:
                          Text("Upload Photo",
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 16,
                                color: Colors.white
                            ),
                          )
                          ),
                        ),
                      ),

                  ],),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
