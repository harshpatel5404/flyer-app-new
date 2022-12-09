import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyerapp/Constants/colors.dart';
import 'package:flyerapp/Screens/SharedPrefrence/sharedprefrence.dart';
import 'package:get/get.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _switchValue = false;
  @override
  void initState() {
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: flyBackground,
      appBar: AppBar(
        backgroundColor: flyBackground,
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
        title: Text("Face Recognition"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 20,
          color: Colors.black,
        ),
        titleSpacing: 2,
      ),
      body: Column(
        children: [
         ListTile(
            dense: true,
            title: Container(child: Text("Face Recognition",
            style: TextStyle(
                fontFamily: "OpenSans-Semibold",
                fontSize: 18,
                color: Colors.black,
              ),)),
            trailing: CupertinoSwitch(
              value: _switchValue,
              trackColor: flyGray1,
              activeColor: flyOrange2,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                  setLockScreenEnable(_switchValue);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getValue() async {
    bool temp = await getLockScreenEnable();
    _switchValue = temp;
    setState(() {});
  }
}
