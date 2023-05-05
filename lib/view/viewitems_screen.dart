import 'package:bestbrightness/controller/viewitems_controller.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:bestbrightness/controller/capture_controller.dart';
import 'package:bestbrightness/view/NavBar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewitemsScreen extends StatelessWidget {
  final controller = Get.put(ViewitemsController());
final String? payload;

     ViewitemsScreen({
        Key? key,
        @required this.payload,
    }): super(key:key);

  Future<void> _loadData() async {
    await controller.fetchData();
    // setState(() {}); // Reload the data table after fetching new data
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                        DataColumn(
                              label: Text('Image timestamp:'),
                              tooltip: 'Stock Remaining'),
                          DataColumn(
                              label: Text('Stock Name:'), tooltip: 'Item Name.'),
                          DataColumn(
                              label: Text('Stock Code:'),
                              tooltip: 'Barcode or QRCode'),
                          DataColumn(
                              label: Text('Stock Amount:'),
                              tooltip: 'Stock Remaining'),
                              DataColumn(
                              label: Text('Stock Price:'),
                              tooltip: 'Stock Price'),
                        ],
                        rows: controller.stocks
                            .map((stock) => DataRow(cells: [
                            DataCell(Text(stock.imgTimestamp)),
                                  DataCell(Text(stock.stockName)),
                                  DataCell(Text(stock.scanCode)),
                                  DataCell(Text(stock.stockAmount.toString()  )),
                                  DataCell(Text('R ' + stock.stockPrice.toString()  )),
                                ]))
                            .toList(),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
