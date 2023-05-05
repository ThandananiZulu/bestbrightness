import 'dart:convert';

import 'package:bestbrightness/model/user_model.dart';
import 'package:bestbrightness/model/viewitems_model.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../helper/general_helper.dart';
import '../view/capture_screen.dart';

class DeliveryrecieptController extends GetxController {
  var stocks = <ViewitemsModel>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  static const apiBaseUrl = 'http://192.168.1.101:4001/api/';
  // static const apiBaseUrl = '';

  fetchData() async {
    print(
        "jsonData..............................................................................................................................................................................................");
    var url = Uri.parse(apiBaseUrl + 'getitems');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'] as List<dynamic>;
      stocks.value = List<ViewitemsModel>.from(
          data.map((e) => ViewitemsModel.fromJson(e)));
    } else {
      throw Exception('Failed to load items');
    }
  }
}
