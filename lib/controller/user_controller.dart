import 'dart:convert';

import 'package:bestbrightness/model/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../helper/general_helper.dart';
import '../services/local_auth_api.dart';
import '../view/capture_screen.dart';

class UserController extends GetxController {
  static const apiBaseUrl = 'http://192.168.1.102:4001/api/';
  // static const apiBaseUrl = '';
  var sessionManager = SessionManager();
  List<UserModel> login = [];
  Future<bool> authenticated = Future<bool>.value(false);
  Future<void> signUp(Map loginData) async {
    print("add user data $loginData");

    var url = Uri.parse(apiBaseUrl + 'adduser');
    print(url);
    try {
      final response = await http.post(url, body: loginData);
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        var r = json.decode(response.body);
        print(r['code']);

        showToast(r['message']);
        Get.back();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> signIn(Map signInData) async {
    var url = Uri.parse(apiBaseUrl + 'login');
    print(url);
    try {
      final response = await http.post(url, body: signInData);
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        var r = json.decode(response.body);
        print(r['code']);
        if (r['status'] == "ok") {
          
        
          // await FlutterSession().set('token', r['username']);
          // showToast('Login successful');
          // print(r['user'][0]["fullname"]);
          await sessionManager.set("username", r['user'][0]["username"]);
           
           await Get.to(const CaptureScreen());

      
        } else {
          showToast("Incorrect credentials");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  void showToast(toast) => Fluttertoast.showToast(
        msg: toast,
        fontSize: 18,
      );
}
