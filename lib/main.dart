import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flyerapp/Constants/colors.dart';
import 'package:flyerapp/Screens/SplashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; 

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flyer Distributor',
      theme: ThemeData(
        unselectedWidgetColor: flyGray3,
        checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreeen(),
    );
  }
}
