import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';

class AddBankAccount2 extends StatefulWidget {
  const AddBankAccount2({Key? key}) : super(key: key);

  @override
  State<AddBankAccount2> createState() => _AddBankAccount2State();
}

class _AddBankAccount2State extends State<AddBankAccount2> {
  String dropDownValue = 'Today';
  final items = [
    'Today',
    'Last 10 Days',
    'Last Month',
    'Last Year'
  ];

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height;
    var W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF6F7F9),
        appBar: AppBar(
          backgroundColor:  Color(0xFFF6F7F9),
          elevation: 0,
          leading: Container(
              child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back,color: Color(0xFF4D4D4D),))),
          title: Text("Add Bank Account"),
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans-Semibold",
            fontSize: 22,
            color: Colors.black,

          ),
          titleSpacing: 2,

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
               Align(
                 alignment: Alignment.centerRight,
                 child: Container(
                   height: H*0.05,
                   padding: EdgeInsets.only(left: W*0.05),
                   decoration: BoxDecoration(
                       color: Colors.white,
                     borderRadius: BorderRadius.all(Radius.circular(8)),
                     border: Border.all(color: Colors.black,width: 1)
                   ),
                   child: DropdownButton<String>(
                     underline: Divider(color: Colors.transparent),
                     borderRadius: BorderRadius.all(Radius.circular(8)),
                     value: dropDownValue,
                     icon: Icon(Icons.keyboard_arrow_down),
                     items: items.map((String items){
                       return DropdownMenuItem(
                         value: items, child: Text(items,style: TextStyle(
                         fontSize: 15,
                         fontFamily: "Opensans-Regular"
                       ),),
                       );
                     }).toList(),
                     onChanged: (String? newValue){
                       setState((){
                         dropDownValue = newValue!;
                       });
                     },
                   ),
                 ),
               ),
                SizedBox(
                  height: H*0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return buildTextBankTransHistory();
                        },
                        itemCount: 5,
                           ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildTextBankTransHistory() {
    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ICICI@1541",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Opensans-Regular"
                                )
                            ),
                            Text("\$125.00",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Opensans-Regular"
                                )
                            )
                          ],
                        ),
                        Text("02/05/2021",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF929292),
                                fontFamily: "Opensans-Regular"
                            )
                        ),
                        Divider(
                          color: Color(0xFFEBEBEB),
                        )
                      ],
                    );
  }
}
