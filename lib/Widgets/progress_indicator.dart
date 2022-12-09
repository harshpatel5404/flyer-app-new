import 'package:flutter/material.dart';
import 'package:flyerapp/Constants/colors.dart';

class ProgressDialog extends StatelessWidget {
String message;
ProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: H*0.08,
        width: W*0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: W*0.03,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(flyOrange2),),
              SizedBox(width: W*0.03,),
              Text(message,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: flyBlack2,
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 14,
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
