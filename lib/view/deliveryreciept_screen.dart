import 'dart:convert';

import 'package:bestbrightness/controller/viewitems_controller.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:bestbrightness/controller/capture_controller.dart';
import 'package:bestbrightness/view/NavBar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/deliveryreciept_controller.dart';

class DeliveryrecieptScreen extends StatelessWidget {
  final controller = Get.put(DeliveryrecieptController());

  Future<void> _loadData() async {
    await controller.fetchData();
    // setState(() {}); // Reload the data table after fetching new data
  }
fetchData() {

}
  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Inventory'),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const NavBar(),
      body: FutureBuilder(
          future:
              fetchData(), // replace with function that fetches data from backend
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // show loading indicator while waiting for data
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // show error message if there was an error fetching data
              return Center(child: Text('Error fetching data'));
            } else {
              // display data in a ListView widget
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index]['imgName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Delivery Date: ${snapshot.data[index]['deliveryDate']}'),
                        Text(
                            'Delivery Time: ${snapshot.data[index]['deliveryTime']}'),
                        Text(
                            'Delivered By: ${snapshot.data[index]['deliveredBy']}'),
                        Text('Stock Items:'),
                        Column(
                          children: (jsonDecode(snapshot.data[index]['items'])
                                  as List<dynamic>)
                              .map((item) => Text(
                                  '${item['stockName']}: ${item['stockAmount']}'))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        )

      
      );
  }
}


