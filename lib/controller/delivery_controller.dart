import 'dart:convert';

import 'package:bestbrightness/model/user_model.dart';
import 'package:bestbrightness/model/delivery_model.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../helper/general_helper.dart';
import '../view/capture_screen.dart';
import '../view/viewitems_screen.dart';

class DeliveryController extends GetxController {
  var items = <DeliveryModel>[].obs;

  @override
  void onInit() {
    fetchList();
    super.onInit();
  }

  static const apiBaseUrl = 'http://192.168.1.102:4001/api/';
  // static const apiBaseUrl = '';

  fetchList() async {
    var url = Uri.parse(apiBaseUrl + 'getitems');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'] as List<dynamic>;

      return data;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> deliverItems(Map deliveredData) async {
    print("add delivered data $deliveredData");

    var url = Uri.parse(apiBaseUrl + 'deliveritems');
    print(url);
    try {
      final response = await http.post(url, body: deliveredData);
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        var r = json.decode(response.body);
        print(r['code']);

        showToast(r['message']);
        Get.to( ViewitemsScreen());
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
