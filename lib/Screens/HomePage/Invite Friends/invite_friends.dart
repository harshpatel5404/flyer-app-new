import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/colors.dart';
import '../../Notifications/notifications.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
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
        title: Text("Invite Friends"),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans-Semibold",
          fontSize: 18,
          color: Colors.black,
        ),
        titleSpacing: 2,
        actions: [
          InkWell(
            onTap: () {
              Get.to(Notifications());
            },
            child: Padding(
              padding: EdgeInsets.only(right: W * 0.04),
              child: Center(
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: flyBlack2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: W * 0.03,
                      ),
                      child: CircleAvatar(
                        backgroundColor: flyOrange2,
                        radius: 7,
                        child: Text(
                          "0",
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite friends by",
              style: TextStyle(
                fontFamily: "OpenSans-Regular",
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: H * 0.03,
            ),
            Row(
              children: [
                buildInviteCard(H, W, "assets/images/whatsapp.png"),
                SizedBox(
                  width: W * 0.03,
                ),
                buildInviteCard(H, W, "assets/images/messenger.png"),
                SizedBox(
                  width: W * 0.03,
                ),
                buildInviteCard(H, W, "assets/images/skype.png"),
                SizedBox(
                  width: W * 0.03,
                ),
                buildInviteCard(H, W, "assets/images/gmail.png"),
              ],
            ),
            SizedBox(
              height: H * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var url =
                        "https://play.google.com/store/apps/details?id=flyerdistributor.randye.ridge.flyerapp";
                    await Share.share("Flyer Distributor : $url");
                  },
                  child: Row(
                    children: [Text("Share"), Icon(Icons.share)],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Column buildInviteCard(double H, double W, String image) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(4, 4), blurRadius: 5, color: flyGray4)
                ]),
            height: H * 0.11,
            width: W * 0.21,
            child: Center(
              child: Container(
                  height: H * 0.05,
                  child: ClipRRect(child: Image.asset(image))),
            )),
      ],
    );
  }
}
