import 'package:bestbrightness/view/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';

import 'view/capture_screen.dart';



void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _main createState() => _main();
}

class _main extends State<MyApp> {
  // This widget is the root of your application.
  dynamic id;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Best Brightness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onInit: () async  {
      id = await SessionManager().get("username");
      print(id);
      setState(() {});
      },
      home:
          id == null || id == "" ? const LoginScreen() : const CaptureScreen(),
    );
  }
}
