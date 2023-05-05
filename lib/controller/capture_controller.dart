import 'dart:convert';
import 'package:bestbrightness/model/capture_model.dart';
import 'package:bestbrightness/view/viewitems_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CaptureController extends GetxController {
  static const apiBaseUrl = 'http://192.168.1.102:4001/api/';
  // static const apiBaseUrl = '';

  List<CaptureModel> allStock = [];
  
   Future<void> captureItems(Map captureData) async {
    print("add capture stock data $captureData");

    var url = Uri.parse(apiBaseUrl + 'additems');
    print(url);
    try {
      final response = await http.post(url, body: captureData);
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        var r = json.decode(response.body);
        print(r['code']);

        showToast(r['message']);
        Get.to(ViewitemsScreen());
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
